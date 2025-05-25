library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank_tb is
end;

architecture a_register_bank_tb of register_bank_tb is
    component register_bank
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;

            reg_write : in unsigned(2 downto 0);
            reg_read : in unsigned(2 downto 0);

            data_write : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal clock, reset, write_enable : std_logic;
    signal reg_write, reg_read : unsigned(2 downto 0);
    signal data_write, data_out : unsigned(15 downto 0);
begin
    uut: register_bank port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        reg_write => reg_write,
        reg_read => reg_read,
        data_write => data_write,
        data_out => data_out
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clock <= '0';
            wait for period_time / 2;
            clock <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 300 ns;
        write_enable <= '0';
        reg_write <= "010";
        reg_read <= "001";
        data_write <= "1111100000000000";
        
        -- Nos testes de escrever em um registrador:
        -- Deve escrever o valor de data_write em reg_write e data_out deve ser o valor armazenado em reg_read

        -- Escrever no registrador R0
        wait for 100 ns;
        write_enable <= '1';
        reg_write <= "000";
        reg_read <= "000";
        data_write <= "0001000000001010";
        
        -- Escrever no registrador R1
        wait for 100 ns;
        write_enable <= '1';
        reg_write <= "001";
        reg_read <= "000";
        data_write <= "0001011000001010";

        -- Escrever no registrador R2
        wait for 100 ns;
        write_enable <= '1';
        reg_write <= "010";
        reg_read <= "001";
        data_write <= "0001000011001011";

        -- Escrever no registrador R3
        wait for 100 ns;
        write_enable <= '1';
        reg_write <= "011";
        reg_read <= "010";
        data_write <= "0001000000001100";

        -- Escrever no registrador R4
        wait for 100 ns;
        write_enable <= '1';
        reg_write <= "100";
        reg_read <= "011";
        data_write <= "1001000110000011";

        -- Ler o valor escrito no registrador R4
        -- Escrever no registrador R0 com write_enable='0' (Não deve escrever)
        wait for 100 ns;
        write_enable <= '0';
        reg_write <= "000";
        reg_read <= "100";
        data_write <= "1111111111111111";

        wait; 
    end process;
end architecture;