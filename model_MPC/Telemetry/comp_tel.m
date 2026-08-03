%% run
car_data;
simout = sim("longitunal_DynamicModel.slx");
simout_2 = sim("steering_pad_test_dual.slx");
%% TAB
TelPlot_3= figure('Name', 'Plotting Telemetries 1', 'WindowState', 'maximized');
tabgroup_3 = uitabgroup(TelPlot_3);
tab1_3 = uitab(tabgroup_3, 'Title', '   Distance   ');
tab2_3 = uitab(tabgroup_3, 'Title', '   Engine_RPM   ');
tab4_3 = uitab(tabgroup_3, 'Title', '   G Longitudinal ');
tab5_3 = uitab(tabgroup_3, 'Title', '   Gear    ');
tab6_3 = uitab(tabgroup_3, 'Title', '   GPS_Speed    ');
%% LOAD Acc-Croazia_1.mat
load("Telemetry\Croazia_24_matlab\Acc_Croazia\Acc-Croazia_1.mat");
%% Dynamics
%LongBodyInfo
simtel.time = get(simout.logsout, 'LongBodyInfo').Values.InertFrm.Cg.Vel.Xdot.Time;
dt = diff(simtel.time);
%x
simtel.dynamics.x = get(simout.logsout,'LongBodyInfo').Values.InertFrm.Cg.Disp.X.Data;
%xdot
simtel.dynamics.xdot = get(simout.logsout, 'LongBodyInfo').Values.InertFrm.Cg.Vel.Xdot.Data*3.6;
%xddot
% dvx= diff(simtel.dynamics.xdot);
% xddot = dvx ./ dt;
% xddot(end + 1) =  xddot(end);
xddot = get(simout.logsout, 'Gx').Values.Data;
%theta
simtel.dynamics.theta = get(simout.logsout,'LongBodyInfo').Values.InertFrm.Cg.Ang.theta.Data;
Pitch = rad2deg(simtel.dynamics.theta);
%% Nuova tab per caratteristiche motore
%Gear
simtel.dynamics.Gear = get(simout.logsout,'Gear').Values.Data;
Gear_time = get(simout.logsout,'Gear').Values.Time;
%Rpm
simtel.dynamics.Engine_RPM = get(simout.logsout,'Eng_RPM').Values.Data;
%Torque
simtel.dynamics.Engine_Torque = get(simout.logsout,'Engine_Torque').Values.Data;
%% Nuova tab per gomme
%Wheel_Travel_front
simtel.dynamics.Wheel_Travel_front=get(simout.logsout,'LongBodyInfo').Values.InertFrm.FrntAxl.Disp.Z.Data;
simtel.dynamics.Wheel_Travel_rear=get(simout.logsout,'LongBodyInfo').Values.InertFrm.RearAxl.Disp.Z.Data;
%Wheel_Travel_rear
simtel.dynamics.Wheel_Travel_rear=get(simout.logsout,'LongBodyInfo').Values.InertFrm.RearAxl.Disp.Z.Data;
%Tyre_Force_vert
tempFzF = get(simout.logsout, "FzF");
tempFzF = tempFzF{2}.Values.Data;
simtel.dynamics.Tyre_Force_vert_front = squeeze(tempFzF(1, 1, :));
tempFzR = get(simout.logsout, "FzR");
tempFzR = tempFzR{2}.Values.Data;
simtel.dynamics.Tyre_Force_vert_rear = squeeze(tempFzR(1, 1, :));
%Tyre_Force_long
tempFxF = get(simout.logsout,'LongBodyInfo').Values.BdyFrm.Forces.FrntAxl.Fx.Data;
simtel.dynamics.Tyre_Force_Long_front = squeeze(tempFxF(1, 1, :));
tempFxR = get(simout.logsout,'LongBodyInfo').Values.BdyFrm.Forces.RearAxl.Fx.Data;
simtel.dynamics.Tyre_Force_Long_rear = squeeze(tempFxR(1, 1, :));


%% Nuova tab per gomme
%Spring compression
FrontSpringCompression = car.Longitudinalbody.IRf .* simtel.dynamics.Wheel_Travel_front;
RearSpringCompression = car.Longitudinalbody.IRr .* simtel.dynamics.Wheel_Travel_rear;
%% CORR_DIST
telemetry_1.Corr_Dist.Value = Corr_Dist.Value;
telemetry_1.Corr_Dist.Time = Corr_Dist.Time;

comp.sim_time = simtel.time;
comp.sim.x = simtel.dynamics.x;
comp.tel_time = telemetry_1.Corr_Dist.Time(20:65);
comp.tel.Corr_Dist = telemetry_1.Corr_Dist.Value(20:65);

x_old = linspace(1, 46, 46);
x_new = linspace(1, 46, 4632);
comp.tel_time_interp = (interp1(x_old, comp.tel_time, x_new, 'linear'))' - 539.2040; 
comp.tel.interp.Corr_Dist = (interp1(x_old, comp.tel.Corr_Dist, x_new, 'linear'))' - 9.073796785562346e+02;
%% plot
figure(TelPlot_3);axes('Parent', tab1_3);
plot(comp.tel_time_interp,comp.tel.interp.Corr_Dist,  'LineWidth', 1.5);
hold on;
plot(comp.sim_time,comp.sim.x, 'LineWidth', 1.5);
grid minor; title('Corr Dist'); xlabel('Time [s]'); ylabel('X [m]');
xlim([0 4.5]); ylim("auto");
legend('telemetry ','simulation','Location','northeastoutside');

%% Engine_speed
telemetry_1.Engine_Speed.Value = Engine_Speed.Value;
telemetry_1.Engine_Speed.Time = Engine_Speed.Time;

%comp.sim.RPM = simtel.dynamics.Engine_RPM(1:9130);
comp.tel.Engine_Speed = telemetry_1.Engine_Speed.Value(20:65);
x_rpm_old = linspace(1,4501,4501);
x_rpm_new = linspace(1,4501,4632);
comp.sim.RPM = (interp1(x_rpm_old, simtel.dynamics.Engine_RPM, x_rpm_new, 'linear'))';
comp.tel.interp.Engine_Speed = (interp1(x_old, comp.tel.Engine_Speed, x_new, 'linear'))';
RPM_sim_time = get(simout.logsout,'Eng_RPM').Values.Time;
%RPM_sim_time(4502:4632) = NaN;
%plot
figure(TelPlot_3);axes('Parent', tab2_3);
plot(comp.tel_time_interp(1:4501),comp.tel.interp.Engine_Speed(1:4501),  'LineWidth', 1.5);
hold on;
plot(RPM_sim_time,simtel.dynamics.Engine_RPM, 'LineWidth', 1.5);
grid minor; title('Engine Speed'); xlabel('Time [s]'); ylabel('RPM');
xlim([0 4.5]); ylim("auto");
legend('telemetry ','simulation','Location','northeastoutside');

%% G_long
telemetry_1.G_long.Value = G_long.Value;
telemetry_1.G_long.Time = G_long.Time;


% x_long_old = linspace(1,5132,5132);
% x_long_new = linspace(1,5132,4632);
% comp.sim.G_long = (interp1(x_long_old, xddot, x_long_new, 'linear'))'./9.81;
comp.sim.G_long = xddot;
comp.tel.G_long = telemetry_1.G_long.Value(20:65);

comp.tel.interp.G_long = (interp1(x_old, comp.tel.G_long, x_new, 'linear'))';


%plot
figure(TelPlot_3);axes('Parent', tab4_3);
plot(comp.tel_time_interp,comp.tel.interp.G_long,  'LineWidth', 1.5);
hold on;
plot(comp.sim_time,comp.sim.G_long, 'LineWidth', 1.5);
grid minor; title('Gx'); xlabel('Time [s]'); ylabel('Gx');
xlim([0 4.5]); ylim("auto");
legend('telemetry ','simulation','Location','northeastoutside');

%% Gear
telemetry_1.Gear.Value = Gear.Value;
telemetry_1.Gear.Time = Gear.Time;

%comp.sim.gear = simtel.dynamics.Gear(1:9130);
comp.tel.gear = telemetry_1.Gear.Value(20:65);

x_gear_old = linspace(1,4501,4501);
x_gear_new = linspace(1,4501,4632);
comp.sim.gear = (interp1(x_gear_old, simtel.dynamics.Gear, x_gear_new, 'linear'))';
%comp.sim.gear = simtel.dynamics.Gear(1:4632);
comp.tel.interp.gear = int32(interp1(x_old, double(comp.tel.gear), x_new, 'linear'))';

%plot
figure(TelPlot_3);axes('Parent', tab5_3);
plot(comp.tel_time_interp(1:4501),comp.tel.interp.gear(1:4501),  'LineWidth', 1.5);
hold on;
plot(Gear_time,simtel.dynamics.Gear, 'LineWidth', 1.5);
grid minor; title('Gear'); xlabel('Time [s]'); ylabel('Gear');
xlim([0 4.5]); ylim("auto");
legend('telemetry ','simulation','Location','northeastoutside');


%% GPS_Speed
telemetry_1.GPS_Speed.Value = GPS_Speed.Value;
telemetry_1.GPS_Speed.Time = GPS_Speed.Time;

comp.sim.GPS = simtel.dynamics.xdot;
comp.tel.GPS = telemetry_1.GPS_Speed.Value(20:65);

comp.tel.interp.GPS = (interp1(x_old, comp.tel.GPS, x_new, 'linear'))';

%plot
figure(TelPlot_3);axes('Parent', tab6_3);
plot(comp.tel_time_interp,comp.tel.interp.GPS,  'LineWidth', 1.5);
hold on;
plot(comp.sim_time,comp.sim.GPS, 'LineWidth', 1.5);
grid minor; title('GPS Speed'); xlabel('Time [s]'); ylabel('GPS Speed');
xlim([0 4.5]); ylim("auto");
legend('telemetry ','simulation','Location','northeastoutside');

%% CLEAR

clear tab1_3 tab2_3 tab3_3 tab4_3 tab5_3 tab6_3 tab7_3 tab8_3 tab9_3 tab10_3