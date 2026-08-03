close all
clear
clc

%% Loading Car Data
car_data;

%% Running the Simulation
simout = sim("longitunal_DynamicModel.slx");

%% Plot
plot_DynMod_Long;
