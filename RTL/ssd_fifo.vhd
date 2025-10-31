library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ssd_fifo is
    port (
        clk    : in  STD_LOGIC;                        
        rst    : in  STD_LOGIC;
        wr_val : in  STD_LOGIC_VECTOR(6 downto 0);     
        write  : in  STD_LOGIC;                        
        seg    : out STD_LOGIC_VECTOR(6 downto 0);    
        an     : out STD_LOGIC_VECTOR(3 downto 0)     
    );
end ssd_fifo;

architecture Behavioral of ssd_fifo is

    type ssd_array is array(0 to 3) of STD_LOGIC_VECTOR(6 downto 0);
    signal values : ssd_array := (others => (others => '1'));  -- blank digits

    signal scan_clk : STD_LOGIC := '0';
    signal scan_idx : integer range 0 to 3 := 0;

    -- edge detect signals
    signal write_d     : STD_LOGIC := '0';
    signal write_pulse : STD_LOGIC := '0';

begin

    -- edge detect write (single-cycle pulse)
    process(clk)
    begin
        if rising_edge(clk) then
            write_pulse <= write and not write_d;
            write_d     <= write;
        end if;
    end process;

    -- shift register process: shift on rising edge of main clk when write_pulse
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                values <= (others => (others => '1'));
            elsif write_pulse = '1' then
                -- shift left: oldest character moves left
                values(3) <= values(2);
                values(2) <= values(1);
                values(1) <= values(0);
                values(0) <= wr_val;  -- newest at rightmost
            end if;
        end if;
    end process;

    -- 1kHz scan clock for multiplexing
    clk_divider : process(clk)
        variable cnt : integer range 0 to 99_999 := 0;
    begin
        if rising_edge(clk) then
            if cnt = 99_999 then
                cnt := 0;
                scan_clk <= not scan_clk;
            else
                cnt := cnt + 1;
            end if;
        end if;
    end process;

    -- scan index for multiplexing
    mux_proc : process(scan_clk)
    begin
        if rising_edge(scan_clk) then
            if rst = '1' then
                scan_idx <= 0;
            else
                scan_idx <= (scan_idx + 1) mod 4;
            end if;
        end if;
    end process;

    an_sel : process(clk, rst, scan_idx)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                an <= "1111";
            else
                case scan_idx is
                    when 0 => 
                        an <= "1110"; -- rightmost
                    when 1 => 
                        an <= "1101";
                    when 2 => 
                        an <= "1011";
                    when 3 => 
                        an <= "0111"; -- leftmost
                    when others => 
                        an <= "1111";
                end case;
            end if;
        end if;
    end process;

    -- combinational output
    seg <= values(scan_idx);

end Behavioral;
