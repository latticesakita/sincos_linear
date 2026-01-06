
# High‑Precision SIN / SIN-COS Linear Interpolation Modules (LUT + DSP)

This repository contains high‑accuracy sine and cosine generator modules implemented in Verilog.  
The design uses a **36‑bit EBR-based lookup table** and a **single 18×18 DSP block** to achieve floating‑point–level accuracy while keeping hardware usage extremely small.

---
## ✨ Features
- **32‑bit phase input**, representing `radian / (2π) * 2^32`
- **Up to 48‑bit output resolution** (default: 32‑bit Q2.30 format)
- **Two‑stage pipeline (clock latency = 2 clocks)** → **Fmax = 200 MHz**
- **Three‑stage pipeline version (clock latency = 3 clocks)** available in the `fmax` branch → **Fmax = 300 MHz**
- 4096‑entry LUT (π/2 range):
  - **36‑bit y0**
  - **18‑bit dy**
- High‑precision interpolation accuracy:
  - Max error: **1.97e‑8**
  - Average error: **8.27e‑9**
  - Better than single‑precision floating‑point (≈1.2e‑7)
- COS output supported by phase shifting (`cos(x) = sin(x + π/2)`).

---
## 📁 Repository Structure
```
/project
  ├─ sincos_linear.rdf     # Radiant project file
  ├─ sincos_linear.pdc     # constraint fileconstraint file


/source
  ├─ sin_linear.v          # supports sin() only
  ├─ sincos_linear.v       # top module for sin()/cos()
  ├─ mult18x18p48.v        # DSP instance
  ├─ rom_y36/
  ├─ rom_dy18/

/sim
  ├─ tb_sin_linear.v
  ├─ top_sin_linear.v      # Used for Fmax estimation
  ├─ gpll/                 # PLL config used during Fmax estimation

/scripts
  ├─ verify.bat            # Simulation + comparison script
  ├─ sim_half.pl           # Script used to generate the numerical LUT base data
  ├─ rom_out/              # Includes LUT .mem files (y0 and dy)

```

---
## 🚀 Performance
| Pipeline | Latency | Max Frequency | Branch |
|---------|---------|----------------|--------|
| 2-stage | 2 clocks | **200 MHz** | `main` |
| 3-stage | 3 clocks | **300 MHz** | `fmax` |

---
## 🧮 Architecture Overview
### SIN Calculation (`sin_linear`)
The module consists of:

#### Stage 0 — Preprocessing
- Extract quadrant from the upper 2 bits of the phase
- Convert phase into address + fractional part

#### Stage 1 — ROM Read
- Read `y0[35:0]` (EBR)
- Read `dy[17:0]` (EBR)
- Quadrant and frac forwarded to next stage

#### Stage 2 — Linear Interpolation
Interpolation formula:
```
sin(x) = y0 + dy * frac
```
- Implementation uses **one 18×18 → 48‑bit DSP block**
- Output sign adjusted by quadrant logic

### SIN + COS Wrapper (`sincos_linear`)
- Selects between SIN and COS by shifting the phase
- Instantiates `sin_linear`

---
## 🧪 Simulation
### Running the testbench
This will test sin_linear module, not sincos_linear module.
```
Run `../tb/tb.spf`
  (tb.spf doesn't simulate sincos_linear, top_sin_linear and gpll modules.)

This test bench will generate `sim_full_output.csv`.

`./scripts/verify.bat`
This compares output against golden reference data and report the accuracy.
```

---
## 🧭 FPGA Implementation Guide
### 1. Clocking Considerations
- Single synchronous clock domain
- DSP and EBR must share the same clock
- Use PLL clocks for high Fmax (`source/gpll`)

### 2. ROM Implementation (EBR)
- `rom_y36`: 36‑bit entries
- `rom_dy18`: 18‑bit entries
- Depth: 4096
- `.mem` files under `scripts/rom_out/`

### 3. DSP Block Mapping
- Expression: `Z = dy * frac + y0`
- Maps to one 18×18 DSP block
- Keep arithmetic intact for proper inference

### 4. Timing Closure Tips
- Keep stage boundaries intact
- Enable retiming, register balancing
- Optionally constrain DSP + EBR locality

### 5. Latency Alignment
- 2-stage version: **2 clocks latency**
- 3-stage version: **3 clocks latency**
- Align downstream pipelines accordingly

### 6. Port Explanation
- mode_cos
  - Output mode select.
  - 0: sin, 1: cos

- phase_i (32bits)
  - phase input value.
  - ex1. pi/2   ==> 32'h4000_0000
  - ex2. pi     ==> 32'h8000_0000
  - ex3. 3*pi/2 ==> 32'hC000_0000
  - ex4. rad    ==> rad/pi*(1<<31)

- valid_i, valid_o
  -  data valid indicator

- result_o (32bits, Q2.30)
  - bit31  : signed
  - bit30  : integer
  - bit29:0: fractional


### 7. Integration Checklist
- Clock/reset stable
- Output width correct
- ROM correctly initialized
- Latency accounted for

### 8. Recommended FPGA Families
- Lattice Avant

---
## 📄 License
This module incorporates content governed by the **Lattice Reference Design License Agreement**.

## Contributing
Issues and PRs are welcome.
