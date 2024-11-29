library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use Work.auxiliar.all;

entity mult_nbits is
generic(n: in natural := 8);         
port(clk:       in     std_logic;
     nRst:      in     std_logic;
     start:     in     std_logic;
     OP1:       in     std_logic_vector(n-1 downto 0); 
     OP2:       in     std_logic_vector(n-1 downto 0);      
     result:    buffer std_logic_vector(2*n-1 downto 0);      
     eop:       buffer std_logic);
     
end entity;

architecture rtl_param of mult_nbits is
  constant m: natural:= ceil_log(n); 
  
  -- Señales de control
  signal estado:  std_logic_vector(m downto 0);   
  signal inicia:  std_logic;
    
  alias desplaza: std_logic_vector(m-1 downto 0) is estado(m-1 downto 0); 

  signal mndo :  std_logic_vector(n-1 downto 0); 
  signal mdor :  std_logic_vector(n-1 downto 0); 
  
  signal producto: std_logic_vector(2*n-2 downto 0);
  
begin

-- Ruta de datos
--***************************************************************************
process(clk, nRst)
begin
  if not nRst then
    mndo <= (others => '0');
    mdor <= (others => '0');
    
  elsif clk'event and clk = '1' then
    if inicia then
      mndo <= OP1;
      mdor <= OP2;
  
    end if;
  end if;
end process;

producto <= shl(ext(mndo, 2*n-1), desplaza) when mdor(conv_integer(desplaza))
            else (others => '0');

process(clk, nRst)
begin
  if not nRst then
    result <= (others => '0');
      
  elsif clk'event and clk = '1' then
    if inicia then
      result <= (others => '0');
        
    elsif not eop then
      result <= result + producto;

    end if;
  end if;
end process;
  
--***************************************************************************  

--Control
--*************************************************************************** 
process(clk, nRst)
begin
  if not nRst then
    estado <= (others => '1');
      
  elsif clk'event and clk = '1' then
    if start and estado(m) then
      estado <= (others => '0');
        
    elsif not eop then
      estado <= estado + 1;

    end if;
  end if;
end process;

eop <= estado(m) and (not estado(0));
inicia <= start and estado(m);

--***************************************************************************
end rtl_param;