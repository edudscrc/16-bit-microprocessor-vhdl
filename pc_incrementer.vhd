library ieee;
use ieee.std_logic_1164.all;
use iee.std_numeric.all;

entity pc_incrementer is
    port (
        current_pc_data : in unsigned(6 downto 0);
        pc_data_incremented : out unsigned(6 downto 0)
    );
end entity;

architecture a_pc_incrementer of pc_incrementer is
begin
    pc_data_incremented <= current_pc_data + 1;
end architecture;