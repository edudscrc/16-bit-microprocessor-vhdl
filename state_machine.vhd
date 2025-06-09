library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
    port (
        clock : in std_logic;
        reset : in std_logic;

        state : out unsigned(1 downto 0)
    );
end entity;

architecture a_state_machine of state_machine is
    signal current_state : unsigned(1 downto 0);
begin
    process(clock, reset)
    begin
        if reset = '1' then
            current_state <= "00";
        elsif rising_edge(clock) then
            if current_state = "10" then
                current_state <= "00";
            else
                current_state <= current_state + 1;
        end if;
    end process;

    state <= current_state;
end architecture;