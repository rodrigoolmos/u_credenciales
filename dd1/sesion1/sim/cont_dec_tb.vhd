library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cont_dec_tb is
end entity cont_dec_tb;

architecture rtl of cont_dec_tb is

    constant period_time : time      := 83333 ps;
    signal cnt_s : natural range 0 to 60;
    signal cnt_m : natural range 0 to 60;
    signal cnt_h : natural range 0 to 24;
    signal finished    : std_logic := '0';

    signal anRst : std_logic;
    signal clk : std_logic;
    signal rst : std_logic;
    signal ena : std_logic;
    signal horas_u : std_logic_vector(3 downto 0);
    signal horas_d : std_logic_vector(3 downto 0);
    signal minutos_u : std_logic_vector(3 downto 0);
    signal minutos_d : std_logic_vector(3 downto 0);
    signal segundos_u : std_logic_vector(3 downto 0);
    signal segundos_d : std_logic_vector(3 downto 0);
begin

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin

        finished <= '0';
        anRst <= '0';
        rst <= '1';
        ena <= '1';
        wait until rising_edge(clk);
        anRst <= '1';
        rst <= '0';

        wait for period_time * 100;
        wait until rising_edge(clk);
        rst <= '1';

        wait for period_time * 100;
        wait until rising_edge(clk);
        rst <= '0';

        ena <= '0';
        wait for period_time * 100;
        wait until rising_edge(clk);
        ena <= '1';


        wait for period_time * 100000;
        finished <= '1';

        wait;
    end process;
    
    process(clk, anRst)
    begin
        if anRst = '0' then
            cnt_s <= 0;
            cnt_m <= 0;
            cnt_h <= 0;
        elsif rising_edge(clk) then
            if rst = '1' then
                cnt_s <= 0;
                cnt_m <= 0;
                cnt_h <= 0;
            elsif ena = '1' then
                cnt_s <= cnt_s + 1;
                if cnt_s = 59 then
                    cnt_s <= 0;
                    cnt_m <= cnt_m + 1;
                    if cnt_m = 59 then
                        cnt_m <= 0;
                        cnt_h <= cnt_h + 1;
                        if cnt_h = 23 then
                            cnt_h <= 0;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            assert (cnt_s = TO_INTEGER(UNSIGNED(segundos_u) + UNSIGNED(segundos_d) * 10))
            report "ERROR CNT SECONDS EXPECTED" & integer'Image(cnt_s) & " ACTUAL "
            & integer'Image(TO_INTEGER(UNSIGNED(segundos_u) + UNSIGNED(segundos_d) * 10))
            severity failure;
            
            assert (cnt_m = TO_INTEGER(UNSIGNED(minutos_u) + UNSIGNED(minutos_d) * 10))
            report "ERROR CNT MINS EXPECTED" & integer'Image(cnt_m) & " ACTUAL "
            & integer'Image(TO_INTEGER(UNSIGNED(minutos_u) + UNSIGNED(minutos_d) * 10))
            severity failure;
            
            assert (cnt_h = TO_INTEGER(UNSIGNED(horas_u) + UNSIGNED(horas_d) * 10))
            report "ERROR CNT HOURS EXPECTED" & integer'Image(cnt_h) & " ACTUAL "
            & integer'Image(TO_INTEGER(UNSIGNED(minutos_u) + UNSIGNED(minutos_d) * 10))
            severity failure;
            
        end if;
    end process;
    

    u1: entity Work.cont_dec(rtl)
    port map(
        anRst => anRst,
        clk => clk,
        rst => rst,
        ena => ena,
        horas_u => horas_u,
        horas_d => horas_d,
        minutos_u => minutos_u,
        minutos_d => minutos_d,
        segundos_u => segundos_u,
        segundos_d => segundos_d
    );

end architecture rtl;