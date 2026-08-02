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
### System Architecture & Control Layout

![Simulink Plant and Control Architecture](modello%20completo.png)
*Fig.1: Simulink layout for MPC & PID Driver-in-the-Loop simulator.*

**Architecture Rationale:** The environment was developed to bridge the gap between theoretical path-tracking and real-world testing. By structuring a modular 4-state single-track plant, the setup allows for the safe, repeatable evaluation of transient vehicle dynamics prior to physical track deployment. The signal routing strictly enforces double precision data type conversions throughout the control loops, guaranteeing mathematical consistency between the predictive algorithms and the continuous physical states of the vehicle model.

### Dynamci Validation & Tracking Performance

To validate the controller's effectiveness under high-dynamic maneuvering, the system was subjected to simulated track layouts. The plots ent color coding for lead and follow trajectory elements, ensuring immediate visual feedback on controller accuracy.

![Lateral Tracking Error](lateral%20error.png)
*Fig.2: Lateral cross-track error distribution for a Formula Student Skid Pad event (m).*

The lateral error remains tightly bounded throughout the simulation. This demonstrates the MPC's predictive capability to hold the designated racing line and optimally manage slip angles, even during aggressive transient cornering phases.

![Yaw Angle Error](yae%20error.png)
*Fig.3: Yaw Heading Error (rad).*

This plot illustrates the alignment deviation between the vehicle's actual heading and the target path. Minimizing this specific metric is critical for maintaining lateral stability and mitigating unintended oversteer scenarios during mid-corner transitions.

![Steering Input](steer.png)
*Fig.4: Steering input command (rad).*

The steering command output confirms that the feedforward logic generates smooth, realistic driver inputs. Measured in radians, the values remain well within the physical actuation limits of a standard Formula Student steering rack, preventing actuator saturation and erratic dynamic responses.

