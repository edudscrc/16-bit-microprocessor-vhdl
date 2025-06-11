ghdl -a *.vhd
ghdl -e processor_tb
ghdl -r processor_tb --wave=processor_tb.ghw
gtkwave processor_tb.ghw