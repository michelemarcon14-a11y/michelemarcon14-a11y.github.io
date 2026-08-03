clc

%% Efficiencies and powertrain parameters
car.eta_pwt = 0.92 * 0.98;       % overall drivetrain efficiency (ICE + gearbox + bevel gear) [-]
car.eta_bg = 0.96;               % bevel gear efficiency [-]

%% Angular velocities
% w_FL: angular velocity front-left wheel [rpm]
% w_FR: angular velocity front-right wheel [rpm]
% w_ICE: angular velocity internal combustion engine [rpm]
% tps: throttle position sensor [%]

%% ENGINE 
car.engine.lut = [0 5.4650   10.9300   15.4400   18.5200   21.0450   22.4022   23.3370   24.4239   24.9076   24.9076   27.7850;
    -9 10.9300   21.8600   30.8800   37.0400   42.0900   44.8043   46.6739   48.8478   49.8152   49.8152   55.5700;
    -9.54295 9.4500   18.9000   27.8600   34.7200   41.0307   45.1630   48.6630   51.8261   53.2609   54.0435   58.5652;
    -10.419558 9.2350   18.4700   27.2900   35.1300   42.2368   47.0326   50.8043   55.1522   56.8478   57.6413   61.3696;
    -11.449392 7.7850   15.5700   24.2300   31.9700   39.1776   44.0435   47.5326   52.3478   54.1739   55.0870   58.8804;
    -12.003758 6.7750   13.5500   21.8900   29.7700   36.9627   42.0978   45.8261   51.3696   53.3696   54.6196   58.0870;
    -12.908068 4.3585    8.7170   18.7700   27.5700   36.0746   41.1000   46.8300   57.1600   62.3300   65.1900   69.7800;
    -13.949236 2.5870    5.1740   15.9300   23.7600   32.2039   40.0978   47.8261   62.9457   71.2935   75.7609   81.4565;
    -15.123209 0.8805    1.7610   13.9200   22.3000   31.2171   39.0435   47.0109   61.2500   68.8152   73.1413   78.5978;
    -16.175276 0         0    9.7280   19.4300   28.0592   36.7609   45.9457   61.3478   69.8152   74.7935   80.8152;
    -17.196114 0         0    6.7720   18.1200   25.9978   34.6848   43.8043   57.9130   66.5870   71.7174   77.5870;
    -18.069962 0         0    7.8260   15.7800   23.3443   31.3370   39.4891   52.9130   60.8804   65.3696   71.5761;
    -18.72991 0         0    2.3700   12.7200   20.8004   28.5435   36.7283   50.0870   57.9674   62.7826   68.7609;
    -19.233147 0         0         0    8.1400   18.1469   25.3478   33.9130   47.3152   54.8587   59.3804   65.6196;
    -19.645615 0         0         0    6.6000   15.1754   23.0543   30.8370   44.6957   53.2717   58.0435   63.9239;
    -19.53654 0         0         0    2.6500   11.9518   20.5652   27.9457   41.7609   49.8804   54.5761   60.5109;
    -19.39199 0         0         0         0    8.6513   16.4565   24.4565   37.5326   45.0435   49.2065   52.6413;
    -19.498215 0         0         0         0    5.8114   13.9674   21.3478   34.0978   40.8587   45.0543   47.8043];

%% Clutch
car.mu_max = 0.18;
car.w0_ICE = 10000;
car.R_clutch = 0.1195; 
car.T_clutch = 163;
car.n_dischi = 6;

car.clutch_RPM_start = 11000;
car.clutch_time_engaged = 0.1;
car.n_dischi= 6;

car.mu_clutch = 0.12;

% modello stribeck
T_eng_max = 82;
T_clutch_dynamic = 163;
car.T_clutch_static = 430;

ratio_clutch = T_clutch_dynamic / car.T_clutch_static;

car.mu_clutch_static = 0.12;
car.mu_clutch_dynamic = car.mu_clutch_static * ratio_clutch;
car.k_damping_clutch = 0.1; % [Nm / (rad/s)]
car.delta_clutch = 1.5;
car.w_stribeck = 3.5;          %[rad/s]
car.w_tolerance = 7;  

%% LSD (Limited slip differential)

R_0=0.032; %m
mu_clutch=0.1; 
n_clutch=4; %numero dischi per assale
car.Mf_preload=30; %Nm
alpha_Pon= 30; %deg
alpha_Poff= 45; %deg

car.delta_w_max = 10^-3; %rad/s

lambda=mu_clutch*R_0*n_clutch; % lambda totale per assale
Fm = car.Mf_preload/lambda; %N

% Power on 

eta0_Pon= 0.88;

F0_th_Pon=Fm*tand(alpha_Pon);  
car.M0_th_Pon=F0_th_Pon*2*R_0;
mu_Pon=lambda/(2*R_0*tand(alpha_Pon));
car.mu_Pon = 0.88;

% Power off

eta0_Poff= 0.51;

F0_th_Poff=Fm*tand(alpha_Poff);
car.M0_th_Poff=-F0_th_Poff*2*R_0;
car.mu_Poff=lambda/(2*R_0*tand(alpha_Poff));
car.mu_Poff = 0.51;

%% Gear ratios
car.Tau_EM = 9.74;              % electric motor gear ratio [-]
car.Tau_cl = 1.761;             % clutch gear ratio [-]
Tau_cl = 1.761;
Tau_bg = 2.82;              % bevel gear ratio [-]
Tau_g1 = 2.785;             % gearbox ratio 1st gear [-]
Tau_g2 = 2;                 % gearbox ratio 2nd gear [-]
Tau_g3 = 1.714;             % gearbox ratio 3rd gear [-]
Tau_g4 = 1.5;               % gearbox ratio 4th gear [-]

%% Total gear ratios
Tau_0 = 0;                         % total gear ratio, neutral [-]
Tau_1 = Tau_bg * Tau_g1;           % total gear ratio, 1st gear [-]
Tau_2 = Tau_bg * Tau_g2;           % total gear ratio, 2nd gear [-]
Tau_3 = Tau_bg * Tau_g3;           % total gear ratio, 3rd gear [-]
Tau_4 = Tau_bg * Tau_g4;           % total gear ratio, 4th gear [-]

%% Torque and force 
% T_ICE: engine torque [N*m]
% T_rear: torque after rear gearbox [N*m]
% T_RL: torque on rear-left wheel [N*m]
% T_RR: torque on rear-right wheel [N*m]
% Fx_ICE_RL: longitudinal force by ICE on RL wheel [N]
% Fx_ICE_RR: longitudinal force by ICE on RR wheel [N]
% Fx_EM_FL: longitudinal force by EM on FL wheel [N]
% Fx_EM_FR: longitudinal force by EM on FR wheel [N]

%% Vehicle geometry and mass distribution
car.R = 0.203;                  % undeformed wheel radius [m] (0.203 è l'unloaded radius della 16x7.5 da file tir)
car.m = 290;                    % total mass [kg]
m_distribution = 0.46;      % mass distribution to front axle [-]
car.h_cog = 0.2928;             % height of center of gravity [m]
car.wb0 = 1.540;            % wheelbase [m]
car.lf = car.wb0 * (1 - m_distribution);   % distance from COG to front axle [m]
car.lr = car.wb0 * m_distribution;         % distance from COG to rear axle [m]
car.tf = 1.26;
car.tr = 1.24;

car.h_rc_f = 0.03;  %da controllare
car.h_rc_r = 0.035; %da controllare

car.m_sprung = 261;           % sprung mass [kg]
car.m_unsprung_F = 7.25;      % unsprung mass front [kg]
car.m_unsprung_R = 7.25;      % unsprung mass rear [kg]
car.Iyy = 114.7;              % pitch inertia
car.Ixx = 20.15;              % roll inertia
car.Izz = 134.3;              % yaw inertia
car.V0 = 10;                  %velocità iniziale in [m/s]
car.limitatore = 12500;       % limitatore engine
%% Enviroment
car.rho = 1.2;              % air density [kg/m^3]
car.g = 9.8065;             % acceleration gravity [m/s^2]

%% Static loads on wheels
car.Fz_static_FL = car.m * m_distribution / 2 * car.g;     % static load front-left wheel [N]
car.Fz_static_FR = car.Fz_static_FL;                      % static load front-right wheel [N]
car.Fz_static_RL = car.m * (1 - m_distribution) / 2 * car.g; % static load rear-left wheel [N]
car.Fz_static_RR = car.Fz_static_RL;                      % static load rear-right wheel [N]

%% Aerodynamics
% M_aero: aerodynamic pitching moment [N*m]
car.h_cp = 0.669;               % height of center of pressure [m]
car.x_cp = 0.7238;              % longitudinal position of center of pressure [m]
car.frontal_area = 0.9812838;   % frontal area [m^2]
car.Cx = 1;                     % aerodynamic drag coefficient [-], with closed drs 1,3 0.9173707
car.Cz = 2;                     % aerodynamic lift/downforce coefficient [-], with closed drs 4,15

%% Tyre
car.tyre_pressure_front = 100000; % Front Tyre Pressure [Pa]
car.tyre_pressure_rear = 55000; % Rear Tyre Pressure [Pa]

if car.tyre_pressure_front < 83000
    car.k_tyre_front = (114182.7 + 90065.2 * (car.tyre_pressure_front/100000 - 0.69)) / 1000;
else
    car.k_tyre_front = (126791.8 + 38778.1 * (car.tyre_pressure_front/100000 - 0.83)) / 1000;
end

if car.tyre_pressure_rear < 83000
    car.k_tyre_rear = (114182.7 + 90065.2 * (car.tyre_pressure_rear/100000 - 0.69)) / 1000;
else
    car.k_tyre_rear = (126791.8 + 38778.1 * (car.tyre_pressure_rear/100000 - 0.83)) / 1000;
end

%% Suspension parameters
lbinch_Nm = 175.126835;     % conversion factor lb/in -> N/m
k_spring_front = 400;       % front spring stiffness [lb/in]
k_spring_rear = 450;        % rear spring stiffness [lb/in]
car.k_flexure = 7;              % front flexure stiffness [N/mm]
car.k_spring_front = k_spring_front * lbinch_Nm / 1000; % front spring stiffness [N/mm]
car.k_spring_rear = k_spring_rear * lbinch_Nm / 1000;   % rear spring stiffness [N/mm]

IR_spring_front = 0.562;    % front spring installation ratio [-]
IR_spring_rear = 0.785;     % rear spring installation ratio [-]
IR_arb_front = 0.270;       % front anti-roll bar installation ratio [-]
IR_arb_rear = 0.415;        % rear anti-roll bar installation ratio [-]
car.IR_spring_front = IR_spring_front;
car.IR_spring_rear = IR_spring_rear;

car.k_ARB_front = 46.935; % [N/mm]
car.k_ARB_rear = 104.698; % [N/mm]

car.k_roll_front = (car.k_spring_front * IR_spring_front^2 + car.k_flexure + car.k_ARB_front) * car.k_tyre_front / ...
              ((car.k_spring_front * IR_spring_front^2) + car.k_flexure + car.k_ARB_front + car.k_tyre_front); % [N/mm]

car.k_roll_rear = (car.k_spring_rear * IR_spring_rear^2 + car.k_ARB_rear) * car.k_tyre_rear / ...
             ((car.k_spring_rear * IR_spring_rear^2) + car.k_ARB_rear + car.k_tyre_rear);

car.k_eq_front = (car.k_spring_front * IR_spring_front^2 + car.k_flexure) * car.k_tyre_front / ...
              ((car.k_spring_front * IR_spring_front^2) + car.k_flexure + car.k_tyre_front);  % front equivalent stiffness [N/mm]
car.z0_front = car.Fz_static_FL / car.k_eq_front;           % static deflection front for ground clearence [mm]

car.k_eq_rear = (car.k_spring_rear * IR_spring_rear^2) * car.k_tyre_rear / ...
             ((car.k_spring_rear * IR_spring_rear^2) + car.k_tyre_rear);     % rear equivalent stiffness [N/mm]
car.z0_rear = car.Fz_static_RL / car.k_eq_rear;             % static deflection rear for ground clearence [mm]

car.z0_spring_front = car.Fz_static_FL / ((car.k_spring_front * IR_spring_front^2)+ car.k_flexure); % front spring static deflection at ground [mm]
car.z0_spring_rear = car.Fz_static_RL / (car.k_spring_rear * IR_spring_rear^2);   % rear spring static deflection at ground [mm]

car.h0_ground_front = 0.040;      % front ground clearance [m]
car.h0_ground_rear = 0.040;       % rear ground clearance [m]

%% Damper

car.click_comp_R = 0;
car.click_tot_comp_R = 10;
car.click_reb_R = 5;
car.click_tot_reb_R = 10;

car.click_comp_F = 5;
car.click_tot_comp_F = 10;
car.click_reb_F = 5;
car.click_tot_reb_F = 10;

%% Wheel camber angles
car.camber0_front = -0.75;            % camber angle front wheel [deg]
car.camber0_rear = -0.5;             % camber angle rear wheel [deg]

%% Wheel toe angles
car.toe0_front = 0;
car.toe0_rear = 0;

%% Rotational inertias (to be recalculated)
J_ice = 0.00702299;             %+ 0.00798422 * Tau_cl^2;             % overall inertia of components rotating at tau_primary * w_ice [kg/m^2]
J_gear = 0.00875757;            % - 0.00798422 ;            % overall inertia of components rotating at tau_primary * tau_gear * w_ice [kg/m^2]
J_rw = 0.2851673;               % overall inertia of components rotating at tau_primary * tau_gear * tau_final * w_ice [kg/m^2]
car.J_driveshaft = 0.14079359;  % driveshaft + wheel rotational inertia [kg*m^2]
car.J_ice = J_ice;

car.J_f = 0.14079359;                  % front axle rotational inertia [kg*m^2] front da controllare

%% Rotational inertia reduced to wheel 

car.Jr_tot_1 = (J_ice * Tau_cl^-2 * Tau_g1^-2 * Tau_bg^-2 * car.eta_pwt + J_gear * Tau_g1^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + car.J_driveshaft;
car.Jr_tot_2 = (J_ice * Tau_cl^-2 * Tau_g2^-2 * Tau_bg^-2 * car.eta_pwt + J_gear * Tau_g2^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + car.J_driveshaft;
car.Jr_tot_3 = (J_ice * Tau_cl^-2 * Tau_g3^-2 * Tau_bg^-2 * car.eta_pwt + J_gear * Tau_g3^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + car.J_driveshaft;
car.Jr_tot_4 = (J_ice * Tau_cl^-2 * Tau_g4^-2 * Tau_bg^-2 * car.eta_pwt + J_gear * Tau_g4^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + car.J_driveshaft;
car.Jr_tot_0 = car.J_driveshaft;

Jr_tot_0 = car.Jr_tot_0;
Jr_tot_1 = car.Jr_tot_1;
Jr_tot_2 = car.Jr_tot_2;
Jr_tot_3 = car.Jr_tot_3;
Jr_tot_4 = car.Jr_tot_4;

%% Rotational inertia after clutch

car.Jr_clutch_1 = (J_gear * Tau_g1^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + 2 * car.J_driveshaft;
car.Jr_clutch_2 = (J_gear * Tau_g2^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + 2 * car.J_driveshaft;
car.Jr_clutch_3 = (J_gear * Tau_g3^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + 2 * car.J_driveshaft;
car.Jr_clutch_4 = (J_gear * Tau_g4^-2 * Tau_bg^-2 * 0.98 * car.eta_bg)/2 + 2 * car.J_driveshaft;


%% Brake
car.bp_max = 80;
car.brakebias = 0.54 ; %Car brake balance referred to wheel [-]
car.prop_valve_pos = 2; % Position proportional valve [1-7]
car.brakepistondiameter = 0.0249 ; %Brake piston diameter [m]
car.brakepad_friction_coeff = 0.48 ; %Brake Pad friction coefficient [-]
car.brake_radius_front = 0.08075 ; %Front brake disk effective radius [m]
car.brake_radius_rear = 0.07725 ; %Rear brake disk effective radius [m]
car.area_front_piston = 0.00067488; % Front piston area [m^2]
car.area_rear_piston = 0.00072796; % Rear piston area [m^2]

%% Steering
car.steer_ratio = 5;
car.steer_lock = 160; 

%% Initial conditions
car.initialconditions_EngineRPM = 7000;
car.initialconditions.Wrpm = 0;
car.initialconditions.xdot = 0;
car.initialconditions.FzR = 0;

%% Skidpad
% car.X0 = -15;
% car.Y0 = 0;

%% Tyre data 

% ricerca e caricamento file .tir
% 1. Trova path del file .tir relativo al progetto
filePath = fileparts(mfilename('fullpath'));

% Use .tir file of Hoosier 18x6x10 R20 rim7 (only longitudinal)
tirFile  = fullfile(filePath,'tir_files','Generic_18x6x10_R20_7_in_rim.tir');

% Use .tir file of Hoosier 16x7.5x10 LCO rim7 (only lateral)
%tirFile  = fullfile(filePath,'tir_files','Hoosier_16x75x10_LC0_7_in_rim.tir');

% Use .tir file of Hoosier Zombie (zombie, 18x6 R20 longitudinal, 16x7.5 LC0 lateral)
%tirFile  = fullfile(filePath,'tir_files','Hoosier_zombie_tire.tir');

%  Lettura del .tir
p = readTirParameters(tirFile);

% estrazione coefficienti longitudinali

car.tyre_Cx1 = getParam(p,'PCX1',1);

car.tyre_Dx1 = getParam(p,'PDX1',1);
car.tyre_Dx2 = getParam(p,'PDX2',0);
car.tyre_Dx3 = getParam(p,'PDX3',0);

car.tyre_Ex1 = getParam(p,'PEX1',0);
car.tyre_Ex2 = getParam(p,'PEX2',0);
car.tyre_Ex3 = getParam(p,'PEX3',0);
car.tyre_Ex4 = getParam(p,'PEX4',0);

car.tyre_Kx1 = getParam(p,'PKX1',10);
car.tyre_Kx2 = getParam(p,'PKX2',0);
car.tyre_Kx3 = getParam(p,'PKX3',0);

car.tyre_Hx1 = getParam(p,'PHX1',0);
car.tyre_Hx2 = getParam(p,'PHX2',0);

car.tyre_Vx1 = getParam(p,'PVX1',0);
car.tyre_Vx2 = getParam(p,'PVX2',0);

car.tyre_px1 = getParam(p,'PPX1',0);
car.tyre_px2 = getParam(p,'PPX2',0);
car.tyre_px3 = getParam(p,'PPX3',0);
car.tyre_px4 = getParam(p,'PPX4',0);

car.tyre_ptx1 = getParam(p,'PTX1',0);
car.tyre_ptx2 = getParam(p,'PTX2',0);
car.tyre_ptx3 = getParam(p,'PTX3',0);

car.tyre_rbx1 = getParam(p,'RBX1',0);
car.tyre_rbx2 = getParam(p,'RBX2',0);
car.tyre_rcx1 = getParam(p,'RCX1',0);
car.tyre_rex1 = getParam(p,'REX1',0);
car.tyre_rex2 = getParam(p,'REX2',0);
car.tyre_rhx1 = getParam(p,'RHX1',0);

car.tyre_lmux = getParam(p,'LMUX',1);

car.scale_factor = 0.7;

% % se manca lmux/mettiamo 1 per sicurezza
% if ~isfield(tyre,'lmux') || isempty(tyre.lmux)
%     tyre.lmux = 1;
% end
% 
% % 4. Esporta come Simulink.Parameter globale chiamato TYRE
% TYRE = Simulink.Parameter(tyre);
% TYRE.CoderInfo.StorageClass = 'Auto';  % va bene così
% 
% % metti TYRE in base workspace (così il modello lo vede)
% assignin('base','TYRE',TYRE);
% 
% fprintf('TYRE pronto nel base workspace.\n');
% 

 % estrazione coefficienti laterali
car.tyre_Cy1 = getParam(p,'PCY1',1.1);

car.tyre_Dy1 = getParam(p,'PDY1',1);
car.tyre_Dy2 = getParam(p,'PDY2',0);
car.tyre_Dy3 = getParam(p,'PDY3',0);

car.tyre_Ey1 = getParam(p,'PEY1',0);
car.tyre_Ey2 = getParam(p,'PEY2',0);
car.tyre_Ey3 = getParam(p,'PEY3',0);
car.tyre_Ey4 = getParam(p,'PEY4',0);

car.tyre_Ky1 = getParam(p,'PKY1',20);
car.tyre_Ky2 = getParam(p,'PKY2',0);
car.tyre_Ky3 = getParam(p,'PKY3',0);

car.tyre_Hy1 = getParam(p,'PHY1',0);
car.tyre_Hy2 = getParam(p,'PHY2',0);
car.tyre_Hy3 = getParam(p,'PHY3',0);

car.tyre_Vy1 = getParam(p,'PVY1',0);
car.tyre_Vy2 = getParam(p,'PVY2',0);
car.tyre_Vy3 = getParam(p,'PVY3',0);
car.tyre_Vy4 = getParam(p,'PVY4',0);

car.tyre_py1 = getParam(p,'PPY1',0);
car.tyre_py2 = getParam(p,'PPY2',0);
car.tyre_py3 = getParam(p,'PPY3',0);
car.tyre_py4 = getParam(p,'PPY4',0);

car.tyre_rby1 = getParam(p,'RBY1',0);
car.tyre_rby2 = getParam(p,'RBY2',0);
car.tyre_rby3 = getParam(p,'RBY2',0);
car.tyre_rcy1 = getParam(p,'RCY1',0);
car.tyre_rey1 = getParam(p,'REY1',0);
car.tyre_rey2 = getParam(p,'REY2',0);
car.tyre_rhy1 = getParam(p,'RHY1',0);
car.tyre_rhy2 = getParam(p,'RHY2',0);
car.tyre_rvy1 = getParam(p,'RVY1',0);
car.tyre_rvy2 = getParam(p,'RVY2',0);
car.tyre_rvy3 = getParam(p,'RVY3',0);
car.tyre_rvy4 = getParam(p,'RVY4',0);
car.tyre_rvy5 = getParam(p,'RVY5',0);
car.tyre_rvy6 = getParam(p,'RVY6',0);

car.tyre_lmuy = getParam(p,'LMUY',1);

% ------- FUNZIONI LOCALI -------
function params = readTirParameters(tirFilename)
    fid = fopen(tirFilename,'r');
    if fid < 0, error('Impossibile aprire il file: %s',tirFilename); end
    cleaner = onCleanup(@() fclose(fid));
    params = struct();
    while ~feof(fid)
        line = fgetl(fid);
        if ~ischar(line), break; end
        % leggo righe tipo "PCX1 = 1.5"
        tokensNum = regexp(line,'^\s*(\S+)\s*=\s*([-+]?\d+(\.\d+)?([eE][+-]?\d+)?)','tokens');
        if ~isempty(tokensNum)
            name = tokensNum{1}{1};
            val  = str2double(tokensNum{1}{2});
            if ~isnan(val), params.(name) = val; end
        end
    end
end

% la funzione getParam prende i valori letti "p" ed estrae il valore con il
% nome del relativo coefficiente. l'ultimo numero è il valore di default
% nel caso non riesca a trovare o mancasse il valore vero nel file .tir

function val = getParam(s,field,def)
    if isfield(s,field), val = s.(field); else, val = def; end
end

% --- Relaxation Length (Lunghezza di Rilassamento) [m] ---
car.Ly = 0.35; % Laterale (Tipica FSAE 10-13 pollici)
car.Lx = 0.15; % Longitudinale (Solitamente più rigida della laterale)

% TYRES PRESSURE

car.tyre_pressure = [car.tyre_pressure_front car.tyre_pressure_front car.tyre_pressure_rear car.tyre_pressure_rear];
car.tyre_pi0 = getParam(p,'IP_NOM',83000);  % Pa nominale
%ATTENZIONE! Cautela nella scelta di pressioni alte, il modello gomma
%potrebbe non essere più coerente.

% Forza verticale nominale
car.tyre_Fz0 = getParam(p,'FNOMIN',0);

% Unloaded Radius
%car.R = getParam(p,'UNLOADED_RADIUS',0.2286);

% Tires
car.rolling_resistance = 0.03*car.R;         % rolling resistance parameter [m]
car.delta = 0.03*car.R;

% BUS che si collega al blocco Simulink come input costante
carBus = Simulink.Bus.createObject(car);

%%
load("lotus_bump.mat");load("lotus_bump.mat");
load("lotus_roll.mat");
load("lotus_steer.mat");

%% SKIDPAD TRACK POINTS

mdlWks = get_param('vdynblksskidpad','ModelWorkspace');
TrackPoints = evalin(mdlWks,'TrackPoints');
figure;
plot(TrackPoints(:,2),TrackPoints(:,1),'ro-');
hold on;
arrowLen = 1.5;
quiver(TrackPoints(:,2),TrackPoints(:,1), ...
    arrowLen*sin(TrackPoints(:,3)),arrowLen*cos(TrackPoints(:,3)), ...
    'b','LineWidth',1,'MaxHeadSize',arrowLen);
box on;
grid on;
xlabel('Y [m]');
ylabel('X [m]');
axis equal;
legend('Waypoints','Path Direction');


%%


% %% MPC Controller Setup (Adaptive Traction Control - SISO)
% % Configurazione per Adaptive MPC:
% % 2 Stati: v, omega (vel. angolare)
% % 1 Input: Torque (Coppia)
% % 1 Output: Slip (Slip Ratio)
% 
% % 1. Impostazioni MPC
% % Sample time: deve corrispondere a quello del blocco Simulink (es. 2ms)
% Ts_mpc = 0.002; 
% p = 15;     % Prediction Horizon
% m = 2;      % Control Horizon
% 
% % 2. Definizione delle matrici
% A0 = zeros(2,2);
% B0 = zeros(2,1);
% C0 = eye(1,2);
% D0 = 0;
% 
% % Creazione oggetto plant nominale DISCRETO
% plant = ss(A0, B0, C0, D0, Ts_mpc); 
% 
% plant.StateName = {'v','omega'};   
% plant.InputName = {'Torque'};
% plant.OutputName = {'Slip'};
% 
% % 3. Creazione oggetto MPC
% mpcobj = mpc(plant, Ts_mpc, p, m);
% 
% % RIMUOVI il modello di disturbo di default (Integratore)
% setoutdist(mpcobj, 'remove'); 
% 
% % Imposta la stima personalizzata
% setEstimator(mpcobj, 'custom');
% 
% % 4. Tuning dei Pesi (Weights)
% % Priorità: seguire il target di Slip (Output Weight alto)
% mpcobj.Weights.OutputVariables = 10; 
% 
% % Input: Non penalizzare l'uso di coppia, ma penalizzare le variazioni brusche (Rate)
% mpcobj.Weights.ManipulatedVariables = 0; 
% mpcobj.Weights.ManipulatedVariablesRate = 0.5; 
% 
% % 5. Vincoli (Constraints)
% mpcobj.MV.Min = 0;   
% mpcobj.MV.Max = 120; % Coppia MAX motore
% 
% % --- IMPORTANTE ---
% % Dopo aver copiato questo codice:
% % 1. Salva lo script.
% % 2. ESEGUI (Run) lo script per aggiornare 'mpcobj' nel Workspace.
% % 3. Solo dopo lancia Simulink.