library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer_tb is
end entity timer_tb;

architecture rtl of timer_tb is

    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal nRST : std_logic;
    signal clk : std_logic;
    signal f_1Hz : std_logic;

begin

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
    
    
    process
    begin
        finished <= '0';
        nRST <= '0';
        wait for 1 ns;
        nRST <= '1';
        wait for 100 ms;
        finished <= '1';
        wait;
    end process;

    u1: entity Work.timer_1Hz(rtl)
    generic map(
        fin_cuenta => 50000
    )
    port map( nRST  => nRST,
        clk   => clk,
        f_1Hz => f_1Hz);

end architecture rtl;