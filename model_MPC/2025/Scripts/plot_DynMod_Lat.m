DynModTel_Lat = figure('Name', 'Dynamic Model Telemtry 2', 'WindowState', 'maximized');
tabgroup_2 = uitabgroup(DynModTel_Lat);
tab1_2 = uitab(tabgroup_2, 'Title', '   Lateral G   ');
tab2_2 = uitab(tabgroup_2, 'Title', '   Velocity   ');
tab3_2 = uitab(tabgroup_2, 'Title', '   HandWheel Angle   ');
tab4_2 = uitab(tabgroup_2, 'Title', '   Curve Radius  ');
tab5_2 = uitab(tabgroup_2, 'Title', '   Gear  ');
tab6_2 = uitab(tabgroup_2, 'Title', '   RPM  ');
%% Time

simtel_2.time = get(simout_2.logsout, 'xdot').Values.Time;


%% Lateral G
simtel_2.G = get(simout_2.logsout, 'Gy').Values.Data;
figure(DynModTel_Lat);axes('Parent', tab1_2);
plot(simtel_2.time,simtel_2.G,  'LineWidth', 1.5);
grid minor; title('G'); xlabel('Time [s]'); ylabel('G');

%% Velocity

%xdot
simtel_2.dynamics.xdot = get(simout_2.logsout, 'LatBodyInfo').Values.BdyFrm.Cg.Vel.xdot.Data;
%plot
figure(DynModTel_Lat);axes('Parent', tab2_2);plot(simtel_2.time,simtel_2.dynamics.xdot.*3.6,  'LineWidth', 1.5);
grid minor; title('V_x [km/h]'); xlabel('Time [s]'); ylabel('V_x [km/h]');
% 
% %ydot
% simtel_2.dynamics.ydot = get(simout_2.logsout, 'LatBodyInfo').Values.BdyFrm.Cg.Vel.ydot.Data;
% %plot
% figure(DynModTel_Lat);axes('Parent', tab2_2);
% subplot(1,2,2);plot(simtel_2.time,simtel_2.dynamics.ydot.*3.6,  'LineWidth', 1.5);
% grid minor; title('V_y [km/h]'); xlabel('Time [s]'); ylabel('V_y [km/h]');

%% handwheel angle

% %FL
% simtel_2.dynamics.steerFL = get(simout_2.logsout, 'steer_FL').Values.Data;
% %plot
% figure(DynModTel_Lat);axes('Parent', tab3_2);
% subplot(1,2,1);plot(simtel_2.time, rad2deg(simtel_2.dynamics.steerFL),  'LineWidth', 1.5);
% grid minor; title('FL steer [deg]'); xlabel('Time [s]'); ylabel('FL steer [deg]');
% 
% %FR
% simtel_2.dynamics.steerFR = get(simout_2.logsout, 'steer_FR').Values.Data;
% %plot
% figure(DynModTel_Lat);axes('Parent', tab3_2);
% subplot(1,2,2);plot(simtel_2.time,rad2deg(simtel_2.dynamics.steerFR),  'LineWidth', 1.5);
% grid minor; title('FR steer [deg]'); xlabel('Time [s]'); ylabel('FR steer [deg]');

simtel_2.dynamics.handWheel_angle = get(simout_2.logsout, 'Handwheel angle').Values.Data;
%simtel_2.dynamics.handWheel_angle = get(simout_2.logsout, 'delta_pid').Values.Data;
%plot
figure(DynModTel_Lat);axes('Parent', tab3_2);
plot(simtel_2.time,rad2deg(simtel_2.dynamics.handWheel_angle), 'LineWidth', 1.5);
ylim([0 180]);
grid minor; title('HandWheel Angle [deg]'); xlabel('Time [s]'); ylabel('angle [deg]');

%% Curve Radius
simtel_2.radius = get(simout_2.logsout, 'radius').Values.Data;
figure(DynModTel_Lat);axes('Parent', tab4_2);
plot(simtel_2.time,simtel_2.radius,  'LineWidth', 1.5);
ylim([17.4 18.5])
grid minor; title('Radius'); xlabel('Time [s]'); ylabel('radius [m]');

%% Gear
simtel_2.Gear = get(simout_2.logsout, 'Gear').Values.Data;
figure(DynModTel_Lat);axes('Parent', tab5_2);
plot(simtel_2.time(1:10001),simtel_2.Gear,  'LineWidth', 1.5);
grid minor; title('Gear'); xlabel('Time [s]'); ylabel('Gear');

%% RPM
simtel_2.RPM = get(simout_2.logsout, 'Engine_RPM').Values.Data;
figure(DynModTel_Lat);axes('Parent', tab6_2);
plot(simtel_2.time,simtel_2.RPM,  'LineWidth', 1.5);
grid minor; title('RPM'); xlabel('Time [s]'); ylabel('RPM');