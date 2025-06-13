library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        input_A : in unsigned (15 downto 0);    -- Accumulator
        input_b : in unsigned (15 downto 0);    -- Register or constant

        op_selec : in unsigned (2 downto 0);    -- ADD, SUB, ADDI, CMPI, MOV_0, MOV_1, LD

        flag_C : out std_logic;
        flag_Z : out std_logic;
        flag_N : out std_logic;
        flag_V : out std_logic;

        result_out : out unsigned (15 downto 0)
    );
end entity;

architecture a_alu of alu is
    signal input_A_17_bits, input_b_17_bits, result_out_17_bits : unsigned(16 downto 0);
    signal aux_result_out : unsigned(15 downto 0);
    signal is_arithmetic : std_logic;
begin
    input_A_17_bits <= '0' & input_A;
    input_b_17_bits <= '0' & input_b;

    is_arithmetic <= '1' when op_selec = "000" or op_selec = "001" or op_selec = "010" or op_selec = "011" else
                     '0';

    -- ADD A, Rn = 000
    -- SUB A, Rn = 001
    -- ADDI A, I = 010
    -- CMPI A, I = 011
    -- MOV A, Rn = 100
    -- MOV Rn, A = 101
    -- LD A, I   = 110 

    aux_result_out <= input_A + input_b when op_selec = "000" else
                      input_A - input_b when op_selec = "001" else
                      input_A + input_b when op_selec = "010" else
                      input_A - input_b when op_selec = "011" else
                      input_b when op_selec = "100" else
                      input_A when op_selec = "101" else
                      input_b when op_selec = "110" else
                      "0000000000000000";
    result_out <= aux_result_out;

    result_out_17_bits <= input_A_17_bits + input_b_17_bits when op_selec = "000" else
                          input_A_17_bits - input_b_17_bits when op_selec = "001" else
                          input_A_17_bits + input_b_17_bits when op_selec = "010" else
                          input_A_17_bits - input_b_17_bits when op_selec = "011" else
                          input_b_17_bits when op_selec = "100" else
                          input_A_17_bits when op_selec = "101" else
                          input_b_17_bits when op_selec = "110" else
                          "00000000000000000";

    flag_Z <= '1' when is_arithmetic = '1' and aux_result_out = "0000000000000000" else
              '0';

    flag_N <= aux_result_out(15) when is_arithmetic = '1' else
              '0';

    flag_C <= result_out_17_bits(16) when op_selec = "000" or op_selec = "010" else
              not result_out_17_bits(16) when op_selec = "001" or op_selec = "011";
              -- else '0';

    flag_V <= '1' when is_arithmetic = '1' and
            (
                ((op_selec = "000" or op_selec = "010") and input_A(15) = input_b(15) and aux_result_out(15) /= input_A(15))
                or
                ((op_selec = "001" or op_selec = "011") and input_A(15) /= input_b(15) and aux_result_out(15) /= input_A(15))
            );
            -- else '0';

end architecture;