# Technical Design Document — Design-and-Developement-of-Food-Waste-Treatement-System

## 1. Purpose

VibraSep is a proposed compact kitchen waste segregation and liquid pretreatment system. It combines multi-stage mesh screening, gravity-based grease separation, and activated carbon filtration.

## 2. System Architecture

The process follows this sequence:

Kitchen Waste + Water
→ Feed Hopper
→ 10 mm Mesh Screen
→ 8 mm Mesh Screen
→ 2 mm Mesh Screen
→ Liquid Collection Tank
→ Gravity-Based Grease Trap
→ Activated Carbon Filter
→ Final Liquid Collection

Solid food particles are retained on the screens according to their size. The separated liquid moves to the grease trap, where floating free oil and grease can be removed. Activated carbon provides an additional polishing stage.

## 3. Major Components

### 3.1 Feed Hopper
Receives the kitchen waste slurry and distributes it to the screening assembly.

### 3.2 Multi-Stage Mesh Screens
Three screens with nominal apertures of 10 mm, 8 mm, and 2 mm are arranged from top to bottom. The screens are intended to progressively separate food particles.

### 3.3 Vibration Mechanism
A vibration mechanism assists the movement of material across the screens. Its frequency, amplitude, and mounting arrangement must be established through design calculations and testing.

### 3.4 Liquid Collection Tank
Collects the liquid passing through the screening assembly and directs it to the grease trap.

### 3.5 Gravity-Based Grease Trap
Allows separable free oil and grease to float to the surface for removal. Stable emulsified oil may remain in the liquid.

### 3.6 Activated Carbon Filter
Provides additional adsorption of certain odour-causing compounds and dissolved organic substances. It does not guarantee complete purification or disinfection.

## 4. Operating Sequence

1. Prepare kitchen waste mixed with water.
2. Introduce the mixture through the feed hopper.
3. Pass the mixture through the 10 mm, 8 mm, and 2 mm screens in sequence.
4. Collect retained solids for suitable handling or further assessment.
5. Direct the screened liquid into the grease trap.
6. Remove accumulated free oil and grease.
7. Pass the remaining liquid through the activated carbon filter.
8. Collect the output for quality testing and appropriate disposal or further treatment.

## 5. Design Requirements

- Compact construction for small-scale applications.
- Accessible and removable screening components.
- Minimise dependence on electrical power.
- Simple cleaning and maintenance.
- Leak-resistant joints and safe handling of waste.
- Replaceable activated carbon media.

## 6. Preliminary Performance Targets

The following are proposed targets and must be validated experimentally:

- Batch volume: approximately 3 litres.
- Target feed flow rate: 3 litres per minute.
- Mesh apertures: 10 mm, 8 mm, and 2 mm.
- Free oil and grease removal: target of at least 50%.
- Suspended solids reduction: target of at least 70%.

These targets are not verified experimental results.

## 7. Verification Plan

Record the input volume, feed time, mass of retained solids, recovered liquid volume, screen clogging, cleaning time, and material costs.

Measure oil and grease concentration and suspended solids before and after treatment using suitable laboratory methods. Calculate removal efficiency from measured inlet and outlet concentrations.

## 8. Risks and Limitations

- Screen clogging from fibrous or sticky food waste.
- Variable particle sizes and feed composition.
- Limited removal of emulsified oils by gravity separation.
- Activated carbon saturation and pressure drop.
- The need for additional treatment before reuse or discharge.

## 9. Safety and Maintenance

Use corrosion-resistant materials where appropriate. Ensure stable supports, guarded moving parts, leak-resistant connections, and safe access for cleaning. Remove collected solids and grease regularly, and replace carbon media based on measured performance.

## 10. Current Development Stage

The project is in the design and development stage. Fabrication, performance testing, and validation remain necessary before the system's effectiveness can be claimed.

