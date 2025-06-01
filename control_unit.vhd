library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clock : in std_logic;
        reset : in std_logic;
        
        rom_address : out unsigned(6 downto 0);
        rom_data : out unsigned(15 downto 0)

        --exception : out std_logic
    );
end entity;

architecture a_control_unit of control_unit is
    component program_counter is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port (
            clock : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component;

    component state_machine is
        port (
            clock : in std_logic;
            reset : in std_logic;

            state : out std_logic
        );
    end component;

    signal s_pc_data_in, s_pc_data_out : unsigned(6 downto 0);
    signal s_pc_write_enable : std_logic;
    
    signal s_state : std_logic;

    signal s_rom_address : unsigned(6 downto 0);
    signal s_rom_data : unsigned(15 downto 0);

    signal s_opcode : unsigned(3 downto 0);
    signal s_operand : unsigned(11 downto 0);

    signal s_jump_enable : std_logic;
    signal s_next_jump : unsigned(6 downto 0);
begin
    pc_instance: program_counter port map (
        clock => clock,
        reset => reset,
        write_enable => s_pc_write_enable,
        data_in => s_pc_data_in,
        data_out => s_pc_data_out
    );

    rom_instance: rom port map (
        clock => clock,
        address => s_rom_address,
        data => s_rom_data
    );

    state_machine_instance: state_machine port map (
        clock => clock,
        reset => reset,
        state => s_state
    );

    rom_address <= s_rom_address;
    rom_data <= s_rom_data;
    
    -- opcode nos 4 bits MSB
    s_opcode <= s_rom_data(15 downto 12);
    s_operand <= s_rom_data(11 downto 0);

    s_jump_enable <= '1' when s_opcode = "1111" else
                     '0';
    s_next_jump <= s_rom_data(6 downto 0);

    s_rom_address <= s_pc_data_out;

    s_pc_data_in <= s_next_jump when s_jump_enable = '1' else
        
    s_pc_data_out + 1;

    s_pc_write_enable <= '1' when s_state = '1' else
                     '0' when s_state = '0' else
                     '0';

end architecture;