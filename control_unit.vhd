library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clock : in std_logic;
        reset : in std_logic
    );
end entity;

architecture a_control_unit of control_unit is
    component program_counter is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            address_in : in unsigned(6 downto 0);
            address_out : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port (
            clock : in std_logic;
            address_in : in unsigned(6 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component state_machine is
        port (
            clock : in std_logic;
            reset : in std_logic;

            state : out std_logic
        );
    end component;

    signal s_pc_address_in, s_pc_address_out : unsigned(6 downto 0);
    signal s_pc_write_enable : std_logic;
    
    signal s_state : std_logic;

    signal s_rom_address_in : unsigned(6 downto 0);
    signal s_rom_data_out : unsigned(15 downto 0);

    signal s_opcode : unsigned(3 downto 0);

    signal s_jump_enable : std_logic;
    signal s_jump_address : unsigned(6 downto 0);
begin
    pc_instance: program_counter port map (
        clock => clock,
        reset => reset,
        write_enable => s_pc_write_enable,
        address_in => s_pc_address_in,
        address_out => s_pc_address_out
    );

    rom_instance: rom port map (
        clock => clock,
        address_in => s_rom_address_in,
        data_out => s_rom_data_out
    );

    state_machine_instance: state_machine port map (
        clock => clock,
        reset => reset,
        state => s_state
    );

    -- opcode nos 4 bits MSB
    s_opcode <= s_rom_data_out(15 downto 12);

    s_jump_enable <= '1' when s_opcode = "1111" else
                     '0';

    s_jump_address <= s_rom_data_out(6 downto 0);

    s_rom_address_in <= s_pc_address_out;

    s_pc_address_in <= s_jump_address when s_jump_enable = '1' else
                       s_pc_address_out + 1;

    s_pc_write_enable <= '1' when s_state = '1' else
                     '0' when s_state = '0' else
                     '0';

end architecture;