
void waitForAnswer() {
  Cp5.hide();
  Main.show();
  showUI = false;
}

void displayUI() {
  Main.show();

  if ((showUI == false)&&(inactive == false)) { 
    background(237, 237, 237);
    imageMode(CORNER);
    image(img_waiting, 0, 0);
  }

  if ((showUI == true) && (inactive != true)) {
    //After configuration everything happens here

    background(237, 237, 237);
    Main.show();
    Cp5.show();

    textAlign(CENTER);
    textSize(40);
    fill(#141414);
    textSize(30);
    text("mm/s", (displayWidth/2), StartStop_yPos+(img_toggle_start.width/2)+588+70);
    text(info, (displayWidth/2), StartStop_yPos+(img_toggle_start.width/2)+588+70+50);
    textSize(90);
    text(textSpeed, (displayWidth/2), StartStop_yPos+(img_toggle_start.width/2)+610);
  } 

  if (inactive == true) {
    background(237, 237, 237);
    Cp5.hide();
    Main.show();
    imageMode(CORNER);
    image(img_passiveMode, 0, 0);
  }
}