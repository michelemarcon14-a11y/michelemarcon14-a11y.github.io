%% %%%%%%%%%%%%%%%%%%% BUMP %%%%%%%%%%%%%%%%%%% 

DynModTel = figure('Name', 'Dynamic Model Telemtry', 'WindowState', 'maximized');
tabgroup = uitabgroup(DynModTel);
tab1 = uitab(tabgroup, 'Title', '   Dynamics   ');
tab2 = uitab(tabgroup, 'Title', '   Engine   ');
tab3 = uitab(tabgroup, 'Title', '   Tires   ');
tab4 = uitab(tabgroup, 'Title', '   Suspensions  ');
tab5  = uitab(tabgroup, 'Title', '   Speed Comparison  ');

%% Dynamics
%xdot
simtel.time = get(simout.logsout, 'LongBodyInfo').Values.InertFrm.Cg.Vel.Xdot.Time;
dt = diff(simtel.time);
%x
simtel.dynamics.x = get(simout.logsout,'LongBodyInfo').Values.InertFrm.Cg.Disp.X.Data;
%plot
figure(DynModTel);axes('Parent', tab1);
subplot(2,2,1);
plot(simtel.time,simtel.dynamics.x,  'LineWidth', 1.5);
grid minor; title('X [m]'); xlabel('Time [s]'); ylabel('X [m]');

%xdot
simtel.dynamics.xdot = get(simout.logsout, 'LongBodyInfo').Values.InertFrm.Cg.Vel.Xdot.Data;
%plot
figure(DynModTel);axes('Parent', tab1);
subplot(2,2,2);plot(simtel.time,simtel.dynamics.xdot.*3.6,  'LineWidth', 1.5);
grid minor; title('V_x [km/h]'); xlabel('Time [s]'); ylabel('V_x [km/h]');

%xddot
dvx= diff(simtel.dynamics.xdot);
xddot = dvx ./ dt;
xddot(end + 1) =  xddot(end);
%plot
figure(DynModTel);axes('Parent', tab1);
subplot(2,2,3);plot(simtel.time, xddot./9.81,  'LineWidth', 1.5);
grid minor; title('a_x [G]'); xlabel('Time [s]'); ylabel('a_x [G]');

%theta
simtel.dynamics.theta = get(simout.logsout,'LongBodyInfo').Values.InertFrm.Cg.Ang.theta.Data;
Pitch = rad2deg(simtel.dynamics.theta);
%plot
subplot(2,2,4);plot(simtel.time,Pitch,'LineWidth', 1.5);
grid minor; title('Pitch [deg]'); xlabel('Time [s]'); ylabel('Pitch [deg]');

%% Engine
%TPS
simtel.dynamics.Engine_TPS = get(simout.logsout, "TPS").Values.Data;
TPS_time = get(simout.logsout, "TPS").Values.Time;
figure(DynModTel);axes('Parent', tab2);
subplot(2,2,1);plot(TPS_time,simtel.dynamics.Engine_TPS, LineWidth=1.5);
grid minor; xlabel('Time [s]'); ylabel('TPS'); title('TPS');
%Gear
simtel.dynamics.Gear = get(simout.logsout,'Gear').Values.Data;
Gear_time = get(simout.logsout,'Gear').Values.Time;
%plot
subplot(2,2,2);plot(Gear_time,simtel.dynamics.Gear, LineWidth=1.5);
hold on;
grid minor; title('Gear'); xlabel('Time [s]'); ylabel('Gear');

%Rpm
simtel.dynamics.Engine_RPM = get(simout.logsout,'Engine_RPM').Values.Data;
simtel.dynamics.Engine_RPM_time = get(simout.logsout,'Engine_RPM').Values.Time;
%plot
subplot(2,2,3);plot(simtel.dynamics.Engine_RPM_time,simtel.dynamics.Engine_RPM, LineWidth=1.5);
grid minor; title('RPM'); xlabel('Time [s]'); ylabel('RPM');

%Torque
simtel.dynamics.Engine_Torque = get(simout.logsout,'Engine_Torque').Values.Data;
%plot
subplot(2,2,4);plot(simtel.time,simtel.dynamics.Engine_Torque, LineWidth=1.5);
grid minor; title('Torque [Nm]'); xlabel('Time [s]'); ylabel('Torque [Nm]');


%% Gomme
%F_z
tempFzF = get(simout.logsout, "FzF");
tempFzF = tempFzF{2}.Values.Data;
simtel.dynamics.Tyre_Force_vert_front = squeeze(tempFzF(1, 1, :));
tempFzR = get(simout.logsout, "FzR");
tempFzR = tempFzR{2}.Values.Data;
simtel.dynamics.Tyre_Force_vert_rear = squeeze(tempFzR(1, 1, :));
%plot
figure(DynModTel);axes('Parent', tab3); subplot(2,2,1);
plot(simtel.time,simtel.dynamics.Tyre_Force_vert_front, LineWidth=1.5);
hold on;
plot(simtel.time,simtel.dynamics.Tyre_Force_vert_rear, LineWidth=1.5);
legend('F_z Front [N]', 'F_z Rear [N]', 'Location', 'northeastoutside');
grid minor; title('F_z (axle) [N]'); xlabel('Time [s]'); ylabel('F_z [N]');

%F_x
tempFxF = get(simout.logsout,'LongBodyInfo').Values.BdyFrm.Forces.FrntAxl.Fx.Data;
simtel.dynamics.Tyre_Force_Long_front = squeeze(tempFxF(1, 1, :));
tempFxR = get(simout.logsout,'LongBodyInfo').Values.BdyFrm.Forces.RearAxl.Fx.Data;
simtel.dynamics.Tyre_Force_Long_rear = squeeze(tempFxR(1, 1, :));
%plot
figure(DynModTel);axes('Parent', tab3); subplot(2,2,2);
plot(simtel.time,simtel.dynamics.Tyre_Force_Long_front, LineWidth=1.5);
hold on;
plot(simtel.time,simtel.dynamics.Tyre_Force_Long_rear, LineWidth=1.5);
legend('F_x Front [N]', 'F_x Rear [N]', 'Location', 'northeastoutside');
grid minor; title('F_x (axle) [N]'); xlabel('Time [s]'); ylabel('F_x [N]');

simtel.dynamics.W_omega = get(simout.logsout, 'omega').Values.Data ;
radius = 0.206;
simtel.dynamics.W_omega = simtel.dynamics.W_omega .* radius .* 3.6;
figure(DynModTel);axes('Parent', tab3); subplot(2,2,[3,4]);
plot(simtel.time,simtel.dynamics.W_omega, LineWidth=1.5);
grid minor; title('Wheel Speed [km/h]'); xlabel('Time [s]'); ylabel('Wheel Speed [km/h]');

figure(DynModTel);axes('Parent', tab5); subplot(2,1,2);
plot(simtel.time,simtel.dynamics.W_omega, LineWidth=1.5);
grid minor; title('Wheel Speed [km/h]'); xlabel('Time [s]'); ylabel('Wheel Speed [km/h]');

figure(DynModTel);axes('Parent', tab5); subplot(2,1,1);
plot(simtel.time,simtel.dynamics.xdot.*3.6,  'LineWidth', 1.5);
grid minor; title('V_x [km/h]'); xlabel('Time [s]'); ylabel('V_x [km/h]');

%Wheel_Travel
simtel.dynamics.Wheel_Travel_front=get(simout.logsout,'LongBodyInfo').Values.InertFrm.FrntAxl.Disp.Z.Data;
simtel.dynamics.Wheel_Travel_rear=get(simout.logsout,'LongBodyInfo').Values.InertFrm.RearAxl.Disp.Z.Data;
%plot
figure(DynModTel);axes('Parent', tab4);
subplot(2,1,1);plot(simtel.time,simtel.dynamics.Wheel_Travel_front.*10^3, LineWidth=1.5);
hold on;
plot(simtel.time,simtel.dynamics.Wheel_Travel_rear.*10^3, LineWidth=1.5);
legend('Wheel Travel Front [mm]', 'Wheel Travel Rear [mm]', 'Location','northeast')
grid minor; title('Wheel Travel [mm]'); xlabel('Time [s]'); ylabel('Wheel Travel [mm]');

%Spring compression
FrontSpringCompression = car.Longitudinalbody.IRf .* simtel.dynamics.Wheel_Travel_front;
RearSpringCompression = car.Longitudinalbody.IRr .* simtel.dynamics.Wheel_Travel_rear;
figure(DynModTel);axes('Parent', tab4);
subplot(2,1,2);plot(simtel.time,FrontSpringCompression.*10^3, LineWidth=1.5);
hold on;
plot(simtel.time,RearSpringCompression.*10^3, LineWidth=1.5);
legend('Spring Compression  [mm]', 'Spring Compression Rear [mm]', 'Location','northeast');
grid minor; title('Spring Compression [mm]'); xlabel('Time [s]'); ylabel('Spring Compression [mm]');
