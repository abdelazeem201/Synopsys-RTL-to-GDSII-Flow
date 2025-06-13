###################################################################################
###################################   INITLIB   ###################################
###################################################################################

set_host_options -max_cores 16
source ../../../common_setup.tcl 	
set TOP_DESIGN ChipTop

set link_library   $LINK_LIBRARY_FILES_PG
set target_library $TARGET_LIBRARY_FILES_PG

create_lib  -ref_libs $NDM_REFERENCE_LIB_DIRS_PG  -technology $TECH_FILE ../work/${TOP_DESIGN}

read_parasitic_tech -tlup $TLUPLUS_MAX_FILE  -layermap  $MAP_FILE 
read_parasitic_tech -tlup $TLUPLUS_MIN_FILE  -layermap  $MAP_FILE 

####################################################################################
###################################   FLOORPLAN   ##################################
####################################################################################

set gate_verilog "../../dc/output/compile.v" 

read_verilog -top $TOP_DESIGN $gate_verilog

current_design $TOP_DESIGN

load_upf ../../dc/output/compile.upf

commit_upf

save_block -as ${TOP_DESIGN}_0_imported

set_attribute [get_layers M1] routing_direction horizontal
set_attribute [get_layers M2] routing_direction horizontal
set_attribute [get_layers M3] routing_direction vertical
set_attribute [get_layers M4] routing_direction horizontal
set_attribute [get_layers M5] routing_direction vertical
set_attribute [get_layers M6] routing_direction horizontal
set_attribute [get_layers M7] routing_direction vertical
set_attribute [get_layers M8] routing_direction horizontal
set_attribute [get_layers M9] routing_direction vertical
set_attribute [get_layers MRDL] routing_direction horizontal

initialize_floorplan \
  -flip_first_row true \
  -boundary {{0 0} {500 500}} \
  -core_offset {30 30 30 30}


place_pins -port [get_ports *]

# # GET CORE
# ##########
set bbox [get_attribute [get_core_area] bbox]
set x1 [lindex [lindex $bbox 0] 0]
set y1 [lindex [lindex $bbox 0] 1]
set x2 [lindex [lindex $bbox 1] 0]
set y2 [lindex [lindex $bbox 1] 1]

############################
### CREATE VOLTAGE AREAS ###
############################

set GPRS_llx 55
set GPRS_lly 55.2
set GPRS_urx 240
set GPRS_ury 229.2

remove_voltage_area -all
create_voltage_area  -region [list [list $GPRS_llx $GPRS_lly] [list $GPRS_urx $GPRS_ury]] -power_domains GPRS -guard_band [list [list 2 2]] -target_utilization 0.4

############################
### PG NET CONNECTIONS   ###
############################

set VDDL                   "VDDL"
set VDD                    "VDD"
set VSS                    "VSS"

create_net -power $VDDL
create_net -power $VDD
create_net -ground $VSS

####################################################################################
###################################  POWER PLAN  ###################################
####################################################################################

############################
########  PG RINGS  ########
############################

set top_ring_width 5
set top_offset 2
set top_ring_spacing 5
set gprs_ring_width 1.5
set gprs_offset -5
set gprs_ring_spacing 2
set hm_gprs M7
set vm_gprs M8
set hm_top M6
set vm_top M5


create_pg_region top_power_ring_region -core -expand_by_edge  \
          "{{side: 1} {offset: $top_offset}} {{side: 2} {offset: $top_offset}} {{side: 3} {offset: $top_offset}} {{side: 4} {offset: $top_offset}}"
	 
create_pg_ring_pattern \
                 ring \
                 -horizontal_layer $hm_top -vertical_layer $vm_top \
                 -horizontal_width $top_ring_width -vertical_width $top_ring_width \
                 -horizontal_spacing $top_ring_spacing -vertical_spacing $top_ring_spacing

set_pg_strategy  ring -pg_regions { top_power_ring_region } -pattern {{ name: ring} { nets: "$VDDL $VSS $VDD" }}

compile_pg -strategies ring

connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDDL"]
connect_pg_net -net $VDD [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VSS [get_pins -hierarchical "*/VSS"]
#########################################SRAMs' Placement################################################################
set sram_width 54.468
set sram_space 40
set sram_start_x 55.4690
set sram_start_y 246.6000

set_attribute [get_cells MemYHier/MemXb] orientation R0
set_attribute [get_cells MemYHier/MemXa] orientation R0
set_attribute [get_cells MemXHier/MemXb] orientation R0
set_attribute [get_cells MemXHier/MemXa] orientation R0

set_attribute [get_cells MemYHier/MemXb] origin "$sram_start_x $sram_start_y"
set_attribute [get_cells MemYHier/MemXa] origin "[expr $sram_start_x + $sram_width + $sram_space] $sram_start_y"
set_attribute [get_cells MemXHier/MemXb] origin "[expr $sram_start_x + 2*($sram_width + $sram_space)] $sram_start_y"
set_attribute [get_cells MemXHier/MemXa] origin "[expr $sram_start_x + 3*($sram_width + $sram_space)] $sram_start_y"

set_fixed_objects [get_cell MemXHier/MemXa]
set_fixed_objects [get_cell MemXHier/MemXb]
set_fixed_objects [get_cell MemYHier/MemXa]
set_fixed_objects [get_cell MemYHier/MemXb]

create_keepout_margin -type hard -outer {20 20 20 20} [get_cells Mem?Hier/MemX?]

create_placement -floorplan -timing_driven
legalize_placement
##########################################################################################################################



#########################################Shapes Creation For SRAMs' PG Connection################################################################
foreach_in_collection pin [get_pins "Mem?Hier/MemX?/VDD* Mem?Hier/MemX?/VSS"] {
	set pin_name [get_attribute [get_pins $pin] name]
	set bb [get_attribute [get_pins $pin] bbox]
	if {$pin_name == "VDDL"} {
		set bb [lreplace $bb 1 1 [list [lindex $bb 1 0] [expr [lindex $bb 1 1] + 17.328]]]
	}
	set net [get_nets -of_objects [get_pins $pin]]
	create_shape -net $net -layer M5 -boundary $bb -shape_type rect
}

#########################################Routing Blockages On Macro Cells################################################################
create_routing_blockage -layers {M1 M2 M3 M4 M5} -boundary [get_attribute [get_cells MemXHier/MemXa] boundary]
create_routing_blockage -layers {M1 M2 M3 M4 M5} -boundary [get_attribute [get_cells MemYHier/MemXa] boundary]
create_routing_blockage -layers {M1 M2 M3 M4 M5} -boundary [get_attribute [get_cells MemXHier/MemXb] boundary]
create_routing_blockage -layers {M1 M2 M3 M4 M5} -boundary [get_attribute [get_cells MemYHier/MemXb] boundary]

#create_placement_blockage -boundary [get_attribute [get_cells MemXHier/MemXa] boundary]
#create_placement_blockage -boundary [get_attribute [get_cells MemYHier/MemXa] boundary]
#create_placement_blockage -boundary [get_attribute [get_cells MemXHier/MemXb] boundary]
#create_placement_blockage -boundary [get_attribute [get_cells MemYHier/MemXb] boundary]
#########################################PNS GPRS################################################################
create_pg_std_cell_conn_pattern gprs_M1_rail -layers {M1} -rail_width {@wtop @wbottom} -parameters {wtop wbottom}

set_pg_strategy M1_rail_strategy_pwr_gprs -voltage_areas GPRS -pattern {{name: gprs_M1_rail} {nets: VDDL} {parameters: {0.094 0.094}}}
set_pg_strategy M1_rail_strategy_gnd_gprs -voltage_areas GPRS -pattern {{name: gprs_M1_rail} {nets: VSS} {parameters: {0.094 0.094}}}

compile_pg -strategies M1_rail_strategy_pwr_gprs -ignore_drc
compile_pg -strategies M1_rail_strategy_gnd_gprs -ignore_drc

create_pg_mesh_pattern GPRS_MESH_VERTICAL \
	-layers " \
		{ {vertical_layer: M5}   {width: 0.3} {spacing: minimum} {pitch: 25} {offset: 0.5}  {trim : true} } \
		"

set_pg_strategy VDDVSS_GPRS_MESH_VERTICAL \
	-voltage_areas GPRS \
	-pattern   { {name: GPRS_MESH_VERTICAL} {nets:{VSS VDDL}} }

compile_pg -strategies {VDDVSS_GPRS_MESH_VERTICAL}

create_pg_mesh_pattern GPRS_MESH_HORIZONTAL \
	-layers " \
		{ {horizontal_layer: M6}   {width: 0.3} {spacing: minimum} {pitch: 25} {offset: 0.5}  {trim : true} } \
		" 

set_pg_strategy VDDVSS_GPRS_MESH_HORIZONTAL \
	-voltage_areas GPRS \
	-pattern   { {name: GPRS_MESH_HORIZONTAL} {nets:{VSS VDDL}} }

compile_pg -strategies {VDDVSS_GPRS_MESH_HORIZONTAL}

create_pg_region gprs_power_ring_region -voltage_area GPRS -expand_by_edge  \
          "{{side: 1} {offset: $gprs_offset}} {{side: 2} {offset: $gprs_offset}} {{side: 3} {offset: $gprs_offset}} {{side: 4} {offset: $gprs_offset}}"
	 
create_pg_ring_pattern \
                 ring_gprs \
                 -horizontal_layer $hm_gprs  -vertical_layer $vm_gprs \
                 -horizontal_width $gprs_ring_width -vertical_width $gprs_ring_width \
                 -horizontal_spacing $gprs_ring_spacing -vertical_spacing $gprs_ring_spacing

set_pg_strategy  ring_gprs -pg_regions { gprs_power_ring_region } -pattern {{name: ring_gprs} {nets: "$VSS $VDDL"}}

compile_pg -strategies ring_gprs


#########################################PNS TOP################################################################
create_pg_std_cell_conn_pattern M1_rail_top -layers {M1} -rail_width {@wtop @wbottom} -parameters {wtop wbottom}

set GPRS_bbox [get_attribute [get_voltage_area_shapes -of_objects [get_voltage_areas GPRS]] voltage_area.bbox]

set_pg_strategy M1_rail_strategy_pwr_top -voltage_areas DEFAULT_VA -pattern {{name: M1_rail_top} {nets: VDD} {parameters: {0.094 0.094}}} \
 		-blockage { {polygon: $GPRS_bbox} }
set_pg_strategy M1_rail_strategy_gnd_top -voltage_areas DEFAULT_VA -pattern {{name: M1_rail_top} {nets: VSS} {parameters: {0.094 0.094}}} \
		-blockage { {polygon: $GPRS_bbox} }

compile_pg -strategies M1_rail_strategy_pwr_top 
compile_pg -strategies M1_rail_strategy_gnd_top

create_pg_mesh_pattern TOP_MESH_VERTICAL \
	-layers " \
		{ {vertical_layer: M5}   {width: 0.3} {spacing: minimum} {pitch: 20} {offset: 0.5}  {trim : true} } \
		"
set_pg_strategy VDDVSS_TOP_MESH_VERTICAL \
	-core \
	-pattern   { {name: TOP_MESH_VERTICAL} {nets:{VSS VDD}} } \
	-extension  { {stop: outermost_ring} } \
	-blockage { {voltage_areas: GPRS } }

compile_pg -strategies {VDDVSS_TOP_MESH_VERTICAL}

create_pg_mesh_pattern TOP_MESH_HORIZONTAL \
	-layers " \
		{ {horizontal_layer: M6}   {width: 0.3} {spacing: minimum} {pitch: 20} {offset: 0.5}  {trim : true} } \
		" 
set_pg_strategy VDDVSS_TOP_MESH_HORIZONTAL \
	-core \
	-pattern   { {name: TOP_MESH_HORIZONTAL} {nets:{VSS VDD}} } \
	-extension  { {stop: outermost_ring} } \
	-blockage { {polygon: $GPRS_bbox} }

compile_pg -strategies {VDDVSS_TOP_MESH_HORIZONTAL}

save_block -as ${TOP_DESIGN}_1_planned

#########################################Placement Optimization################################################################
legalize_placement
source ../scripts/mcmm.tcl
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix -value POPT
set_lib_cell_purpose -include "optimization" [get_lib_cells "*/*BUF* */*INV* */*DEL*"]
place_opt

connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDDL"]
connect_pg_net -net $VDD [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VSS [get_pins -hierarchical "*/VSS"]

save_block -as ${TOP_DESIGN}_2_placed

#########################################Clock Tree Synthesis And Optimization################################################################
create_routing_rule CLK_SPACING -spacings {M2 0.3 M3 0.5 M4 0.7}
set_clock_routing_rules -rules CLK_SPACING -min_routing_layer M2 -max_routing_layer M4
set_app_options -name opt.common.user_instance_name_prefix -value COPT

clock_opt

connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDDL"]
connect_pg_net -net $VDD [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VSS [get_pins -hierarchical "*/VSS"]

save_block -as ${TOP_DESIGN}_3_cts

#########################################Signal Nets' Routing And Optimization################################################################
set_ignored_layers -min_routing_layer M2  -max_routing_layer M4
set_app_options  -name time.si_enable_analysis -value true
set_app_options -name opt.common.user_instance_name_prefix -value ROPT 
route_opt

connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDDL"]
connect_pg_net -net $VDD [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VSS [get_pins -hierarchical "*/VSS"]

save_block -as ${TOP_DESIGN}_4_routed

route_eco -max_detail_iterations 5
##############################################################FILLERS ############################################################## 
set pnr_std_fillers "SAEDRVT14_FILL*"
set std_fillers ""
foreach filler $pnr_std_fillers { lappend std_fillers "*/${filler}" }

create_stdcell_fillers -lib_cells $std_fillers  \
		-voltage_area GPRS
create_stdcell_fillers -lib_cells $std_fillers \
		-voltage_area DEFAULT_VA

connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VDDL [get_pins -hierarchical "*/VDDL"]
connect_pg_net -net $VDD [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $VSS [get_pins -hierarchical "*/VSS"]

report_area
report_timing
report_power 

save_block -as ${TOP_DESIGN}_4_finished


change_names -rules verilog -verbose
write_verilog \
	-include {pg_netlist unconnected_ports} \
	../output/${TOP_DESIGN}.v

write_gds -design ${TOP_DESIGN}_4_finished \
	  -layer_map $GDS_MAP_FILE \
	  -keep_data_type \
	  -fill include \
	  -output_pin all \
	  -merge_files "$STD_CELL_GDS $SRAMLP_SINGLELP_GDS" \
	  -long_names \
	  ../output/${TOP_DESIGN}.gds

write_parasitics -output    {../results/${TOP_DESIGN}.spf}

close_block
close_lib

exit
