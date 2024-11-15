library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity aserciones_tb is
end entity;

architecture test of aserciones_tb is

    signal nRST:          std_logic;
    signal clk:           std_logic;
    signal D_in:          std_logic;
    signal D_out:         std_logic;
    constant T_CLK:       time := 10 ns;

begin

    dut: entity work.aserciones(rtl)
    port map(
        nRST => nRST,
        clk => clk,
        D_in => D_in,
        D_out => D_out);

    process
    begin
        clk <= '0';
        wait for T_CLK/2;
        clk <= '1';
        wait for T_CLK/2;
    end process;

    process
    begin
        nRST <= '0';
        wait for 3*T_CLK/5;
        nRST <= '1';
        wait;
    end process;

    process
    begin
        D_in <= '0';
        wait until nRST'event and nRST = '1';
        wait until clk'event and clk = '1';
        wait for T_CLK/2;
        for j in 1 to 7 loop
            D_in <= '1';
            wait for T_CLK/2;
            D_in <= '0';
            wait for (T_CLK/2) + 1 ns;
        end loop;

        assert false
        report "Fin de la simulación"
        severity failure;
    end process;

    process(D_in, clk)
    begin
        if clk'event and clk = '1' then
            assert D_in'stable(2 ns)
            report "Violated set up time"
            severity warning;
        end if;

        if D_in'event and clk = '1' then
            assert clk'last_event > 1 ns
            report "Violated set hold time"
            severity warning;
        end if;
    end process;

end test;

