-- ETSI SISTEMAS DE TELECOMUNICACION
-- DPTO. INGENIERIA TELEMATICA Y ELECTRONICA
--
-- Agente SPI simple usado en el test para simular al esclavo
-- Compatible con el protocolo SPI a 4 hilos.
-- v 0.0 
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;  -- Para ?=

entity agent_spi_sensor is
port(g_range: in std_logic_vector(2 downto 0);

     nCS:     in  std_logic;                      -- chip select
     SPC:     in  std_logic;                      -- clock SPI 
     SDI:     in  std_logic;                      -- Slave Data input  (conectado al master SDO)
     SDO:     out std_logic);                     -- Slave Data Output (conectado al master SDI)
     
end entity;

architecture sim of agent_spi_sensor is
  type t_estado is(reposo, byte_1st_Rd, byte_1st_Wr, enviar_lecturas, registrar_comando);
  signal estado: t_estado;

  signal reg_comandos:    std_logic_vector(7 downto 0) := X"00";
  signal reg_lecturas:    std_logic_vector(15 downto 0);

  signal reg_addr:        std_logic_vector(6 downto 0);
  
  function calcular_reg_lectura_g(signal g_range: in std_logic_vector(2 downto 0)) return std_logic_vector is
    variable dato_g: std_logic_vector(9 downto 0);
   
  begin
    case g_range is 
      when "000"   => dato_g := 10X"200"; -- -2 g 
      when "001"   => dato_g := 10X"280"; -- -1.5 g 
      when "010"   => dato_g := 10X"300"; -- -1 g 
      when "011"   => dato_g := 10X"380"; -- -0.5 g 
      when "100"   => dato_g := 10D"002"; -- 0 g (offset)
      when "101"   => dato_g := 10D"128"; -- 0.5 g  
      when "110"   => dato_g := 10D"256"; -- 1 g   
      when others  => dato_g := 10D"512"; -- 2 g  

    end case;

    return dato_g(1 downto 0)&6D"0"&dato_g(9 downto 2); -- 15-8 LSB ... 7-0 MSB
    
  end function;
  
begin

process(nCS, SPC)
  variable cnt_bits: natural := 0;
  
begin
  if nCS then                           -- Esclavo en reposo
    cnt_bits := 0;
    estado <= reposo;

  elsif SPC'event and SPC = '1' then    -- flanco de subida del reloj SPI
    cnt_bits := cnt_bits + 1;
    if cnt_bits = 1 then
      if SDI then
        estado <= byte_1st_Rd;

      else
        estado <= byte_1st_Wr;

      end if;

    elsif cnt_bits = 8 then 
      if estado = byte_1st_Rd then
        estado <= enviar_lecturas;
        
      else
        estado <= registrar_comando;

      end if;
    end if;
  end if;
end process;

process
  variable init_reg_lecturas : boolean:= true;

begin  
  if not nCS then
    wait until nCS'event or SPC'event;
      if SPC'event then
        if ((estado = byte_1st_Rd) or (estado = byte_1st_Wr)) and SPC = '1' then
          reg_addr <= reg_addr(5 downto 0) & SDI;

        elsif (estado = registrar_comando) and (SPC = '1') then
           reg_comandos <= reg_comandos(6 downto 0) & SDI;

        elsif (estado = enviar_lecturas) and (SPC = '0') then
          if init_reg_lecturas then
            init_reg_lecturas := false;
            if reg_addr = 7X"68" then  -- x"68"                                
              reg_lecturas(15 downto 0) <= calcular_reg_lectura_g(g_range);

            else
              reg_lecturas <= 16X"A5B4";

            end if;
            wait for 1 ns;

          end if;
          SDO <= reg_lecturas(15) after 25 ns;
          reg_lecturas <= reg_lecturas(14 downto 0)&reg_lecturas(15);

        end if;
      end if;

  else
    SDO <= '1';
    init_reg_lecturas := true;
    wait until nCS'event;

  end if;
end process;

end sim;





