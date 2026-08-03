clear; clc; close all;
%-------------------------------------------------------------------------%ì
% Constant parameters
g= 9.81;  %gravity [m/s^2]
rho = 1.2; % Air density [kg/m^3]
Cd  = 1.8;  % Drag coefficient
Cz = 4.05; %Downforce coefficient
A =1.11; %Cross sectional area [m^2]
f =0.025; %rolling friction coefficient
m = 298; %mass of the fully loaded vehicle with the driver[kg]
R=0.254; %wheel effective radius [m]
ratios=[1/13.83, 1/10.19, 1/8.51, 1/7.45]; %transmission ratios between engine and wheel
tau_em=9.71; %transmission ratios between electric motor and wheel
Mapp = [355.0, 335.8, 328.8, 325.1];   %apparent translating masses [kg] 
eta_ice=0.96^3; %mechanical efficiency ICE
eta_em= 0.97; %mechanical efficiency electric motor
gearNames = ["1st gear", "2nd gear", "3rd gear", "4th gear"];
%-------------------------------------------------------------------------%
% Engine parameters at 100% TPS
T_ice= [27.79, 55.57 ,58.57 ,61.37, 58.88, 58.09, 69.78, 81.46, 78.60, ...
     80.82, 77.59, 71.58, 68.76, 65.62, 63.92, 60.51, 52.64, 47.80]; 
w_ice = [0, 4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000, ...
     9500,10000,10500,11000,11500,12000];    
% Electric motros parameters at 100% TPS
T_em=[6.91,6.91, 6.46,5.72,5.04,4.45,3.93,3.15,2.55,2.04];
w_em = [0, 5415, 6000, 7000, 8000, 9000, 10000,12000, 14000, 16000];

v = linspace(0.1, 40, 200);

Pn_fun = @(v) (0.5*rho*Cd*A*v.^3) + (f*v.*(m*g + 0.5*rho*Cz*A*v.^2));
v_em = (2*pi*R*tau_em) .* w_em ./ 60;
P_em= (T_em .* w_em .* (2*pi / (1000*60)));
P_em_interp = interp1(v_em, P_em, v, 'linear', 'extrap');

%-------------------------------------------------------------------------%
figure(1); hold on; grid on;
figure(4); hold on; grid on;
figure(5); hold on; grid on;

colors = lines(length(Mapp)); 

a_all = zeros(length(Mapp), length(v));  % salva le curve di accelerazione
v_kmh = 3.6*v;  % velocità in km/h per plot

for i = 1:length(Mapp)
    r = ratios(i);
    m_app = Mapp(i);

    v_eng = (2*pi*R*r) .* w_ice ./ 60;
    Pn = Pn_fun(v) / 1000;
    Peng = (T_ice .* w_ice .* (2*pi / (1000*60)));
    Peng_interp = interp1(v_eng, Peng, v, 'linear', 'extrap');
    Pe = (eta_ice*Peng_interp) + 2*(eta_em*P_em_interp) - Pn;
    a = 1000 * Pe ./ (v .* m_app);

    a_all(i,:) = a;  % salva accelerazioni per intersezioni

    %---------------- PLOT ----------------%
    figure(1);
    plot(v, Peng_interp, '-', 'Color', colors(i,:), 'LineWidth', 2, ...
        'DisplayName',gearNames(i));

    figure(4);
    plot(v, Pe, '-', 'Color', colors(i,:), 'LineWidth', 2, ...
        'DisplayName', gearNames(i));

    figure(5);
    plot(v_kmh, a, '-', 'Color', colors(i,:), 'LineWidth', 2, ...
        'DisplayName', gearNames(i));
end

%-------------------------------------------------------------------------%

% Intersezioni tra curve successive
intersections = zeros(length(Mapp)-1,1);  
for i = 1:length(Mapp)-1
    diff = a_all(i,:) - a_all(i+1,:);
    idx = find(diff(1:end-1).*diff(2:end) <= 0, 1, 'first'); 
    if ~isempty(idx)
        x1 = v_kmh(idx);
        x2 = v_kmh(idx+1);
        y1 = diff(idx);
        y2 = diff(idx+1);
        intersections(i) = x1 - y1*(x2-x1)/(y2-y1);  % interpolazione lineare
        % plot punto di intersezione
        figure(5);
 % Genera la stringa con solo la velocità in km/h
label_str = sprintf('%.1f km/h', intersections(i));

% Plotta il punto e aggiunge la legenda con la sola velocità
h = plot(intersections(i), a_all(i, idx), 'ro', 'MarkerSize',8,'LineWidth',2, ...
         'DisplayName', label_str);

    else
        intersections(i) = NaN;
    end
end

disp('Optimal speed at which to change gear to maximize acceleration:');
fprintf('\n');
for i = 1:length(intersections)
    if ~isnan(intersections(i))
        fprintf('Change from %s to %s: %.1f km/h\n', gearNames(i), gearNames(i+1), intersections(i));
    else
        fprintf('Change from %s to %s: not found\n', gearNames(i), gearNames(i+1));
    end
end

%-------------------------------------------------------------------------%

% Etichette e legende finali
figure(1);
plot(v, Pn, 'k', 'LineWidth', 2, 'DisplayName', 'Pn');
xlabel('Speed [m/s]');
ylabel('Power [kW]');
title('Engine Power vs Drag and Rolling Resitance Power (for different gear ratios)');
legend('show', 'Location', 'northwest'); 
grid on;

figure(4);
xlabel('Speed [m/s]');
ylabel('Power surplus [kW]');
title('Pe: power available after overcoming drag and rolling resistance');
legend show; grid on;

figure(5);
v_lines = 0:5:150;
for k = 1:length(v_lines)
    xline(v_lines(k), '--', 'Color', [0.7 0.7 0.7], 'HandleVisibility','off'); 
end
xticks(0:5:150);  % imposta i tick da 0 a 150 con passo 5
xlabel('Speed [km/h]');
ylabel('Acceleration [m/s^2]');
title('Acceleration vs Speed (for different gear ratios)');
legend show; grid on;

figure(2);
plot(w_ice, T_ice, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Engine speed [rpm]');
ylabel('Engine torque [Nm]');
title('Lookup‐table: Engine curve');
grid on;

figure(3);
Peng = (T_ice .* w_ice .* (2*pi / (1000*60)));
plot(w_ice, Peng, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Engine speed [rpm]');
ylabel('Engine power [kW]');
title('Engine power');
grid on;

figure(6);
plot(w_em, 2*T_em, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Electric motors speed [rpm]');
ylabel('Engine torque [Nm]');
title('Electric motors (both) torque');
grid on;

figure(7);
plot(w_em, 2*P_em, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Electric motor speed [rpm]');
ylabel('Electric motors power');
title('Electric motors (both) power');
grid on;
