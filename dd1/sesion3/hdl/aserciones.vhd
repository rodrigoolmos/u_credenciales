library ieee;
use ieee.std_logic_1164.all;

entity aserciones is
    port(nRST:          in std_logic;
        clk:           in std_logic;
        D_in:          in std_logic;
        D_out:         out std_logic);
end entity;

architecture rtl of aserciones is
begin

    process(clk, nRST)
    begin
        if not nRST then
            D_out <= '0';
        elsif clk'event and clk = '1' then
            D_out <= D_in;
        end if;
    end process;

end rtl;
