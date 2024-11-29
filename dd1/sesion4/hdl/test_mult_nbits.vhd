library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_mult_nbits is
end entity;

architecture test of test_mult_nbits is
  constant n: natural := 3;
  
  signal clk:       std_logic;
  signal nRst:      std_logic;
  signal start:     std_logic;
  signal OP1:       std_logic_vector(n-1 downto 0); 
  signal OP2:       std_logic_vector(n-1 downto 0);      
  signal result:    std_logic_vector(2*n-1 downto 0);      
  signal eop: std_logic;
  
  constant T_clk: time:= 100 ns;
  
begin
  
  dut: entity Work.mult_nbits(rtl_param)
       generic map(n => n)
       port map(clk => clk,
                nRst => nRst,
                start => start,
                OP1 => OP1,
                OP2 => OP2,
                result => result,
                eop => eop);

  process
  begin
    clk <= '0';
    wait for T_clk/2;
    clk <= '1';
    wait for T_clk/2;
  end process;
  
  process      
  begin
    report "Tiempo de simulacion = 0";
    
    wait until clk'event and clk = '1';
    nRst <= '0';
    report "Activacion del reset asincrono";
    
    wait until clk'event and clk = '1';
    start <= '0';
    OP1 <= (others => '0');
    OP2 <= (others => '0');
    
    wait until clk'event and clk = '1';
    nRst <= '1';      
    report "Desactivacion del reset asincrono";

    wait until clk'event and clk = '1';
    start <= '1';
    for i in 0 to 2**n-1 loop
      for j in 0 to 2**n-1 loop   
        wait until clk'event and clk = '1';
        start <= '0';
      
        wait until eop'event and eop = '1';
        wait until clk'event and clk = '1';
        
        report "Operacion: " & integer'image(conv_integer(OP1)) & " x " & integer'image(conv_integer(OP2)) &
               " = " & integer'image(conv_integer(result));
        assert conv_integer(result) = conv_integer(OP1)*conv_integer(OP2)
          report "Error en el resultado de la multiplicacion"
          severity warning;

        start <= '1';
        OP2 <= OP2 + 1;
        
      end loop;
      OP1 <= OP1 + 1;     
    end loop;
    
    assert false
    report "FIN"
    severity failure;
    wait;
  end process; 
end test;      