library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    port (
        clock : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;
        address_in : in unsigned(6 downto 0);
        address_out : out unsigned(6 downto 0)
    );
end entity;

architecture a_program_counter of program_counter is
    signal reg: unsigned(6 downto 0);
begin
    process(clock, reset, write_enable)
    begin
        if reset='1' then
            reg <= "0000000";
        elsif write_enable='1' then
            if rising_edge(clock) then
                reg <= address_in;
            end if;
        end if;
    end process;

    address_out <= reg;
end architecture;