close all;
clc;
%% TABS
POLY_STEER = figure('Name', 'FUNCTIONS', 'WindowState', 'maximized');
tabgroup = uitabgroup(POLY_STEER);
tab1 = uitab(tabgroup, 'Title', '   Camber   ');
%% BUMP
load 2026\lotus_data\lotus_steer.mat;
load steer_data.mat;
steer_funcs = [];

% camber

x = steer_data.rack_travel;
y = steer_data.camber_LHS;
z = steer_data.camber_RHS;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
steer_funcs.camber_LHS = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
steer_funcs.camber_RHS = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_STEER);axes('Parent', tab1);subplot(1, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER LEFT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

figure(POLY_STEER);axes('Parent', tab1);subplot(1, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER RIGHT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

%% FUNCTIONS
steer_funcs