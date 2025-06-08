ghdl -a *.vhd
ghdl -e control_unit_tb
ghdl -r control_unit_tb --wave=control_unit_tb.ghw
gtkwave control_unit_tb.ghw