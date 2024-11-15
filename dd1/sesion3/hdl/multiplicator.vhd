library ieee;
use ieee.std_logic_1164.all;

entity mult_1xN is
    generic(N: in natural := 4);
    
    port(bit_in:   in     std_logic;
        Dato_in:  in     std_logic_vector(N-1 downto 0);
        Dato_out: buffer std_logic_vector(N-1 downto 0)
    );
end entity;

architecture estructural of mult_1xN is
begin
    G1: for i in 0 to N-1 generate
        Dato_out(i) <= bit_in and Dato_in(i);
    end generate;
    
end estructural;

