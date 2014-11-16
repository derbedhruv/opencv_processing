import org.opencv.imgproc.Imgproc;
import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);
  cam = new Capture(this, 640, 480);
  cam.start(); 
}

void draw() {
  // the following if condition needs to be put, 
  // otherwise there are errors and the video shakes around.
  if (cam.available() == true) {
    cam.read();
  }
  // image(cam, 0, 0);
  
  set(0, 0, cam);    // this one's faster than image()
}
