# Design and Developement of Food Waste Treatment System

## 1. Project Overview

VibraSep is a proposed compact, low-cost kitchen waste treatment system designed to separate food solids from liquid waste and provide preliminary liquid treatment. The system combines multi-stage mesh screening, gravity-based oil and grease separation, and activated carbon filtration.

## 2. Problem Statement

Kitchen waste containing food particles, water, oil, and grease can contribute to drain blockages, unpleasant odours, and wastewater pollution when improperly disposed of. VibraSep aims to simplify waste segregation and improve kitchen wastewater pretreatment for small-scale applications.

## 3. Working Principle

1. **Feed:** Kitchen waste mixed with water enters the feed hopper.
2. **Screening:** The mixture passes through 10 mm, 8 mm, and 2 mm mesh screens in sequence.
3. **Solid Separation:** Food particles are retained according to screen aperture.
4. **Grease Separation:** A gravity-based trap separates floating, free oil and grease.
5. **Filtration:** Activated carbon provides additional polishing of the liquid.
6. **Collection:** The resulting liquid is collected for testing and appropriate disposal or further treatment.

## 4. Main Components

- Three mesh screens: 10 mm, 8 mm, and 2 mm
- Screen frame and vibration mechanism
- Feed hopper and collection tank
- Gravity-based grease trap
- Activated carbon filter
- Connecting pipes, fittings, and support frame

## 5. Software and Requirements

- MATLAB for simulation and analysis
- A compatible computer with MATLAB installed
- Optional CAD software for mechanical design and drawings

No external MATLAB toolboxes are confirmed as required; check the source script before running it.

## 6. Running the Simulation

1. Download or clone this repository.
2. Open MATLAB.
3. Navigate to the `src` folder.
4. Open the main `.m` simulation file.
5. Run the script and review the generated figures and outputs.

## 7. Repository Structure

```text
 Design and Developement of Food Waste Treatment System/
├── README.md
├── LICENSE
├── src/
│   └── water_filter_top10_middle8_bottom2.m
├── docs/
│   ├── TECHNICAL_DESIGN.md
│   └── architecture.md
├── data/
│   └── sample_input.csv
└── tests/
    ├── test_plan.md
    └── expected_results.csv
```

## 8. Validation and Limitations

The design and simulation are intended to support prototype development. Simulated outputs must not be treated as experimental results. Screening efficiency, vibration performance, liquid recovery, grease removal, clogging, and fabrication cost must be validated experimentally.

Activated carbon filtration does not guarantee disinfection or potable water quality. The separated liquid requires suitable testing and further treatment where necessary.

## 9. Current Project Stage

Design and development, with prototype fabrication and experimental validation to be documented as they are completed.

## 10. License

Refer to the `LICENSE` file for the terms governing reuse of the materials included in this repository.

## 11. Contributions

Suggestions for improving the mechanical design, simulation, testing methodology, and documentation are welcome, subject to the project team's intellectual property and publication decisions.

