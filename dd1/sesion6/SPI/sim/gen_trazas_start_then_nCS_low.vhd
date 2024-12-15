

library ieee;
use ieee.std_logic_1164.all;

entity gen_trazas_start_then_nCS_low is
port(clk:   out std_logic;
     start: out std_logic;
     rdy:   out std_logic;
     nCS:   out std_logic;
     nRst:  out std_logic);

end entity;

architecture test_psl of gen_trazas_start_then_nCS_low is
  signal   cnt_T: natural := 0;
  constant T:     time := 100 ns;

  -- psl default clock is (clk'event and clk = '1');
  -- psl ass_start_then_nCS_low: assert always ((start and rdy) -> next(not nCS))    -- ASSERT basica LTL
  --                             report "ERROR: No se atiende la orden de start" ;
  -- psl cover_start_rdy: cover{(start and rdy)};
  -- psl asm_gu_start_tic: assume_guarantee always (start-> next(not start)) report "NOTE: Pulso de start de más de 1 Tclk" ;

begin
  process
  begin
    clk <= '1';
    wait for T/2;
   
    clk <= '0';
    wait for T/2;

  end process;

  process(clk, nRst)
  begin
    if not nRst then
      cnt_T <= 0;

    elsif clk'event and clk = '1' then
      cnt_T <= cnt_T + 1;

    end if;
  end process;
  
  process
  begin
  nRst <= '0';
    wait until clk'event and clk = '1';
      start <= '0';
      rdy <= '1';
      nCS <= '1';

    wait until clk'event and clk = '1';
      nRst <= '1';

    -- Comienzo de traza tras reset: 
    --
    -- T = 0 start 0, rdy 1, nCS 1       ----> No se cumple antecedente 

    -- T = 1 start 1, rdy 1, nCS 1       ----> Se cumple antecedente => en T = 2 nCS debe valer 0 
    wait until clk'event and clk = '1';
      start <= '1';

    -- T = 2                             -----> Debe satisfacerse la aserción
    wait until clk'event and clk = '1';
      start <= '0';
      rdy   <= '0';
      nCS <= '0';

    -- T = 3                             -----> No se cumple antecedente 
    wait until clk'event and clk = '1';
      start <= '1';

    wait for 2*T;                        ------> Se mantiene start sin que se cumpla el antecedente
    wait until clk'event and clk = '1'; 
    -- T = 5                             -----> Se activa rdy para que se cumpla antecedente 
      rdy <= '1';

    -- T = 6 
    wait until clk'event and clk = '1';  -- No debe cumplirse la asercion
      rdy <= '0';
      nCS <= '1';

    wait for 5*T;

    assert false
    report "Fin del test"
    severity failure;

  end process;
end test_psl;


