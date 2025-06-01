library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_rom is
    port (
        clock : in std_logic;
        reset : in std_logic;
        write_enable_pc : in std_logic;

        rom_data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_pc_rom of pc_rom is
    component program_counter is
        port (
            clock : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    component pc_incrementer is
        port (
            current_pc_data : in unsigned(6 downto 0);
            pc_data_incremented : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port (
            clock : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component;

    signal s_pc_address : unsigned(6 downto 0);
    signal s_pc_next_address : unsigned(6 downto 0);
begin
    pc_instance: program_counter port map (
        clock => clock,
        reset => reset,
        write_enable => write_enable_pc,
        data_in => s_pc_next_address,
        data_out => s_pc_address
    );

    pc_incrementer_instance: pc_incrementer port map (
        current_pc_data => s_pc_address,
        pc_data_incremented => s_pc_next_address
    );

    rom_instance: rom port map (
        clock => clock,
        address => s_pc_next_address,
        data => rom_data_out
    );
end architecture;