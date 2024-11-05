library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity complementador_tb is
end entity;

architecture test of complementador_tb is

    signal d_in:   std_logic_vector(31 downto 0);
    signal ctrl: std_logic;
    signal d_out:  std_logic_vector(31 downto 0);

begin

    dut: entity work.complementador(rtl_2008)
    port map(
        d_in => d_in,
        ctrl => ctrl,
        d_out => d_out);

    process
    begin
        
        ctrl <= '0';
        d_in <= x"A5A5A5A5";
        wait for 10 us;

        ctrl <= '1';
        d_in <= x"A5A5A5A5";
        wait for 10 us;
        
        ctrl <= '0';
        d_in <= x"F0F0F0F0";
        wait for 10 us;
        
        ctrl <= '1';
        d_in <= x"F0F0F0F0";
        wait for 10 us;

        wait;
        
    end process;

end test;