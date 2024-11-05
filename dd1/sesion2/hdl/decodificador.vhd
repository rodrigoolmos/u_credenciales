library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decodificador is
    port(d_in:   in  std_logic_vector(5 downto 0);
        enable: in  std_logic;
        d_out:  out std_logic_vector(63 downto 0));
end entity;

architecture rtl_2008 of decodificador is
begin
    process(all)
    variable tmp: std_logic_vector(63 downto 0);
    
    begin
        tmp := (others => '0');
        tmp(conv_integer(d_in)) := enable;
        d_out <= tmp;
        
    end process;
end rtl_2008;

architecture rtl_2008_2 of decodificador is
begin
    process(all)
    
    begin
        d_out <= (others => '0');
        d_out(conv_integer(d_in)) <= enable;
        
    end process;
end rtl_2008_2;

