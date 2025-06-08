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

            reg_bank_write_enable : in std_logic;
            accumulator_write_enable : in std_logic;

            alu_op_selec : in unsigned (2 downto 0);
            mux_immediate : in std_logic;

            reg_bank_reg_read_in : in unsigned(2 downto 0);
            reg_bank_reg_write_in : in unsigned(2 downto 0);

            immediate : in unsigned(15 downto 0);

            flag_C : out std_logic;
            flag_Z : out std_logic;
            flag_N : out std_logic;
            flag_V : out std_logic;

            alu_result_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal clock, reset, reg_bank_write_enable, accumulator_write_enable, mux_immediate : std_logic;
    signal flag_C, flag_Z, flag_N, flag_V : std_logic;
    signal reg_bank_reg_read_in, reg_bank_reg_write_in, alu_op_selec : unsigned(2 downto 0);
    signal immediate, alu_result_out : unsigned(15 downto 0);
begin
    uut: register_bank_and_ula port map(
        clock => clock,
        reset => reset,
        reg_bank_write_enable => reg_bank_write_enable,
        accumulator_write_enable => accumulator_write_enable,
        alu_op_selec => alu_op_selec,
        mux_immediate => mux_immediate,
        reg_bank_reg_read_in => reg_bank_reg_read_in,
        reg_bank_reg_write_in => reg_bank_reg_write_in,
        immediate => immediate,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        alu_result_out => alu_result_out
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
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '0';
        alu_op_selec <= "000";
        mux_immediate <= '0';
        reg_bank_reg_read_in <= "000";
        reg_bank_reg_write_in <= "000";
        immediate <= "0000000000000000";

        -- ADDI A, 5
        wait for 100 ns;
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '1';
        alu_op_selec <= "010";
        mux_immediate <= '1';
        reg_bank_reg_read_in <= "000";  -- Não importa
        reg_bank_reg_write_in <= "000"; -- Não importa
        immediate <= "0000000000000101";

        -- A = 5

        -- MOV R3, A
        wait for 100 ns;
        reg_bank_write_enable <= '1';
        accumulator_write_enable <= '0';
        alu_op_selec <= "101";
        mux_immediate <= '0';
        reg_bank_reg_read_in <= "000";      -- Não importa
        reg_bank_reg_write_in <= "011";
        immediate <= "0000000000000000";    -- Não importa

        -- A = 5
        -- R3 = 5

        -- ADD A, R3
        wait for 100 ns;
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '1';
        alu_op_selec <= "000";
        mux_immediate <= '0';
        reg_bank_reg_read_in <= "011";
        reg_bank_reg_write_in <= "000";     -- Não importa
        immediate <= "0000000000000000";    -- Não importa

        -- A = 10
        -- R3 = 5

        -- MOV A, R3
        wait for 100 ns;
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '1';
        alu_op_selec <= "100";
        mux_immediate <= '0';
        reg_bank_reg_read_in <= "011";
        reg_bank_reg_write_in <= "000";     -- Não importa
        immediate <= "0000000000000000";    -- Não importa

        -- A = 5
        -- R3 = 5

        -- CMPI A, 10
        wait for 100 ns;
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '0';
        alu_op_selec <= "011";
        mux_immediate <= '1';
        reg_bank_reg_read_in <= "000";  -- Não importa
        reg_bank_reg_write_in <= "000"; -- Não importa
        immediate <= "0000000000001010";

        -- CMPI A, 5
        wait for 100 ns;
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '0';
        alu_op_selec <= "011";
        mux_immediate <= '1';
        reg_bank_reg_read_in <= "000";  -- Não importa
        reg_bank_reg_write_in <= "000"; -- Não importa
        immediate <= "0000000000000101";

        -- SUB A, 2
        wait for 100 ns;
        reg_bank_write_enable <= '0';
        accumulator_write_enable <= '1';
        alu_op_selec <= "001";
        mux_immediate <= '1';
        reg_bank_reg_read_in <= "000";  -- Não importa
        reg_bank_reg_write_in <= "000"; -- Não importa
        immediate <= "0000000000000010";

        -- A = 3
        -- R3 = 5

        wait;
    end process;
end architecture;