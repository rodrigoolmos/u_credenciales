library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decodBCD7seg_tb is
end entity decodBCD7seg_tb;

architecture rtl of decodBCD7seg_tb is
    signal digBCD_tb :  std_logic_vector(3 downto 0);
    signal segDisp_tb : std_logic_vector(6 downto 0);
    signal BI_tb : std_logic;


begin

    process
    begin
        BI_tb <= '0';
        for i in 0 to 9 loop
            digBCD_tb <= STD_LOGIC_VECTOR(TO_SIGNED(i, digBCD_tb'LENGTH));
            wait for 10 ns;
        end loop;
        BI_tb <= '1';
        for i in 0 to 9 loop
            digBCD_tb <= STD_LOGIC_VECTOR(TO_SIGNED(i, digBCD_tb'LENGTH));
            wait for 10 ns;
        end loop;
        wait;
    end process;
    

    u1: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => digBCD_tb,
        segDisp => segDisp_tb,
        BI => BI_tb
    );

end architecture rtl;