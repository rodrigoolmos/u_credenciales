library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_master_spi_4_hilos is
end entity;

architecture test of test_master_spi_4_hilos is
  signal nRst:     std_logic;
  signal clk:      std_logic; 

  signal no_bytes: std_logic_vector(2 downto 0);

  signal start:    std_logic;                       
  signal nWR_RD:   std_logic;                       
  signal dir_reg:  std_logic_vector(6 downto 0);    
  signal dato_wr:  std_logic_vector(7 downto 0);    
  signal dato_rd:  std_logic_vector(7 downto 0);    
  signal ena_rd:   std_logic;                       
  signal rdy:      std_logic;                       
                                                        
  signal nCS:      std_logic;                      
  signal SPC:      std_logic;                      
  signal SDI_msr:  std_logic;                     -- SDI master                      
  signal SDO_msr:  std_logic;                     -- SDO master

  constant T_clk: time := 20 ns; -- 50 MHz system clock

  signal g_range: std_logic_vector(2 downto 0);

begin

process
begin
  clk <= '0';
  wait for T_clk/2;

  clk <= '1';
  wait for T_clk/2;

end process;

dut: entity work.master_spi_4_hilos(rtl)
     port map(nRst     => nRst,
              clk      => clk,
              no_bytes => no_bytes,
              start    => start,
              nWR_RD   => nWR_RD,
              dir_reg  => dir_reg,
              dato_wr  => dato_wr,
              dato_rd  => dato_rd,
              ena_rd   => ena_rd,
              rdy      => rdy,
              nCS      => nCS,
              SPC      => SPC,
              SDI      => SDI_msr,
              SDO      => SDO_msr);


slave_sens: entity work.agent_spi_sensor(sim)
       port map(g_range => g_range,
                nCS => nCS,
                SPC => SPC,
                SDI => SDO_msr,
                SDO => SDI_msr);

process
begin
  -- SECUENCIA DE RESET
  wait until clk'event and clk = '1';
    nRst <= '1';
  
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
    nRst <= '0';

  wait until clk'event and clk = '1';
    no_bytes <= "010";
    start    <= '0';
    nWR_RD   <= '0';
    dir_reg  <= 7X"0";
    dato_wr  <= 8X"0";

    g_range <= "000";


  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
    nRst <= '1';

  wait for 100*T_clk;
  wait until clk'event and clk = '1';

  --Escritura de 1 registro
  wait until clk'event and clk = '1';
    start <= '1';
    no_bytes <= "010";
    nWR_RD <= '0';
    dir_reg <= 7X"02";
    dato_WR <= 8X"A5";

  wait until clk'event and clk = '1';
    start <= '0';

  wait until nCS'event and nCS = '1';
  wait for 20*T_clk;
  wait until clk'event and clk = '1';

  -- 8 lecturas de 2 bytes
    for i in 0 to 7 loop
       wait until clk'event and clk = '1';
         start <= '1';
         no_bytes <= "011";
         nWR_RD <= '1';
         dir_reg <= 7X"68";


       wait until clk'event and clk = '1';
         start <= '0';

         if i = 5 then                             -- start extemporaneo y no tic para probar aserciones
           wait for 30 * T_clk;
           wait until clk'event and clk = '1';
             start <= '1';
           wait until clk'event and clk = '1';
           wait until clk'event and clk = '1';
             start <= '0';

         end if;

       wait until nCS'event and nCS = '1';
          g_range <= g_range + 1;

       wait for 20*T_clk;

    end loop;
 
  wait for 100 * T_clk;

  assert false
  report "Fin del test"
  severity failure;

end process;
end test;