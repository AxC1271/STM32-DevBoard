# STM32 MCU Board

## 📖 Introduction
This repository is my first ever PCB design project. After working on projects that involved more digital circuits and RTL scripting, I've always wanted to build my own boards, specifically FPGA boards. However, I want to start on something simpler so I can understand the inner workings of PCB design, decision choices, and general concepts that are crucial to a functional STM32 board.

## 🛠️ Design Approach
Given that this is just a basic guide to designing, laying out, and manufacturing a simple STM32 board, this PCB will only offer a single USB port, an I2C interface, an SWD interface, and a UART interface. The specific processor chip that we are using is the STM32F103C8Tx, which uses an `ARM Cortex-M3 processor`. 

### ⚡ Power Regulator Circuit
<p align="center">
    <img width="800px" src="./Images/AMS1117Schematic.png" />
</p>
<p align="center">
    <em> LDO-Based Power Regulator Circuit.</em>
</p>

Here we have the external USB-B micro port that interfaces with our STM32 microcontroller. In order to use `VBUS` coming from this port, I stepped down any input voltage down to 3.3V using the **AMS1117** chip, which requires two `22uF` capacitors according to its datasheet, one at the input and one at the output. At the output, the 3.3V signal is then passed through an LED with a current limiting resistor as a visual indicator that the 3.3V source is present at the output.

<br />
Quick note about the shield option being ignored, generally the shield pin is to connect the board to an external chassis but because this is a standalone board, that's why it's ignored.

### 🔲 STM32F103C8T6 MCU
<p align="center">
    <img width="800px" src="./Images/STM32Schematic.png" />
</p>
<p align="center">
    <em>MCU Schematic with USB-B Micro Interface.</em>
</p>

First and foremost, there needs to be capacitors between the 3.3V source and ground. Since this specific STM32 microcontroller has 4 **VDD** pins, there must generally be a `100 nF` capacitor in parallel for each of these pins. These capacitors act as `decoupling capacitors`, ensuring a steady voltage supply to each VDD pin. In addition, a bulk capacitor with a value of `4.7 uF` is also placed in parallel to the decoupling capacitors to handle lower-frequency current swings, while the decoupling capacitors handle the higher frequency noise and transients.

## 🧩 PCB Layout

<p align="center">
    <img width="800px" src="./Images/PCBFullLayout.png" />
</p>
<p align="center">
    <em> Signal traces on the STM32 board, with power traces being 0.5mm while ordinary traces are kept at 0.3mm. Vias are used for ground traces. </em>
</p>

In general, vias are used to link ground pins to the ground plane. Most signals are routed on the top copper layer, with a couple of vias used to prevent signal crossing especially with the 3.3V bus. 
A copper pour was used near the voltage regulator to create ground and power planes whilst also reducing EMI and improving signal integrity.

Quick note: to further increase the stability of a 2-layer board like this, it is recommended to add as much stitching vias as possible, on top of adding a ground pour on the top layer. This is to decrease
the distance that sensitive signals have to travel to get to ground, reducing the inductance and therefore maximizing signal integrity.

## 🖼️ 3D View

<p align="center">
    <img width="800px" src="./Images/3DModel.png" />
</p>
<p align="center">
    <em> Front copper layer with all signal traces and silkscreens. </em>
</p>

## 🧪 Physical Board / Functionality

After passing a design rule check on KiCAD, it's time to send the files to a PCB manufacturer to get my board assembled. For this specific board, I'm using `JLCPCB`'s services to get my board manufactured. 

<p align="center">
    <img width="800px" src="./Images/PhysicalBoard.png" />
</p>
<p align="center">
    <em>Manufactured Board from JLCPCB.</em>
</p>

Unfortunately, I was unable to find the USB micro-B ports for these boards, but I still want to be able to program it using an ST-Linker that I found off of Amazon for roughly `$9`. 

## 💻 Code

To test the UART interface of this STM32 board, I'll write a simple UART transceiver on my Basys3 FPGA board to interface with it.

UART Receiver:
```Verilog
module uart_rx #(
    parameter CLK_TICKS = 54
)
(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output reg  [7:0] data
);

    typedef enum reg [1:0] {IDLE, START, DATA, STOP} rx_state_t;
    rx_state_t curr_state;

    reg baud_clk;
    reg [7:0] data_i;

    // clock generator process
    reg [6:0] clk_count; // enough to hold 0..CLK_TICKS
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 0;
            baud_clk <= 0;
        end else begin
            if (clk_count == CLK_TICKS) begin
                clk_count <= 0;
                baud_clk <= 1'b1;
            end else begin
                clk_count <= clk_count + 1;
                baud_clk <= 1'b0;
            end
        end
    end

    // process to handle uart_rx fsm
    integer bit_count;
    integer bit_duration;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_i <= 8'b0;
            curr_state <= IDLE;
            bit_count <= 0;
            bit_duration <= 0;
            data <= 8'b0;
        end else if (baud_clk) begin
            case (curr_state)
                IDLE: begin
                    data_i <= 8'b0;
                    bit_count <= 0;
                    bit_duration <= 0;
                    if (rx == 1'b0)
                        curr_state <= START;
                end

                START: begin
                    if (rx == 1'b0) begin
                        if (bit_duration == 7) begin
                            curr_state <= DATA;
                            bit_duration <= 0;
                        end else begin
                            bit_duration <= bit_duration + 1;
                        end
                    end else begin
                        curr_state <= IDLE;
                    end
                end

                DATA: begin
                    if (bit_duration == 15) begin
                        data_i[bit_count] <= rx;
                        bit_duration <= 0;
                        if (bit_count == 7) begin
                            curr_state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        bit_duration <= bit_duration + 1;
                    end
                end

                STOP: begin
                    if (bit_duration == 15) begin
                        data <= data_i;
                        curr_state <= IDLE;
                    end else begin
                        bit_duration <= bit_duration + 1;
                    end
                end

                default: curr_state <= IDLE;
            endcase
        end
    end

endmodule
```

Now we can write the C code for the STM32 to pass in some serial data to the Basys3 board and vice versa. We will interface using PlatformIO and write some firmware for the STM32 to transmit some characters to the FPGA. This is just one test code example:

```C
#include "stm32f1xx_hal.h"

UART_HandleTypeDef huart2;

void SystemClock_Config(void);
void MX_GPIO_Init(void);
void MX_USART2_UART_Init(void);
void Error_Handler(void);

int main(void) {
    HAL_Init();

    SystemClock_Config();

    MX_GPIO_Init();
    MX_USART2_UART_Init();

    char msg[] = "Hello, World!\r\n";

    while (1) {
        HAL_UART_Transmit(&huart2, (uint8_t*)msg, sizeof(msg) - 1, HAL_MAX_DELAY);
        HAL_Delay(1000);  
    }
}

void SystemClock_Config(void) {
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;  
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK) {
        Error_Handler();
    }

    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
                                | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2; 
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK) {
        Error_Handler();
    }
}

void MX_USART2_UART_Init(void) {
    huart2.Instance = USART2;
    huart2.Init.BaudRate = 115200;
    huart2.Init.WordLength = UART_WORDLENGTH_8B;
    huart2.Init.StopBits = UART_STOPBITS_1;
    huart2.Init.Parity = UART_PARITY_NONE;
    huart2.Init.Mode = UART_MODE_TX_RX;
    huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    huart2.Init.OverSampling = UART_OVERSAMPLING_16;
    if (HAL_UART_Init(&huart2) != HAL_OK) {
        Error_Handler();
    }
}

void MX_GPIO_Init(void) {
    __HAL_RCC_GPIOA_CLK_ENABLE();
    __HAL_RCC_AFIO_CLK_ENABLE();
    __HAL_RCC_PWR_CLK_ENABLE();
}

void Error_Handler(void) {
    while (1) {

    }
}
```

## 🎥 Video Demo

Here's the video link showing the Basys3 taking the 
daya bytes through a PMOD port from the STM32 MCU board
to show that communication is indeed possible from my 
fabricated board.

---
