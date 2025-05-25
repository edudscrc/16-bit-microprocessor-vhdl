library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank_and_ula is
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
end entity;

architecture a_register_bank_and_ula of register_bank_and_ula is
    component register_bank is
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

    component alu is
        port (
            input_A : in unsigned (15 downto 0);
            input_b : in unsigned (15 downto 0);

            op_selec : in unsigned (2 downto 0);

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

    signal accumulator_data : unsigned(15 downto 0);    -- Accumulator output
    signal alu_input_b : unsigned(15 downto 0);         -- Constant or Register
    signal data_bank : unsigned(15 downto 0);           -- Register Bank output
    signal data_bank_write : unsigned(15 downto 0);     -- Data to be written in the Register Bank
    signal alu_result : unsigned(15 downto 0);

begin
    register_bank_instance: register_bank port map (
        clock => clock,
        reset => reset,
        write_enable => write_enable_bank,
        reg_write => reg_write,
        reg_read => reg_read,
        data_write => data_bank_write,
        data_out => data_bank
    );

    alu_instance: alu port map (
        input_A => accumulator_data,
        input_b => alu_input_b,
        op_selec => alu_op_selec,
        flag_C => flag_C,
        flag_Z => flag_Z,
        flag_N => flag_N,
        flag_V => flag_V,
        result_out => alu_result
    );

    accumulator_instance: accumulator_16_bits port map (
        clock => clock,
        reset => reset,
        write_enable => write_enable_acc,
        data_in => alu_result,
        data_out => accumulator_data
    );

    alu_input_b <= const when mux_const = '1' else
                   data_bank;

    data_bank_write <=  alu_result;

    acc_data_out <= accumulator_data;
    bank_data_out <= data_bank;

end architecture;