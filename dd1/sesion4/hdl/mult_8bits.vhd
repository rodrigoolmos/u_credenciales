library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mult_8bits is
    port(clk:       in     std_logic;
        nRst:      in     std_logic;
        start:     in     std_logic;
        OP1:       in     std_logic_vector(7 downto 0);
        OP2:       in     std_logic_vector(7 downto 0);
        result:    buffer std_logic_vector(15 downto 0);
        eop:       buffer std_logic);
end entity;

architecture rtl of mult_8bits is
  -- Registros de operandos
    signal mndo :  std_logic_vector(7 downto 0);
    signal mdor :  std_logic_vector(7 downto 0);
    
    signal bit_mdor: std_logic;
    
  -- Salida barrel-shifter
    signal producto: std_logic_vector(14 downto 0);
    
  -- Se�ales de control
    type t_estado is(ini, espera, cero, uno, dos, tres, cuatro, cinco, seis, siete);
    signal estado:  t_estado;
    
    signal sel_bit: std_logic_vector(2 downto 0);
    signal carga:   std_logic;
    signal acumula: std_logic;
    
    alias  desplaza: std_logic_vector(2 downto 0) is sel_bit;
    alias  inicia:   std_logic                    is carga;
begin

--RUTA DE DATOS
--***********************************************************
    process(clk, nRst) -- interfaz OP
    begin
        if not nRst then
            mndo <= 8D"0";
            mdor <= 8D"0";
            
        elsif clk'event and clk = '1' then
            if carga then
                mndo <= OP1;
                mdor <= OP2;
                
            end if;
        end if;
    end process;

    bit_mdor <= mdor(conv_integer(sel_bit)); -- interfaz OP
    
    process(all) -- mult 1 bit
    begin
        producto <= 15D"0";
        if bit_mdor then
            for i in 0 to 7 loop
                producto(i + conv_integer(desplaza)) <= mndo(i);
                
            end loop;
        end if;
    end process;
    
    process(clk, nRst) -- acumula
    begin
        if not nRst then
            result <= 16X"0";
            
        elsif clk'event and clk = '1' then
            if inicia then
                result <= X"0000";
                
            elsif acumula then
                result <= result + producto;

            end if;
        end if;
    end process;
--***********************************************************

-- CONTROL
--***********************************************************
    process(clk, nRst)
    begin
        if nRst = '0' then
            estado <= ini;
            
        elsif clk'event and clk = '1' then
            case estado is
                when ini|espera =>
                    if start = '1' then
                        estado <= cero;
                    end if;
                    
                when siete =>
                    estado <= espera;
                    
                when others =>
                    estado <= t_estado'succ(estado);
                    
            end case;
        end if;
    end process;

    sel_bit <= "000" when t_estado'pos(estado) < 2 else
             "000" + t_estado'pos(estado) - 2;
    
    carga   <= start when t_estado'pos(estado) < 2 else
    '0';
    
    eop     <= '1' when estado = espera else
    '0';

    acumula <= not eop;
--***********************************************************
end rtl;
