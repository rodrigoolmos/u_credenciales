library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_top_tb is
end entity clock_top_tb;

architecture rtl of clock_top_tb is
    signal clk : std_logic;
    signal anrst : std_logic;
    signal rst : std_logic;
    signal segDisp : std_logic_vector(6 downto 0);
    signal muxDisp : std_logic_vector(5 downto 0)
begin


    u1: entity Work.clock_top(rtl)
    port map(
        clk => clk,
        anrst => anrst,
        rst => rst,
        segDisp => segDisp,
        muxDisp => muxDisp
    );


end architecture rtl;