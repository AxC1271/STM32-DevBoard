#include "main.h"
#include "stm32f1xx_hal.h"

UART_HandleTypeDef huart2;

int main(void) {
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();
    MX_USART2_UART_Init();

    char num = '0';

    while (1) {
        HAL_UART_Transmit(&huart2, (uint8_t*)&num, 1, HAL_MAX_DELAY);
        num++;
        if (num > '9') num = '0';  
        HAL_Delay(1000);         
    }
}
