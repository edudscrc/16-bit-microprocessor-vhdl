library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator_16_bits is
    port (
        clock : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_accumulator_16_bits of accumulator_16_bits is
    signal acc_reg: unsigned(15 downto 0);
begin
    process(clock, reset, write_enable)
    begin
        if reset='1' then
            acc_reg <= "0000000000000000";
        elsif write_enable='1' then
            if rising_edge(clock) then
                acc_reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= acc_reg;
end architecture;