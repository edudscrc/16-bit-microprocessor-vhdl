library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank_and_ula is
    port (
        clock : in std_logic;
        reset : in std_logic;
        
        reg_bank_write_enable : in std_logic;
        accumulator_write_enable : in std_logic;

        alu_op_selec : in unsigned (3 downto 0);
        mux_immediate : in std_logic;

        reg_bank_reg_read_in : in unsigned(2 downto 0);
        reg_bank_reg_write_in : in unsigned(2 downto 0);

        immediate : in unsigned(15 downto 0);

        flag_C : out std_logic;
        flag_Z : out std_logic;
        flag_N : out std_logic;
        flag_V : out std_logic;

        accumulator_data_out : out unsigned(15 downto 0);

        reg_0_data : out unsigned(15 downto 0);
        reg_1_data : out unsigned(15 downto 0);
        reg_2_data : out unsigned(15 downto 0);
        reg_3_data : out unsigned(15 downto 0);
        reg_4_data : out unsigned(15 downto 0);

        alu_result_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_register_bank_and_ula of register_bank_and_ula is
    component register_bank is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;

            reg_write_in : in unsigned(2 downto 0);
            reg_read_in : in unsigned(2 downto 0);

            data_write_in : in unsigned(15 downto 0);

            reg_0_data : out unsigned(15 downto 0);
            reg_1_data : out unsigned(15 downto 0);
            reg_2_data : out unsigned(15 downto 0);
            reg_3_data : out unsigned(15 downto 0);
            reg_4_data : out unsigned(15 downto 0);

            data_out : out unsigned(15 downto 0)
        );
    end component;

    component alu is
        port (
            input_A : in unsigned (15 downto 0);
            input_b : in unsigned (15 downto 0);

            op_selec : in unsigned (3 downto 0);

            flag_C : out std_logic;
            flag_Z : out std_logic;
            flag_N : out std_logic;
            flag_V : out std_logic;

            result_out : out unsigned (15 downto 0)
        );
    end component;

    component accumulator_16_bits is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal s_accumulator_data_in : unsigned(15 downto 0);

    signal s_alu_result_out : unsigned(15 downto 0);

    signal s_accumulator_data_out : unsigned(15 downto 0);
    signal s_alu_input_b : unsigned(15 downto 0);
    signal s_reg_bank_data_out : unsigned(15 downto 0);
    signal s_reg_bank_data_write_in : unsigned(15 downto 0);

    signal s_reg_0_data, s_reg_1_data, s_reg_2_data, s_reg_3_data, s_reg_4_data : unsigned(15 downto 0);

begin
    register_bank_instance: register_bank port map (
        clock => clock,
        reset => reset,
        write_enable => reg_bank_write_enable,
        reg_write_in => reg_bank_reg_write_in,
        reg_read_in => reg_bank_reg_read_in,
        data_write_in => s_reg_bank_data_write_in,
        reg_0_data => s_reg_0_data,
        reg_1_data => s_reg_1_data,
        reg_2_data => s_reg_2_data,
        reg_3_data => s_reg_3_data,
        reg_4_data => s_reg_4_data,
        data_out => s_reg_bank_data_out
    );

    alu_instance: alu port map (
        input_A => s_accumulator_data_out,
        input_b => s_alu_input_b,
        op_selec => alu_op_selec,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        result_out => s_alu_result_out
    );

    accumulator_instance: accumulator_16_bits port map (
        clock => clock,
        reset => reset,
        write_enable => accumulator_write_enable,
        data_in => s_accumulator_data_in,
        data_out => s_accumulator_data_out
    );

    s_alu_input_b <= immediate when mux_immediate = '1' else
                     s_reg_bank_data_out;

    s_reg_bank_data_write_in <= s_alu_result_out;

    alu_result_out <= s_alu_result_out;

    accumulator_data_out <= s_accumulator_data_out;

    s_accumulator_data_in <= immediate when alu_op_selec = "0111" else
                             s_alu_result_out;

    reg_0_data <= s_reg_0_data;
    reg_1_data <= s_reg_1_data;
    reg_2_data <= s_reg_2_data;
    reg_3_data <= s_reg_3_data;
    reg_4_data <= s_reg_4_data;

end architecture;