% This script contains all the car data

%% ENGINE 
car.engine.lut = [5.4650   10.9300   15.4400   18.5200   21.0450   22.4022   23.3370   24.4239   24.9076   24.9076   27.7850;
    10.9300   21.8600   30.8800   37.0400   42.0900   44.8043   46.6739   48.8478   49.8152   49.8152   55.5700;
    9.4500   18.9000   27.8600   34.7200   41.0307   45.1630   48.6630   51.8261   53.2609   54.0435   58.5652;
    9.2350   18.4700   27.2900   35.1300   42.2368   47.0326   50.8043   55.1522   56.8478   57.6413   61.3696;
    7.7850   15.5700   24.2300   31.9700   39.1776   44.0435   47.5326   52.3478   54.1739   55.0870   58.8804;
    6.7750   13.5500   21.8900   29.7700   36.9627   42.0978   45.8261   51.3696   53.3696   54.6196   58.0870;
    4.3585    8.7170   18.7700   27.5700   36.0746   41.1000   46.8300   57.1600   62.3300   65.1900   69.7800;
    2.5870    5.1740   15.9300   23.7600   32.2039   40.0978   47.8261   62.9457   71.2935   75.7609   81.4565;
    0.8805    1.7610   13.9200   22.3000   31.2171   39.0435   47.0109   61.2500   68.8152   73.1413   78.5978;
    0         0    9.7280   19.4300   28.0592   36.7609   45.9457   61.3478   69.8152   74.7935   80.8152;
    0         0    6.7720   18.1200   25.9978   34.6848   43.8043   57.9130   66.5870   71.7174   77.5870;
    0         0    7.8260   15.7800   23.3443   31.3370   39.4891   52.9130   60.8804   65.3696   71.5761;
    0         0    2.3700   12.7200   20.8004   28.5435   36.7283   50.0870   57.9674   62.7826   68.7609;
    0         0         0    8.1400   18.1469   25.3478   33.9130   47.3152   54.8587   59.3804   65.6196;
    0         0         0    6.6000   15.1754   23.0543   30.8370   44.6957   53.2717   58.0435   63.9239;
    0         0         0    2.6500   11.9518   20.5652   27.9457   41.7609   49.8804   54.5761   60.5109;
    0         0         0         0    8.6513   16.4565   24.4565   37.5326   45.0435   49.2065   52.6413;
    0         0         0         0    5.8114   13.9674   21.3478   34.0978   40.8587   45.0543   47.8043];
%% LONGITUDINAL BLOCK

car.Longitudinalbody.Mass = 265.50; % Mass(car+driver) in kg
car.Longitudinalbody.I = [13.988, 44.821, 49.553]; % Moments_of_Inertia in Kg*m^2
car.Longitudinalbody.COGa = 0.84627; % COG distance to front in m
car.Longitudinalbody.COGb = 0.69873; % COG distance to rear in m
car.Longitudinalbody.COGh =0.31347; % COG distance from ground in m
Wheelbase=car.Longitudinalbody.COGa+car.Longitudinalbody.COGb;
car.Longitudinalbody.Cd= 1.8; %Drag Coeff
car.Longitudinalbody.Cl= -4.04; %Lift Coeff
car.Longitudinalbody.Af= 1.11; %Projected frontal Area in m^2

car.Longitudinalbody.COGz_o=-0.3028; %initial vertical position of the CoG in m
 
car.Longitudinalbody.Kf = 78833; %Front Susp Stiffness in N/m 
car.Longitudinalbody.Cf = 6300; %Front Susp damping in N*s/m 
car.Longitudinalbody.IRf = 0.56; %Front Susp Aspect Ratio
car.Longitudinalbody.Kr = 61312; %Rear Susp Stiffness in N/m 
car.Longitudinalbody.Cr = 6300; %Rear Susp damping in N*s/m 
car.Longitudinalbody.IRr = 0.78; %Rear Susp Aspect Ratio


car.Longitudinalbody.FskF=2*[car.Longitudinalbody.Kf, car.Longitudinalbody.Kf*2]*car.Longitudinalbody.IRf^2; %Front axle stiffness force data in N
car.Longitudinalbody.FsbF=2*[car.Longitudinalbody.Cf, car.Longitudinalbody.Cf*2]*car.Longitudinalbody.IRf^2; %Front axle damping force data in N
car.Longitudinalbody.dzsF=[1, 2]; %Front axle displacement data in m
car.Longitudinalbody.dzdotsF=[1, 2]; %Front axle velocity data in m/s


car.Longitudinalbody.FskR=2*[car.Longitudinalbody.Kr, car.Longitudinalbody.Kr*2]*car.Longitudinalbody.IRr^2; %Rear axle stiffness force data in N
car.Longitudinalbody.FsbR=2*[car.Longitudinalbody.Cr, car.Longitudinalbody.Cr*2]*car.Longitudinalbody.IRr^2; %Rear axle damping force data in N
car.Longitudinalbody.dzsR=[1, 2]; %Rear axle displacement data in m
car.Longitudinalbody.dzdotsR=[1, 2]; %Rear axle velocity data in m/s

car.transmission.lut = [1, 2.785, 2.052, 1.714, 1.5];
car.transmission.clgr = 1.761;
car.transmission.bevgear = 2.82;
%%
car.clutch.RPM.start = 11000;
car.clutch.time.engaged = 1.5;

%% TIRE BLOCK
% Dugoff
car.tire.dugoff.camber=-0.0174533;
car.tire.dugoff.Vy=0;
car.tire.dugoff.yaw_rate=0;
car.tire.dugoff.pressure=80000;
car.tire.dugoff.gnd=0;
car.tire.dugoff.scaleFctr=0.8;
car.tire.dugoff.Ckappa=17909;
car.tire.dugoff.Calpha=27759;
car.tire.dugoff.Cgamma=-1390;
car.tire.dugoff.mu0=2.2;
car.tire.dugoff.As=0.03;
car.tire.dugoff.Lrelx=0.1;
car.tire.dugoff.Lrely=0.15;
car.tire.dugoff.WIDTH=0.1524;
car.tire.dugoff.bMz=0;
car.tire.dugoff.omegao=0;
car.tire.dugoff.IYY=0.1505;
car.tire.dugoff.br=1e-3;
car.tire.dugoff.FZMAX=1200;
car.tire.dugoff.FZMIN=100;
car.tire.dugoff.PRESMAX=1000000;
car.tire.dugoff.PRESMIN=10000;
car.tire.dugoff.KPUMAX=0.999;
car.tire.dugoff.KPUMIN=-0.999;
car.tire.dugoff.ALPMAX=1.5;
car.tire.dugoff.ALPMIN=-1.5;
car.tire.dugoff.CAMMAX=0.1745;
car.tire.dugoff.CAMMIN=-0.1745;

%Longitudinal Tire
car.tire.long.spinIYY=0.1505; % Analoga a car.tire.dugoff.IYY
car.tire.long.scaleFctr=1.15;
car.tire.diam=16.2; %INCH

%% Driver block
car.driver.n_up=11000;     %  valore soglia superiore
car.driver.n_down=8000;   % valore soglia inferiore
car.driver.n_idle=4000;
car.driver.max_gear= 4;
car.driver.min_gear=2;
car.driver.n_23_up=11000;
car.driver.n_34_up=10750;

%% Initial conditions
car.initialconditions.EngineRPM = 10000;
car.initialconditions.Wrpm = 50;
car.initialconditions.xdot = 0;
car.initialconditions.FzR = 0;

%% Steering Pad test

% Lateral body
car.lateralbody.NF=2; %Number of wheels on front axle
car.lateralbody.NR=2; %Number of wheels on rear axle
car.lateralbody.m=283; %Vehicle mass
car.lateralbody.a=0.818; %Longitudinal distance from center of mass to front axle
car.lateralbody.b=0.722; %Longitudinal distance from center of mass to rear axle
car.lateralbody.h=0.0871; %Vertical distance from center of mass to axle plane
car.lateralbody.X_o=0; %Initial inertial frame longitudinal position
car.lateralbody.xdot_o=17; %Initial longitudinal velocity
car.lateralbody.d=0; %Lateral distance from geometric centerline to center of mass
car.lateral.body.w=[1.27,1.24]; %Track width
car.lateralbody.Cy_f=25e3; %Front tire corner stiffness
car.lateralbody.Cy_r=25e3; %Rear tire corner stiffness
car.lateralbody.sigma_f=0.1; %Front tire relexation lenght
car.lateralbody.sigma_r=0.1; %Rear tire relaxation lenght
car.lateralbody.Y_o=0; %Initial inertial frame lateral displacement
car.lateralbody.ydot_o=0; %Initial lateral velocity
car.lateralbody.Izz=160; %Yaw polar inertia
car.lateralbody.psi_o=0; %Initial yaw angle
car.lateralbody.r_o=0.8; %Initial yaw rate
car.lateralbody.Af=1; %Longitudinal drag area
car.lateralbody.Cd=1.8; %Longitudinal drag coefficient.(1.1578)
car.lateralbody.Cl=4.010; %Longitudinal lift coefficient
car.lateralbody.Cpm=0.1; %Longitudinal drag pitch moment
car.lateralbody.beta_w=[0 0.01:0.01:0.3]; %Relative wind angle vector
car.lateralbody.Cs=0:0.03:0.9; %Side force coefficient vector
car.lateralbody.Cym=[0 1e-6:0.01:0.3] ; %Yaw moment coefficient vector
car.lateralbody.Pabs=101325; %Absolute pressure
car.lateralbody.Tair=273; %Air temperature
car.lateralbody.g=9.81; %Gravitational acceleration
car.lateralbody.mu=1; %Nominal friction scaling factor
car.lateralbody.xdot_tol=0.01; %Longitudinal velocity tollerance
car.lateralbody.Fznom=2000; %Nominal normal force
car.lateralbody.longOff=0; %Geometrical longitudinal offset from axle plane
car.lateralbody.latOff=0; %Geometrical lateral offset from center plane
car.lateralbody.vertOff=0; %Geometrical vertical offset from axle plane

%PID
car.steering_pad_test.PID.P=500; %Proportional term of PID
car.steering_pad_test.PID.I=500; %Integral term of PID
car.steering_pad_test.PID.D=0; %Derivative term of PID
car.steering_pad_test.PID.N=0; %Filter coefficient of PID

% Target radius & wheelbase
car.steering_pad_test.target_radius=22;
car.steering_pad_test.wheelbase=1.545;
car.steering_pad_test.steering_ratio=5;
car.steering_pad_test.FwF=0;
car.steering_pad_test.FwR=1400;

% Kinematic Steering
car.kinematic_steering.NrmlFctr=0.01; %Normalization Factor
car.kinematic_steering.TrckWdth=1.270; %Track width
car.kinematic_steering.WhlBase=1.54; %Wheel base
car.kinematic_steering.Db=0; %Deadband
car.kinematic_steering.StrgRng=0.861*pi; %Steering range
car.kinematic_steering.StrgRatio=5; %Steering ratio
car.kinematic_steering.PctAck=26; %Percent Ackerman

% Setup
car.setup.static_toe.front = 2; %Front static toe [mm]
car.setup.static_toe.rear = 2; %Front static toe [mm]
car.setup.rim_radius = 254; %Rim radius [mm]

%% Brake
car.Longitudinalbody.braketest.v0 = 20 ; %Car initial velocity  [m/s]
car.brakebalance = 0.53 ; %Car brake balancee referred to wheel [1]
car.brakepistondiameter = 0.0249 ; %Brake piston diameter [m]
car.proportioning_valve_cutting_p = 12 ; %Proportioning Valve Cutting Pressure [bar]
car.brakepad_friction_coeff = 0.75 ; %Brake Pad friction coefficient [-]