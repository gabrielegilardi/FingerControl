# Biomimetic Control of Artificial Fingers

The objective of this project was to design a biomimetic tendon-driven actuation system for powered orthotic and prosthetic hand applications in rehabilitation robotics. The actuation system is based on the combination of compliant tendon cables and one-way Shape Memory Alloy (SMA) wires that form a set of artificial muscle pairs for the flexion-extension or abduction-adduction of an artificial finger joint. This type of configuration enables the emulation of key biological features of the natural muscle-tendon arrangement found in the human hand, such as the compliant and bi-directional agonist-antagonist pulling motion about each joint.

#### References

**Gilardi G.**, Haslam E., Bundhoo V., and Park E.J., 2010, “A Shape Memory Alloy Based Tendon-Driven Actuation System for Biomimetic Artificial Fingers, part II: Modeling and Control”, [*Robotica*, **28**(5), pp. 675-687](https://www.cambridge.org/core/journals/robotica/article/shape-memory-alloy-based-tendondriven-actuation-system-for-biomimetic-artificial-fingers-part-ii-modelling-and-control/07DE661B714879F509C975C9DD7B8ADD).

Ko J., Martin B.J., **Gilardi G.**, Haslam E., and Park E.J, 2011, “Fuzzy PWM-PID control of co-contracting antagonistic shape memory alloy muscle pairs in an artificial finger”, [*Mechatronics*, **21**(7), pp. 1190-1202](https://www.sciencedirect.com/science/article/abs/pii/S0957415811001097).

#### Code
- The code has been written and tested in Matlab/Simulink version 8.3 (R2014a).
- Run `Initialization.m` before running `Finger_Full_Model` in Simulink.
- All variables are saved in the workspace after the simulation.
- `plotResults.m` plots the main results.
- Use variable `ProfileType` in `Initialization.m` to specify different desired time-profiles.
- The desired time-profiles are defined in `Finger_Desired_Position.m`.


#### Examples

`ProfileType = 1`
- rotation to -25 degrees using SMA1 (SMA2 used as passive spring).
- cool down period (both SMAs used as passive springs).
- rotation to -30 degrees using SMA1 (SMA2 used as passive spring).

`ProfileType = 2`
- rotation to -25 degrees using SMA1 (SMA2 used as passive spring).
- rotation to -55 degrees using both SMAs (motion is driven by SMA2 while SMA1 is used to reduce overshooting).

Results for these two examples are shown in the bmp files.
