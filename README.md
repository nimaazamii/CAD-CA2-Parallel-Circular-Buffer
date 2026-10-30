# CAD HW2 — Parallel Circular Buffer

A parameterized Verilog circular-buffer design with separate read/write pointers, a storage datapath, and an FSM-based control unit.

## Main features

- Parameterized address width, data width and buffer depth.
- Independent read and write pointer updates.
- Configurable read/write batch sizes (`PAR_RD` and `PAR_WR`).
- `ready` and `valid` handshake outputs.
- Separate `simple_buffer`, pointer-register, datapath and control modules.

## Repository layout

- `src/hdl/` — RTL modules.
- `sim/tb/tb_top.v` — supplied simulation testbench.
- `sim/sim_top.tcl` — ModelSim/Questa simulation script.

## Simulation

Open ModelSim/Questa in the `sim/` directory and run:

```tcl
do sim_top.tcl
```

The HDL path in the script has been changed from the original machine-specific absolute path to a repository-relative path.

## Validation notes

The supplied testbench instantiates the design with `PAR_RD=1` and `PAR_WR=1`; it therefore does not exercise the default parallel settings (`PAR_RD=4`, `PAR_WR=2`). It also assigns 16-bit constants to an 8-bit input in that configuration, which truncates the values. A stronger self-checking testbench covering wraparound, full/empty conditions, simultaneous read/write and parallel transfers should be added before claiming full verification.
