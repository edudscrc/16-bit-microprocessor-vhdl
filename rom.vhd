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

    -- opcodes
    -- NOP  -> "0000"
    -- LD   -> "0001"
    -- MOV  -> "0010"
    -- DEC  -> "0011"
    -- CMPI -> "0100"
    -- ADD  -> "0101"
    -- SUB  -> "0110"
    -- JMP  -> "1111"

    constant rom_content : mem := (
        0  => "0001000000000101",  -- LD A,5      (carrega 5 no acumulador)
        1  => "0010000000000001",  -- MOV R1,A    (move acumulador para R1)
        2  => "0011000000000001",  -- DEC R1      (decrementa R1)
        3  => "0100000000000110",  -- CMPI A,0    (compara acumulador com 0)
        4  => "0001000000001010",  -- LD A,10     (carrega nova constante)
        5  => "0101000000000001",  -- ADD A,R1    (soma R1 ao acumulador)
        6  => "1111000000000111",  -- JMP 7       (salto incondicional)
        7  => "0000000000000000",  -- NOP
        8  => "1111000000001000",  -- JMP 8       (loop infinito)
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