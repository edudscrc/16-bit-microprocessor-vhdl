library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (
        clock : in std_logic;
        address_in : in unsigned(6 downto 0);
        write_enable : std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_ram of ram is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    signal content_ram : mem;
begin
    process(clock, write_enable)
    begin
        if rising_edge(clock) then
            if write_enable='1' then
                content_ram(to_integer(address_in)) <= data_in;
            end if;
        end if;
    end process;
    data_out <= content_ram(to_integer(address_in));
end architecture;