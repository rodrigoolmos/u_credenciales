library ieee;
use ieee.std_logic_1164.all;

entity gen_trazas_ena_rd_2_a is
port(clk:    out std_logic;
     start:  out std_logic;
     rdy:    out std_logic;
     nWR_RD: out std_logic;
     nCS:    out std_logic;
     ena_rd: out std_logic;
     nRst:  out std_logic);

end entity;

architecture test_psl of gen_trazas_ena_rd_2_a is
  signal   cnt_T: natural := 0;
  constant T:     time := 100 ns;

  -- psl default clock is (clk'event and clk = '1');

  -- psl ass_2_tics_ena_rd_1: assert always({start and rdy and nWR_RD} |=> {{ena_rd[->2]} && {(not nCS)[*]};(not ena_rd)[*]:rose(nCS)} ) abort fell(nRst)     
  --                        report "ERROR: No se han producido 2 tics de ena_rd en la lectura";


  -- psl ass_2_tics_ena_rd_2: assert always({start and rdy and nWR_RD} |=> {{rose(ena_rd)[->2]} && {(not nCS)[*]};(not ena_rd)[*]:rose(nCS)} ) abort fell(nRst)
  --                                report "No se han producido 2 tics de ena_rd en la lectura";
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
      nWR_RD <= '0';
      nCS    <= '1';
      ena_rd <= '0';

    wait until clk'event and clk = '1';
      nRst <= '1';

    -- Comienzo de traza tras reset: 
    --
    -- T = 0 start 0, rdy 1, nWR_RD = '0'      ----> No se cumple antecedente 

    -- T = 1 start 1, rdy 1, nWR_RD = '0'      ----> No se cumple antecedente
    wait until clk'event and clk = '1';
      start <= '1';

    -- T = 2 start 1, rdy 1, nWR_RD = '1'      ----> Se cumple antecedente -------------------------------
    wait until clk'event and clk = '1';       
      nWR_RD <= '1';

    wait until clk'event and clk = '1';        ----> Secuencia que cumple propiedad       
      nCS <= '0';
      start <= '0';
      for i in 1 to 8 loop
         if i = 2 or i = 6 then
           ena_rd <= '1';

         else 
           ena_rd <= '0';

         end if;
         wait until clk'event and clk = '1';

     end loop;
     nCS <= '1';

    wait for 3*T;
    wait until clk'event and clk = '1';        ----> Se cumple antecedente -------------------------------
       start <= '1';      

    wait until clk'event and clk = '1';        ----> Secuencia que NO cumple propiedad       
      nCS <= '0';
      start <= '0';
      for i in 1 to 6 loop
         if i = 4 then
           ena_rd <= '1';

         else 
           ena_rd <= '0';

         end if;
         wait until clk'event and clk = '1';

     end loop;
     nCS <= '1';

    wait for 3*T;
    wait until clk'event and clk = '1';        ----> Se cumple antecedente -------------------------------
       start <= '1';      

    wait until clk'event and clk = '1';        ----> Secuencia que NO cumple propiedad       
      nCS <= '0';
      start <= '0';
      for i in 1 to 9 loop
         if i = 2 or i = 5 or i = 7 then
           ena_rd <= '1';

         else 
           ena_rd <= '0';

         end if;
         wait until clk'event and clk = '1';

     end loop;
     nCS <= '1';

    wait for 3*T;
    wait until clk'event and clk = '1';        ----> Se cumple antecedente -------------------------------
       start <= '1';      

    wait until clk'event and clk = '1';        ----> Secuencia que NO cumple propiedad PERO QUE NO FALLA por nRst       
      nCS <= '0';
      start <= '0';
      for i in 1 to 8 loop
         if i = 3 then
           ena_rd <= '1';

         elsif i = 6 then
           nRst <= '0';

         else 
           ena_rd <= '0';
           nRst <= '1';

         end if;
         wait until clk'event and clk = '1';

     end loop;
     nCS <= '1';

    wait for 3*T;
    wait until clk'event and clk = '1';        ----> Se cumple antecedente -------------------------------
       start <= '1';      

    wait until clk'event and clk = '1';        ----> Secuencia que cumple propiedad cuando NO DEBERÍA        
      nCS <= '0';
      start <= '0';
      for i in 1 to 5 loop
         if i = 3 or i = 4 then
           ena_rd <= '1';

         else 
           ena_rd <= '0';

         end if;
         wait until clk'event and clk = '1';

     end loop;
     nCS <= '1';




    wait for 5*T;

    assert false
    report "Fin del test"
    severity failure;

  end process;
end test_psl;


