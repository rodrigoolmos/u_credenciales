library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_top is
    port(
        clk : in std_logic;
        anrst : in std_logic;
        rst : in std_logic;
        segDisp : buffer std_logic_vector(6 downto 0);
        muxDisp : buffer std_logic_vector(5 downto 0)
    );
end entity;

architecture top of clock_top is

    signal horas_u : std_logic_vector(3 downto 0);
    signal horas_d : std_logic_vector(3 downto 0);
    signal minutos_u : std_logic_vector(3 downto 0);
    signal minutos_d : std_logic_vector(3 downto 0);
    signal segundos_u : std_logic_vector(3 downto 0);
    signal segundos_d : std_logic_vector(3 downto 0);
    signal BI : std_logic_vector(5 downto 0);
    signal f_1Hz : std_logic;
    signal mux_cnt : unsigned(25 downto 0) ;

begin

    process (clk, anrst)
    begin
        if anrst = '0' then
            BI <= "111110";
            mux_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if mux_cnt < 50000 then
                mux_cnt <= mux_cnt + 1;
            else
                mux_cnt <= (others => '0');
                BI <= BI(4 downto 0) & BI(5);     
            end if;
            
        end if;
    end process;

    cnt_dec: entity Work.cont_dec(rtl)
    port map(
        anRst => anRst,
        clk => clk,
        rst => rst,
        ena => f_1Hz,
        horas_u => horas_u,
        horas_d => horas_d,
        minutos_u => minutos_u,
        minutos_d => minutos_d,
        segundos_u => segundos_u,
        segundos_d => segundos_d
    );

    timer: entity Work.timer_1Hz(rtl)
    generic map(
        fin_cuenta => 5
    )
    port map( nRST  => anrst,
        clk   => clk,
        f_1Hz => f_1Hz
    );

    s_u: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => segundos_u,
        segDisp => segDisp,
        BI => BI(0)
    );

    s_d: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => segundos_d,
        segDisp => segDisp,
        BI => BI(1)
    );

    m_u: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => minutos_u,
        segDisp => segDisp,
        BI => BI(2)
    );
    
    m_d: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => minutos_d,
        segDisp => segDisp,
        BI => BI(3)
    );

    h_u: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => horas_u,
        segDisp => segDisp,
        BI => BI(4)
    );
    
    h_d: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => horas_d,
        segDisp => segDisp,
        BI => BI(5)
    );

end top;