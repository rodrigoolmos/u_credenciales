package auxiliar is
 -- La función ceil_log calcula el mínimo valor, n, que
 -- cumple que 2**n es mayor o igual que x 
 function ceil_log(x: in natural) return natural; 
 
end package;

package body auxiliar is
function ceil_log(x: in natural) return natural is
 begin
 
 for n in 1 to 16 loop
   if 2**n >= x then
     return n;
   end if;
 end loop;
 return 0; --error
end ceil_log; 
 
end package body;   
