car_data;
simout_2 = sim("steering_pad_test_dual.slx");
load("Telemetry\lateral_telemetry\S1_#9866_20241206_123419.mat");

%% figure
comp_Lat = figure('Name', 'Comparison Lateral Telemetry', 'WindowState', 'maximized');
tabgroup_3 = uitabgroup(comp_Lat);
tab1_3 = uitab(tabgroup_3, 'Title', '   Lateral G   ');
tab2_3 = uitab(tabgroup_3, 'Title', '   Velocity   ');
tab3_3 = uitab(tabgroup_3, 'Title', '   HandWheel Angle   ');
tab4_3 = uitab(tabgroup_3, 'Title', '   Curve Radius  ');
tab5_3 = uitab(tabgroup_3, 'Title', '   Gear  ');
tab6_3 = uitab(tabgroup_3, 'Title', '   RPM  ');
%% simulation
simtel_2.time = get(simout_2.logsout, 'xdot').Values.Time;
simtel_2.time = simtel_2.time(3002:end);
%G
simtel_2.G = get(simout_2.logsout, 'Gy').Values.Data;
simtel_2.G = simtel_2.G(3002:end);
%velocity
simtel_2.dynamics.xdot = get(simout_2.logsout, 'LatBodyInfo').Values.BdyFrm.Cg.Vel.xdot.Data.*3.6;
simtel_2.dynamics.xdot = simtel_2.dynamics.xdot(3002:end);
%handwheel angle
simtel_2.dynamics.handWheel_angle = get(simout_2.logsout, 'Handwheel angle').Values.Data;
simtel_2.dynamics.handWheel_angle = simtel_2.dynamics.handWheel_angle(3002:end);
%Curve Radius
simtel_2.radius = get(simout_2.logsout, 'radius').Values.Data;
simtel_2.radius = simtel_2.radius(3002:end);
%gear
simtel_2.Gear = get(simout_2.logsout, 'Gear').Values.Data;
%rpm
simtel_2.RPM = get(simout_2.logsout, 'Engine_RPM').Values.Data;
simtel_2.RPM = simtel_2.RPM(3002:end);
%% G
telemetry_lat.G = abs(IMU_Accelerometer_Y.Value(13690:14490));
telemetry_lat.G_time = IMU_Accelerometer_Y.Time(190:990);

%comp.tel.interp.G_lat = (interp1(x_old, comp.tel.G_lat, x_new, 'linear'))';
x_old = linspace(1, 801, 801);
x_new = linspace(1, 801, 11696);
telemetry_lat.G_time_interp = (interp1(x_old, telemetry_lat.G_time, x_new, 'linear'))';
telemetry_lat.G_interp = (interp1(x_old, telemetry_lat.G, x_new, 'linear'))';

figure(comp_Lat);axes('Parent', tab1_3);
plot(simtel_2.time,simtel_2.G,  'LineWidth', 1.5);
hold on;
plot(telemetry_lat.G_time_interp, telemetry_lat.G_interp, 'LineWidth', 1.5);
xlim([2 10]);
legend('simulation','telemetry','Location','northeastoutside');
grid minor; title('G'); xlabel('Time [s]'); ylabel('G');
 %% RPM
telemetry_lat.RPM = (Engine_Speed.Value(27379:28979));
telemetry_lat.RPM_time = Engine_Speed.Time(379:1979);
x_old = linspace(1, 1601, 1601);
x_new = linspace(1, 1601, 11696);
telemetry_lat.RPM_time_interp = (interp1(x_old, telemetry_lat.RPM_time, x_new, 'linear'))';
telemetry_lat.RPM_interp = (interp1(x_old, telemetry_lat.RPM, x_new, 'linear'))';

figure(comp_Lat);axes('Parent', tab6_3);
plot(simtel_2.time,simtel_2.RPM,  'LineWidth', 1.5);
hold on;
plot(telemetry_lat.RPM_time_interp, telemetry_lat.RPM_interp, 'LineWidth', 1.5);
xlim([2 10]);
legend('simulation','telemetry','Location','northeastoutside');
grid minor; title('RPM'); xlabel('Time [s]'); ylabel('RPM');

%% velocity
telemetry_lat.GPS_speed = (GPS_Speed.Value(13690:14490));
telemetry_lat.GPS_speed_time = GPS_Speed.Time(190:990);

%comp.tel.interp.G_lat = (interp1(x_old, comp.tel.G_lat, x_new, 'linear'))';
x_old = linspace(1, 801, 801);
x_new = linspace(1, 801, 11696);
telemetry_lat.GPS_speed_time_interp = (interp1(x_old, telemetry_lat.GPS_speed_time, x_new, 'linear'))';
telemetry_lat.GPS_speed_interp = (interp1(x_old, telemetry_lat.GPS_speed, x_new, 'linear'))';

figure(comp_Lat);axes('Parent', tab2_3);
plot(simtel_2.time,simtel_2.dynamics.xdot,  'LineWidth', 1.5);
hold on;
plot(telemetry_lat.GPS_speed_time_interp, telemetry_lat.GPS_speed_interp, 'LineWidth', 1.5);
xlim([2 10]);
legend('simulation','telemetry','Location','northeastoutside');
grid minor; title('GPS Speed [km/h]'); xlabel('Time [s]'); ylabel('GPS Speed');

%% steering angle
telemetry_lat.steering_angle = (Steering_Angle.Value(6845:7245));
telemetry_lat.steering_angle_time = Steering_Angle.Time(95:495);

%comp.tel.interp.G_lat = (interp1(x_old, comp.tel.G_lat, x_new, 'linear'))';
x_old = linspace(1, 401, 401);
x_new = linspace(1, 401, 11696);
telemetry_lat.steering_angle_time_interp = (interp1(x_old, telemetry_lat.steering_angle_time, x_new, 'linear'))';
telemetry_lat.steering_angle_interp = (interp1(x_old, telemetry_lat.steering_angle, x_new, 'linear'))';

figure(comp_Lat);axes('Parent', tab3_3);
plot(simtel_2.time,rad2deg(simtel_2.dynamics.handWheel_angle),  'LineWidth', 1.5);
hold on;
plot(telemetry_lat.steering_angle_time_interp, telemetry_lat.steering_angle_interp, 'LineWidth', 1.5);
xlim([2 10]); ylim ([0 50]);
legend('simulation','telemetry','Location','northeastoutside');
grid minor; title('Steering Angle [deg]'); xlabel('Time [s]'); ylabel('Steering Angle');

%% gear
telemetry_lat.gear = (Gear.Value(1370:1450));
telemetry_lat.gear_time = Gear.Time(20:100);

%comp.tel.interp.G_lat = (interp1(x_old, comp.tel.G_lat, x_new, 'linear'))';
x_old = linspace(1, 81, 81);
x_new = linspace(1, 81, 11696);
telemetry_lat.gear_time_interp = (interp1(x_old, (telemetry_lat.gear_time), x_new, 'linear'))';
telemetry_lat.gear_interp = int32(interp1(x_old, double(telemetry_lat.gear), x_new, 'linear'))';
% gear_old = linspace(1,51,51);
% gear_new = linspace(1,51,10001);
% simtel_2.Gear_new = interp1(gear_old, simtel_2.Gear, gear_new);
figure(comp_Lat);axes('Parent', tab5_3);
plot(simtel_2.time(1:10001),simtel_2.Gear,  'LineWidth', 1.5);
hold on;
plot(telemetry_lat.gear_time_interp, telemetry_lat.gear_interp, 'LineWidth', 1.5);
xlim([2 10]);
legend('simulation','telemetry','Location','northeastoutside');
grid minor; title('Gear'); xlabel('Time [s]'); ylabel('Gear');

%% radius
telemetry_lat.radius = ((telemetry_lat.GPS_speed./3.6).^2)./((telemetry_lat.G).*9.81)';
% telemetry_lat.radius_time = Gear.Time(1:101);

%comp.tel.interp.G_lat = (interp1(x_old, comp.tel.G_lat, x_new, 'linear'))';
x_old = linspace(1, 801, 801);
x_new = linspace(1, 801, 11696);
telemetry_lat.radius_time_interp = telemetry_lat.G_time_interp;
telemetry_lat.radius_interp = (interp1(x_old, telemetry_lat.radius(:,1), x_new, 'linear'));

figure(comp_Lat);axes('Parent', tab4_3);
plot(simtel_2.time,simtel_2.radius,  'LineWidth', 1.5);
hold on;
plot(telemetry_lat.radius_time_interp, telemetry_lat.radius_interp, 'LineWidth', 1.5);
xlim([2 10]);
legend('simulation','telemetry','Location','northeastoutside');
grid minor; title('Radius [m]'); xlabel('Time [s]'); ylabel('Radius');
