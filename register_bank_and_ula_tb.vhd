library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank_and_ula_tb is
end;

architecture a_register_bank_and_ula_tb of register_bank_and_ula_tb is
    component register_bank_and_ula
        port (
            clock : in std_logic;
            reset : in std_logic;
            
            write_enable_bank : in std_logic;
            write_enable_acc : in std_logic;

            alu_op_selec : in unsigned (2 downto 0);
            mux_const : in std_logic;

            reg_read : in unsigned(2 downto 0);
            reg_write : in unsigned(2 downto 0);

            const : in unsigned(15 downto 0);

            flag_C : out std_logic;
            flag_Z : out std_logic;
            flag_N : out std_logic;
            flag_V : out std_logic;

            acc_data_out : out unsigned(15 downto 0);
            bank_data_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal clock, reset, write_enable_bank, write_enable_acc, mux_const : std_logic;
    signal flag_C, flag_Z, flag_N, flag_V : std_logic;
    signal reg_write, reg_read, alu_op_selec : unsigned(2 downto 0);
    signal const, acc_data_out, bank_data_out : unsigned(15 downto 0);
begin
    uut: register_bank_and_ula port map(
        clock => clock,
        reset => reset,
        write_enable_bank => write_enable_bank,
        write_enable_acc => write_enable_acc,
        alu_op_selec => alu_op_selec,
        mux_const => mux_const,
        reg_read => reg_read,
        reg_write => reg_write,
        const => const,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        acc_data_out => acc_data_out,
        bank_data_out => bank_data_out
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
        write_enable_bank <= '0';
        write_enable_acc <= '0';
        alu_op_selec <= "000";
        mux_const <= '0';
        reg_read <= "000";
        reg_write <= "000";
        const <= "0000000000000000";

        -- ADD  = 000
        -- SUB  = 001
        -- ADDI = 010
        -- CMPI = 011
        -- DEC  = 100
        -- MOV Rn, A = 101
        -- MOV A, Rn = 110

        -- ADDI A, 5 (Soma 5 com o Acumulador e escreve o resultado nele)
        wait for 100 ns;
        write_enable_bank <= '0';
        write_enable_acc <= '1';
        alu_op_selec <= "010";
        mux_const <= '1';
        reg_read <= "000";      -- Não importa, pois um operando será o Acumulador e o outro será a Constante
        reg_write <= "000";     -- Não importa, pois um operando será o Acumulador e o outro será a Constante
        const <= "0000000000000101";

        -- A = 5

        -- MOV R3, A (Mover o valor do Acumulador para R3)
        wait for 100 ns;
        write_enable_bank <= '1';
        write_enable_acc <= '0';
        alu_op_selec <= "101";
        mux_const <= '0';
        reg_read <= "000";              -- Não usado aqui
        reg_write <= "011";
        const <= "0000000000000000";    -- Não usado aqui

        -- A = 5
        -- R3 = 5

        -- ADD A, R3 (Soma o valor de R3 com o Acumulador e escreve o resultado nele)
        wait for 100 ns;
        write_enable_bank <= '0';
        write_enable_acc <= '1';
        alu_op_selec <= "000";
        mux_const <= '0';
        reg_read <= "011";
        reg_write <= "000";             -- Não usado aqui
        const <= "0000000000000000";    -- Não usado aqui

        -- A = 10
        -- R3 = 5

        -- MOV A, R3 (Mover o valor de R3 para o Acumulador)
        wait for 100 ns;
        write_enable_bank <= '0';
        write_enable_acc <= '1';
        alu_op_selec <= "110";
        mux_const <= '0';
        reg_read <= "011";
        reg_write <= "000";             -- Não usado aqui
        const <= "0000000000000000";    -- Não usado aqui

        -- A = 5
        -- R3 = 5

        -- CMPI A, 10 (Comparar o valor do Acumulador com a constante 10)
        wait for 100 ns;
        write_enable_bank <= '0';
        write_enable_acc <= '0';
        alu_op_selec <= "011";
        mux_const <= '1';
        reg_read <= "000";              -- Não usado aqui
        reg_write <= "000";             -- Não usado aqui
        const <= "0000000000001010";

        -- CMPI A, 5 (Comparar o valor do Acumulador com a constante 10)
        wait for 100 ns;
        write_enable_bank <= '0';
        write_enable_acc <= '0';
        alu_op_selec <= "011";
        mux_const <= '1';
        reg_read <= "000";              -- Não usado aqui
        reg_write <= "000";             -- Não usado aqui
        const <= "0000000000000101";

        -- DEC A (Decrementar o Acumulador)
        wait for 100 ns;
        write_enable_bank <= '0';
        write_enable_acc <= '1';
        alu_op_selec <= "100";
        mux_const <= '0';               -- Não usado aqui
        reg_read <= "000";              -- Não usado aqui
        reg_write <= "000";             -- Não usado aqui
        const <= "0000000000000000";    -- Não usado aqui

        -- A = 4
        -- R3 = 5

        wait;
    end process;
end architecture;