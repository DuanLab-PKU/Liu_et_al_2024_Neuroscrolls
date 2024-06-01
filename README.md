# Code, software and data for Liu et al A high-density 1024-channel probe for brain-wide recordings in nonhuman primates

## Introduction

This repository stores code, software and data of the paper _A high-density 1024-channel probe for brain-wide recordings in nonhuman primates_ by Liu et al.

## Repository Structure

This repository contains 4 subfolders:
+ directory `scripts` stores Python and MATLAB scripts for data analysis (`*-generator.ipynb`) and visualization (`plotter.ipynb`). `*-generator.ipynb` reads binary data and kilosort output using a self-written package, called `KSD` (Kilosort Decipher) to perform various analyses, generating source data for figures. The `KSD` package is available in a [seperate repository](https://github.com/DuanLab-PKU/KSD).
+ directory `data` stores the source data for all figures.
+ directory `sourcedata` stores source data of selected statistical figures in `xlsx` format, converted from `data` using `scripts/organizer.ipynb`. Files in this folder is submitted with the manuscript and published online.
+ directory `software` stores the 1024-channel data acquisition software. It can only run on Windows x86_64 platform. Without any device connected, the software can only enter demo mode.

## Reproducibility

+ You can run `plotter.ipynb` to generate most of the figures in the paper (except for figure 4h, which is plotted by MATLAB scripts as provided in `scripts/fig4h`, and extended data figure 3/4/7, which is plotted by Origin). 
+ `*-generator.ipynb` requires some extra data files to generate data used in `plotter.ipynb`. Since those files were not provided, `*-generator.ipynb` cannot be executed, and it is for display of analysis process only.

## License

The custom code and software in this repository are licensed under [GPL v3](https://www.gnu.org/licenses/gpl-3.0.en.html) (GNU General Public License v3.0). See LICENSE file for details.