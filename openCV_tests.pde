import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

// the contour arrays
ArrayList<Contour> contours;
ArrayList<Contour> polygons;

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
  scale(2);                 // I think this is scaling the whole image frame down by 2
  // first you load the image from video feed, this returns void
  opencv.loadImage(video);

  // adaptive thresholding has to be done only on a gray image, obviously
  opencv.gray();            
  // next we do the adaptive thresholding...
  // the first argument has to be an ODD number, 
  // the second argument is the constant that is subtracted from the thresholded values
  opencv.adaptiveThreshold(601, 1);    
  thresh = opencv.getOutput();  // get its output
  
  // now that we've thresholded it nicely, we go about finding contours.
  contours = opencv.findContours();
  
  // println(contours.size());
  image(thresh, 0, 0 );            // display the image on the window
  
  noFill();
  strokeWeight(1);
  
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.draw();
    
    /*
    stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
    /**/
  }
  /**/
}

// dunno what this next function does, but its crucial to operation...
void captureEvent(Capture c) {
  c.read();
}

