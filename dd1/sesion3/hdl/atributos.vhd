library ieee;
use ieee.std_logic_1164.all;

entity atributos is
end entity;

architecture test of atributos is

    type t_estado is (UNO, DOS, TRES, CUATRO);
    subtype byte_C2 is integer range -128 to 127;
    subtype byte_C2_inverso is integer range 127 downto -128;
    signal estado: t_estado;
    signal entero: integer;
    signal saludo: string(1 to 16) := "Hola como estas?";
    signal dato: string(1 to 2) := "23";
    signal std_l_v : std_logic_vector(3 downto 0) := "1011";
    signal clk: std_logic;
    signal clk_delay: std_logic;
    
begin

    process
    begin
        for i in 0 to 8 loop
            clk <= '0';
            wait for 20 ns;
            clk <= '1';
            wait for 30 ns;
        end loop;
        wait;
    end process;


-- Genere en la señal clk_delay una versión retrasada 10 ns de la señal clk

    clk_delay <= clk'delayed(10 ns);

    process
    begin
-- Las siguientes sentencias report hacen uso del atributo 'image para obtener un string con
-- la representacion del valor entre parentesis que debe ser del tipo al que se asocia el
-- atributo. Dicho string se concatena con el texto previo.

-- Por ejemplo (std_logic'right) es un valor definido para el tipo std_logic (concretamente '-')
-- y el atributo std_logic'image lo convierte en string
        report "Ultimo valor del tipo std_logic: " & std_logic'image(std_logic'right);

-- Analice esta otra sentencia:
        report "Subíndice más a la derecha del array std_l_v: " & natural'image(std_l_v'right);

-- Descomente y complete las siguientes sentencias para obtener el valor indicado en el texto previo
--
        report "Valor mas alto del tipo integer: " & integer'image(integer'high);
        report "Subíndice más alto del array std_l_v: " & natural'image(std_l_v'high);
        report "Primer valor del tipo t_estado: " & t_estado'image(t_estado'low);
        report "Valor a la izquierda de 'X' en el tipo std_logic: " & std_logic'image(std_logic'low);
        report "Posicion de '0' en el tipo std_logic: " & integer'image(std_logic'pos('0'));
        report "Valor siguiente a DOS del tipo t_estado: " & t_estado'image(t_estado'succ(DOS));
        report "Número de caracteres de la señal saludo: " & integer'image(saludo'length);
        report "Valor que precede a 26 en el tipo byte_C2: " & integer'image(byte_C2'pred(26));
        report "Primer valor del tipo byte_C2: " & integer'image(byte_C2'low);
        report "Valor entero del número contenido en el string 'dato': " & integer'image(integer'value(dato));
        report "Valor de la posición 3 del del tipo t_estado: " & t_estado'image(t_estado'val(3));

        entero <= integer'high;
        wait for 100 ns;

        entero <= byte_C2_inverso'left;
        report "La señal entero no ha variado en los últimos 100 ns: " & boolean'image(entero'stable(100 ns));
        wait for 100 ns;


-- Descomente y complete la siguiente sentencia para obtener el valor (true o false) indicado
-- en el texto previo
--
--    report "La señal entero no ha variado en los últimos 200 ns: " &
        entero <= byte_C2'right;
        wait for 100 ns;

-- Descomente y complete la siguiente sentencia para obtener el valor (true o false) indicado
-- en el texto previo
--
        report "La señal entero no ha variado en los últimos 200 ns: " & boolean'image(entero'stable(200 ns));

-- Descomente y complete la siguiente sentencia para obtener el valor (true o false) indicado
-- en el texto previo
--
        report "No se han proyectado asignaciones a entero en los últimos 200 ns: " & boolean'image(entero'quiet(200 ns));
        wait;

    end process;

end test;
