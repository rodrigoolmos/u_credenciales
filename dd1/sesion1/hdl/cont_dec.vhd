-- ETSI SISTEMAS DE TELECOMUNICACION
-- DPTO. INGENIERIA TELEMATICA Y ELECTRONICA
--
-- Modelo (incompleto) de un contador decimal de horas, minutos y segundos
-- v 1.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cont_dec is
    port (
        anRst : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        ena : in std_logic;
        horas_u : buffer std_logic_vector(3 downto 0);
        horas_d : buffer std_logic_vector(3 downto 0);
        minutos_u : buffer std_logic_vector(3 downto 0);
        minutos_d : buffer std_logic_vector(3 downto 0);
        segundos_u : buffer std_logic_vector(3 downto 0);
        segundos_d : buffer std_logic_vector(3 downto 0));
end cont_dec;

architecture rtl of cont_dec is
    signal fin_sg_u : std_logic;
    signal fin_sg_d : std_logic;
    signal fin_mn_u : std_logic;
    signal fin_mn_d : std_logic;
    signal fin_h_u : std_logic;
    signal fin_h_d : std_logic;
begin

    proc_seg_u: process(clk, anRst)
    begin
        if anRst = '0' then
            segundos_u <= (others => '0');
        elsif clk'event and clk = '1' then
            if rst = '1' then
                segundos_u <= (others => '0');
            elsif ena = '1' then
                if fin_sg_u = '1' then
                    segundos_u <= (others => '0');
                else
                    segundos_u <= segundos_u + 1;
                end if;
            end if;
        end if;
    end process;

    fin_sg_u <= '1' when segundos_u = 9 and ena = '1' else
    '0';

    proc_seg_d: process(clk, anRst)
    begin
        if anRst = '0' then
            segundos_d <= (others => '0');
        elsif clk'event and clk = '1' then
            if rst = '1' then
                segundos_d <= (others => '0');
            elsif fin_sg_u = '1' then
                if fin_sg_d = '1' then
                    segundos_d <= (others => '0');
                else
                    segundos_d <= segundos_d + 1;
                end if;
            end if;
        end if;
    end process;

    fin_sg_d <= '1' when segundos_d = 5 and fin_sg_u = '1' else
    '0';

    proc_min_u: process(clk, anRst)
    begin
        if anRst = '0' then
            minutos_u <= (others => '0');
        elsif clk'event and clk = '1' then
            if rst = '1' then
                minutos_u <= (others => '0');
            elsif fin_sg_d = '1' then
                if fin_mn_u = '1' then
                    minutos_u <= (others => '0');
                else
                    minutos_u <= minutos_u + 1;
                end if;
            end if;
        end if;
    end process;

    fin_mn_u <= '1' when minutos_u = 9 and fin_sg_d = '1' else
    '0';
    
    proc_min_d: process(clk, anRst)
    begin
        if anRst = '0' then
            minutos_d <= (others => '0');
        elsif clk'event and clk = '1' then
            if rst = '1' then
                minutos_d <= (others => '0');
            elsif fin_mn_u = '1' then
                if fin_mn_d = '1' then
                    minutos_d <= (others => '0');
                else
                    minutos_d <= minutos_d + 1;
                end if;
            end if;
        end if;
    end process;

    fin_mn_d <= '1' when minutos_d = 5 and fin_mn_u = '1' else
    '0';
    

    proc_h_u: process(clk, anRst)
    begin
        if anRst = '0' then
            horas_u <= (others => '0');
        elsif clk'event and clk = '1' then
            if rst = '1' then
                horas_u <= (others => '0');
            elsif fin_mn_d = '1' then
                if fin_h_u = '1' or fin_h_d = '1' then
                    horas_u <= (others => '0');
                else
                    horas_u <= horas_u + 1;
                end if;
            end if;
        end if;
    end process;

    fin_h_u <= '1' when horas_u = 9 and fin_mn_d = '1' else
    '0';

    proc_h_d: process(clk, anRst)
    begin
        if anRst = '0' then
            horas_d <= (others => '0');
        elsif clk'event and clk = '1' then
            if rst = '1' or fin_h_d = '1' then
                horas_d <= (others => '0');
            elsif fin_h_u = '1' then
                horas_d <= horas_d + 1;
            end if;
        end if;
    end process;

    fin_h_d <= '1' when horas_d = 2 and horas_u = 3 and fin_mn_d = '1' else
    '0';
    
end rtl;

