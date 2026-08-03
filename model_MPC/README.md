# MPC & PID Driver-in-the-Loop Simulator

This directory contains the full MATLAB Project and Simulink environment used to validate a custom-built Model Predictive Controller (MPC) for vehicle path-tracking.

## 🚀 How to Run the Model

To ensure all dependencies and variables are correctly loaded, **do not manually add folders to your path**. 
1. Clone the repository to your local machine.
2. Open MATLAB and double-click the `.prj` project file to automatically initialize the environment and load the generic `.tir` tire properties.
3. **Data Formatting Protocol:** Ensure that any telemetry data imported into the MATLAB workspace is ordered strictly by **COLUMNS** (not rows). The state-space processing and control architecture strictly require column-wise data arrays to function correctly.
4. Once you're in the folder model_MPC, open the folder named "scripts". Open and run the file "car_data_new_vehicle.m".
5. After that, in the same folder, open and run the file "MPC_script".
6. Open the main Simulink model (`Vehicle_definitivo_validazione_2.slx`) in the 2026 folder; your focus is the driver in the loop subsystem, comment the others. click **Run**.

## 🏗️ Project Architecture & Evaluation Focus

This model contains a complete closed-loop system, including a 4-state single-track physical plant. **For evaluation purposes, please focus on the Controller Subsystem.**

*   **🟦 Driver Model (Core Focus):** Contains the entirely from-scratch MPC architecture, the PID longitudinal controller, and the custom objective function logic.
*   **⬜ Vehicle Plant (Reference):** Contains the physical modeling of the vehicle and tires (Magic Formula). This block is strictly configured as a responsive testing environment and is encapsulated to isolate it from the control logic.

## 📁 Directory Structure
*   `/scripts` - Contains state-space initialization and parameter definition files.
*   `/models` - Simulink `Vehicle_definitivo_validazione_2.slx` block diagrams.
*   `/data` - Generic Pacejka `.tir` files for dynamic validation.
