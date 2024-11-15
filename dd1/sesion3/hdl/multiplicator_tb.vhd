library ieee;
use ieee.std_logic_1164.all;

entity mult_1xN_tb is
end entity;

architecture test of mult_1xN_tb is

    constant N:      natural := 8;
    signal bit_in:   std_logic;
    signal Dato_in:  std_logic_vector(N-1 downto 0);
    signal Dato_out: std_logic_vector(N-1 downto 0);

begin

    dut: entity work.mult_1xN(estructural)
    generic map(N => N)
    port map(bit_in => bit_in,
        Dato_in => Dato_in,
        Dato_out => Dato_out);

    process
    begin
        
        Dato_in <= x"A5";
        bit_in <= '0';
        wait for 10 ns;
        bit_in <= '1';
        wait for 10 ns;
        
        Dato_in <= x"5A";
        bit_in <= '0';
        wait for 10 ns;
        bit_in <= '1';
        wait for 10 ns;

        Dato_in <= x"00";
        bit_in <= '0';
        wait for 10 ns;
        bit_in <= '1';
        wait for 10 ns;

        Dato_in <= x"FF";
        bit_in <= '0';
        wait for 10 ns;
        bit_in <= '1';
        wait for 10 ns;


        wait;
    end process;
end test;