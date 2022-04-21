import ddf.minim.*;
import g4p_controls.*; // GUI, buttons etc.
import processing.video.*; // camera
import jp.nyatla.nyar4psg.*; // import biblioteki nyar4psg, umożliwia odczyt znaczników
import gab.opencv.*;
import processing.video.*;
import java.awt.*;


Minim minim;
AudioPlayer anger, disgust, fear, happiness, neutral, sadness, surprise;
Capture cam; // camera
int flag = 0; // change screens
PImage banner; 
GButton start, home, audio, text, image, data;
PFont Font1, Font2;
MultiMarker nya;
OpenCV opencv;
List<FaceTracker> trackers;
int timer = 0;
int musicTimer = 0;

PImage model3D; // zmienna dla obraza

void setup () {
  size(640, 532); // zwiekszenie rozmiaru o rozmiar gui
  background(#FFFFFF);

  cam = new Capture(this, 640, 480, "pipeline:autovideosrc");
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  cam.start();
  minim = new Minim(this); // do dzwiekow

  banner = loadImage("data/baner.jpg");
  Font1 = createFont("Arial Bold", 26);
  Font2 = createFont("Arial", 10);
  anger = minim.loadFile("data/anger.wav"); // ladowanie dzwięków
  disgust = minim.loadFile("data/disgust.wav");
  fear = minim.loadFile("data/fear.wav");
  happiness = minim.loadFile("data/happiness.wav");
  neutral = minim.loadFile("data/neutral.wav");
  sadness = minim.loadFile("data/sadness.wav");
  surprise = minim.loadFile("data/surprise.wav");

  nya = new MultiMarker(this, width, height, "data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("data/31.patt", 80); //dodanie znaczników do zmiennej
  nya.addARMarker("data/37.patt", 80);
  nya.addARMarker("data/47.patt", 80);
  nya.addARMarker("data/89.patt", 80);

  trackers = new ArrayList<FaceTracker>();
  for (int i = 0; i < 10; i++) { // maks 10 twarzy
    FaceTracker tracker = new FaceTracker(); // oszczedzanie czasu na inicjalizacje trackerow
    trackers.add(tracker);
  }

  createGUI();
  customGUI();
}

void draw() {
  
  model3D = loadImage("unknown.png"); // ladowanie "defoltowego" wyrazu twarzy
  
  if (flag == 0) { // ekran poczatkowy
    background(#FFFFFF);
    landing_page();
    start.setVisible(true);
    home.setVisible(false);
    audio.setVisible(false);
    text.setVisible(false);
    image.setVisible(false);
    data.setVisible(false);
  } else if (flag == 1 && cam.available() == true) { // dzialajacy program
    background(#FFFFFF);
    start.setVisible(false);
    home.setVisible(true);
    audio.setVisible(true);
    text.setVisible(true);
    image.setVisible(true);
    data.setVisible(true);
    cam.read();

    PImage img = create(cam);
    Rectangle[] faces;
    opencv.loadImage(img);
    faces = opencv.detect(); // twarze z openCV

    if (timer < millis()) { // trackowanie co 1/4 sekundy
      timer += 250;
      println(faces.length);
      process(img, faces); // rozpoznawanie punktow szczegolowych i rozpoznawanie emocji
    }

    nya.detect(img); // rozpoznawanie znacznikow
    checkMarkers(); // zmienianie configu na podstawie znacznikow
    image(img, 0, 52);

    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);

    for (int i = 0; i < faces.length; i++) {
      List<Point2d> points = trackers.get(i).points;
      if (points != null) { // jesli openimaj znajdzie twarz, czasem nie znajduje, wtedy nie znamy emocji
        String emotion = trackers.get(i).classifier.currentEmotion;

        if (Config.useAudio()) { // rozne dzialania na emocji i zalezne od configu
          if (musicTimer < millis()) {
            musicTimer = millis() + 1500;

            if (emotion == "anger") {
              anger.play();
              anger.rewind();
              anger.play();
            }
            if (emotion == "surprise") {
              surprise.play();
              surprise.rewind();
              surprise.play();
            }
            if (emotion == "disgust") {
              disgust.play();
              disgust.rewind();
              disgust.play();
            }
            if (emotion == "anger") {
              anger.play();
              anger.rewind();
              anger.play();
            }
            if (emotion == "sadness"){
              sadness.play();
              sadness.rewind();
              sadness.play();
            }
            if (emotion == "unknown"){
              neutral.play();
              neutral.rewind();
              neutral.play();
            }
            if (emotion == "happiness"){
              happiness.play();
              happiness.rewind();
              happiness.play();
            }
          }
        }

        if (Config.useText()) {
          textSize(40);
          fill(204, 102, 0);
          text(emotion, faces[i].x, faces[i].y + 52 + faces[i].height);
        }

        if (Config.useData()) {
          noFill();
          circle(points.get(30).getX(), points.get(30).getY() + 52, 10);
          circle(points.get(0).getX(), points.get(0).getY() + 52, 10);
          circle(points.get(8).getX(), points.get(8).getY() + 52, 10);
          circle(points.get(16).getX(), points.get(16).getY() + 52, 10);
        }

        if (Config.useImage()) { // sprawdzanie czy jesz włączony przycisk "image"
          if (emotion == "fear"){  model3D = loadImage("fear.png");} //  sprawdzamy emocję i ladujemy odpowiedni obrazek do zmiennej
          if (emotion == "surprise"){  model3D = loadImage("surprised.png");}
          if (emotion == "disgust"){  model3D = loadImage("disgused.png");}
          if (emotion == "anger"){  model3D = loadImage("angry.png");}
          if (emotion == "sadness"){  model3D = loadImage("sad.png");}
          if (emotion == "unknown"){  model3D = loadImage("unknown.png");}
          if (emotion == "happiness"){  model3D = loadImage("happy.png");}
          image(model3D, faces[i].x+faces[i].width/4, faces[i].y-faces[i].height/3, faces[i].width/2, faces[i].width/2); // na koordynaty rozpoznawania twarzy opencv ladujemy obrazek emoji 
        }
      }

      if (Config.useData()) {
        noFill();
        rect(faces[i].x, faces[i].y + 52, faces[i].width, faces[i].height); // zielona zama razpoznawania twarzy
      }
    }
  }
}

//GUI, start page 
void landing_page () {
  image(banner, 0.507*width, 110, 253, 253);
  textFont(Font1);
  //textSize(54);
  fill(#212121);
  textLeading(32);
  text("Facial Emotion Recognition", 0.097*width, 160, 253, 62);
  textFont(Font2);
  //textSize(18);
  fill(#616161);
  textLeading(16);
  text("Easy and simple detection of human feelings at a specific moment.", 0.097*width, 232, 200, 50);
}

// buttons for GUI from G4P library
public void createGUI() {
  start = new GButton(this, 0.097*width, 290, 90, 30, "START");
  start.setFont(new Font("Arial", Font.BOLD, 10));
  start.addEventHandler(this, "buttonClick");

  home = new GButton(this, 0.031*width, 20, 41, 14, "Home");
  home.setFont(new Font("Arial", Font.BOLD, 12));
  home.addEventHandler(this, "homeClick");

  audio = new GButton(this, 0.325*width, 20, 41, 14, "Audio");
  audio.setFont(new Font("Arial", Font.BOLD, 12));
  audio.addEventHandler(this, "audioClick");

  text = new GButton(this, 0.421*width, 20, 41, 14, "Text");
  text.setFont(new Font("Arial", Font.BOLD, 12));
  text.addEventHandler(this, "textClick");

  image = new GButton(this, 0.515*width, 20, 42, 14, "Image");
  image.setFont(new Font("Arial", Font.BOLD, 12));
  image.addEventHandler(this, "imageClick");

  data = new GButton(this, 0.61*width, 20, 41, 14, "Data");
  data.setFont(new Font("Arial", Font.BOLD, 12));
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
    // dzwieki w tle
    Config.toogleAudioButton();
  }
}

public void textClick(GButton button, GEvent event) {
  if (button == text && event == GEvent.CLICKED) {
    // name of emotions clos to head
    Config.toogleTextButton();
  }
}

public void imageClick(GButton button, GEvent event) {
  if (button == image && event == GEvent.CLICKED) {
    // 3d shape on head
    Config.toogleImageButton();
  }
}

public void dataClick(GButton button, GEvent event) {
  if (button == data && event == GEvent.CLICKED) {
    // show frame and points around head
    Config.toogleDataButton();
  }
}

public void checkMarkers() {
  if (nya.isExist(0)) {
    Config.audioMarker = true;
  } else {
    Config.audioMarker = false;
  }
  if (nya.isExist(1)) {
    Config.textMarker = true;
  } else {
    Config.textMarker = false;
  }
  if (nya.isExist(2)) {
    Config.imageMarker = true;
  } else {
    Config.imageMarker = false;
  }
  if (nya.isExist(3)) {
    Config.dataMarker = true;
  } else {
    Config.dataMarker = false;
  }
}

PImage create(Capture cam) { // kopiowanie pixeli z obrazu kamery przez bug
  PImage res = createImage(cam.width, cam.height, ARGB);
  res.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  return res;
}

void copy(PImage from, PImage to, int x, int y, int width, int height) {
  to.copy(from, x, y, width, height, x, y, width, height);
}

void process(PImage img, Rectangle[] faces) {
  int border_width = img.width / 20;
  int border_height = img.height / 20;
  for (int i = 0; i < faces.length; i++) {
    int x = faces[i].x - border_width; // poszerzanie obszaru poszukiwan
    int y = faces[i].y - border_height;
    int w = faces[i].width + 2 * border_width;
    int h = faces[i].height + 2 * border_height;
    if (x < 0) {
      w += x; // zmniejszamy w bo x ujemne
      x = 0;
    }
    if (y < 0) {
      h += y; // zmniejszamy h bo x ujemne
      y = 0;
    }
    if (x + w > img.width) {
      w = img.width - x;
    }
    if (y + h > img.height) {
      h = img.height - y;
    }

    PImage part = createImage(img.width, img.height, ARGB);
    copy(img, part, x, y, w, h); // wycinamy fragment z twarza
    FaceTracker fc = trackers.get(i);
    fc.track(part, Config.useData());
    part = fc.outImg;
    copy(part, img, x, y, w, h); // przenosimy spowrotem twarz z punktami
  }
}
