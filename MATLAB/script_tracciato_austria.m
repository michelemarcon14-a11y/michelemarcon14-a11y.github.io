% --- 1. Configuration: insert the name of your Excel file ---
clc; 

filename = "autox_austria_video.xlsx"; 

if ~isfile(filename)
    error('File non trovato! Controlla che "%s" sia nella cartella corrente.', filename);
end

% Read the table
data = readtable(filename);

% --- 2. Select the columns ---
% The new file has: Col 3 = Longitude, Col 4 = Latitude
% Changing the names in the MATLAB format (es. "GPS Longitude" -> "GPSLongitude")
try
    if ismember('GPSLongitude', data.Properties.VariableNames)
        raw_lon = data.GPSLongitude;
        raw_lat = data.GPSLatitude;
    else
        % Fallback: use indices if the names do not match
        raw_lon = data.Var3; 
        raw_lat = data.Var4;
    end
catch
    error('Non riesco a trovare le colonne Lat/Lon. Assicurati di aver eliminato la riga delle unità nel file Excel!');
end

% Delete NaN cells
valid_idx = ~isnan(raw_lon) & ~isnan(raw_lat);
raw_lon = raw_lon(valid_idx);
raw_lat = raw_lat(valid_idx);

% --- 3. CONVERSION GPS -> METERS ---
origin_lat = raw_lat(1);
origin_lon = raw_lon(1);
R = 6371000; % Earth radius (meters)

% Equirectangular formulas
x_m = deg2rad(raw_lon - origin_lon) .* R .* cos(deg2rad(origin_lat));
y_m = deg2rad(raw_lat - origin_lat) .* R;

% --- 4. Track creation ---
% Smoothing to make every turn cleaner
X_smooth = movmean(x_m, 5); 
Y_smooth = movmean(y_m, 5);

% Progressive distance calculus for interpolation
dist_steps = [0; cumsum(sqrt(diff(X_smooth).^2 + diff(Y_smooth).^2))];
[d_unique, idx_u] = unique(dist_steps, 'stable');
X_u = X_smooth(idx_u);
Y_u = Y_smooth(idx_u);

% Regular resampling (every 0.5 meters)
d_reg = 0 : 0.5 : d_unique(end);
X_track = interp1(d_unique, X_u, d_reg, 'spline')';
Y_track = interp1(d_unique, Y_u, d_reg, 'spline')';

% --- 5. Definition of cones and borders ---
track_width = 5; % Track width (meters)
cone_spacing = 4; % Cones spacing (meters)

N = length(X_track);
inner_border = zeros(N, 2);
outer_border = zeros(N, 2);
coords = [X_track, Y_track];

% Normal vectors calculus
for i = 1:N
    % Prende un punto avanti e uno indietro per calcolare la tangente
    %Considers one point ahead and point behind to define the tangent
    i1 = max(1, i-5);
    i2 = min(N, i+5);
    tangent = coords(i2,:) - coords(i1,:);
    L = norm(tangent);
    if L > 0
        t_vec = tangent / L;
        n_vec = [-t_vec(2), t_vec(1)]; % 90 degrees rotation
        
        outer_border(i,:) = coords(i,:) + n_vec * (track_width/2);
        inner_border(i,:) = coords(i,:) - n_vec * (track_width/2);
    end
end

% --- 6. PLOT ---
figure('Color', 'k'); % Black background
plot(X_track, Y_track, 'w--'); hold on; % Central white line

% Function to sample the cones
[xc_out, yc_out] = sample_cones(outer_border, cone_spacing);
[xc_in, yc_in]   = sample_cones(inner_border, cone_spacing);

plot(xc_out, yc_out, 'b^', 'MarkerFaceColor', 'b'); % Blue cones
plot(xc_in, yc_in, 'y^', 'MarkerFaceColor', 'y');   % Yellow cones

axis equal; grid on;
title('Tracciato Autocross Austria(Generato da GPS)', 'Color', 'w');
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');

% --- Auxiliar function ---
function [xc, yc] = sample_cones(border, spacing)
    d = [0; cumsum(sqrt(diff(border(:,1)).^2 + diff(border(:,2)).^2))];
    [d_u, i_u] = unique(d, 'stable');
    d_query = 0 : spacing : d_u(end);
    xc = interp1(d_u, border(i_u,1), d_query, 'linear');
    yc = interp1(d_u, border(i_u,2), d_query, 'linear');
end