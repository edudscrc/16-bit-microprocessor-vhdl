library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end;

architecture a_alu_tb of alu_tb is
    component alu
        port (
            input_A : in unsigned (15 downto 0);    -- Accumulator
            input_b : in unsigned (15 downto 0);    -- Register or constant

            op_selec : in unsigned (2 downto 0);    -- ADD, SUB, ADDI, CMPI, DEC

            flag_C : out std_logic;
            flag_Z : out std_logic;
            flag_N : out std_logic;
            flag_V : out std_logic;

            result_out : out unsigned (15 downto 0)
        );
    end component;
    signal input_A, input_b, result_out : unsigned(15 downto 0);
    signal op_selec : unsigned(2 downto 0);
    signal flag_C, flag_Z, flag_N, flag_V : std_logic;
begin
    uut: alu port map(
        input_A => input_A,
        input_b => input_b,
        op_selec => op_selec,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        result_out => result_out
    );
    process
    begin
        input_A <= "0000000000000101";
        input_b <= "0000000000001010";
        op_selec <= "000"; -- ADD
        wait for 50 ns;

        input_A <= "1111111111111111";
        input_b <= "0000000000000001";
        op_selec <= "000"; -- ADD (carry)
        wait for 50 ns;

        input_A <= "0100000000000000";
        input_b <= "0100000000000000";
        op_selec <= "000"; -- ADD (overflow)
        wait for 50 ns;

        input_A <= "0000000000001100";
        input_B <= "0000000000000101";
        op_selec <= "001"; -- SUB (A > B)
        wait for 50 ns;

        input_A <= "0000000000000101";
        input_B <= "0000000000001100";
        op_selec <= "001"; -- SUB (A < B)
        wait for 50 ns;

        input_A <= "0011000000111001";
        input_b <= "0011000000111001";
        op_selec <= "001"; -- Subtração (zero)
        wait for 50 ns;

        input_A <= "0000000000010000";
        input_B <= "0000000000100011";
        op_selec <= "010"; -- ADDI
        wait for 50 ns;

        input_A <= "0000000001100100";
        input_B <= "0000000000110010";
        op_selec <= "011"; -- CMPI (A > B)
        wait for 50 ns;

        input_A <= "0000000000110010";
        input_B <= "0000000001100100";
        op_selec <= "011"; -- CMPI (A < B)
        wait for 50 ns;

        input_A <= "0000000001100100";
        input_B <= "0000000001100100";
        op_selec <= "011"; -- CMPI (A = B)
        wait for 50 ns;

        input_A <= "0000000000001010";
        input_B <= "0000000000000001";
        op_selec <= "100"; -- DEC
        wait for 50 ns;

        input_A <= "0000000000001010";
        input_B <= "0000000000000001";
        op_selec <= "101"; -- MOV Rn, A
        wait for 50 ns;

        input_A <= "0000001100001010";
        input_B <= "0110000000000001";
        op_selec <= "110"; -- MOV A, Rn
        wait for 50 ns;

        wait;
    end process;
end architecture;