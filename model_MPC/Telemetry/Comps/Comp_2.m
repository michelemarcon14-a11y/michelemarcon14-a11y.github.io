%% TAB
TelPlot_2= figure('Name', 'Plotting Telemetries 1', 'WindowState', 'maximized');
tabgroup = uitabgroup(TelPlot_2);
tab1 = uitab(tabgroup, 'Title', '   Distance   ');
tab2 = uitab(tabgroup, 'Title', '   Engine_RPM   ');
tab3 = uitab(tabgroup, 'Title', '   Friction_Slip   ');
tab4 = uitab(tabgroup, 'Title', '   G Longitudinal  ');
tab4_1 = uitab(tabgroup, 'Title', '   G Lateral ');
tab5 = uitab(tabgroup, 'Title', '   Gear    ');
tab6 = uitab(tabgroup, 'Title', '   GPS_Speed    ');
tab7 = uitab(tabgroup, 'Title', '   Pitch_Susp    ');
tab8 = uitab(tabgroup, 'Title', '   Suspension    ');
tab9 = uitab(tabgroup, 'Title', '   Throttle    ');
tab10 = uitab(tabgroup, 'Title', '   Wheel_Speed    ');




%% LOAD Acc-Croazia_2.mat
load("Telemetry\Croazia_24_matlab\Acc_Croazia\Acc-Croazia_2.mat");





%% Dynamics

%LongBodyInfo

simtel.time = get(simout.logsout, 'LongBodyInfo').Values.InertFrm.Cg.Vel.Xdot.Time;
dt = diff(simtel.time);

%x
simtel.dynamics.x = get(simout.logsout,'LongBodyInfo').Values.InertFrm.Cg.Disp.X.Data;


%xdot
simtel.dynamics.xdot = get(simout.logsout, 'LongBodyInfo').Values.InertFrm.Cg.Vel.Xdot.Data*3.6;

%xddot
dvx= diff(simtel.dynamics.xdot);
xddot = dvx ./ dt;
xddot(end + 1) =  xddot(end);



%theta
simtel.dynamics.theta = get(simout.logsout,'LongBodyInfo').Values.InertFrm.Cg.Ang.theta.Data;
Pitch = rad2deg(simtel.dynamics.theta);


%% Nuova tab per caratteristiche motore


%reshape vectors
% simtel.dynamics.Engine_TPS = get(simout.logsout, "Engine_TPS").Values.Data;
% TPS_time = get(simout.logsout, "Engine_TPS").Values.Time;
% 
% 
% figure(DynModTel);axes('Parent', tab2);

%Gear
simtel.dynamics.Gear = get(simout.logsout,'Gear').Values.Data;
Gear_time = get(simout.logsout,'Gear').Values.Time;


%Rpm
simtel.dynamics.Engine_RPM = get(simout.logsout,'Engine_RPM').Values.Data;


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



%Tyre_Force_rear
% tempFzR = get(simout.logsout,'FzR').Values.Data;
% simtel.dynamics.Tyre_Force_rear = squeeze(tempFzR(1, 1, :));

%Tyre_Force_long
tempFxF = get(simout.logsout,'LongBodyInfo').Values.BdyFrm.Forces.FrntAxl.Fx.Data;
simtel.dynamics.Tyre_Force_Long_front = squeeze(tempFxF(1, 1, :));
tempFxR = get(simout.logsout,'LongBodyInfo').Values.BdyFrm.Forces.RearAxl.Fx.Data;
simtel.dynamics.Tyre_Force_Long_rear = squeeze(tempFxR(1, 1, :));


%% Nuova tab per gomme

%Spring compression
FrontSpringCompression = car.Longitudinalbody.IRf .* simtel.dynamics.Wheel_Travel_front;
RearSpringCompression = car.Longitudinalbody.IRr .* simtel.dynamics.Wheel_Travel_rear;

%%%%%%%%%% PLOT TELEMETRIE %%%%%%%%%%%

%% CORR_DIST
telemetry_2.Corr_Dist.Value = Corr_Dist.Value;
telemetry_2.Corr_Dist.Time = Corr_Dist.Time;
%plot
figure(TelPlot_2);axes('Parent', tab1);
subplot(1,2,1);
plot(telemetry_2.Corr_Dist.Time,telemetry_2.Corr_Dist.Value,  'LineWidth', 1.5);
grid minor; title('Telemetry'); xlabel('Time [s]'); ylabel('Corr-Dist');
figure(TelPlot_2);axes('Parent', tab1);
subplot(1,2,2);
plot(simtel.time,simtel.dynamics.x,  'LineWidth', 1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('X [m]');
%% Engine_speed
telemetry_2.Engine_Speed.Value = Engine_Speed.Value;
telemetry_2.Engine_Speed.Time = Engine_Speed.Time;
%plot
figure(TelPlot_2);axes('Parent', tab2);
subplot(1,2,1);
plot(telemetry_2.Engine_Speed.Time,telemetry_2.Engine_Speed.Value,  'LineWidth', 1.5);
grid minor; title('Telemetry'); xlabel('Time [s]'); ylabel('Engine Speed');
figure(TelPlot_2);axes('Parent', tab2);
subplot(1,2,2);
plot(simtel.time,simtel.dynamics.Engine_RPM, LineWidth=1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('RPM');
%% Friction_Slip
telemetry_2.Friction_Slip.Value = Friction_Slip.Value;
telemetry_2.Friction_Slip.Time = Friction_Slip.Time;
%plot
figure(TelPlot_2);axes('Parent', tab3);
plot(telemetry_2.Friction_Slip.Time,telemetry_2.Friction_Slip.Value,  'LineWidth', 1.5);
grid minor; title('Friction Slip'); xlabel('Time [s]'); ylabel('Friction Slip');

%% G_lat
telemetry_2.G_lat.Value = G_lat.Value;
telemetry_2.G_lat.Time = G_lat.Time;
simtel_2.G = get(simout_2.logsout, 'Gy').Values.Data;
simtel_2.time = get(simout_2.logsout, 'xdot').Values.Time;
%plot
figure(TelPlot_2);axes('Parent', tab4_1);
subplot(1,2,1);
plot(telemetry_2.G_lat.Time,telemetry_2.G_lat.Value,  'LineWidth', 1.5);
grid minor; title('G lat'); xlabel('Time [s]'); ylabel('G lat');
figure(TelPlot_2);axes('Parent', tab4_1);
subplot(1,2,2);
plot(simtel_2.time,simtel_2.G./9.81,  'LineWidth', 1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('a_y [G]');

%% G_long
telemetry_2.G_long.Value = G_long.Value;
telemetry_2.G_long.Time = G_long.Time;
%plot
figure(TelPlot_2);axes('Parent', tab4);
subplot(1,2,1);
plot(telemetry_2.G_long.Time,telemetry_2.G_long.Value,  'LineWidth', 1.5);
grid minor; title('Telemetry'); xlabel('Time [s]'); ylabel('G long');
figure(TelPlot_2);axes('Parent', tab4);
subplot(1,2,2);
plot(simtel.time,xddot,  'LineWidth', 1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('a_x [m/s^2]');

%% Gear
telemetry_2.Gear.Value = Gear.Value;
telemetry_2.Gear.Time = Gear.Time;
%plot
figure(TelPlot_2);axes('Parent', tab5);
subplot(1,2,1);
plot(telemetry_2.Gear.Time,telemetry_2.Gear.Value,  'LineWidth', 1.5);
grid minor; title('Telemetry'); xlabel('Time [s]'); ylabel('Gear');
figure(TelPlot_2);axes('Parent', tab5);
subplot(1,2,2);
plot(Gear_time,simtel.dynamics.Gear, LineWidth=1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('Gear');

%% GPS_Speed
telemetry_2.GPS_Speed.Value = GPS_Speed.Value;
telemetry_2.GPS_Speed.Time = GPS_Speed.Time;
%plot
figure(TelPlot_2);axes('Parent', tab6);
subplot(1,2,1);
plot(telemetry_2.GPS_Speed.Time,telemetry_2.GPS_Speed.Value,  'LineWidth', 1.5);
grid minor; title('Telemetry'); xlabel('Time [s]'); ylabel('GPS Speed');
figure(TelPlot_2);axes('Parent', tab6);
subplot(1,2,2);
plot(simtel.time,simtel.dynamics.xdot,  'LineWidth', 1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('V_x');


%% Pitch_Susp 
telemetry_2.Pitch_Susp.Value = Pitch_Susp.Value;
telemetry_2.Pitch_Susp.Time = Pitch_Susp.Time;
%plot
figure(TelPlot_2);axes('Parent', tab7);
subplot(1,2,1);
plot(telemetry_2.Pitch_Susp.Time,telemetry_2.Pitch_Susp.Value,  'LineWidth', 1.5);
grid minor; title('Telemetry'); xlabel('Time [s]'); ylabel('Pitch Susp');
figure(TelPlot_2);axes('Parent', tab7);
subplot(1,2,2);
plot(simtel.time,Pitch,'LineWidth', 1.5);
grid minor; title('Simulation'); xlabel('Time [s]'); ylabel('Pitch [deg]');

%% Suspension_Front_Left
telemetry_2.Suspension_Front_Left.Value = Suspension_Front_Left.Value;
telemetry_2.Suspension_Front_Left.Time = Suspension_Front_Left.Time;
%plot
figure(TelPlot_2);axes('Parent', tab8);subplot(2,2,1);
plot(telemetry_2.Suspension_Front_Left.Time,telemetry_2.Suspension_Front_Left.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Front Left'); xlabel('Time [s]'); ylabel('Suspension Front Left');

%% Suspension_Front_Right
telemetry_2.Suspension_Front_Right.Value = Suspension_Front_Right.Value;
telemetry_2.Suspension_Front_Right.Time = Suspension_Front_Right.Time;
%plot
figure(TelPlot_2);axes('Parent', tab8);subplot(2,2,2);
plot(telemetry_2.Suspension_Front_Right.Time,telemetry_2.Suspension_Front_Right.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Front Right'); xlabel('Time [s]'); ylabel('Suspension Front Right');

%% Suspension_Rear_Left
telemetry_2.Suspension_Rear_Left.Value = Suspension_Rear_Left.Value;
telemetry_2.Suspension_Rear_Left.Time = Suspension_Rear_Left.Time;
%plot
figure(TelPlot_2);axes('Parent', tab8);subplot(2,2,3);
plot(telemetry_2.Suspension_Rear_Left.Time,telemetry_2.Suspension_Rear_Left.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Rear Left'); xlabel('Time [s]'); ylabel('Suspension Rear Left');

%% Suspension_Rear_Right
telemetry_2.Suspension_Rear_Right.Value = Suspension_Rear_Right.Value;
telemetry_2.Suspension_Rear_Right.Time = Suspension_Rear_Right.Time;
%plot
figure(TelPlot_2);axes('Parent', tab8);subplot(2,2,4);
plot(telemetry_2.Suspension_Rear_Right.Time,telemetry_2.Suspension_Rear_Right.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Rear Right'); xlabel('Time [s]'); ylabel('Suspension Rear Right');

%% Throttle_Pedal
telemetry_2.Throttle_Pedal.Value = Throttle_Pedal.Value;
telemetry_2.Throttle_Pedal.Time = Throttle_Pedal.Time;
%plot
figure(TelPlot_2);axes('Parent', tab9);subplot(1,2,1);
plot(telemetry_2.Throttle_Pedal.Time,telemetry_2.Throttle_Pedal.Value,  'LineWidth', 1.5);
grid minor; title('Throttle Pedal'); xlabel('Time [s]'); ylabel('Throttle Pedal');

%% Throttle_Position
telemetry_2.Throttle_Position.Value = Throttle_Position.Value;
telemetry_2.Throttle_Position.Time = Throttle_Position.Time;
%plot
figure(TelPlot_2);axes('Parent', tab9);subplot(1,2,2);
plot(telemetry_2.Throttle_Position.Time,telemetry_2.Throttle_Position.Value,  'LineWidth', 1.5);
grid minor; title('Throttle Position'); xlabel('Time [s]'); ylabel('Throttle Position');

%% Wheel_Speed_Front_Left
telemetry_2.Wheel_Speed_Front_Left.Value = Wheel_Speed_Front_Left.Value;
telemetry_2.Wheel_Speed_Front_Left.Time = Wheel_Speed_Front_Left.Time;
%plot
figure(TelPlot_2);axes('Parent', tab10);subplot(2,2,1);
plot(telemetry_2.Wheel_Speed_Front_Left.Time,telemetry_2.Wheel_Speed_Front_Left.Value,  'LineWidth', 1.5);
grid minor; title('Wheel Speed Front Left'); xlabel('Time [s]'); ylabel('Wheel Speed Front Left');

%% Wheel_Speed_Front_Right
telemetry_2.Wheel_Speed_Front_Right.Value = Wheel_Speed_Front_Right.Value;
telemetry_2.Wheel_Speed_Front_Right.Time = Wheel_Speed_Front_Right.Time;
%plot
figure(TelPlot_2);axes('Parent', tab10);subplot(2,2,2);
plot(telemetry_2.Wheel_Speed_Front_Right.Time,telemetry_2.Wheel_Speed_Front_Right.Value,  'LineWidth', 1.5);
grid minor; title('Wheel Speed Front Right'); xlabel('Time [s]'); ylabel('Wheel Speed Front Right');

%% Wheel_Speed_Rear_Left
telemetry_2.Wheel_Speed_Rear_Left.Value = Wheel_Speed_Rear_Left.Value;
telemetry_2.Wheel_Speed_Rear_Left.Time = Wheel_Speed_Rear_Left.Time;
%plot
figure(TelPlot_2);axes('Parent', tab10);subplot(2,2,3);
plot(telemetry_2.Wheel_Speed_Rear_Left.Time,telemetry_2.Wheel_Speed_Rear_Left.Value,  'LineWidth', 1.5);
grid minor; title('Wheel Speed Rear Left'); xlabel('Time [s]'); ylabel('Wheel Speed Rear Left');

%% Wheel_Speed_Rear_Right
telemetry_2.Wheel_Speed_Rear_Right.Value = Wheel_Speed_Rear_Right.Value;
telemetry_2.Wheel_Speed_Rear_Right.Time = Wheel_Speed_Rear_Right.Time;
%plot
figure(TelPlot_2);axes('Parent', tab10);subplot(2,2,4);
plot(telemetry_2.Wheel_Speed_Rear_Right.Time,telemetry_2.Wheel_Speed_Rear_Right.Value,  'LineWidth', 1.5);
grid minor; title('Wheel Speed Rear Right'); xlabel('Time [s]'); ylabel('Wheel Speed Rear Right');

%% CLEAR

clear tab1 tab2 tab3 tab4 tab5 tab6 tab7 tab8 tab9 tab10