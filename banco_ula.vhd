library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_ula is
    port (
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_wr : in unsigned(15 downto 0);
        reg_wr : in unsigned(2 downto 0);
        reg_r1 : in unsigned(2 downto 0);
        data_r1 : out unsigned(15 downto 0);
        
        selec_op : in unsigned (1 downto 0);
        flag_C : out std_logic;
        flag_Z : out std_logic;
        flag_N : out std_logic;
        flag_V : out std_logic;
        saida_ula : out unsigned (15 downto 0)
    );
end entity;

architecture a_banco_ula of banco_ula is
    component banco_regs is
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_wr : in unsigned(15 downto 0);
            reg_wr : in unsigned(2 downto 0);
            reg_r1 : in unsigned(2 downto 0);
            data_r1 : out unsigned(15 downto 0);
        );
    end component;

    component ula is
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

    signal entrada_0, entrada_1 : unsigned(15 downto 0);
    signal data_r1, data_wr : unsigned(15 downto 0);
    signal saida : unsigned(15 downto 0);

begin

    banco_r: banco_regs port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => saida,
        reg_wr => reg_wr,
        reg_r1 => reg_r1,
        data_r1 => data_r1
    );

    ula_banco: ula port map (
        entrada_0 => entrada_0,
        entrada_1 => entrada_1,
        selec_op => selec_op,
        saida => saida,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V
    );

    saida_ula <= saida;

    entrada_0 <= data_r1

    entrada_1 <= acumulador??;

end architecture;