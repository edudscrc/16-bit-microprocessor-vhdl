library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
    port (
        clock : in std_logic;
        reset : in std_logic;

        state : out std_logic
    );
end entity;

architecture a_state_machine of state_machine is
    signal current_state : std_logic;
begin
    process(clock, reset)
    begin
        if reset = '1' then
            current_state <= '0';
        elsif rising_edge(clock) then
            current_state <= not current_state;
        end if;
    end process;

    state <= current_state;
end architecture;