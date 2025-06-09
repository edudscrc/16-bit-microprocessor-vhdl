library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_register is
    port (
        clock : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_instruction_register of instruction_register is
    signal reg: unsigned(15 downto 0);
begin
    process(clock, reset, write_enable)
    begin
        if reset='1' then
            reg <= "0000000000000000";
        elsif write_enable='1' then
            if rising_edge(clock) then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
end architecture;