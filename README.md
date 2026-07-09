# FPGA Butterworth IIR Filter

Implementation of a **4th-order Butterworth IIR Low-Pass Filter** on an FPGA using **Verilog HDL**. This project was developed as an undergraduate thesis and demonstrates real-time digital signal filtering using an FPGA. An STM32 microcontroller is used as the input sine wave generator, while the filtered output is transmitted back to a PC for visualization using a Serial Oscilloscope.

---

## Features

- 4th-order Butterworth IIR Low-Pass Filter
- Parameterized filter coefficients
- UART communication between STM32 and FPGA
- Fixed-point arithmetic implementation
- TCL-based Vivado automation
- One-command project build using Makefile

---

## System Architecture

```text
                 UART                     UART
+-----------+ -------------> +---------+ -------------> +----------------------+
|  STM32    |                |  FPGA   |                | Serial Oscilloscope  |
| Sine Wave |                | Butter- |                |      / PC            |
| Generator |                | worth   |                |                      |
+-----------+ <------------- +---------+ <------------- +----------------------+
```

1. STM32 generates digital sine wave samples.
2. Samples are transmitted to the FPGA through UART.
3. The FPGA processes the data using a Butterworth IIR filter.
4. Filtered samples are sent back to the PC through UART.
5. The waveform can be observed using a Serial Oscilloscope.

---

## Repository Structure

```text
.
├── coeff/              # Filter coefficient generator
├── rtl/                # Verilog HDL source files
├── constraint/         # FPGA constraints (.xdc)
├── scripts/            # TCL automation scripts
├── ip/                 # Vivado IP files
├── stm32/              # STM32 sine generator project
├── sim/                # Simulation files
├── build/              # Generated project files
├── Makefile
└── README.md
```

---

# Requirements

Software

- Xilinx Vivado
- GNU Make
- Git
- STM32CubeIDE
- Python (optional, if using Python Serial Oscilloscope)

Hardware

- Basys3 FPGA Board
- STM32 Development Board
- USB Type-C / Micro USB cable
- USB-UART connection

---

# Setup

Before running the project, edit

```text
setenv.bat
```

and modify the Vivado installation path according to your local installation.

Example:

```bat
set XILINX_VIVADO=C:\Xilinx\Vivado\2023.2
```

After that, initialize the environment

```bash
setenv.bat
```

---

# Build Commands

## Build Project

Create the Vivado project, run synthesis, implementation, and generate the bitstream.

```bash
make build
```

---

## Flash FPGA

Program the generated bitstream to the FPGA.

```bash
make flash
```

---

## Generate Filter Coefficients

Generate Butterworth filter coefficients.

```bash
make coeff
```

Run this command whenever the filter specifications are changed.

---

## Generate Clock Wizard

Regenerate the Clock Wizard IP.

```bash
make clock
```

Use this command if the FPGA clock configuration has changed.

---

## Clean Project

Remove generated Vivado files.

```bash
make clean
```

---

# Running the Hardware

## Step 1

Open the STM32 project using STM32CubeIDE.

Compile and flash the firmware to the STM32 board.

The STM32 will continuously generate sine wave samples through UART.

---

## Step 2

Connect

- STM32 TX → FPGA RX
- STM32 RX ← FPGA TX
- Common GND

---

## Step 3

Open a terminal.

Initialize the Vivado environment.

```bash
setenv.bat
```

---

## Step 4

Generate the FPGA bitstream.

```bash
make build
```

---

## Step 5

Download the bitstream.

```bash
make flash
```

---

## Step 6

Open the Serial Oscilloscope application.

Select the FPGA COM port.

The filtered waveform should appear in real time.

---

# Workflow

```text
STM32
   │
   ▼
Generate Sine Wave
   │
   ▼
UART Transmission
   │
   ▼
FPGA Butterworth Filter
   │
   ▼
UART Output
   │
   ▼
Serial Oscilloscope
```

---

# Notes

- Run `make coeff` whenever the cutoff frequency or filter order is modified.
- Run `make clock` if the FPGA clock frequency changes.
- Rebuild the project after modifying RTL files.

---

# Author

**Adji Pangestu**

Undergraduate Thesis Project

Digital Signal Processing on FPGA using Verilog HDL
