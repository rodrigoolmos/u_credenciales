library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity codificador_tb is
end entity;

architecture test of codificador_tb is

    signal D_in:   std_logic_vector(7 downto 0);
    signal enable: std_logic;
    signal D_out:  std_logic_vector(2 downto 0);

begin

    dut: entity work.codificador(rtl_2)
    port map(
        D_in => D_in,
        enable => enable,
        D_out => D_out);

    process
    begin
        d_in <= 8b"0";
        enable <= '0';
        for i in 1 to 2 loop
            for j in 0 to 255 loop
                wait for 100 ns;
                d_in <= d_in + 1;
            end loop;
            enable <= '1';
        end loop;
        wait for 10 ns;
        wait;
    end process;

end test;