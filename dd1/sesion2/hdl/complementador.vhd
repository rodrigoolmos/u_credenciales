library ieee;
use ieee.std_logic_1164.all;

entity complementador is
    port(d_in:   in  std_logic_vector(31 downto 0);
        ctrl:   in  std_logic;
        d_out:  out std_logic_vector(31 downto 0));
end entity;

architecture rtl_2002 of complementador is
begin
    process(ctrl, d_in)
    begin
        for i in 0 to 31 loop
            d_out(i) <= d_in(i) xor ctrl;
            
        end loop;
    end process;
end rtl_2002;

architecture rtl_2008 of complementador is
begin
    
    d_out <= d_in xor ctrl;
end rtl_2008;
