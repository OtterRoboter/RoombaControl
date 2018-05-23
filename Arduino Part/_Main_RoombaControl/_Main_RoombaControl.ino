/*------------------------------------------------------------------

*Roomba Control via BT and Processing for Android*
  
-> Main commands according IRobot Open Interface doc:  
http://www.irobotweb.com/~/media/MainSite/PDFs/About/STEM/Create/iRobot_Roomba_600_Open_Interface_Spec.pdf?la=enBasic 

-> Bluetooth connection to Processing for Android App:
Main parts based on Prof. Takaya's 'Connecting Android and Arduino by Bluetooth' sketch
http://prof-takaya.blogspot.de/2013/02/connecting-android-and-arduino-by.html

-> Arduino-Roomba communication:
Based on Marcelo Jose Rovai's ' iRobot Roomba Control via BT/Android' sketch.
https://github.com/Mjrovai/Roomba_BT_Ctrl


Rahel Flechtner, May 2018
-------------------------------------------------------------------*/

#define clamp(value, min, max) (value < min ? min : value > max ? max : value)
#define ON 1
#define OFF 0

//Motor Drive
# define MAX_SPEED 220 // 70% of top speed ==> 256
# define MIN_SPEED 70

#include <SoftwareSerial.h>



// Roomba Create2 connection
int rxPin = 10;
int txPin = 11;
SoftwareSerial Roomba(rxPin, txPin);

// BT Module (HC-06)
SoftwareSerial BT1(8, 9); // El pin 8 es Rx y el pin 9 es Tx


int ddPin = 2; // device detect

bool debrisLED;
bool spotLED;
bool dockLED;
bool warningLED;
byte color;
byte intensity;

char digit1;
char digit2;
char digit3;
char digit4;

int motorSpeed = 300;
int sendMotorSpeed;
int lastMotorSpeed;

char command = 'z'; // variable to store command received from IR or BT remote control
char state = 0;
int data = 0;
boolean stopCircleLeft = true;
boolean stopCircleRight = true;
boolean driving = false;


//blocking sensor functions - these will request data and wait until a response is recieved, then return the response

int getSensorData(byte sensorID);
int * getSensorData(byte numOfRequests, byte requestIDs[]);

bool getSensorData(byte * buffer, byte bufferLength);

byte single_byte_packets[22] = { 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 21, 24, 34, 35, 36, 37, 38, 45, 52, 53, 58};
bool is_in_array(byte val);

char chByte = 0;  // incoming serial byte
String strInput = "";    // buffer for incoming packet
String strCompare = "l";

int lastRoombaStatus = 1;
int RoombaStatus = 1;
float lastMillis = 0;
int setTime = 2000;
boolean checkRoombaStatus = false;


void setup() {

  // initialize serial:
  Serial.begin(19200);
  Roomba.begin(19200);
  BT1.begin(19200);

  Serial.println("Roomba Remote Control");
  pinMode(ddPin, OUTPUT);

  // Initial Wakeup
  wakeUp();
  startSafe();
  delay(500);
  BT1.write('p'); // Set RemoteApp to Off-Mode
  // turn-off all LEDs and Display
  //playSound(2);
  setPowerLED(0, 250);
  setDebrisLED(OFF);
  setDockLED(OFF);
  setSpotLED(OFF);
  setWarningLED(OFF);
  cleanDigitLED ();
  stop();
  powerOff();

  lastMillis = millis();
  Serial.println("Roomba is ready");
}


void loop() {
  CheckStatus();
  checkBluetooth();
  remoteCmd();
  UpdateBehaviour();
}






