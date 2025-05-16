library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port (
            entrada_0, entrada_1 : in unsigned (15 downto 0);
            selec_op : in unsigned (1 downto 0);
            flag_C : out std_logic;
            flag_Z : out std_logic;
            flag_N : out std_logic;
            flag_V : out std_logic;
            saida : out unsigned (15 downto 0)
        );
    end component;
    signal entrada_0, entrada_1, saida : unsigned(15 downto 0);
    signal selec_op : unsigned(1 downto 0);
    signal flag_C, flag_Z, flag_N, flag_V : std_logic;
begin
    uut: ula port map(
        entrada_0 => entrada_0,
        entrada_1 => entrada_1,
        selec_op => selec_op,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        saida => saida
    );
    process
    begin
        entrada_0 <= "0000000000000101";
        entrada_1 <= "0000000000001010";
        selec_op <= "00"; -- Soma
        wait for 50 ns;

        entrada_0 <= "1111111111111111";
        entrada_1 <= "0000000000000001";
        selec_op <= "00"; -- Soma (carry)
        wait for 50 ns;

        entrada_0 <= "0100000000000000";
        entrada_1 <= "0100000000000000";
        selec_op <= "00"; -- Soma (overflow)
        wait for 50 ns;

        entrada_0 <= "0011000000111001";
        entrada_1 <= "0011000000111001";
        selec_op <= "01"; -- Subtração (zero)
        wait for 50 ns;

        entrada_0 <= "1111000011110000";
        entrada_1 <= "1010101010101010";
        selec_op <= "10"; -- AND
        wait for 50 ns;

        entrada_0 <= "1111000000000000";
        entrada_1 <= "0000111100001111";
        selec_op <= "11"; -- OR
        wait for 50 ns;

        wait;
    end process;
end architecture;