void sayHello() {
  for (int i = 150; i > 0; i = i - 10) { // Turns green power light slowly off
    delay(80);
    setPowerLED(0, i);
  }
  //playSound(1);
  writeLEDs (' ', 'h', 'i', ' ');
  for (int i = 0; i < 150; i = i + 10) { //  Turns red power light slowly on
    delay(80);
    setPowerLED(128, i);
  }
  setPowerLED(128, 250);
  delay(1500);
  cleanDigitLED ();
}



void sayCiao() {
  //playSound (3);
  writeLEDs ('c', 'i', 'a', 'o');
  delay(1000);


  for (int i = 150; i > 0; i = i - 10) { //  Turns red power light slowly off
    delay(100);
    setPowerLED(128, i);
  }
  cleanDigitLED ();

  for (int i = 0; i < 150; i = i + 10) { // Turns green power light slowly on
    delay(100);
    setPowerLED(0, i);
  }
  setPowerLED(0, 250);

  // turn-off all LEDs and Display
  setDebrisLED(OFF);
  setDockLED(OFF);
  setSpotLED(OFF);
  setWarningLED(OFF);

}


void startBrushes()
{
  Roomba.write(138);
  // Roomba.write(7 >> 8));
  Roomba.write(7);
  delay(1000);
}

void stopBrushes()
{
  Roomba.write(138);
  // Roomba.write(0 >> 8);
  Roomba.write((byte)0x00);
  delay(1000);
}


void resetCommand() {
  command = 'z';
}

void sendVelocity() {
  sendMotorSpeed = map(motorSpeed, -400, 500, 48, 57);
  BT1.write(sendMotorSpeed);
}

void CheckStatus() {
  if (millis() - lastMillis <= setTime) {
    return;
  } else if ((millis() - lastMillis > setTime) && (checkRoombaStatus == true)) {
    
//    if (driving == false) {
//    BT1.write('-'); // toggles Start-Stop Button in App to stopped
//    }
    lastRoombaStatus = RoombaStatus;
    RoombaStatus = getSensorData(35);
    delay(100);
    //Serial.print(RoombaStatus);
    lastMillis = millis();
    if (RoombaStatus != lastRoombaStatus) {
      if (RoombaStatus == 1) {
        BT1.write('p'); //Sets App to Off-Mode
        cleanDigitLED ();
        checkRoombaStatus = false;
        BT1.write('7'); // Send Motorspeed 300 to App
        motorSpeed = 300;
      } 
    }
  }
}

  void UpdateBehaviour() {

  if (stopCircleRight == false) { // makes Roomba drive in a cricle cw until stopped
    turnCW (motorSpeed, 20);
  }

  if (stopCircleLeft == false) { // makes Roomba drive in a cricle ccw until stopped
    turnCCW (motorSpeed, 20);
  } 
 
   if ((driving == true) && (motorSpeed != lastMotorSpeed)) { // Changes speed while Roomba is driving
    drive (motorSpeed, 0);
    Serial.print("changeSpeed");
  }
  lastMotorSpeed = motorSpeed;
  return true;
}


