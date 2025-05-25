library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank is
    port (
        clock : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;

        reg_write : in unsigned(2 downto 0);
        reg_read : in unsigned(2 downto 0);

        data_write : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_register_bank of register_bank is
    component register_16_bits is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    signal write_enable_reg_0, write_enable_reg_1, write_enable_reg_2, write_enable_reg_3, write_enable_reg_4 : std_logic;
    signal data_out_reg_0, data_out_reg_1, data_out_reg_2, data_out_reg_3, data_out_reg_4 : unsigned(15 downto 0);
begin
    reg_0: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable_reg_0,
        data_in => data_write,
        data_out => data_out_reg_0
    );
    reg_1: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable_reg_1,
        data_in => data_write,
        data_out => data_out_reg_1
    );
    reg_2: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable_reg_2,
        data_in => data_write,
        data_out => data_out_reg_2
    );
    reg_3: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable_reg_3,
        data_in => data_write,
        data_out => data_out_reg_3
    );
    reg_4: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable_reg_4,
        data_in => data_write,
        data_out => data_out_reg_4
    );

    write_enable_reg_0 <= '1' when write_enable = '1' and reg_write = "000" else
                          '0';
    write_enable_reg_1 <= '1' when write_enable = '1' and reg_write = "001" else
                          '0';
    write_enable_reg_2 <= '1' when write_enable = '1' and reg_write = "010" else
                          '0';
    write_enable_reg_3 <= '1' when write_enable = '1' and reg_write = "011" else
                          '0';
    write_enable_reg_4 <= '1' when write_enable = '1' and reg_write = "100" else
                          '0';

    data_out <= data_out_reg_0 when reg_read = "000" else
                data_out_reg_1 when reg_read = "001" else
                data_out_reg_2 when reg_read = "010" else
                data_out_reg_3 when reg_read = "011" else
                data_out_reg_4 when reg_read = "100" else
                "0000000000000000";
end architecture;