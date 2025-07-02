library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
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
end entity;

architecture a_processor of processor is
    component register_bank_and_ula is
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
    end component;

    component control_unit is
        port (
            clock : in std_logic;
            reset : in std_logic;

            state_out : out unsigned(1 downto 0);
            pc_address_in : in unsigned(6 downto 0);
            pc_address_out : out unsigned(6 downto 0);

            rom_data_out : out unsigned(15 downto 0)
        );
    end component;

    component instruction_register is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component ram is
        port (
            clock : in std_logic;
            address_in : in unsigned(6 downto 0);
            write_enable : std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component register_16_bits is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal s_ram_address_in : unsigned(6 downto 0);
    signal s_ram_data_out : unsigned(15 downto 0);
    signal s_ram_write_enable : std_logic;
    signal s_mux_ram_or_immediate : unsigned(15 downto 0);

    signal s_rom_data_out : unsigned(15 downto 0);
    signal s_ir_data_out : unsigned(15 downto 0);
    signal s_state : unsigned(1 downto 0);

    signal s_ir_write_enable : std_logic;
    signal s_reg_bank_write_enable : std_logic;
    signal s_accumulator_write_enable : std_logic;
    signal s_mux_immediate : std_logic;

    signal s_opcode : unsigned(3 downto 0);
    signal s_register_from_instruction : unsigned(2 downto 0);
    signal s_immediate : unsigned(15 downto 0);
    signal s_alu_op_selec : unsigned(3 downto 0);

    signal s_reg_bank_reg_read_in : unsigned(2 downto 0);
    signal s_reg_bank_reg_write_in : unsigned(2 downto 0);


    signal s_alu_result_out : unsigned(15 downto 0);
    signal s_flag_C, s_flag_Z, s_flag_N, s_flag_V : std_logic;
    signal s_flag_C_aux, s_flag_Z_aux, s_flag_N_aux, s_flag_V_aux : unsigned(15 downto 0);
    signal s_C, s_Z, s_N, s_V : unsigned(15 downto 0);

    signal s_accumulator_data_out : unsigned(15 downto 0);
    signal s_pc_address_out : unsigned(6 downto 0);
    signal s_reg_0_data, s_reg_1_data, s_reg_2_data, s_reg_3_data, s_reg_4_data : unsigned(15 downto 0);

    signal s_pc_address_in : unsigned(6 downto 0);

    signal s_jump_enable : std_logic;
    signal s_jump_address : unsigned(6 downto 0);

    signal s_branch_enable : std_logic;
    signal s_branch_offset_address : unsigned(6 downto 0);

    signal s_write_enable_flags : std_logic;
begin
    register_bank_and_ula_instance: register_bank_and_ula port map (
        clock => clock,
        reset => reset,
        reg_bank_write_enable => s_reg_bank_write_enable,
        accumulator_write_enable => s_accumulator_write_enable,
        alu_op_selec => s_alu_op_selec,
        mux_immediate => s_mux_immediate,
        reg_bank_reg_read_in => s_reg_bank_reg_read_in,
        reg_bank_reg_write_in => s_reg_bank_reg_write_in,
        immediate => s_mux_ram_or_immediate,
        flag_C => s_flag_C,
        flag_Z => s_flag_Z,
        flag_N => s_flag_N,
        flag_V => s_flag_V,
        accumulator_data_out => s_accumulator_data_out,
        reg_0_data => s_reg_0_data,
        reg_1_data => s_reg_1_data,
        reg_2_data => s_reg_2_data,
        reg_3_data => s_reg_3_data,
        reg_4_data => s_reg_4_data,
        alu_result_out => s_alu_result_out
    );

    control_unit_instance: control_unit port map (
        clock => clock,
        reset => reset,
        state_out => s_state,
        pc_address_in => s_pc_address_in,
        pc_address_out => s_pc_address_out,
        rom_data_out => s_rom_data_out
    );

    instruction_register_instance: instruction_register port map (
        clock => clock,
        reset => reset,
        write_enable => s_ir_write_enable,
        data_in => s_rom_data_out,
        data_out => s_ir_data_out
    );

    ram_instance: ram port map (
        clock => clock,
        address_in => s_ram_address_in,
        write_enable => s_ram_write_enable,
        data_in => s_accumulator_data_out,
        data_out => s_ram_data_out
    );

    reg_Z: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => s_write_enable_flags,
        data_in => s_flag_Z_aux,
        data_out => s_Z
    );

    reg_V: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => s_write_enable_flags,
        data_in => s_flag_V_aux,
        data_out => s_V
    );

    reg_C: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => s_write_enable_flags,
        data_in => s_flag_C_aux,
        data_out => s_C
    );

    reg_N: register_16_bits port map(
        clock => clock,
        reset => reset,
        write_enable => s_write_enable_flags,
        data_in => s_flag_N_aux,
        data_out => s_N
    );

    s_opcode <= s_ir_data_out(15 downto 12);
    s_register_from_instruction <= s_ir_data_out(11 downto 9);
    s_immediate <= "1111" & s_ir_data_out(11 downto 0) when s_ir_data_out(11) = '1' else
                   "0000" & s_ir_data_out(11 downto 0);

    -- RAM.data_out quando LW
    s_mux_ram_or_immediate <= s_ram_data_out when s_opcode = "1011" else
                              s_immediate;
    
    s_ram_address_in <= s_reg_0_data(6 downto 0) when s_register_from_instruction = "000" else
                        s_reg_1_data(6 downto 0) when s_register_from_instruction = "001" else
                        s_reg_2_data(6 downto 0) when s_register_from_instruction = "010" else
                        s_reg_3_data(6 downto 0) when s_register_from_instruction = "011" else
                        s_reg_4_data(6 downto 0) when s_register_from_instruction = "100" else
                        "0000000";

    s_write_enable_flags <= '1' when (s_opcode = "0100" or s_opcode = "0101" or s_opcode = "0110" or s_opcode = "0111" )and s_state = "10" else
                            '0';

    s_ram_write_enable <= '1' when s_opcode = "1100" and s_state = "10" else
                          '0';

    s_flag_N_aux <= "000000000000000" & s_flag_N when s_state = "10" else
                 "0000000000000000";

    s_flag_Z_aux <= "000000000000000" & s_flag_Z when s_state = "10" else
                 "0000000000000000";

    s_flag_V_aux <= "000000000000000" & s_flag_V when s_state = "10" else
                 "0000000000000000";

    s_flag_C_aux <= "000000000000000" & s_flag_C when s_state = "10" else
                 "0000000000000000";
 
    s_branch_enable <= '1' when s_opcode = "1001" and s_C = "0000000000000001" and s_Z = "0000000000000000" and s_state = "10" else
                       '1' when s_opcode = "1010" and s_N /= s_V and s_state = "10" else
                       '0';
    s_branch_offset_address <= s_ir_data_out(6 downto 0);

    s_jump_enable <= '1' when s_opcode = "1000" and s_state = "10" else
                     '0';

    s_jump_address <= s_ir_data_out(6 downto 0);

    s_pc_address_in <= s_jump_address when s_jump_enable = '1' else
                       s_pc_address_out + s_branch_offset_address when s_branch_enable = '1' else
                       s_pc_address_out + 1 when s_state = "10";

    s_alu_op_selec <= "0000" when s_opcode = "0101" else -- ADD A, Rn
                "0001" when s_opcode = "0110" else -- SUB A, Rn
                "0010" when s_opcode = "0111" else -- ADDI A, I
                "0011" when s_opcode = "0100" else -- CMPI A, I
                "0100" when s_opcode = "0010" else -- MOV A, Rn
                "0101" when s_opcode = "0011" else -- MOV Rn, A
                "0110" when s_opcode = "0001" else -- LD A, I
                "0111" when s_opcode = "1011" else -- LW A, [Rn] (Reutilizando LD)
                "1000" when s_opcode = "1101" else -- DEC A
                "1001";
    
    s_ir_write_enable <= '1' when s_state = "00" else
                         '0';

    s_accumulator_write_enable <= '1' when s_opcode = "0101" and s_state = "10" else -- ADD A, Rn
                                  '1' when s_opcode = "0110" and s_state = "10" else -- SUB A, Rn
                                  '1' when s_opcode = "0111" and s_state = "10" else -- ADDI A, I
                                  '0' when s_opcode = "0100" and s_state = "10" else -- CMPI A, I
                                  '1' when s_opcode = "0010" and s_state = "10" else -- MOV A, Rn
                                  '0' when s_opcode = "0011" and s_state = "10" else -- MOV Rn, A
                                  '1' when s_opcode = "0001" and s_state = "10" else -- LD A, I
                                  '1' when s_opcode = "1011" and s_state = "10" else -- LW A, [Rn]
                                  '0' when s_opcode = "1100" and s_state = "10" else -- SW [Rn], A
                                  '1' when s_opcode = "1101" and s_state = "10" else -- DEC A
                                  '0';

    s_mux_immediate <= '0' when s_opcode = "0101" and s_state = "10" else -- ADD A, Rn
                       '0' when s_opcode = "0110" and s_state = "10" else -- SUB A, Rn
                       '1' when s_opcode = "0111" and s_state = "10" else -- ADDI A, I
                       '1' when s_opcode = "0100" and s_state = "10" else -- CMPI A, I
                       '0' when s_opcode = "0010" and s_state = "10" else -- MOV A, Rn
                       '0' when s_opcode = "0011" and s_state = "10" else -- MOV Rn, A
                       '1' when s_opcode = "0001" and s_state = "10" else -- LD A, I
                       '0' when s_opcode = "1101" and s_state = "10" else -- DEC A
                       '0';

    s_reg_bank_write_enable <= '0' when s_opcode = "0101" and s_state = "10" else -- ADD A, Rn
                               '0' when s_opcode = "0110" and s_state = "10" else -- SUB A, Rn
                               '0' when s_opcode = "0111" and s_state = "10" else -- ADDI A, I
                               '0' when s_opcode = "0100" and s_state = "10" else -- CMPI A, I
                               '0' when s_opcode = "0010" and s_state = "10" else -- MOV A, Rn
                               '1' when s_opcode = "0011" and s_state = "10" else -- MOV Rn, A
                               '0' when s_opcode = "0001" and s_state = "10" else -- LD A, I
                               '0' when s_opcode = "1101" and s_state = "10" else -- DEC A
                               '0';

    s_reg_bank_reg_read_in <= s_register_from_instruction when s_opcode = "0101" and s_state = "10" else -- ADD A, Rn
                              s_register_from_instruction when s_opcode = "0110" and s_state = "10" else -- SUB A, Rn
                              s_register_from_instruction when s_opcode = "0010" and s_state = "10" else -- MOV A, Rn
                              s_register_from_instruction when s_opcode = "1011" and s_state = "10" else -- LW A, [Rn]
                              s_register_from_instruction when s_opcode = "1100" and s_state = "10" else -- SW, [Rn], A
                              "000";

    s_reg_bank_reg_write_in <= s_register_from_instruction when s_opcode = "0011" and s_state = "10" else -- MOV Rn, A
                               "000";

    

    state <= s_state;
    ir_data <= s_ir_data_out;
    pc_address_out <= s_pc_address_out;
    reg_0_data <= s_reg_0_data;
    reg_1_data <= s_reg_1_data;
    reg_2_data <= s_reg_2_data;
    reg_3_data <= s_reg_3_data;
    reg_4_data <= s_reg_4_data;
    accumulator_data <= s_accumulator_data_out;
    flag_C <= s_flag_C;
    flag_Z <= s_flag_Z;
    flag_N <= s_flag_N;
    flag_V <= s_flag_V;
    alu_result <= s_alu_result_out;

end architecture;