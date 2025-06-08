library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clock : in std_logic;
        address_in : in unsigned(6 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);

    -- NOP         -> "0000"
    -- LD A, I     -> "0001"
    -- MOV A, Rn   -> "0010"
    -- MOV Rn, A   -> "0011"
    -- CMPI A, I   -> "0100"
    -- ADD A, Rn   -> "0101"
    -- SUB A, Rn   -> "0110"
    -- ADDI A, I   -> "0111"
    -- JMP address -> "1000"

    -- Programa: Calcular (10 + 20) - 5 e armazenar em R4
    constant rom_content : mem := (
    -- LD A, 10
    -- Formato: [0001] [0000 0000 1010]
    0 => "0001000000001010",
    
    -- MOV R1, A
    -- Formato: [0011] [001] [000000000]
    1 => "0011001000000000",
    
    -- LD A, 20
    -- Formato: [0001] [0000 0001 0100]
    2 => "0001000000010100",
    
    -- MOV R2, A
    -- Formato: [0011] [010] [000000000]
    3 => "0011010000000000",
    
    -- LD A, 5
    -- Formato: [0001] [0000 0000 0101]
    4 => "0001000000000101",
    
    -- MOV R3, A
    -- Formato: [0011] [011] [000000000]
    5 => "0011011000000000",
    
    -- MOV A, R1
    -- Formato: [0010] [001] [000000000]
    6 => "0010001000000000",
    
    -- ADD A, R2
    -- Formato: [0101] [010] [000000000]
    7 => "0101010000000000",

    -- SUB A, R3
    -- Formato: [0110] [011] [000000000]
    8 => "0110011000000000",
    
    -- MOV R4, A
    -- Formato: [0011] [100] [000000000]
    9 => "0011100000000000",

    -- CMPI A, 25
    -- Formato: [0100] [0000 0001 1001]
    10 => "0100000000011001",
    
    -- ADDI A, -1
    -- Formato: [0111] [1111 1111 1111]
    11 => "0111111111111111",

    -- NOP
    -- Formato: [0000] [000000000000]
    12 => "0000000000000000",

    -- JMP 13
    -- Formato: [1000] [00000] [0001101]
    13 => "1000000000001101",
        others => (others => '0')
    );
begin
    process(clock)
    begin
        if (rising_edge(clock)) then
            data_out <= rom_content(to_integer(address_in));
        end if;
    end process;
end architecture;