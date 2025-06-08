###########################################
## SETUP HOST ENVIRONMENT
###########################################
set_host_options -max_cores 8   ;# Use 8 threads for synthesis
set design top_odyssey          ;# Define top module name

# Load common variables: libraries, paths, environment settings
source ../../../common_setup.tcl


###########################################
## LIBRARY SETUP
###########################################
set link_library   $LINK_LIBRARY_FILES_CLG
set target_library $TARGET_LIBRARY_FILES_CLG


###########################################
## LIBRARY CELL EXCLUSIONS
###########################################
# Avoid using known problematic cells
set_dont_use [get_lib_cells -quiet */SAEDRVT14_AO21_U_0P5]


###########################################
## READ RTL SOURCES
###########################################
analyze -library WORK -format verilog {
    ../../RTL/top_odyssey.v
    ../../RTL/srff.v
    ../../RTL/power_controller.v
    ../../RTL/mult3232.v
    ../../RTL/MemXHier.v
    ../../RTL/MemYHier.v
    ../../RTL/InstructionDecoder.v
    ../../RTL/gpr.v
    ../../RTL/genpp32.v
    ../../RTL/csa.v
    ../../RTL/cla.v
    ../../RTL/address_gen.v
    ../../RTL/addpp32.v
}

elaborate $design -lib WORK


###########################################
## CONSTRAINTS SETUP
###########################################
source -echo ../../Constraints/chiptop.sdc


###########################################
## CLOCK GATING SETUP
###########################################
set_clock_gating_registers -include_instances \
  [remove_from_collection [all_registers -clock clock] \
    [get_cells "MemYHier/MemXb MemYHier/MemXa MemXHier/MemXb MemXHier/MemXa"]]


###########################################
## OPERATING CONDITIONS
###########################################
set_operating_conditions -min ff0p88v125c -max ss0p6v125c


###########################################
## DESIGN LINKING & FIXES
###########################################
# Ensure unique names if the design is instantiated multiple times
set uniquify_naming_style "%s_mydesign_%d"
uniquify

link

# Prevent issues with multiple drivers
set_fix_multiple_port_nets -all -buffer_constants [get_designs $design]


###########################################
## SYNTHESIS PHASE 1: LOGIC + GATING
###########################################
compile -exact_map -gate_clock

# Remove unused ports (clean up)
remove_unconnected_ports [get_cells -hierarchical *]
remove_unconnected_ports [get_cells -hierarchical *] -blast_buses


###########################################
## POST-SYNTHESIS CLEANUP
###########################################
change_names -rules verilog -verbose -hier
report_clock_gating


###########################################
## HOLD FIXING
###########################################
set_fix_hold [all_clocks]
report_constraints -min_delay


###########################################
## SYNTHESIS PHASE 2: INCREMENTAL OPTIMIZATION
###########################################
compile -incremental -only_design


###########################################
## REPORTS
###########################################
report_area       -hier > ./report/synth_area.rpt
report_power      -hier > ./report/synth_power.rpt
report_cell             > ./report/synth_cells.rpt
report_qor              > ./report/synth_qor.rpt
report_resources        > ./report/synth_resources.rpt
report_timing -delay min  -max_paths 4 > ./report/synth_Hold.rpt 
report_timing -delay max  -max_paths 4 > ./report/synth_Setup.rpt
report_timing -path full -delay max -max_paths 1 -nworst 1 -significant_digits 4 > ./report/synth_timing.rpt
report_constraint -all_violators > ./report/report_violation.rpt


###########################################
## OUTPUT FINAL FILES
###########################################
write_sdc output/${design}.sdc
write_sdf -version 1.0 -context verilog output/${design}.sdf

define_name_rules no_case -case_insensitive
change_names -rule no_case -hierarchy
change_names -rule verilog -hierarchy

set verilogout_no_tri true
set verilogout_equation false

write -f verilog -h -out ../output/${design}.v
write -f ddc     -h -out ../output/${design}.ddc
