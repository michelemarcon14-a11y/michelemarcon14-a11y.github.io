close all
clear
clc

%% Loading Car Data
car_data;

%% Running the Simulation
%simout_2 = sim("steering_pad_test_dual.slx");
simout_2 = sim("steering_pad_test_dual.slx");

%% Plot
plot_DynMod_Lat;