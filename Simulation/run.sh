#!/bin/bash

dhm_path=../rtl/

bench=$dhm_path/bench
wave_dir=$dhm_path/sim/rtl_sim/i2c_verilog/waves

vcs	-debug_all							\
	+incdir+$bench/verilog					\
	+incdir+$dhm_path/rtl/verilog				\
								\
	$dhm_path/rtl/*.v\
	$dhm_path/sim/*.v			\
								\
	-R
	
