import ddf.minim.*;
import g4p_controls.*; // GUI, buttons etc.
import processing.video.*; // camera
import java.awt.Font; // Custom GUI


Minim minim;
AudioPlayer fear, happiness, pain, sadness;
Capture cam; // camera
int flag = 0; // change screens
PImage banner; 
GButton start, home, audio, text, image, data;
PFont Font1, Font2;


void setup () {
  size(1280, 720);
  background(#FFFFFF);
  Font1 = createFont("Arial Bold", 54);
  Font2 = createFont("Arial", 18);
  cam=new Capture(this, 1280, 720, "pipeline:autovideosrc"); // przypisanie rozdzielczości kamery
  cam.start();
  banner = loadImage("baner.jpg");
  createGUI();
  customGUI();
  minim = new Minim(this);
  pain = minim.loadFile("pain.wav");
  happiness = minim.loadFile("happiness.wav");
  sadness = minim.loadFile("sadness.wav");
  fear = minim.loadFile("fear.wav");
}

void draw() {
  if (flag == 0) {
    background(#FFFFFF);
    landing_page();
    start.setVisible(true);
    home.setVisible(false);
    audio.setVisible(false);
    text.setVisible(false);
    image.setVisible(false);
    data.setVisible(false);
  } else if (flag == 1 && cam.available() == true) {
    background(#FFFFFF);
    start.setVisible(false);
    home.setVisible(true);
    audio.setVisible(true);
    text.setVisible(true);
    image.setVisible(true);
    data.setVisible(true);
    cam.read();
    set(0, 62, cam);
  }
}

//GUI, start page 
void landing_page () {
  image(banner, 650, 120, 487, 487);
  textFont(Font1);
  textSize(54);
  fill(#212121);
  textLeading(64);
  text("Facial Emotion Recognition", 142, 200, 488, 140);
  textFont(Font2);
  textSize(18);
  fill(#616161);
  textLeading(26);
  text("Easy and simple detection of human feelings at a specific moment.", 142, 360, 340, 50);
}

// buttons for GUI from G4P library
public void createGUI() {
  start = new GButton(this, 142, 470, 213, 56, "START");
  start.setFont(new Font("Arial", Font.BOLD, 16));
  start.addEventHandler(this, "buttonClick");

  home = new GButton(this, 40, 20, 80, 22, "Home");
  home.setFont(new Font("Arial", Font.BOLD, 18));
  home.addEventHandler(this, "homeClick");

  audio = new GButton(this, 420, 20, 80, 22, "Audio");
  audio.setFont(new Font("Arial", Font.BOLD, 18));
  audio.addEventHandler(this, "audioClick");

  text = new GButton(this, 540, 20, 80, 22, "Text");
  text.setFont(new Font("Arial", Font.BOLD, 18));
  text.addEventHandler(this, "textClick");

  image = new GButton(this, 660, 20, 80, 22, "Image");
  image.setFont(new Font("Arial", Font.BOLD, 18));
  image.addEventHandler(this, "imageClick");

  data = new GButton(this, 780, 20, 80, 22, "Data");
  data.setFont(new Font("Arial", Font.BOLD, 18));
  data.addEventHandler(this, "dataClick");
}

// button settings, color scheme
void customGUI() {
  start.setLocalColorScheme(G4P.RED_SCHEME);
  start.setLocalColor(4, color(#EC407A)); // change button background
  start.setLocalColor(6, color(#9D2D53)); // change button hover background
  start.setLocalColor(3, color(#EC407A)); // change outlines of buttons
  start.setLocalColor(2, color(#FFFFFF)); // change button text color

  home.setLocalColorScheme(G4P.RED_SCHEME);
  home.setLocalColor(4, color(#FFFFFF)); // change button background
  home.setLocalColor(6, color(#FFFFFF)); // change button hover background
  home.setLocalColor(3, color(#FFFFFF)); // change outlines of buttons
  home.setLocalColor(2, color(#212121)); // change button text color

  audio.setLocalColorScheme(G4P.RED_SCHEME);
  audio.setLocalColor(4, color(#FFFFFF)); // change button background
  audio.setLocalColor(6, color(#FFFFFF)); // change button hover background
  audio.setLocalColor(3, color(#FFFFFF)); // change outlines of buttons
  audio.setLocalColor(2, color(#212121)); // change button text color

  text.setLocalColorScheme(G4P.RED_SCHEME);
  text.setLocalColor(4, color(#FFFFFF)); // change button background
  text.setLocalColor(6, color(#FFFFFF)); // change button hover background
  text.setLocalColor(3, color(#FFFFFF)); // change outlines of buttons
  text.setLocalColor(2, color(#212121)); // change button text color

  image.setLocalColorScheme(G4P.RED_SCHEME);
  image.setLocalColor(4, color(#FFFFFF)); // change button background
  image.setLocalColor(6, color(#FFFFFF)); // change button hover background
  image.setLocalColor(3, color(#FFFFFF)); // change outlines of buttons
  image.setLocalColor(2, color(#212121)); // change button text color

  data.setLocalColorScheme(G4P.RED_SCHEME);
  data.setLocalColor(4, color(#FFFFFF)); // change button background
  data.setLocalColor(6, color(#FFFFFF)); // change button hover background
  data.setLocalColor(3, color(#FFFFFF)); // change outlines of buttons
  data.setLocalColor(2, color(#212121)); // change button text color
}

// event on buttons
public void buttonClick(GButton button, GEvent event) {
  if (button == start && event == GEvent.CLICKED) {
    flag=1;
  }
}

public void homeClick(GButton button, GEvent event) {
  if (button == home && event == GEvent.CLICKED) {
    flag=0;
  }
}

public void audioClick(GButton button, GEvent event) {
  if (button == audio && event == GEvent.CLICKED) {
    happiness.play();
    happiness.rewind();
    happiness.play();
  }
}

public void textClick(GButton button, GEvent event) {
  if (button == text && event == GEvent.CLICKED) {
    // name of emotions clos to head
  }
}

public void imageClick(GButton button, GEvent event) {
  if (button == image && event == GEvent.CLICKED) {
    // 3d shape on head
  }
}

public void dataClick(GButton button, GEvent event) {
  if (button == data && event == GEvent.CLICKED) {
    // show frame and points around head
  }
}
