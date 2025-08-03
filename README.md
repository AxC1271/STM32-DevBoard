# STM32 MCU Board

## Introduction
This repository is my first ever PCB design project. After working on projects that involved more digital circuits and RTL scripting, I've always wanted to build my own boards, more specifically FPGA boards. However, I want to start on something simpler so I can understand the inner workings of PCB design, decision choices, and general concepts that are crucial to a functional STM32 board.

## Design Approach
Given that this is just a basic guide to designing, laying out, and manufacturing a simple STM32 board, this PCB will only offer a single USB interface. The specific processor chip that we are using is the STM32F103C8Tx, which uses an `ARM Cortex-M3 processor`. 

### Power Regulator Circuit
<p align="center">
    <img width="800px" src="./Images/LDOSchematic.png" />
</p>
<p align="center">
    <em> LDO-Based Power Regulator Circuit.</em>
</p>


### STM32F030 MCU
<p align="center">
    <img width="800px" src="./Images/STM32MCUSchematic.png" />
</p>
<p align="center">
    <em>MCU Schematic with USB-B Micro Interface.</em>
</p>

## Connectors

<p align="center">
  <img width="600px" src="./Images/Connector.png" />
</p>

## Assigning Footprints

## PCB Layout

## 3D View

## Physical Board / Functionality
---
