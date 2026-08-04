---
layout: default
title: Michele Marcon | Mechanical Engineer
---
# Engineering Portfolio

### Driver-in-the-Loop Simulation: MPC & PID Vehicle Controller

**Objective:** Engineered an advanced path-following controller within Simulink to simulate realistic driver inputs for dynamic vehicle evaluation.

**Technical Implementation:**
*   **Plant Architecture:** Structured a 4-state single-track vehicle dynamics model in MATLAB, defining the state-space matrices through precise parameterization of vehicle mass, yaw inertia, and tire cornering stiffness.
*   **Control Logic Integration:** Implemented a Model Predictive Control (MPC) algorithm for optimal trajectory tracking, functioning in tandem with a PID controller to govern longitudinal throttle and brake actuation.
*   **Simulation & Validation:** Deployed the integrated controller within a driver-in-the-loop environment to evaluate transient vehicle behavior and dynamic stability under simulated track conditions.

**Quick Navigation:**
* [MPC Architecture & Theoretical Foundation](#mpc-architecture--theoretical-foundation)
* [System Architecture & Control Layout](#system-architecture--control-layout)
* [Dynamic Validation & Tracking Performance](#dynamic-validation--tracking-performance)
* [Lap Time Analysis & Iterative Tuning](#lap-time-analysis--iterative-tuning)
* [Limitations & Future Developments](#limitations--future-developments)

---

### MPC Architecture & Theoretical Foundation

A key defining factor of this project was the decision to develop the control architecture entirely from scratch, bridging fundamental vehicle dynamics theory with advanced control system implementation.

**Theoretical Framework & Literature**

Rather than relying on pre-packaged driver models, the predictive algorithm was mathematically derived from core literature. The control logic and plant matrices were built following established methodologies from:
*   *[MathWorks Website]* - Referenced for structuring the objective function and prediction horizon tuning within the MPC framework.
*   *[Vehicle Dynamics and Control by R. Rajamani]* - Utilized for defining the state-space formulation of the lateral dynamics.

**From Scratch Implementation**

The development process deliberately separated the physical vehicle plant from the driver model. By focusing heavily on the driver-side algorithm, we established a robust Model Predictive Controller capable of:
1.  **Solving the Optimization Problem:** Calculating optimal steering angles by minimizing the cost function over a defined prediction horizon, strictly adhering to track boundary constraints.
2.  **Handling Actuator Limits:** Explicitly integrating physical steering constraints (rate and angle limits) into the MPC solver to ensure the generated commands are physically executable by the vehicle's steering rack.
3.  **Future State Prediction:** Utilizing the internally coded 4-state mathematical model to predict the vehicle's lateral deviation and yaw error, allowing the algorithm to preemptively react to upcoming trajectory curvatures.

**State-Space Plant Definition:**
The core of the predictive model relies on the accurate mathematical representation of the vehicle's lateral dynamics. Below is the initialization of the continuous-time state-space matrices (*A*, *B*, *C*, *D*) derived from the single-track model equations:

```matlab
% Vehicle Parameters definition
V = 34/3.6; % Constant speed in [m/s].
L = 1.54;   % Wheelbase [m]. 
Cr = 25210; % Cornering stiffness rear [Nm/rad]
Cf = Cr;    % Cornering stiffness rear [Nm/rad]
m = 298;    % Vehicle mass [Kg]
lr = 0.722; % Rear wheelbase [m]
lf = 0.818; % Front wheelbase [m]
Iz = 134.3; % Yaw inertia [Kg*m^2]
phi = 0;    % Road angle inclination [deg]
g = 9.81;   % Gravity's acceleration [m/s^2]

% State-Space Matrices (Continuous)
A_dyn = [0,         1,              0,                      0                                   ;
         0, -(2*Cf + 2*Cr)/(m*V), (2*Cf + 2*Cr)/m, (2*Cr*lr - 2*Cf*lf)/(m*V)                    ;
         0,             0,                  0,                      1                           ;
         0, (2*Cr*lr - 2*Cf*lf)/(Iz*V), (2*Cf*lf - 2*Cr*lr)/Iz, -(2*Cf*lf^2 + 2*Cr*lr^2)/(Iz*V)];

B1 = [      0       ;
          2*Cf/m    ;
            0       ;
     2*(Cf*lf)/Iz]  ;

B2 = [              0                 ;
      -(2*Cf*lf - 2*Cr*lr)/(m*V) - V  ;
                    0                 ;
      -(2*Cf*lf^2 + 2*Cr*lr^2)/(Iz*V)];

B3 = [  0    ;
        0    ;
        0    ;
      1/Iz]  ;

% Merging all the matrices in one

B_dyn = [ B1 , B2 , B3 ]; 

C_dyn = eye(4);   
D_dyn = zeros(4,3);
```

### System Architecture & Control Layout

<div align="center">
  <img src="modello%20completo.png" width="80%">
  <br>
  <em>Fig. 1: Simulink layout for MPC & PID Driver-in-the-Loop simulator.</em>
</div>
<br>

**Architecture Rationale:** The environment was developed to bridge the gap between theoretical path-tracking and real-world testing. By structuring a modular 4-state single-track plant, the setup allows for the safe, repeatable evaluation of transient vehicle dynamics prior to physical track deployment. The signal routing strictly enforces double precision data type conversions throughout the control loops, guaranteeing mathematical consistency between the predictive algorithms and the continuous physical states of the vehicle model.

### Dynamic Validation & Tracking Performance

To validate the controller's effectiveness under high-dynamic maneuvering, the system was subjected to simulated track layouts. The trajectory plots utilize an inverted red and green color coding for the lead and follow elements, maintaining strict visual consistency with external project materials and ensuring immediate feedback on controller accuracy.

<div align="center">
  <img src="lateral%20error.png" width="70%">
  <br>
  <em>Fig. 2: Lateral cross-track error distribution for a Formula Student Skidpad event (m).</em>
</div>
<br>

The lateral error remains tightly bounded throughout the simulation, peaking at approximately **0.15 m (15 cm)** during critical transition phases. This high-precision tracking demonstrates the MPC's capability to hold the designated racing line and optimally manage slip angles, even during aggressive transient cornering.

<div align="center">
  <img src="yae%20error.png" width="70%">
  <br>
  <em>Fig. 3: Yaw Heading Error (rad).</em>
</div>
<br>

This plot illustrates the alignment deviation between the vehicle's actual heading and the target path, successfully constrained to **0.05 radians (less than 3 degrees)** during cornering and to **0.12 radians (~7 degrees)** during critical transition phases. Minimizing this specific metric is critical for maintaining lateral stability and mitigating unintended oversteer scenarios during mid-corner transitions.

<div align="center">
  <img src="steer.png" width="70%">
  <br>
  <em>Fig. 4: Steering input command (rad).</em>
</div>
<br>

The steering command output confirms that the predictive logic generates smooth, realistic driver inputs. Measured in radians, the values remain well within the physical actuation limits of a standard Formula Student steering rack, preventing actuator saturation and erratic dynamic responses. 

### Lap Time Analysis & Iterative Tuning

Beyond pure trajectory tracking, a custom lap-timing logic was integrated directly into the simulation loop. This tool precisely calculates lap times across the generated trajectories, establishing a robust, data-driven baseline. The ultimate goal of this environment is to evaluate how iterative modifications to the vehicle's physical parameters (e.g., suspension setups, track width adjustments, or mass distribution) directly impact overall track performance, allowing for rapid virtual prototyping before physical manufacturing.
Right now the car is able to lap one circle in 6 seconds at approximately 9.4 m/s, highlighting how the MPC is working correctly but the there's still room for improvement. 

### Limitations & Future Developments

While the current MPC architecture provides a robust baseline for path-tracking, the driver model is part of an ongoing iterative development process. Targeted areas for future improvement include:

*   **Combined Slip Management:** Expanding the control logic to concurrently manage lateral and longitudinal slip ratios, fully integrating the steering MPC with dedicated traction and launch control architectures.
*   **Transient Spike Mitigation:** Refining the control response to eliminate algorithmic spikes during high-frequency directional changes, specifically targeting the transition zone between Skidpad circles.
*   **Real-Time 3D Simulation:** Porting the mathematical control logic into a real-time interactive environment, utilizing custom vehicle physics and skeletal meshes to evaluate the driver-in-the-loop response with direct visual feedback.
*   **Adaptive MPC Implementation:** Upgrading the static linear controller to an Adaptive Model Predictive Controller (AMPC) to dynamically update the plant's defining state-space matrices at each discrete time step.
*   **Custom Solver Development:** Transitioning from standard library blocks to a fully proprietary, in-house coded MPC algorithm tailored specifically for our processing constraints and vehicle parameters.
*   **Lap Time:** Improving the 6 seconds Lap Time for the Skid Pad Event, as this time is far from being ideal.

**[View the complete MATLAB Project and Simulink models on GitHub](https://github.com/michelemarcon14-a11y/michelemarcon14-a11y.github.io/tree/main/model_MPC)**

**[⬅ Return to Portfolio Home](index.html)**

<style>
  footer { display: none !important; }
</style>
