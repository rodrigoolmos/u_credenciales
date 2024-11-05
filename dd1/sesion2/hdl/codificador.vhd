library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity codificador is
    port(D_in:       in  std_logic_vector(7 downto 0);
        enable:     in  std_logic;
        D_out:      out std_logic_vector(2 downto 0));
end entity;

architecture rtl_1 of codificador is
begin
    process(all)
    variable tmp: std_logic_vector(2 downto 0);
    
    begin
        tmp := 3X"0";
        if enable then
            for i in 7 downto 0 loop
                if D_in(i) then
                    tmp := tmp + i;
                    exit;
                    
                end if;
            end loop;
        end if;
        D_out <= tmp;
        
    end process;
end rtl_1;

architecture rtl_2 of codificador is
begin
    
    process(all)
    begin
        if enable then
            case? D_in is
                when "1-------" => D_out <= "111";
                when "01------" => D_out <= "110";
                when "001-----" => D_out <= "101";
                when "0001----" => D_out <= "100";
                when "00001---" => D_out <= "011";
                when "000001--" => D_out <= "010";
                when "0000001-" => D_out <= "001";
                when "00000001" => D_out <= "001";

                when others => D_out <= "000";
                    
            end case?;
        else
            D_out <= "000";
        end if;
    end process;
    
end rtl_2;

