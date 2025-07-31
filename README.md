# STM32 MCU Board

## Introduction
This repository is my first ever PCB design project. After working on projects that involved more digital circuits and RTL scripting, I've always wanted to build my own boards, more specifically FPGA boards. However, I want to start on something simpler so I can understand the inner workings of PCB design, decision choices, and general concepts that are crucial to a functional STM32 board.

## Design Approach
Given that this is just a basic guide to designing, laying out, and manufacturing a simple STM32 board, this PCB will only offer 2 UART channels and a single I2C bus for peripherals. 

### Power Regulator Circuit
<p align="center">
    <img width="800px" src="./Images/BuckRegulatorSchematic.png" />
</p>
<p align="center">
    <em>Buck Converter Based Power Regulator Circuit.</em>
</p>

For the specific buck converter that we are using, I'm using the TPS54300DDA chip. 

### STM32F030 MCU
<p align="center">
  <img width="600px" src="./Images/STM32MCUSchematic.png" />
</p>
<p align="center">
    <em>MCU Schematic with GPIO, UART, and I2C pins.</em>
</p>

## Connectors

### Left Connector
<p align="center">
  <img width="600px" src="./Images/LeftConnectorSchematic.png" />
</p>
<p align="center">
    <em>External connector for I2C bus, NRST, and USART1 pins.</em>
</p>

### Right Connector
<p align="center">
  <img width="600px" src="./Images/RightConnectorSchematic.png" />
</p>
<p align="center">
    <em>External connector for USART2 and GPIO pins.</em>
</p>

## Assigning Footprints

## PCB Layout

## 3D View

## Physical Board / Functionality
---

Please check each subdirectory for more detail.
