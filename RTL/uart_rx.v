library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    generic (
        clk_ticks: integer := 54 -- taken from (100_000_000 / 115200) / 16 = 54.25 ticks
        );
    port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        rx : in STD_LOGIC;
        byte : out STD_LOGIC_VECTOR (7 downto 0);
        write : out STD_LOGIC
        );
end uart_rx;

architecture Behavioral of uart_rx is
    -- define internal signals here
    type rx_state is (IDLE, START, DATA, STOP); -- defined states
    signal curr_state : rx_state := IDLE; -- initial state
    
    signal baud_clk : STD_LOGIC := '0';
    signal byte_i : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
begin
    -- define internal processes here
    
    -- first process is a clock generator that generates an oversampled
    -- clock signal to check for the rx signal
    clk_generator : process(clk, rst) 
        variable clk_count : integer range 0 to clk_ticks := 0;
    begin 
        if rst = '1' then
            clk_count := 0;
            baud_clk <= '0';
        elsif rising_edge(clk) then
            if clk_count = clk_ticks then
                clk_count := 0;
                baud_clk <= '1'; -- set high when clk count reaches 54
            else
                clk_count := clk_count + 1;
                baud_clk <= '0';
            end if;
        end if;
    end process;
    
    -- second process handles the state machine logic
    rx_FSM : process(clk, rst) 
        variable bit_count : integer range 0 to 7 := 0; -- check for where we are in the data word
        variable bit_duration : integer range 0 to 15 := 0; -- check if a logic level has stayed steady
    begin
        if rst = '1' then
            byte_i <= (others => '0'); -- reset data bus
            curr_state <= IDLE;
            bit_count := 0;
            bit_duration := 0;
            write <= '0';
        elsif rising_edge(clk) then
            if baud_clk = '1' then
                case curr_state is
                    when IDLE =>
                        byte_i <= (others => '0');
                        bit_count := 0;
                        bit_duration := 0;
                        write <= '0';
                        -- if the rx line gets pulled low then
                        if rx = '0' then
                            curr_state <= START;
                        end if;
                    when START =>
                        write <= '0';
                        if rx = '0' then
                            if bit_duration = 7 then
                                curr_state <= DATA;
                                bit_duration := 0;
                            else
                                bit_duration := bit_duration + 1;
                            end if;
                        else
                            curr_state <= IDLE;
                        end if;
                    when DATA =>
                        write <= '0';
                        if (bit_duration = 15) then                
                                byte_i(bit_count) <= rx;     
                                bit_duration := 0;
                                if (bit_count = 7) then -- we got 8 bits             
                                    curr_state <= STOP;
                                    bit_duration := 0;
                                else
                                    bit_count := bit_count + 1;
                                end if;
                            else
                                bit_duration := bit_duration + 1;
                            end if;
                    when STOP =>
                        if (bit_duration = 15) then      
                            if rx = '1' then  -- validate stop bit is HIGH
                                byte <= byte_i;
                                write <= '1';    
                                curr_state <= IDLE;
                            else
                            -- Invalid stop bit, frame error - reset
                                curr_state <= IDLE;
                            end if;
                        else
                            bit_duration := bit_duration + 1;
                        end if;
                    when others =>
                        curr_state <= IDLE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
