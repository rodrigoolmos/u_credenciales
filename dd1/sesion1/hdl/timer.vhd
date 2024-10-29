-- ETSI SISTEMAS DE TELECOMUNICACION
-- DPTO. INGENIERIA TELEMATICA Y ELECTRONICA
--
-- Modelo de un timer con salida de 1 Hz a partir de un reloj de 50 MHz
-- v 1.0

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer_1Hz is
    generic(
        fin_cuenta : natural := 50000000
    );
    port( nRST  : in std_logic;
        clk   : in std_logic;
        f_1Hz : buffer std_logic);
end timer_1Hz;

architecture rtl of timer_1Hz is
    
    signal cnt : unsigned(30 downto 0);

begin
    process (nRST, clk)
    begin
        if nRST = '0' then
            cnt <= (0 => '1', others => '0');
        elsif clk = '1' and clk'event then
            if f_1Hz = '1' then
                cnt <= (0 => '1', others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    f_1Hz <= '1' when cnt = fin_cuenta else
    '0';
end rtl;
