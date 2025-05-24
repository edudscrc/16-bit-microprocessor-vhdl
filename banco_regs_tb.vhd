library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_tb is
end entity;

architecture a_banco_regs_tb of banco_regs_tb is
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

    signal clk, rst, wr_en : std_logic;
    signal reg_wr, reg_r1 : unsigned(2 downto 0);
    signal data_wr, data_r1 : unsigned(15 downto 0);

begin
    uut: banco_regs port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        reg_r1 => reg_r1,
        data_r1 => data_r1
    );

    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    process
    begin
        wait for 100 ns;
        wr_en <= '0';
    end process;

end architecture;