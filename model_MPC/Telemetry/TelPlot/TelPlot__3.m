%%%%%%%%%% PLOT TELEMETRIE %%%%%%%%%%%
clear all;
clc;
%% TAB
TelPlot_3= figure('Name', 'Plotting Telemetries 3', 'WindowState', 'maximized');
tabgroup = uitabgroup(TelPlot_3);
tab1 = uitab(tabgroup, 'Title', '   Corr_Dist   ');
tab2 = uitab(tabgroup, 'Title', '   Engine_Speed   ');
tab3 = uitab(tabgroup, 'Title', '   Friction_Slip   ');
tab4 = uitab(tabgroup, 'Title', '   G  ');
tab5 = uitab(tabgroup, 'Title', '   Gear    ');
tab6 = uitab(tabgroup, 'Title', '   GPS_Speed    ');
tab7 = uitab(tabgroup, 'Title', '   Pitch_Susp    ');
tab8 = uitab(tabgroup, 'Title', '   Suspension    ');
tab9 = uitab(tabgroup, 'Title', '   Throttle    ');

%% LOAD Acc-Croazia_3.mat
load("Telemetry\Croazia_24_matlab\Acc_Croazia\Acc-Croazia_3.mat");
%% CORR_DIST
telemetry_3.Corr_Dist.Value = Corr_Dist.Value;
telemetry_3.Corr_Dist.Time = Corr_Dist.Time;
%plot
figure(TelPlot_3);axes('Parent', tab1);
plot(telemetry_3.Corr_Dist.Time,telemetry_3.Corr_Dist.Value,  'LineWidth', 1.5);
grid minor; title('Corr-Dist'); xlabel('Time [s]'); ylabel('Corr-Dist');

%% Engine_speed
telemetry_3.Engine_Speed.Value = Engine_Speed.Value;
telemetry_3.Engine_Speed.Time = Engine_Speed.Time;
%plot
figure(TelPlot_3);axes('Parent', tab2);
plot(telemetry_3.Engine_Speed.Time,telemetry_3.Engine_Speed.Value,  'LineWidth', 1.5);
grid minor; title('Engine Speed'); xlabel('Time [s]'); ylabel('Engine Speed');

%% Friction_Slip
telemetry_3.Friction_Slip.Value = Friction_Slip.Value;
telemetry_3.Friction_Slip.Time = Friction_Slip.Time;
%plot
figure(TelPlot_3);axes('Parent', tab3);
plot(telemetry_3.Friction_Slip.Time,telemetry_3.Friction_Slip.Value,  'LineWidth', 1.5);
grid minor; title('Friction Slip'); xlabel('Time [s]'); ylabel('Friction Slip');

%% G_lat
telemetry_3.G_lat.Value = G_lat.Value;
telemetry_3.G_lat.Time = G_lat.Time;
%plot
figure(TelPlot_3);axes('Parent', tab4);subplot(1,2,1);
plot(telemetry_3.G_lat.Time,telemetry_3.G_lat.Value,  'LineWidth', 1.5);
grid minor; title('G lat'); xlabel('Time [s]'); ylabel('G lat');

%% G_long
telemetry_3.G_long.Value = G_long.Value;
telemetry_3.G_long.Time = G_long.Time;
%plot
figure(TelPlot_3);axes('Parent', tab4);subplot(1,2,2);
plot(telemetry_3.G_long.Time,telemetry_3.G_long.Value,  'LineWidth', 1.5);
grid minor; title('G long'); xlabel('Time [s]'); ylabel('G long');

%% Gear
telemetry_3.Gear.Value = Gear.Value;
telemetry_3.Gear.Time = Gear.Time;
%plot
figure(TelPlot_3);axes('Parent', tab5);
plot(telemetry_3.Gear.Time,telemetry_3.Gear.Value,  'LineWidth', 1.5);
grid minor; title('Gear'); xlabel('Time [s]'); ylabel('Gear');

%% GPS_Speed
telemetry_3.GPS_Speed.Value = GPS_Speed.Value;
telemetry_3.GPS_Speed.Time = GPS_Speed.Time;
%plot
figure(TelPlot_3);axes('Parent', tab6);
plot(telemetry_3.GPS_Speed.Time,telemetry_3.GPS_Speed.Value,  'LineWidth', 1.5);
grid minor; title('GPS Speed'); xlabel('Time [s]'); ylabel('GPS Speed');

%% Pitch_Susp 
telemetry_3.Pitch_Susp.Value = Pitch_Susp.Value;
telemetry_3.Pitch_Susp.Time = Pitch_Susp.Time;
%plot
figure(TelPlot_3);axes('Parent', tab7);
plot(telemetry_3.Pitch_Susp.Time,telemetry_3.Pitch_Susp.Value,  'LineWidth', 1.5);
grid minor; title('Pitch Susp'); xlabel('Time [s]'); ylabel('Pitch Susp');

%% Suspension_Front_Left
telemetry_3.Suspension_Front_Left.Value = Suspension_Front_Left.Value;
telemetry_3.Suspension_Front_Left.Time = Suspension_Front_Left.Time;
%plot
figure(TelPlot_3);axes('Parent', tab8);subplot(2,2,1);
plot(telemetry_3.Suspension_Front_Left.Time,telemetry_3.Suspension_Front_Left.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Front Left'); xlabel('Time [s]'); ylabel('Suspension Front Left');

%% Suspension_Front_Right
telemetry_3.Suspension_Front_Right.Value = Suspension_Front_Right.Value;
telemetry_3.Suspension_Front_Right.Time = Suspension_Front_Right.Time;
%plot
figure(TelPlot_3);axes('Parent', tab8);subplot(2,2,2);
plot(telemetry_3.Suspension_Front_Right.Time,telemetry_3.Suspension_Front_Right.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Front Right'); xlabel('Time [s]'); ylabel('Suspension Front Right');

%% Suspension_Rear_Left
telemetry_3.Suspension_Rear_Left.Value = Suspension_Rear_Left.Value;
telemetry_3.Suspension_Rear_Left.Time = Suspension_Rear_Left.Time;
%plot
figure(TelPlot_3);axes('Parent', tab8);subplot(2,2,3);
plot(telemetry_3.Suspension_Rear_Left.Time,telemetry_3.Suspension_Rear_Left.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Rear Left'); xlabel('Time [s]'); ylabel('Suspension Rear Left');

%% Suspension_Rear_Right
telemetry_3.Suspension_Rear_Right.Value = Suspension_Rear_Right.Value;
telemetry_3.Suspension_Rear_Right.Time = Suspension_Rear_Right.Time;
%plot
figure(TelPlot_3);axes('Parent', tab8);subplot(2,2,4);
plot(telemetry_3.Suspension_Rear_Right.Time,telemetry_3.Suspension_Rear_Right.Value,  'LineWidth', 1.5);
grid minor; title('Suspension Rear Right'); xlabel('Time [s]'); ylabel('Suspension Rear Right');

%% Throttle_Pedal
telemetry_3.Throttle_Pedal.Value = Throttle_Pedal.Value;
telemetry_3.Throttle_Pedal.Time = Throttle_Pedal.Time;
%plot
figure(TelPlot_3);axes('Parent', tab9);subplot(1,2,1);
plot(telemetry_3.Throttle_Pedal.Time,telemetry_3.Throttle_Pedal.Value,  'LineWidth', 1.5);
grid minor; title('Throttle Pedal'); xlabel('Time [s]'); ylabel('Throttle Pedal');

%% Throttle_Position
telemetry_3.Throttle_Position.Value = Throttle_Position.Value;
telemetry_3.Throttle_Position.Time = Throttle_Position.Time;
%plot
figure(TelPlot_3);axes('Parent', tab9);subplot(1,2,2);
plot(telemetry_3.Throttle_Position.Time,telemetry_3.Throttle_Position.Value,  'LineWidth', 1.5);
grid minor; title('Throttle Position'); xlabel('Time [s]'); ylabel('Throttle Position');

%% CLEAR

clear tab1 tab2 tab3 tab4 tab5 tab6 tab7 tab8 tab9