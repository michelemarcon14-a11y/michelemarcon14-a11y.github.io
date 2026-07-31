---
layout: default
title: Michele Marcon | Mechanical Engineer
---
# Engineering portfolio

### Driver-in-the-Loop Simulation: MPC & PID Vehicle Controller

**Objective:** Engineered an advanced path-following controller within Simulink to simulate realistic driver inputs for dynamic vehicle evaluation.

**Technical Implementation:**
*   **Plant Architecture:** Structured a 4-state single-track vehicle dynamics model in MATLAB, defining the state-space matrices through precise parameterization of vehicle mass, yaw inertia, and tire cornering stiffness.
*   **Control Logic Integration:** Implemented a Model Predictive Control (MPC) algorithm for optimal trajectory tracking, functioning in tandem with a PID controller to govern longitudinal dynamics.
*   **Feedforward Calibration:** Designed and integrated a steering feedforward logic to enhance the predictive response of the path-tracking algorithm. Restructured the variable calculation loops, resolving an inactive conditional block to guarantee uninterrupted feedforward data transmission during high-dynamic maneuvering.
*   **Simulation & Validation:** Deployed the integrated controller within a driver-in-the-loop environment to evaluate transient vehicle behavior and dynamic stability under simulated track conditions.
