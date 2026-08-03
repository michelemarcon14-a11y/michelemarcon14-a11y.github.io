close all;
clc;
%% TABS
POLY_BUMP = figure('Name', 'FUNCTIONS', 'WindowState', 'maximized');
tabgroup = uitabgroup(POLY_BUMP);
tab1 = uitab(tabgroup, 'Title', '   Camber   ');
tab2 = uitab(tabgroup, 'Title', '   Wheelbase Change   ');
tab3 = uitab(tabgroup, 'Title', '   Antisquat   ');
tab4 = uitab(tabgroup, 'Title', '   Antidive   ');
tab5 = uitab(tabgroup, 'Title', '   IR   ');
%% BUMP
load 2026\lotus_data\lotus_bump.mat;
load bump_data.mat;
bump_funcs = [];

% camber

x = bump_data.wheeltravel;
y = bump_data.camber_front;
z = bump_data.camber_rear;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
bump_funcs.camber_front = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
bump_funcs.camber_rear = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_BUMP);axes('Parent', tab1);subplot(1, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER FRONT');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

figure(POLY_BUMP);axes('Parent', tab1);subplot(1, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('CAMBER REAR');xlabel('Wheel travel [mm]');ylabel('Camber [deg]');

% wheelbase change

x = bump_data.wheeltravel;
y = bump_data.wheelbase_change_front;
z = bump_data.wheelbase_change_rear;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
bump_funcs.wheelbase_change_front = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
bump_funcs.wheelbase_change_rear = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_BUMP);axes('Parent', tab2);subplot(1, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('WHEELBASE CHANGE FRONT');xlabel('Wheel travel [mm]');ylabel('Wheelbase Change [mm]');

figure(POLY_BUMP);axes('Parent', tab2);subplot(1, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('WHEELBASE CHANGE REAR');xlabel('Wheel travel [mm]');ylabel('Wheelbase Change [mm]');

% antisquat

x = bump_data.wheeltravel;
y = bump_data.antisquat;

n = 7;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
bump_funcs.antisquat = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata


% Plot
figure(POLY_BUMP);axes('Parent', tab3);subplot(1, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('ANTISQUAT');xlabel('Wheel travel [mm]');ylabel('Antisquat [%]');

% antidive

x = bump_data.wheeltravel;
y = bump_data.antidive_front;
z = bump_data.antidive_rear;

n = 5;

p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
bump_funcs.antidive_front = p_y;
y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata

p_z = polyfit(x, z, n);
bump_funcs.antidive_rear = p_z;
z_fit = polyval(p_z, x);

% Plot
figure(POLY_BUMP);axes('Parent', tab4);subplot(1, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('ANTIDIVE FRONT');xlabel('Wheel travel [mm]');ylabel('Antidive [deg]');

figure(POLY_BUMP);axes('Parent', tab4);subplot(1, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Interp','Location','northeastoutside');
grid minor; title('ANTIDIVE REAR');xlabel('Wheel travel [mm]');ylabel('Antidive [deg]');

% IR

% x = bump_data.wheeltravel;
% y = bump_data.ir_front;
% z = bump_data.ir_rear;
% 
% n = 10;
% 
% p_y = polyfit(x, y, n);      % trova i coefficienti del polinomio di grado n
% bump_funcs.ir_front = p_y;
% y_fit = polyval(p_y, x);     % calcola i valori della curva approssimata
% 
% p_z = polyfit(x, z, n);
% bump_funcs.ir_rear = p_z;
% z_fit = polyval(p_z, x);

x = bump_data.wheeltravel;
y = bump_data.ir_front;
z = bump_data.ir_rear;

% fit tramite smoothing spline
p_y = fit(x, y, 'smoothingspline');
bump_funcs.ir_front = p_y;
ir_front_coeffs = coeffvalues(p_y);
y_fit = p_y(x);

p_z = fit(x, z, 'smoothingspline');
bump_funcs.ir_rear = p_z;
ir_rear_coeffs = coeffvalues(p_z);
z_fit = p_z(x);


% Plot
figure(POLY_BUMP);axes('Parent', tab5);subplot(1, 2, 1);
plot(x, y, 'o', x, y_fit, '-')
legend('Real','Smoothed','Location','northeastoutside');
grid minor; title('IR FRONT');xlabel('Wheel travel [mm]');ylabel('IR');

figure(POLY_BUMP);axes('Parent', tab5);subplot(1, 2, 2);
plot(x, z, 'o', x, z_fit, '-')
legend('Real','Smoothed','Location','northeastoutside');
grid minor; title('IR REAR');xlabel('Wheel travel [mm]');ylabel('IR');
%% FUNCTIONS
bump_funcs


