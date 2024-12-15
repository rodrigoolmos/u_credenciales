library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;  -- Para ?=

entity test_timer_25 is
end entity;

architecture test of test_timer_25 is
  signal nRst:   std_logic;
  signal clk:    std_logic;
  signal tic_25: std_logic;

  constant T: time := 100 ns;
  
begin
  dut: entity work.timer_25(rtl)
       generic map(div_param => 25)   -- periodo de tic 25         

       port map(nRst   => nRst,
                clk    => clk,
                tic_25 => tic_25);

  process
  begin
    clk <= '0';
    wait for T/2;

    clk <= '1';
    wait for T/2;

  end process;

  process
  begin
    nRst <= '0';
    wait for 2*T;
    wait until clk'event and clk = '1';
    nRst <= '1';

    wait for 100*T;
    wait until clk'event and clk = '1';

    -- DESCOMENTAR CUANDO SE INDIQUE

--    nRst <= '0';
--    wait for 2*T;
--    wait until clk'event and clk = '1';
--    nRst <= '1';
--
--    wait for 100*T;
--    wait until clk'event and clk = '1';
    
    assert false
    report "Fin del test"
    severity failure;

  end process;
  
end test; 
