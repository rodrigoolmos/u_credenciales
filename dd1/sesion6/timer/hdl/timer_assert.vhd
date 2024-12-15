library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;  -- Para ?=

entity timer_25 is
generic(div_param: natural := 25);   -- periodo de tic s -> 5 ms         

port(nRst:      in  std_logic;
     clk:       in  std_logic;
     tic_25:    out std_logic);

end entity;

architecture rtl of timer_25 is
  signal cnt: std_logic_vector(4 downto 0);

  -- CODIGO___PSL con metacomentarios
  -- psl default clock is (clk'event and clk = '1');
  -- psl sequence tic_N(numeric N) is {(not tic_25)[*(N-1)];tic_25};
  -- psl property tic_N_periodico(numeric N) is always {tic_25} |=> tic_N(N); 
  -- psl assert tic_N_periodico(div_param);

begin
  process(clk, nRst)
  begin
    if not nRst then
      cnt <= 5D"1";

    elsif clk'event and clk = '1' then
      if tic_25 then
        cnt <= 5D"1";

      else
        cnt <= cnt +1;

      end if;
    end if;
  end process;

  tic_25 <= cnt ?= div_param;
  
end rtl; 
