library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
    port (
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_wr : in unsigned(15 downto 0);
        reg_wr : in unsigned(2 downto 0);
        reg_r1 : in unsigned(2 downto 0);
        data_r1 : out unsigned(15 downto 0);
    );
end entity;

architecture a_banco_regs of banco_regs is
    component reg16bits is
        port (
            clk : in std_logic;
            rst : in_std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4 : std_logic;
    signal data_out0, data_out1, data_out2, data_out3, data_out4 : unsigned(15 downto 0);
begin
    reg0: reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en0,
        data_in => data_wr,
        data_out => data_out0
    );
    reg1: reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en1,
        data_in => data_wr,
        data_out => data_out1
    );
    reg2: reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en2,
        data_in => data_wr,
        data_out => data_out2
    );
    reg3: reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en3,
        data_in => data_wr,
        data_out => data_out3
    );
    reg4: reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en4,
        data_in => data_wr,
        data_out => data_out4
    );

    wr_en0 <= '1' when wr_en = '1' and reg_wr = "000" else
              '0';
    wr_en1 <= '1' when wr_en = '1' and reg_wr = "001" else
              '0';
    wr_en2 <= '1' when wr_en = '1' and reg_wr = "010" else
              '0';
    wr_en3 <= '1' when wr_en = '1' and reg_wr = "011" else
              '0';
    wr_en4 <= '1' when wr_en = '1' and reg_wr = "100" else
              '0';

    data_out <= data_out0 when reg_wr = "000" else
                data_out1 when reg_wr = "001" else
                data_out2 when reg_wr = "010" else
                data_out3 when reg_wr = "011" else
                data_out3 when reg_wr = "100" else
                "1111111111111111";
end architecture;