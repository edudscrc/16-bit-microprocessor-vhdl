library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        entrada_0, entrada_1 : in unsigned (15 downto 0);
        selec_op : in unsigned (1 downto 0);
        flag_C : out std_logic;
        flag_Z : out std_logic;
        flag_N : out std_logic;
        flag_V : out std_logic;
        saida : out unsigned (15 downto 0)
    );
end entity;

architecture a_ula of ula is
    signal aux_entrada_0, aux_entrada_1, aux_saida : unsigned(16 downto 0);
    signal mesmo_sinal : std_logic;
    signal saida_read : unsigned(15 downto 0);
begin
    aux_entrada_0 <= '0' & entrada_0;
    aux_entrada_1 <= '0' & entrada_1;

    mesmo_sinal <= entrada_0(15) xnor entrada_1(15);

    saida_read <= entrada_0 + entrada_1 when selec_op = "00" else
             entrada_0 - entrada_1 when selec_op = "01" else
             entrada_0 and entrada_1 when selec_op = "10" else
             entrada_0 or entrada_1 when selec_op = "11" else
             "0000000000000000";
    saida <= saida_read;

    aux_saida <= aux_entrada_0 + aux_entrada_1 when selec_op = "00" else
                 aux_entrada_0 - aux_entrada_1 when selec_op = "01" else
                 aux_entrada_0 and aux_entrada_1 when selec_op = "10" else
                 aux_entrada_0 or aux_entrada_1 when selec_op = "11" else
                 "00000000000000000";

    flag_Z <= '1' when saida_read = "0000000000000000" else
              '0';
    flag_N <= saida_read(15);
    flag_C <= '1' when aux_saida(16) = '1' else
              '0';
    flag_V <= '1' when mesmo_sinal = '1' and saida_read(15) /= entrada_0(15) else
              '0'; 
end architecture;