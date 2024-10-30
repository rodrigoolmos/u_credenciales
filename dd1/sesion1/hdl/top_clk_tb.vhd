library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_top_tb is
end entity clock_top_tb;

architecture sim of clock_top_tb is
    
    constant period_time : time      := 20000 ps;
    signal   finished    : std_logic := '0';
    
    signal clk : std_logic;
    signal anrst : std_logic;
    signal rst : std_logic;
    signal segDisp : std_logic_vector(6 downto 0);
    signal muxDisp : std_logic_vector(5 downto 0);
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
        anrst <= '0';
        rst <= '0';
        wait for 1 ns;
        anrst <= '1';
        wait for 25 ms;
        rst <= '1';
        wait for 10 us;
        rst <= '0';
        wait for 5 ms;
        finished <= '1';
        wait;
    end process;

    u1: entity Work.clock_top(top)
    generic map(
        clk_frec => 10
    )
    port map(
        clk => clk,
        anrst => anrst,
        BI => '0',
        UP_DOWN => '0',
        rst => rst,
        segDisp => segDisp,
        muxDisp => muxDisp
    );


end architecture sim;