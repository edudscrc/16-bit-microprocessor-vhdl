library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end;

architecture a_processor_tb of processor_tb is
    component processor is
        port (
            clock : in std_logic;
            reset : in std_logic;

            state : out unsigned(1 downto 0);
            ir_data : out unsigned(15 downto 0);

            pc_address_out : out unsigned(6 downto 0);

            reg_0_data : out unsigned(15 downto 0);
            reg_1_data : out unsigned(15 downto 0);
            reg_2_data : out unsigned(15 downto 0);
            reg_3_data : out unsigned(15 downto 0);
            reg_4_data : out unsigned(15 downto 0);

            accumulator_data : out unsigned(15 downto 0);

            flag_C : out std_logic;
            flag_Z : out std_logic;
            flag_N : out std_logic;
            flag_V : out std_logic;

            alu_result : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time := 10 ns;
    signal finished : std_logic := '0';

    signal clock, reset: std_logic;

    signal state : unsigned(1 downto 0);
    signal ir_data : unsigned(15 downto 0);
    signal pc_address_out : unsigned(6 downto 0);
    signal reg_0_data : unsigned(15 downto 0);
    signal reg_1_data : unsigned(15 downto 0);
    signal reg_2_data : unsigned(15 downto 0);
    signal reg_3_data : unsigned(15 downto 0);
    signal reg_4_data : unsigned(15 downto 0);
    signal accumulator_data : unsigned(15 downto 0);
    signal flag_C : std_logic;
    signal flag_Z : std_logic;
    signal flag_N : std_logic;
    signal flag_V : std_logic;
    signal alu_result : unsigned(15 downto 0);

begin
    uut: processor port map(
        clock => clock,
        reset => reset,
        state => state,
        ir_data => ir_data,
        pc_address_out => pc_address_out,
        reg_0_data => reg_0_data,
        reg_1_data => reg_1_data,
        reg_2_data => reg_2_data,
        reg_3_data => reg_3_data,
        reg_4_data => reg_4_data,
        accumulator_data => accumulator_data,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        alu_result => alu_result
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
        wait for 50 us;
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
        wait for 400 ns;
        wait;
    end process;

end architecture;