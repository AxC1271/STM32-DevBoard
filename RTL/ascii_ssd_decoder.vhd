library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ascii_ssd_decoder is
    port (
        ascii     : in STD_LOGIC_VECTOR(7 downto 0);
        seg_ssd   : out STD_LOGIC_VECTOR(6 downto 0)
    );
end ascii_ssd_decoder;

architecture Behavioral of ascii_ssd_decoder is
    -- define internal signals here
begin
    -- define internal processes here
    decoder : process(ascii)
    begin
        case ascii is
            when x"30" => -- 0
                seg_ssd <= "0000001";
            when x"31" => -- 1
                seg_ssd <= "1001111";
            when x"32" => -- 2
                seg_ssd <= "0010010";
            when x"33" => -- 3
                seg_ssd <= "0000110";
            when x"34" => -- 4
                seg_ssd <= "1001100";
            when x"35" => -- 5
                seg_ssd <= "0100100";
            when x"36" => -- 6
                seg_ssd <= "0100000";
            when x"37" => -- 7
                seg_ssd <= "0001111";
            when x"38" => --8
                seg_ssd <= (others => '0'); 
            when x"39" => -- 9
                seg_ssd <= "0000100";
            when x"41" | x"61" => -- A/a
                seg_ssd <= "0001000";
            when x"42" | x"62" => -- B/b
                seg_ssd <= "1100000";
            when x"43" | x"63" => -- C/c
                seg_ssd <= "1110010";
            when x"44" | x"64" => -- D/d
                seg_ssd <= "1000010";
            when x"45" | x"65" => -- E/e
                seg_ssd <= "0110000";
            when x"46" | x"66" => -- F/f
                seg_ssd <= "0111000";
            when x"47" | x"67" => -- G/g
                seg_ssd <= "0100001";
            when x"48" | x"68" => -- H/h
                seg_ssd <= "1001000";
            when x"49" | x"69" => -- I/i
                seg_ssd <= "0101111";
            when x"4A" | x"6A" => -- J/j
                seg_ssd <= "1000011";
            when x"4C" | x"6C" => -- L/l
                seg_ssd <= "1110001";
            when x"4E" | x"6E" => -- N/n
                seg_ssd <= "1101010";
            when x"4F" | x"6F" => -- O/o
                seg_ssd <= "1100010";
            when x"50" | x"70" => -- P/p
                seg_ssd <= "0011000";
            when x"52" | x"72" => --R/r
                seg_ssd <= "1111010";
            when x"54" | x"74" => -- T/t
                seg_ssd <= "1110000";
            when x"55" | x"75" => -- U/u
                seg_ssd <= "1100011";
            when x"59" | x"79" => -- Y/y
                seg_ssd <= "1000100"; 
            when others => -- spaces or invalid chars
                seg_ssd <= (others => '1');
        end case;
    end process;
end Behavioral;
