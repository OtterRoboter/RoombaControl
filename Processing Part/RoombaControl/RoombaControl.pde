/*------------------------------------------------------------------
  Roomba Control via BT and Processing for Android
 
-> Bluetooth connection to Processing for Android App:
Main parts based on Prof. Takaya's 'Connecting Android and Arduino by Bluetooth' sketch
http://prof-takaya.blogspot.de/2013/02/connecting-android-and-arduino-by.html

Rahel Flechtner, May 2018

-------------------------------------------------------------------*/


import controlP5.*;
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

KetaiBluetooth bt;
boolean isConfiguring = true;
String info = "";
KetaiList klist;
ArrayList devicesDiscovered = new ArrayList();

// add Button object for each categorie

ControlP5 Cp5;
ControlP5 Main;
ControlP5 plain;

boolean submissionSucessfull = false;
boolean showUI = false;
boolean inactive = true;


// Declare a variable of type PImage for each image
PImage img_toggle_stop;
PImage img_toggle_start;
PImage img_btn_straight;
PImage img_btn_turnLeft;
PImage img_btn_turnRight;
PImage img_btn_decreaseVelocity;
PImage img_btn_increaseVelocity;
PImage img_btn_circleLeft;
PImage img_btn_circleRight;
PImage img_btn_customProgram1;
PImage img_btn_customProgram2;
PImage img_btn_customProgram3;
PImage img_btn_customProgram4;
PImage img_btn_customProgram5;
PImage img_btn_customProgram6;
PImage img_btn_customProgram7;
PImage img_btn_customProgram8;
PImage img_element_line;
PImage img_element_circle;

PImage img_toggle_Off;
PImage img_toggle_On;
PImage img_toggle_cleanOn;
PImage img_toggle_cleanOff;

PImage img_btn_straight_pressed;
PImage img_btn_turnLeft_pressed;
PImage img_btn_turnRight_pressed;
PImage img_btn_decreaseVelocity_pressed;
PImage img_btn_increaseVelocity_pressed;
PImage img_btn_circleLeft_pressed;
PImage img_btn_circleRight_pressed;
PImage img_btn_customProgram1_pressed;
PImage img_btn_customProgram2_pressed;
PImage img_btn_customProgram3_pressed;
PImage img_btn_customProgram4_pressed;
PImage img_btn_customProgram5_pressed;
PImage img_btn_customProgram6_pressed;
PImage img_btn_customProgram7_pressed;
PImage img_btn_customProgram8_pressed;

PImage img_btn_backwards;
PImage img_btn_backwards_pressed;

PImage inactive_bw;

PImage img_loadingScreen;
PImage img_passiveMode;
PImage img_waiting;

String DeviceToConnect = "noName";

int textSpeed = 300;
int infoConv;

// Positions: 
int CPyPos;
int StartStop_yPos;


//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}




void setup() {
  size(displayWidth, displayHeight);
  background(237, 237, 237);
  println(displayHeight);

  // Make a new instance of a PImage by loading an image file
  img_toggle_stop = loadImage("img_toggle_stop.png");
  img_toggle_start = loadImage("img_toggle_start.png");
  img_btn_straight = loadImage("img_btn_straight.png");
  img_btn_turnLeft = loadImage("img_btn_turnLeft.png");
  img_btn_turnRight = loadImage("img_btn_turnRight.png");
  img_btn_decreaseVelocity = loadImage("img_btn_decreaseVelocity.png");
  img_btn_increaseVelocity = loadImage("img_btn_IncreaseVelocity.png");
  img_btn_circleLeft = loadImage("img_btn_circleLeft.png");
  img_btn_circleRight = loadImage("img_btn_circleRight.png");
  img_btn_customProgram1 = loadImage("img_btn_customProgram1.png");
  img_btn_customProgram2 = loadImage("img_btn_customProgram2.png");
  img_btn_customProgram3 = loadImage("img_btn_customProgram3.png");
  img_btn_customProgram4 = loadImage("img_btn_customProgram4.png");
  img_btn_customProgram5 = loadImage("img_btn_customProgram5.png");
  img_btn_customProgram6 = loadImage("img_btn_customProgram6.png");
  img_btn_customProgram7 = loadImage("img_btn_customProgram7.png");
  img_btn_customProgram8 = loadImage("img_btn_customProgram8.png");
  img_element_line = loadImage("img_element_line.png");
  img_element_circle = loadImage("img_element_circle.png");

  img_toggle_Off = loadImage("img_toggleSwitch_OFF.png");
  img_toggle_On = loadImage("img_toggleSwitch_ON.png");
  img_toggle_cleanOn = loadImage("img_toggle_cleanOn.png");
  img_toggle_cleanOff = loadImage("img_toggle_cleanOff.png");


  img_btn_straight_pressed = loadImage("img_btn_straight_pressed.png");
  img_btn_turnLeft_pressed = loadImage("img_btn_turnLeft_pressed.png");
  img_btn_turnRight_pressed = loadImage("img_btn_turnRight_pressed.png");
  img_btn_decreaseVelocity_pressed = loadImage("img_btn_decreaseVelocity_pressed.png");
  img_btn_increaseVelocity_pressed = loadImage("img_btn_IncreaseVelocity_pressed.png");
  img_btn_circleLeft_pressed = loadImage("img_btn_circleLeft_pressed.png");
  img_btn_circleRight_pressed = loadImage("img_btn_circleRight_pressed.png");
  img_btn_customProgram1_pressed = loadImage("img_btn_customProgram1_pressed.png");
  img_btn_customProgram2_pressed = loadImage("img_btn_customProgram2_pressed.png");
  img_btn_customProgram3_pressed = loadImage("img_btn_customProgram3_pressed.png");
  img_btn_customProgram4_pressed = loadImage("img_btn_customProgram4_pressed.png");
  img_btn_customProgram5_pressed = loadImage("img_btn_customProgram5_pressed.png");
  img_btn_customProgram6_pressed = loadImage("img_btn_customProgram6_pressed.png");
  img_btn_customProgram7_pressed = loadImage("img_btn_customProgram7_pressed.png");
  img_btn_customProgram8_pressed = loadImage("img_btn_customProgram8_pressed.png");

  img_btn_backwards = loadImage("img_btn_backwards.png");
  img_btn_backwards_pressed = loadImage("img_btn_backwards_pressed.png");

  inactive_bw = loadImage("inactive_bw.png");

  img_loadingScreen = loadImage("img_loadingScreen.png");
  img_waiting = loadImage("img_waiting.png");
  img_passiveMode = loadImage("img_passiveMode.png");


  //Set Positions: 
  CPyPos = 1920-144-50-222-10; //displayHeight-Interaktionsleiste unten-Abstand unten- eine Kachel- Abstand/2
  StartStop_yPos = 476+70 -(img_toggle_start.width/2); //((displayHeight/2)-(img_toggle_start.width/2))-430;



  Cp5 = new ControlP5(this);
  Main = new ControlP5(this);
  plain = new ControlP5(this);


  //start listening for BT connections
  bt.start();
  //at app start select device…
  isConfiguring = true;


  // Toggle Safe Mode On/Off
  Main.addToggle("SafeMode_OnOff")
    .setPosition(0, 0)
    .setImages(img_toggle_Off, img_toggle_On)
    .updateSize()
    .setState(false);


  //Toggle CLeaning on/off
  Cp5.addToggle("Cleaning_OnOff")
    .setPosition((displayWidth-210), 0)
    .setImages(img_toggle_cleanOff, img_toggle_cleanOn)
    .updateSize();

  //Button Left
  Cp5.addButton("Btn_Left")
    .setPosition(((displayWidth/2)-476), StartStop_yPos+(img_toggle_start.width/2)-404)
    .setImages(img_btn_turnLeft, img_btn_turnLeft, img_btn_turnLeft_pressed)   
    .updateSize();

  //Button Straight
  Cp5.addButton("Btn_Straight")
    .setPosition(((displayWidth/2)-(img_btn_straight.width/2)), StartStop_yPos+(img_toggle_start.width/2)-477)
    .setImages(img_btn_straight, img_btn_straight, img_btn_straight_pressed)   
    .updateSize();

  //Button Right
  Cp5.addButton("Btn_Right")
    .setPosition(((displayWidth/2)+142), StartStop_yPos+(img_toggle_start.width/2)-404)
    .setImages(img_btn_turnRight, img_btn_turnRight, img_btn_turnRight_pressed)   
    .updateSize();

  //Button Backwards
  Cp5.addButton("Btn_backwards")
    .setPosition(((displayWidth/2)-228), StartStop_yPos+(img_toggle_start.width/2)+232)
    .setImages(img_btn_backwards, img_btn_backwards, img_btn_backwards_pressed)   
    .updateSize();

  //toggle Start Stop
  Cp5.addToggle("Btn_StartStop")
    .setPosition(((displayWidth/2)-(img_toggle_start.width/2)), StartStop_yPos )
    .setImages(img_toggle_start, img_toggle_stop)
    .updateSize();

  //Circle Left
  Cp5.addButton("Btn_CircleLeft")
    .setPosition(((displayWidth/2)-476), StartStop_yPos+(img_toggle_start.width/2)+8)
    .setImages(img_btn_circleLeft, img_btn_circleLeft, img_btn_circleLeft_pressed)   
    .updateSize();

  //Circle Right
  Cp5.addButton("Btn_CircleRight")
    .setPosition(((displayWidth/2)+140), StartStop_yPos+(img_toggle_start.width/2)+8)
    .setImages(img_btn_circleRight, img_btn_circleRight, img_btn_circleRight_pressed)   
    .updateSize();

  //decrease Velocity
  Cp5.addButton("Btn_decreaseVelocity")
    .setPosition(((displayWidth/2)-232), StartStop_yPos+(img_toggle_start.width/2)+538)
    .setImages(img_btn_decreaseVelocity, img_btn_decreaseVelocity, img_btn_decreaseVelocity_pressed)   
    .updateSize();

  //increase Velocity
  Cp5.addButton("Btn_increaseVelocity")
    .setPosition(((displayWidth/2)+104), StartStop_yPos+(img_toggle_start.width/2)+538)
    .setImages(img_btn_increaseVelocity, img_btn_increaseVelocity, img_btn_increaseVelocity_pressed)   
    .updateSize();


  //Custom Program Buttons 1-8:

  //CP Btn 1:
  Cp5.addButton("Btn_CP1")
    .setPosition(((displayWidth/2)-474), (CPyPos - 232))
    .setImages(img_btn_customProgram1, img_btn_customProgram1, img_btn_customProgram1_pressed)   
    .updateSize();

  //CP Btn 2:
  Cp5.addButton("Btn_CP2")
    .setPosition(((displayWidth/2)-232), (CPyPos - 232))
    .setImages(img_btn_customProgram2, img_btn_customProgram2, img_btn_customProgram2_pressed)   
    .updateSize();

  //CP Btn 3:
  Cp5.addButton("Btn_CP3")
    .setPosition(((displayWidth/2)+10), (CPyPos - 232))
    .setImages(img_btn_customProgram3, img_btn_customProgram3, img_btn_customProgram3_pressed)   
    .updateSize();

  //CP Btn 4:
  Cp5.addButton("Btn_CP4")
    .setPosition(((displayWidth/2)+252), (CPyPos - 232))
    .setImages(img_btn_customProgram4, img_btn_customProgram4, img_btn_customProgram4_pressed)   
    .updateSize();

  //CP Btn 5:
  Cp5.addButton("Btn_CP5")
    .setPosition(((displayWidth/2)-474), (CPyPos + 10))
    .setImages(img_btn_customProgram5, img_btn_customProgram5, img_btn_customProgram5_pressed)   
    .updateSize();

  //CP Btn 6:
  Cp5.addButton("Btn_CP6")
    .setPosition(((displayWidth/2)-232), (CPyPos +10))
    .setImages(img_btn_customProgram6, img_btn_customProgram6, img_btn_customProgram6_pressed)   
    .updateSize();

  //CP Btn 7:
  Cp5.addButton("Btn_CP7")
    .setPosition(((displayWidth/2)+10), (CPyPos +10))
    .setImages(img_btn_customProgram7, img_btn_customProgram7, img_btn_customProgram7_pressed)   
    .updateSize();

  //CP Btn 8:
  Cp5.addButton("Btn_CP8")
    .setPosition(((displayWidth/2)+252), (CPyPos +10))
    .setImages(img_btn_customProgram8, img_btn_customProgram8, img_btn_customProgram8_pressed)   
    .updateSize();
}



void draw() {


  //---------------------- At app start select device to connect to

  // If not BT is configured yet but in the process of configuration
  if (isConfiguring)
  {
    ArrayList names;
    background(#484848);

    // klist = new KetaiList(this, bt.getPairedDeviceNames());
    bt.getPairedDeviceNames();
    bt.connectToDeviceByName("Roomba"); //choose the name of your Bluetooth Device here or rename it with "Roomba"
    isConfiguring = false;
  } else
  {

    if (bt.connectToDeviceByName("Roomba")) {
      Main.show();
      if (submissionSucessfull == true) {
        submissionSucessfull = false;
        showUI = true;
        Cp5.show();
        Main.show();
        //Cp5.getController("SafeMode_OnOff").show();
      }    
      displayUI();
    } else {
      Cp5.hide();
      Main.hide();
      imageMode(CORNER);
      image(img_loadingScreen, 0, 0); // Ladebildschirm
    }
  }
}



public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
}

// function buttonA will receive changes from 
// controller with name buttonA


public void SafeMode_OnOff (int theValue) { //SafeMode on/Off
  println("a button event from Btn_StartStop: " + theValue);
  if (theValue == 1) {
    print("SafeMode On");
    //send with BT
    byte[] data = {'t'};
    //println("sent 't'");
    bt.broadcast(data);
    showUI = true;
    inactive = false;
    waitForAnswer();
  } else if (theValue == 0) {
    Cp5.getController("Btn_StartStop").setValue(0);
    print("SafeMode Off");
    //send with BT
    byte[] data = {'u'};
    //println("sent 'u'");
    bt.broadcast(data);
    inactive = true;
    waitForAnswer();
  }
}  

public void Cleaning_OnOff (int theValue) { //Clean on/off
  println("a button event from Btn_StartStop: " + theValue);
  if (theValue == 1) {
    print("Cleaning on");
    //send with BT
    byte[] data = {'v'};
    //println("sent 'v'");
    bt.broadcast(data);
  } else if (theValue == 0) {
    print("Cleaning off");
    //send with BT
    byte[] data = {'w'};
    //println("sent 'w'");
    bt.broadcast(data);
  }
} 

public void Btn_Left (int theValue) {
  println("a button event from Btn_Left: "+theValue);
  //send with BT
  byte[] data = {'c'};
  println("sent 'c'");
  bt.broadcast(data);
}


public void Btn_StartStop (int theValue) {
  println("a button event from Btn_StartStop: " + theValue);
  if (theValue == 1) {
    print("Start");
    //send with BT
    byte[] data = {'a'};
    println("sent 'a'");
    bt.broadcast(data);
  } else if (theValue == 0) {
    print("Stop");
    //send with BT
    byte[] data = {'b'};
    println("sent 'b'");
    bt.broadcast(data);
  }
}  


public void Btn_Straight (int theValue) {
  println("a button event from Btn_Straight: "+theValue);
  //send with BT
  byte[] data = {'d'};
  println("sent 'd'");
  bt.broadcast(data);
}

public void Btn_Right (int theValue) {
  println("a button event from Btn_Right: "+theValue);
  //send with BT
  byte[] data = {'e'};
  println("sent 'e'");
  bt.broadcast(data);
}

public void Btn_backwards (int theValue) {
  println("a button event from Btn_Right: "+theValue);
  //send with BT
  byte[] data = {'y'};
  println("sent 'y'");
  bt.broadcast(data);
}


public void Btn_CircleLeft (int theValue) {
  println("a button event from Btn_CircleLeft: "+theValue);
  //send with BT
  byte[] data = {'f'};
  println("sent 'f'");
  bt.broadcast(data);
}

public void Btn_CircleRight (int theValue) {
  println("a button event from Btn_CircleRight: "+theValue);
  //send with BT
  byte[] data = {'g'};
  println("sent 'g'");
  bt.broadcast(data);
}

public void Btn_decreaseVelocity (int theValue) {
  println("a button event from Btn_decreaseVelocity: "+theValue);


  //send with BT
  byte[] data = {'h'};
  println("sent 'h'");
  bt.broadcast(data);
}

public void Btn_increaseVelocity (int theValue) {
  println("a button event from Btn_increaseVelocity: "+theValue);


  //send with BT
  byte[] data = {'i'};
  println("sent 'i'");
  bt.broadcast(data);
}




//Custom Program Buttons 1-8:

public void Btn_CP1 (int theValue) {
  println("a button event from Btn_CP1: "+theValue);

  //send with BT
  byte[] data = {'j'}; 
  println("sent 'j'");
  bt.broadcast(data);
}

public void Btn_CP2 (int theValue) {
  println("a button event from Btn_CP2: "+theValue);
  //send with BT
  byte[] data = {'k'};
  println("sent 'k'");
  bt.broadcast(data);
}

public void Btn_CP3 (int theValue) {
  println("a button event from Btn_CP3: "+theValue);
  //send with BT
  byte[] data = {'l'};
  println("sent 'l'");
  bt.broadcast(data);
}

public void Btn_CP4 (int theValue) {
  println("a button event from Btn_CP4: "+theValue);
  //send with BT
  byte[] data = {'m'};
  println("sent 'm'");
  bt.broadcast(data);
}

public void Btn_CP5 (int theValue) {
  println("a button event from Btn_CP5: "+theValue);
  //send with BT
  byte[] data = {'n'};
  println("sent 'n'");
  bt.broadcast(data);
}

public void Btn_CP6 (int theValue) {
  println("a button event from Btn_CP6: "+theValue);
  //send with BT
  byte[] data = {'o'};
  println("sent 'o'");
  bt.broadcast(data);
}

public void Btn_CP7 (int theValue) {
  println("a button event from Btn_CP7: "+theValue);
  //send with BT
  byte[] data = {'p'};
  println("sent 'p'");
  bt.broadcast(data);
}

public void Btn_CP8 (int theValue) {
  println("a button event from Btn_CP8: "+theValue);
  //send with BT
  byte[] data = {'s'};
  println("sent 's'");
  bt.broadcast(data);
}



// Bluetooth


//------------------------ For killing the list after you've selected a device to pair 
//void onKetaiListSelection(KetaiList klist) {
//  String selection = klist.getSelection();
//  bt.connectToDeviceByName(selection);
//  DeviceToConnect = selection;

//  //dispose of list for now
//  klist = null;
//}


//------------------------ Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data) {
  if (isConfiguring)
    return;
  //received
  info += new String(data);

  println (info);
  if (info.equals ("k")) {
    submissionSucessfull = true;

    //Modes
  } else if (info.equals ("p")) { // pasive Mode
    println("got a p");
    ((Toggle)Main.getController("SafeMode_OnOff")).setState(false);
    ((Toggle)Main.getController("SafeMode_OnOff")).setValue(0);
    ((Toggle)Cp5.getController("Cleaning_OnOff")).setState(false);
    ((Toggle)Cp5.getController("Btn_StartStop")).setState(false);
  } else if (info.equals ("-")) {
    ((Toggle)Cp5.getController("Btn_StartStop")).setState(false);
  } else {
    infoConv = int(info);
    if  ((infoConv >=0) && (infoConv <= 9)) {
      textSpeed = int(map(infoConv, 0, 9, -400, 500));
    }
    infoConv = 10;
  }
  info = "";
}