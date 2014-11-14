import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

// the image object which shall contain the processed image
PImage thresh;

void setup() {
  size(640, 480);            // size of the processing window
  video = new Capture(this, 640/2, 480/2);    // new video object
  opencv = new OpenCV(this, 640/2, 480/2);    // new opencv object
  // opencv.loadCascade(OpenCV.CASCADE_EYE);  // here's where you load the object detection cascade that you're interested in using
    

  video.start();            // begin the capturing
}

void draw() {
  scale(2);                 // ?
  // first you load the image from video feed, this returns void
  opencv.loadImage(video);

  opencv.threshold(80);          // threshold being applied
  thresh = opencv.getSnapshot();   // load a snapshot of the threshold into the thresh pimage object 
  
  image(thresh, 0, 0 );            // display the "thresh" object at origin position, on the window
  
}

// dunno what this next function does, but its crucial to operation...
void captureEvent(Capture c) {
  c.read();
}

