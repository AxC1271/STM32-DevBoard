library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_controller is
    port (
        clk     : in STD_LOGIC;
        rst     : in STD_LOGIC;
        rx      : in STD_LOGIC;
        data    : out STD_LOGIC_VECTOR(7 downto 0);
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        ade     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end uart_controller;

architecture Behavioral of uart_controller is
    -- define modules here
    component uart_rx is
        port (
            clk   : in STD_LOGIC;
            rst   : in STD_LOGIC;
            rx    : in STD_LOGIC;
            byte  : out STD_LOGIC_VECTOR(7 downto 0);
            write : out STD_LOGIC
        );
    end component;
    
    component ascii_ssd_decoder is
        port (
            ascii   : in STD_LOGIC_VECTOR(7 downto 0);
            seg_ssd : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    component ssd_fifo is
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            wr_val  : in STD_LOGIC_VECTOR(6 downto 0);
            write   : in STD_LOGIC;
            seg : out STD_LOGIC_VECTOR(6 downto 0);
            an  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    -- define internal signals here
    signal data_i  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal seg_i : STD_LOGIC_VECTOR(6 downto 0) := (others => '1');    
    signal write_i : STD_LOGIC := '0';
    
begin
    -- instantiate modules here
    rx_receiver : uart_rx
        port map (
            clk   => clk,
            rst   => rst,
            rx    => rx,
            byte  => data_i, -- needs to be propagated to the decoder
            write => write_i -- needs to be passed to ssd_fifo module
        );
        
    decoder : ascii_ssd_decoder
        port map (
            ascii => data_i, -- data is originally in ascii, we need to convert
            seg_ssd => seg_i
        );
        
    mem : ssd_fifo
        port map (
            clk => clk,
            rst => rst,
            wr_val => seg_i,
            write => write_i,
            seg => seg,
            an => ade
        );
        
    data <= data_i;
    
end Behavioral;
