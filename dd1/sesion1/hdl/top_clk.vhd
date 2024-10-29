library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_top is
    generic(
        clk_frec : natural := 50000000
    );
    port(
        clk : in std_logic;
        anrst : in std_logic;
        rst : in std_logic;
        BI : in std_logic;
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
    signal f_1Hz : std_logic;
    signal mux_cnt : unsigned(30 downto 0) ;
    type segDispArray is array (5 downto 0) of std_logic_vector(6 downto 0);
    signal segDisp_vec : segDispArray;
    signal disp_sel :  std_logic_vector(5 downto 0);

    
begin

    process (anrst, clk)
    begin
        if anrst = '0' then
            mux_cnt <= (0 => '1', others => '0');
            disp_sel <= "000001";
        elsif clk = '1' and clk'event then
            if mux_cnt < clk_frec/1000 then
                mux_cnt <= mux_cnt + 1;
            else
                mux_cnt <= (0 => '1', others => '0');
                disp_sel <= disp_sel(4 downto 0) & disp_sel(5);
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
        fin_cuenta => clk_frec
    )
    port map( nRST  => anrst,
        clk   => clk,
        f_1Hz => f_1Hz
    );

    s_u: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => segundos_u,
        segDisp => segDisp_vec(0),
        BI => BI
    );

    s_d: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => segundos_d,
        segDisp => segDisp_vec(1),
        BI =>BI
    );

    m_u: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => minutos_u,
        segDisp => segDisp_vec(2),
        BI => BI
    );
    
    m_d: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => minutos_d,
        segDisp => segDisp_vec(3),
        BI => BI
    );

    h_u: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => horas_u,
        segDisp => segDisp_vec(4),
        BI => BI
    );
    
    h_d: entity Work.decodBCD7seg(rtl)
    port map(
        digBCD => horas_d,
        segDisp => segDisp_vec(5),
        BI => BI
    );
    
    segDisp <= segDisp_vec(0) when disp_sel = "000001" else
    segDisp_vec(1) when disp_sel = "000010" else
    segDisp_vec(2) when disp_sel = "000100" else
    segDisp_vec(3) when disp_sel = "001000" else
    segDisp_vec(4) when disp_sel = "010000" else
    segDisp_vec(5) when disp_sel = "100000";
    
    muxDisp <= not disp_sel;

end top;