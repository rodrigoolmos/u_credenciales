library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decodificador_tb is
end entity;

architecture test of decodificador_tb is

signal d_in:   std_logic_vector(5 downto 0);
signal enable: std_logic;
signal d_out:  std_logic_vector(63 downto 0);

begin

dut: entity work.decodificador(rtl_2008_2)
port map(
     d_in => d_in,
     enable => enable,
     d_out => d_out);

process
begin
  d_in <= 6b"0";
  enable <= '0';
  for i in 1 to 2 loop
    for j in 1 to 64 loop
      wait for 100 ns;
      d_in <= d_in + 1;
    end loop;
    enable <= '1';
  end loop;
  wait; 
end process;

end test; 