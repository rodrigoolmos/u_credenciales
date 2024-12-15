-- ETSI SISTEMAS DE TELECOMUNICACION
-- DPTO. INGENIERIA TELEMATICA Y ELECTRONICA
--
-- Master SPI a 4 hilos compatible con el acelerometro LIS2DH12
-- v 0.0 
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

entity master_spi_4_hilos is
port(nRst:     in  std_logic;
     clk:      in  std_logic;                       -- 50 MHz

     -- Ctrl_SPI
     start:    in  std_logic;                       -- Inicio de transaccion (pulso activo a nivel alto). Solo funciona si rdy = 1
     nWR_RD:   in  std_logic;                       -- Escritura (0) o lectura (1)
     dir_reg:  in  std_logic_vector(6 downto 0);    -- Bit 6: sin (0) o con (1) autoincremento; bits 5..0: direccion del registro
     dato_wr:  in  std_logic_vector(7 downto 0);    -- Dato a escribir (solo escrituras de 1 byte)
     no_bytes: in  std_logic_vector(2 downto 0);    -- Numero total de bytes de la transaccion
     dato_rd:  out std_logic_vector(7 downto 0);    -- Valor del byte leido
     ena_rd:   out std_logic;                       -- Valida (pulso activo a nivel alto) a dato_rd. Ignorar en operaciones de escritura
     rdy:      out std_logic;                       -- Unidad preparada para aceptar start (1), transaccion en curso (0) 
	 
     -- bus SPI
     nCS:      out std_logic;                      -- Chip select. Reposo (1); transaccion en curso (0)
     SPC:      out std_logic;                      -- Reloj del bus SPI (5 MHz). Nivel alto en reposo. CT 50%
     SDI:      in std_logic;                       -- Entrada de datos serie del maestro (conectado a la SDO del esclavo)
     SDO:      out std_logic);                     -- Salida de datos serie del maestro (conectado a la SDI del esclavo)
     
end entity;

architecture rtl of master_spi_4_hilos is
 --Reloj del bus
 signal cnt_SPC:     std_logic_vector(2 downto 0);   --Para generar SPC
 signal fdc_cnt_SPC: std_logic;
 signal SPC_posedge: std_logic;
 signal SPC_negedge: std_logic;

 constant SPC_LH: natural := 5;                      -- Duracion de los niveles de SPC
 
 -- Contador de bits y bytes transmitidos
 signal cnt_bits_SPC: std_logic_vector(5 downto 0);  -- maximo {wr = 2 x 8, rd = (1 + 6) x 8} = 56

 -- Sincro SDI y Registro de transmision y recepcion
 signal SDI_syn: std_logic;
 signal reg_SPI: std_logic_vector(16 downto 0);

 -- Para el control
 signal fin: std_logic;

begin

  -- Apartado 1
  -- Gestion de nCS:
  process(nRst, clk)
  begin
    if  not nRst then                       -- Cambiar 2008
      nCS <= '1';

    elsif clk'event and clk = '1' then
      if start and nCS then                                -- Completar 2008
        nCS <= '0';

      elsif fin then                    -- Cambiar 2008. Fin se activa cuando debe desactivarse nCS
        nCS <= '1';                                      

      end if;
    end if;
  end process;
  
  rdy <= nCS;                                    -- Ecuacion que define el nivel logico de rdy


  -- Fin de Gestion nCS

  -- Apartado 2
  -- Generacion de SPC: Frq SPC = Frq clk/10 -> 5 MHZ
  --
  -- 2.3: tsu = 4*20=80ns (5 ns min); th = 2*20=40 ns (20 ns min)
  -- 2.4: evita que se detecten flancos de subida inicialmente cuando no toca
  -- 2.5: 1 MHz -> 50 ciclos de clk (25+25). SPC_LH = 25. cnt_spc debe tener 5 bits para contar 1..25
  process(nRst, clk)
  begin
    if not nRst then
      cnt_SPC <= 3D"2";
      SPC <= '1';

    elsif clk'event and clk = '1' then
      if nCS then                        -- Reposo => SPC H
        cnt_SPC <= 3D"2";
        SPC <= '1';

      elsif fdc_cnt_SPC then             -- Operando y generando reloj
        SPC <= not SPC;
        cnt_SPC <= 3D"1";

      else
        cnt_SPC <= cnt_SPC + 1;

      end if;
    end if;
  end process;

  fdc_cnt_SPC <= '1' when cnt_SPC = SPC_LH else '0';

  SPC_posedge <= SPC when cnt_SPC = 1 else '0'; 

  SPC_negedge <= not SPC when cnt_SPC = 1 else '0';

  -- Fin de Generacion de SPC
 

  -- Apartado 3
  -- Gestion de SDI y SDO
  -- 3.1: Los bits se leen en los flancos positivos de SPC y se escriben en los negativos. Esto se corresponde
  -- con polaridad y fase 1
  -- 3.2: SDI_syn es para sincronizar la entrada de datos del SPI con el reloj del sistema
  -- 3.3: tsu = 4*20= 80 ns (> 5 ns); th = 6*20= 120 ns (> 15 ns)
  -- 3.4: la lectura ocurre 5 TCLK despues del flanco de bajada de SPC (100 ns), el esclavo pone el dato
  -- 50 ns despues de ese flanco, como tarde (tvso)
  process(nRst, clk)
  begin
    if not nRst then
      reg_SPI <= 17D"0";
      SDI_syn <= '0';

    elsif clk'event and clk = '1' then  
      SDI_syn <= SDI;
      
      if start and nCS then
        reg_SPI <= '0'& nWR_RD & dir_reg & dato_wr;
 
      elsif SPC_negedge then
        reg_SPI(16 downto 1) <= reg_SPI(15 downto 0);

      elsif SPC_posedge then
        reg_SPI(0) <= SDI_syn;

      end if;
    end if;
  end process;

  dato_rd <= reg_SPI(7 downto 0);                                        -- Completar

  SDO <= reg_SPI(16);                                            -- Completar

  -- Fin de Gestion de SDI y SDO


  -- Apartado 4
  -- Gestion de transferencia
  -- 4.1: cnt_bits_SPC(2 downto 0) es en numero de bits transmitidos y cnt_bits_SPC(5 downto 3) el numero de bytes
  -- 4.2: ena_rd se activa en operaciones de lectura (nWR_RD = '1'):
  --      - en los flancos de bajada de SPC a partir del segundo byte, coincidiendo con la llegada del primer bit de cada byte
  --      - al activarse fin antes de que nCS vuelva a nivel alto cuando se ha transmitido el último byte
  
  process(nRst, clk)
  begin
    if not nRst then
      cnt_bits_SPC <= 6D"0";
      
    elsif clk'event and clk = '1' then  
      if SPC_posedge then
        cnt_bits_SPC <= cnt_bits_SPC + 1;

      elsif nCS then
        cnt_bits_SPC <= 6D"0";

      end if;
    end if;
  end process;


  ena_rd <= (not nCS and fin) when cnt_bits_SPC(5 downto 3) =  no_bytes  and nWR_RD = '1'                           else  
            SPC_negedge       when cnt_bits_SPC(5 downto 3) >  1 and cnt_bits_SPC(2 downto 0) = 0  and nWR_RD = '1' else  
            '0';

  fin <= '1' when cnt_bits_SPC(5 downto 3) = no_bytes else '0';

  -- Fin de Gestion de transferencia
 
end rtl;
