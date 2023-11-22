# RangeMap Package
This R package facilitates the construction of species distribution models (SDM) using MaxEnt and the generation of corresponding range map products. It streamlines the workflow for users interested in analyzing and visualizing the distribution of terrestrial vertebrates.

## Overview
This package is designed to provide a comprehensive workflow for generating SDMs and range maps. The primary features include:

**MaxEnt Modeling**: Utilize MaxEnt to construct SDMs for multiple species.<br>
**Binary Map Generation and Expert Review**: Convert continuous MaxEnt predictions into binary maps based on specified thresholds, Generate range maps with thresholds selected by experts for further evaluation.<br>
**Final Range Map Creation**: Produce final range maps for each species.

## Example Workflow
To get started, explore the example workflow provided in the example_workflow.html file. This document walks you through the essential steps, demonstrating how to use the package effectively.

## Installation
``` r
# Install the RangeMap package from GitHub
devtools::install_github("kemushi54/RangeMap")
```

For detailed information on the workflow and the underlying dataset, please refer to the associated data paper (https://doi.org/10.1016/j.dib.2022.108060).
