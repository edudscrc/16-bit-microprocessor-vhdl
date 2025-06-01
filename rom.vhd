library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clock : in std_logic;
        address : in unsigned(6 downto 0);
        data : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant rom_content : mem := (
        0 => "0000000000000001",
        1 => "0000001100100100",
        2 => "1110001000110001",
        3 => "1110000000011000",
        4 => "0000000011000010",
        5 => "1100000000000100",
        others => (others => '0')
    );
begin
    process(clock)
    begin
        if (rising_edge(clock)) then
            data <= rom_content(to_integer(address));
        end if;
    end process;
end architecture;