
void checkBluetooth() {
  // Keep reading from HC-06 and send to Arduino Serial Monitor
  while (BT1.available() > 0)
  {
    command = BT1.read();
    //Serial.print(command);
  }

  // Keep reading from Arduino Serial Monitor and send to HC-06
  if (Serial.available())
  {
    BT1.write(Serial.read());
  }

  return true;
}

//******************************************************************************//

void remoteCmd()
{

  if (command != 'z') {
    // Serial.print("Entered loop");

    switch (command)
    {
      case 't': // Start Safe Mode
        wakeUp();
        startSafe();
        sayHello();
        Serial.println("Roomba in Safe mode");
        BT1.write('k');
        resetCommand();
        checkRoombaStatus = true;
        break;


      case 'u': // Stop Safe Mode, back to passive Mode
        Serial.println("Roomba in Passive mode");
        sayCiao();
        stop();
        powerOff();
        BT1.write('k');
        resetCommand();
        checkRoombaStatus = false;
        motorSpeed = 300;
        BT1.write('7'); // Send Motorspeed 300 to App
        break;


      case 'a': // start driving (straight)
        Serial.println("driving");
        drive (motorSpeed, 0);
        writeLEDs (' ', 'g', 'o', ' ');
        state = command;
        resetCommand();
        driving = true;
        break;


      case 'b': // Stop driving
        Serial.println("stopped");
        driveStop(); //turn off both motors
        writeLEDs ('s', 't', 'o', 'p');
        state = command;
        stopCircleLeft = true;
        stopCircleRight = true;
        BT1.write('k');
        resetCommand();
        driving = false;
        break;


      case 'c': // driving left
        Serial.println("turn left");
        if (driving == true) {
          driveLeft(motorSpeed);
        }
        writeLEDs ('l', 'e', 'f', 't');
        resetCommand();
        break;


      case 'd': // driving straight
        Serial.println("straight");
        if (driving == true) {
          drive (motorSpeed, 0);
        }

        writeLEDs (' ', 'g', 'o', ' ');
        state = command;
        resetCommand();
        break;


      case 'e': // driving right
        Serial.println("turn right");
        if (driving == true) {
          driveRight(motorSpeed);
        }
        writeLEDs ('r', 'i', 'g', 'h');
        resetCommand();
        break;

      case 'y': // driving backwards
        Serial.println("backwards");
        if (driving == true) {
          drive((motorSpeed * -1), 0);
        }
        resetCommand();
        break;


      case 'f': // circle left
        Serial.println("circle left");
        stopCircleRight = true;
        stopCircleLeft = !stopCircleLeft;
        if (stopCircleLeft == true) {
          BT1.write('-'); // toggles Start-Stop Button in App to stopped
          driving = false;
          setTime = 2000;
        } else if (stopCircleRight == false) {
          driving = true;
          lastMillis = millis();
          setTime = 4000;
        }
        resetCommand();
        break;


      case 'g': // circle right
        Serial.println("circle right");
        stopCircleLeft = true;
        stopCircleRight = !stopCircleRight;
        if (stopCircleRight == true) {
          BT1.write('-'); // toggles Start-Stop Button in App to stopped
          driving = false;
          setTime = 2000;
        } else if (stopCircleRight == false) {
          driving = true;
          lastMillis = millis();
          setTime = 4000;
        }
        resetCommand();
        break;



      case 'h': // decrease velocity
        motorSpeed = motorSpeed - 100;
        if (motorSpeed <= -400) {
          motorSpeed = -400;
        }
        //Serial.println(motorSpeed);
        sendVelocity();
        resetCommand();
        break;



      case 'i': // increase velocity
        motorSpeed = motorSpeed + 100;
        if (motorSpeed >= 500) {
          motorSpeed = 500;
        }
        //Serial.println(motorSpeed);
        sendVelocity();
        resetCommand();
        break;


      case 'j': // programmable task 1
        Serial.println("executing task 1");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'k': // programmable task 2
        Serial.println("executing task 2");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'l': // programmable task 3
        Serial.println("executing task 3");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'm': // programmable task 4
        Serial.println("executing task 4");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'n': // programmable task 5
        Serial.println("executing task 5");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'o': // programmable task 6
        Serial.println("executing task 6");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'p': // programmable task 7
        Serial.println("texecuting task 7");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 's': // programmable task 8
        Serial.println("executing task 8");
        writeLEDs ('t', 'a', 's', 'k');
        resetCommand();
        break;


      case 'v': // Start brushes for cleaning
        Serial.println("cleaning");
        writeLEDs ('v', 'a', 'c', ' ');
        startBrushes();
        resetCommand();
        break;


      case 'w': // Stop brushes
        Serial.println("stopped cleaning");
        cleanDigitLED ();
        stopBrushes();
        resetCommand();
        break;

      case 'x': // Wake up
        Serial.println("wake up");
        wakeUp();
        resetCommand();
        break;


    }

  }

}



