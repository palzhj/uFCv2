# uFC - MicroTCA fast control board v2

The uFC is a double-width Advanced Mezzanine Card (AMC) conceived to serve a small and simple system residing either inside a MicroTCA crate or on a bench with a link to a PC and it is based on a Kintex-7 FPGA. The uFC hosts two SFP+ transceiver modules, each operating at bi-directional data rates of up to 10Gbps. The uFC I/O capability can be further enhanced with two FPGA Mezzanine Cards (FMCs). The two high-pin-count FMC sockets each provide up to 58 user-specific differential I/O pairs directly connected to the FPGA as well as two differential clock inputs and two differential clock outputs. Concerning the AMC high speed serial connectivity, the uFC provides two Gigabit Ethernet (GbE) and one 2nd generation four-lane PCI Express (PCIe x4 GEN2) interfaces. The uFC offers a large selection of input clock sources (AMC clocks, FMC clocks, front panel clock connector or on-board oscillators).
<img src="/readme/uFCv2.jpg" width="400px">

## Specification

* Core: Xilinx Kintex FPGA XC7K325T-2FFG900I
* Memory
  1. Up to 8G-Byte DDR3L SODIMM with 64-bit data bus, capable of data transfer rate up to 64 Gbps at 500 MHz
  2. 2K-bit I2C Serial EEPROM with EUI-48™ Identity, providing a unique node Ethernet MAC address for mass-production process
  3. 256M-bit Quad SPI Flash for storing the FPGA firmware
* Configuration
  * JTAG header provided for use with Xilinx download cables such as the Platform Cable USB II or Digilent USB cable
  * JTAG from AMC backboard 
<img src="/readme/jtag.jpg" width="400px">

* Communication & Networking
  * SFP/SFP+ cage x2
  * UART To USB Bridge
  * Expansion Connectors
    * FMC-HPC (Partial Population) connector x2 (4 GTX Transceiver, 116 single-ended or 58 differential (34 LA & 24 HA) user defined signals), Vadj can be selected to support 1.8V, 2.5V, or 3.3V
  * Control & I/O
    * 8x DIP Switches
    * FAN Header (2 I/O)
    * LEMO input/output x2
* Clocking
  * Fixed Oscillator with differential 200MHz output
    * Used as the “system” clock for the FPGA
  * Programmable Oscillator with 156.250 MHz as the default output
    * Default frequency targeted for Ethernet applications but oscillator is programmable for many end uses
  * AMC clock input/output
  * LEMO clock input
  * White Rabbit clocking which provides sub-nanosecond synchronization
  * Jitter attenuated clock
    * Based on cross-point switches and programmable clock multipliers, the clock distribution circuit offers a large selection of input clock sources (e.g. the LEMO connectors in the front/rear panel, the AMC clocks, the FMC clocks, or onboard oscillators). This makes the uFC give users the possibility of implementing various high speed serial data protocols for custom applications.
<img src="/readme/clocking.jpg">

* Power
  * In bench-top prototyping, a 12V adapter is used as input power, and a switch helps to bypass the AMC initialization in MMC and 3.3V Management Power.
  * Voltage and Current measurement and management capability
<img src="/readme/power.jpg" width="600px">
