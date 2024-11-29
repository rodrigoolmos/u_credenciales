library ieee;
use std.textIO.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity test_mult_nbits_file is
end entity;

library std_developerskit;
use std_developerskit.std_iopak.all;

architecture test of test_mult_nbits_file is
  constant n : natural := 8;

  signal clk:              std_logic;
  signal nRst:             std_logic;
  signal start:            std_logic;
  signal OP1:              std_logic_vector(n-1 downto 0);
  signal OP2:              std_logic_vector(n-1 downto 0);
  signal result:           std_logic_vector(2*n - 1 downto 0);
  signal result_from_file: std_logic_vector(2*n - 1 downto 0);
  signal eop: std_logic;

  constant T_clk: time := 100 ns;
  
begin

  dut : entity work.mult_nbits(rtl_param)
    generic map(n => n)
    port map(
      clk => clk,
      nRst => nRst,
      start => start,
      OP1 => OP1,
      OP2 => OP2,
      result => result,
      eop => eop);

  process
  begin
    clk <= '0';
    wait for T_clk/2;
    clk <= '1';
    wait for T_clk/2;
  end process;

  process
    file file_auto : text open read_mode is "estimulos.txt";
    variable line_file : line;
    variable value_op1 : integer;
    variable value_op2 : integer;
    variable value_result : integer;
    variable delimiter : character;
  begin
    report "Tiempo de simulacion = 0";

    wait until clk'event and clk = '1';
    nRst <= '0';
    report "Activacion del reset asincrono";

    wait until clk'event and clk = '1';
    start <= '0';
    OP1 <= (others => '0');
    OP2 <= (others => '0');

    wait until clk'event and clk = '1';
    nRst <= '1';
    report "Desactivacion del reset asincrono";

    wait until clk'event and clk = '1';


    while not endfile(file_auto) loop
  
      readline(file_auto, line_file);
        read(line_file, value_op1);
        read(line_file, delimiter);
        read(line_file, value_op2);
        read(line_file, delimiter);
        read(line_file, value_result);

        start <= '1';
        OP1 <= CONV_STD_LOGIC_VECTOR(value_op1, OP1'length);
        OP2 <= CONV_STD_LOGIC_VECTOR(value_op2, OP2'length);
        result_from_file <= CONV_STD_LOGIC_VECTOR(value_result, result_from_file'length);
        wait until clk'event and clk = '1';

        start <= '0';
        wait until eop'event and eop = '1';
        wait until clk'event and clk = '1';

        assert conv_integer(result) = value_result
          report "Error en el resultado de la multiplicacion: " & "result:" & To_String(conv_integer(result), "%10d") & " result_from_file: " & To_String(conv_integer(result_from_file), "%10d")
          severity failure;
    end loop;

    assert false
    report "FIN"
      severity failure;
    wait;
  end process;
end test;