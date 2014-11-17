// taken and modified from http://www.magicandlove.com/blog/2013/04/04/opencv-2-4-4-and-processing/ 
// import all the necessary libraries.. these are native from opencv ver 2.4.6
import processing.video.*;
 
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
 
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.awt.image.Raster;
 
// the basic objects which are needed to get this working...
Capture cap;
int pixCnt;
BufferedImage bm;
PImage img;
Mat circles;

// parameters to be passed to the houghCircles method...
int dp = 1, minDist = 20, param1 = 10, param2 = 25, minRadius = 100, maxRadius = 200;

// variables for the detected circles...
int x, y, radius;
 
void setup() {
  size(640, 480);
  
  // the system.loadlibrary seems to be indispensible to getting things working...
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
 
  // define a new capture object and start it...
  cap = new Capture(this, width, height);
  cap.start();
  
  // next we initialize some ofthe variables which will be indispensible
  bm = new BufferedImage(width, height, BufferedImage.TYPE_4BYTE_ABGR);
  img = createImage(width, height, ARGB);
  pixCnt = width*height*4;
}
 
void convert(PImage _i) {
  /* the magical function which does it all */
  
  // first we extract the elements from the PImage object and throw them into the Mat object 'm1'. This is a 'colourspace' matrix.
  bm.setRGB(0, 0, _i.width, _i.height, _i.pixels, 0, _i.width);
  Raster rr = bm.getRaster();
  byte [] b1 = new byte[pixCnt];
  rr.getDataElements(0, 0, _i.width, _i.height, b1);
  Mat m1 = new Mat(_i.height, _i.width, CvType.CV_8UC4);
  m1.put(0, 0, b1);
  
  // next we define the 'greyscale space' matrix 'm2' and put the greyscaled version of the PImage into it
  Mat m2 = new Mat(_i.height, _i.width, CvType.CV_8UC1);
  Imgproc.cvtColor(m1, m2, Imgproc.COLOR_BGRA2GRAY);   
 
  /***********************************************************/
  /* now the magic.. perform whichever Imgproc method you want to on these matrices
     Just be sure to choose m1 or m2 depending on whether the method is performed on 
     colourspace or greyscale spaces. Source and destination can be the same matrix. */
  // Imgproc.GaussianBlur(m2, m2, new Size(7, 7), 1.5, 1.5);
  // Imgproc.Canny(m2, m2, 0, 30, 3, false);
  Imgproc.adaptiveThreshold(m2, m2, (double)255.0, Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, Imgproc.THRESH_BINARY, 301, (double)1.0);    // Imgproc is the object, just apply method
  
  circles = new Mat();    // copied from http://stackoverflow.com/questions/9445102/detecting-hough-circles-android
  Imgproc.HoughCircles(m2, circles, Imgproc.CV_HOUGH_GRADIENT, dp, minDist, param1, param2, minRadius, maxRadius);
    
  /**********************************************************/
  
  // and now we have to convert back to colourspace to display in the procesing window
  // Hence m2 is the final matrix which will be showed..
  Imgproc.cvtColor(m2, m1, Imgproc.COLOR_GRAY2BGRA);
  
  // Re-convert m2 to a PImage object 'img'
  m1.get(0, 0, b1);
  WritableRaster wr = bm.getRaster();
  wr.setDataElements(0, 0, _i.width, _i.height, b1);
  bm.getRGB(0, 0, _i.width, _i.height, img.pixels, 0, _i.width);
  img.updatePixels();
  
  // release the flush. It's all over.
  bm.flush();
  m2.release();
  m1.release();
}
 
void draw() {
  if (cap.available()) {    // essential line otherwise video will be jerky
    /* simple 3-step process. Read the capture object, convert the capture object and display the captured image. */
    cap.read();
    convert(cap);
    image(cap, 0, 0);
    
    // print out the circles
    for (int k = 0; k < circles.cols(); k++) {
        double vCircle[] = circles.get(0,k);
      
        if (vCircle == null) {
            println("no circle found");
            break;
        } else {
            // circle detected. extract parameters. taken from http://stackoverflow.com/questions/23860014/houghcircles-finds-wrong-circles-opencv
            x = (int)Math.round(vCircle[0]); 
            y = (int)Math.round(vCircle[1]);
            radius = (int)Math.round(vCircle[2]);
            
            print(x);
            print('\t');
            print(y);
            print('\t');
            println(radius);
          
            // draw the found circle
            stroke(255, 0, 0);
            fill(0,0,0,0);    // transparent fill
            ellipse(x, y, radius, radius);
         }
    }
  }
}
