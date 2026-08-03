close all;
clc;
%% TABS
POLY_ROLL = figure('Name', 'FUNCTIONS', 'WindowState', 'maximized');
tabgroup = uitabgroup(POLY_ROLL);
tab1 = uitab(tabgroup, 'Title', '   Camber   ');
tab2 = uitab(tabgroup, 'Title', '   Wheelbase Change   ');
%% BUMP
load 2026\lotus_data\lotus_roll.mat;
load roll_data.mat;
roll_funcs = [];
% camber front

x = roll_data.roll_angle;
y = roll_data.front_camber_LHS;
z = roll_data.front_camber_RHS;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
roll_funcs.front_camber_LHS = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
roll_funcs.front_camber_RHS = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_ROLL);axes('Parent', tab1);subplot(2, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER FRONT LEFT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

figure(POLY_ROLL);axes('Parent', tab1);subplot(2, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER FRONT RIGHT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

% camber rear

x = roll_data.roll_angle;
y = roll_data.rear_camber_LHS;
z = roll_data.rear_camber_RHS;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
roll_funcs.rear_camber_LHS = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
roll_funcs.rear_camber_RHS = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_ROLL);axes('Parent', tab1);subplot(2, 2, 3);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER REAR LEFT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

figure(POLY_ROLL);axes('Parent', tab1);subplot(2, 2, 4);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER REAR RIGHT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

% wheelbase change front

x = roll_data.roll_angle;
y = roll_data.front_wbchange_LHS;
z = roll_data.front_wbchange_RHS;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
roll_funcs.front_wbchange_LHS = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
roll_funcs.front_wbchange_RHS = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_ROLL);axes('Parent', tab2);subplot(2, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('WHEELBASE CHANGE FRONT LEFT');xlabel('Wheel travel [mm]');ylabel('Wheelbase Change [mm]');

figure(POLY_ROLL);axes('Parent', tab2);subplot(2, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('WHEELBASE CHANGE FRONT RIGHT');xlabel('Wheel travel [mm]');ylabel('Wheelbase Change [mm]');

% wheelbase change rear

x = roll_data.roll_angle;
y = roll_data.rear_wbchange_LHS;
z = roll_data.rear_wbchange_RHS;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
roll_funcs.rear_wbchange_LHS = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
roll_funcs.rear_wbchange_RHS = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_ROLL);axes('Parent', tab2);subplot(2, 2, 3);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('WHEELBASE CHANGE REAR LEFT');xlabel('Wheel travel [mm]');ylabel('Wheelbase Change [mm]');

figure(POLY_ROLL);axes('Parent', tab2);subplot(2, 2, 4);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('WHEELBASE CHANGE REAR RIGHT');xlabel('Wheel travel [mm]');ylabel('Wheelbase Change [mm]');

%% FUNCTIONS
roll_funcs