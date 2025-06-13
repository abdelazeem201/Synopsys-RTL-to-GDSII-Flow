## Constants
set PERIOD         7.0
set INPUT_DELAY    1.0
set OUTPUT_DELAY   1.0
set CLOCK_LATENCY  1.5
set MIN_IO_DELAY   1.0
set MAX_TRANSITION 0.5

## Clock Setup
create_clock -name "clock" -period $PERIOD [get_ports clock]
set_clock_latency     $CLOCK_LATENCY     [get_clocks clock]
set_clock_uncertainty 0.3                [get_clocks clock]
set_clock_transition  0.4                [get_clocks clock]

## IO Ports
set INPUTPORTS  [remove_from_collection [get_ports [all_inputs]] [get_ports clock]]
set OUTPUTPORTS [get_ports [all_outputs]]

## IO Constraints
set_input_delay  -clock "clock" -max $INPUT_DELAY   $INPUTPORTS
set_input_delay  -clock "clock" -min $MIN_IO_DELAY  $INPUTPORTS
set_output_delay -clock "clock" -max $OUTPUT_DELAY  $OUTPUTPORTS
set_output_delay -clock "clock" -min $MIN_IO_DELAY  $OUTPUTPORTS

## Group Paths
group_path -name REG2REG -from [all_registers] -to [all_registers] -weight 1
group_path -name INPUTS  -through $INPUTPORTS       -weight 1
group_path -name OUTPUTS -to $OUTPUTPORTS           -weight 1

## DRC
set_max_transition   $MAX_TRANSITION   [current_design]
set_max_capacitance  10.0             [current_design]
set_max_fanout       20               [current_design]

## IO modeling

set_driving_cell -lib_cell NBUFFX4_RVT $INPUTPORTS
set_load 20 $OUTPUTPORTS



## EXCEPTIONS
set_multicycle_path -setup -through [get_pin PwrCtrl/gprs_iso] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/mult_iso] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/memx_iso] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/memy_iso] 2

set_multicycle_path -setup -through [get_pin PwrCtrl/gprs_save] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/gprs_restore] 2

set_multicycle_path -setup -through [get_pin PwrCtrl/mult_sd] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/gprs_sd] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/memx_sd] 2
set_multicycle_path -setup -through [get_pin PwrCtrl/memy_sd] 2

set_multicycle_path -hold -through [get_pin PwrCtrl/gprs_iso] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/mult_iso] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/memx_iso] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/memy_iso] 1

set_multicycle_path -hold -through [get_pin PwrCtrl/gprs_save] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/gprs_restore] 1

set_multicycle_path -hold -through [get_pin PwrCtrl/mult_sd] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/gprs_sd] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/memx_sd] 1
set_multicycle_path -hold -through [get_pin PwrCtrl/memy_sd] 1

set_operating_conditions -library saed14rvt_ss0p72v125c ss0p72v125c

set_voltage 0.72 -obj {VDDL}
set_voltage 0.72 -obj {VDD }
set_voltage 0.000 -obj {VSS}
set_voltage 0.72 -obj {TOP.primary.power}
set_voltage 0.000 -obj {TOP.primary.ground}
set_voltage 0.000 -obj {GPRS.primary.ground}
set_voltage 0.72 -obj {GPRS.primary.power}
