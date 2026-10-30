alias clc ".main clear"

clc
exec vlib work
vmap work work

set TB                  "tb_top"  ;# Changed to match the format
set hdl_path            "../src/hdl"
set inc_path            "../src/inc"

set run_time            "1 us"
# set run_time            "-all"

# ============================ Add Verilog files ===============================
# Please add other modules here
vlog     +acc -incr -source +define+SIM     $hdl_path/circular_buffer.v
vlog     +acc -incr -source +define+SIM     $hdl_path/ControlUnit.v
vlog     +acc -incr -source +define+SIM     $hdl_path/datapath.v
vlog     +acc -incr -source +define+SIM     $hdl_path/ptr_register.v
vlog     +acc -incr -source +define+SIM     $hdl_path/register.v
vlog     +acc -incr -source +define+SIM     $hdl_path/simple_buffer.v
vlog     +acc -incr -source +incdir+$inc_path +define+SIM     ./tb/$TB.v
onerror {break}

# ================================= simulation ====================================
vsim    -voptargs=+acc -debugDB $TB

# ======================= adding signals to wave window ==========================
add wave -hex -group      {TB}                sim:/$TB/*
add wave -hex -group      {top}               sim:/$TB/uut/*    
add wave -hex -group -r   {all}               sim:/$TB/*

# =========================== Configure wave signals =============================
configure wave -signalnamewidth 2

# ====================================== run =====================================
run $run_time
