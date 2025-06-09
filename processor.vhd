library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
    port (

    );
end entity;

architecture a_processor of processor is
    component register_bank_and_ula is
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

    component control_unit is
        port (
            clock : in std_logic;
            reset : in std_logic;

            rom_data_out : out unsigned(15 downto 0)
        );
    end component;

    signal blabla : std_logic;

begin
    register_bank_and_ula_instance: register_bank_and_ula port map (
        clock => ,
        reset => ,
        reg_bank_write_enable => ,
        accumulator_write_enable => ,
        alu_op_selec => ,
        mux_immediate => ,
        reg_bank_reg_read_in => ,
        reg_bank_reg_write_in => ,
        immediate => ,
        flag_C => ,
        flag_Z => ,
        flag_N => ,
        flag_V => ,
        alu_result_out => 
    );

    control_unit_instance: control_unit port map (
        clock => ,
        reset => ,
        rom_data_out => 
    );

end architecture;