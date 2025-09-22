#include <Arduino.h>
#include <HardwareSerial.h>

// TX pin: PB6, RX pin: PB7 (for UART1)
HardwareSerial Serial1(PB7, PB6); // RX, TX pins

unsigned long lastByteTime = 0;
const unsigned long byteInterval = 1000; // send each byte every 1 second
const char message[] = "Hello "; // message to send
int currentByteIndex = 0;
const int messageLength = 6; 

void setup() {
  Serial1.begin(115200); // uart receiver has baud rate of 115200
  
  Serial.begin(115200);
  Serial.println("STM32 UART Transmitter Started");
  Serial.println("Transmitting 'Hello' - one byte per second");

}

void loop() {
  if (millis() - lastByteTime >= byteInterval) {
    
    char currentByte = message[currentByteIndex];
    Serial1.write(currentByte);
    
    Serial.print("Transmitted byte: '");
    Serial.print(currentByte);
    Serial.print("' (ASCII: ");
    Serial.print((int)currentByte);
    Serial.println(")");

    digitalWrite(PC13, !digitalRead(PC13));
    
    currentByteIndex++;
    if (currentByteIndex >= messageLength) {
      currentByteIndex = 0; 
      Serial.println("--- Message complete, restarting ---");
    }
    
    lastByteTime = millis();
  }
  
  delay(10);
}
