library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_tb is
end;

architecture a_control_unit_tb of control_unit_tb is
    component control_unit
        port (
            clock : in std_logic;
            reset : in std_logic;
            rom_address : out unsigned(6 downto 0);
            rom_data : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal clock, reset: std_logic;
    signal rom_address : unsigned(6 downto 0);
    signal rom_data : unsigned(15 downto 0);

begin
    uut: control_unit port map(
        clock => clock,
        reset => reset,
        rom_address => rom_address,
        rom_data => rom_data
    );
    
    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clock <= '0';
            wait for period_time / 2;
            clock <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 400 ns;
        wait;
    end process;
end architecture;    