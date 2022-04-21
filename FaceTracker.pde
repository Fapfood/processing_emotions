import java.util.List;
import Jama.Matrix;
import org.openimaj.image.MBFImage;
import org.openimaj.image.processing.face.tracking.clm.CLMFaceTracker;
import org.openimaj.image.processing.face.tracking.clm.MultiTracker;
import org.openimaj.math.geometry.shape.Triangle;
import org.openimaj.math.geometry.shape.Shape;
import org.openimaj.math.geometry.point.Point2dImpl;
import org.openimaj.math.geometry.point.Point2d;
import org.openimaj.math.geometry.point.PointList;
import org.openimaj.math.geometry.line.Line2d;


class FaceTracker {
  CLMFaceTracker tracker;
  PImage inImg;
  PImage outImg;
  MultiTracker.TrackedFace face;
  List<Point2d> points;
  List<Triangle> triangles;
  EmotionClassifier classifier;

  FaceTracker() {
    this.tracker = new CLMFaceTracker();
    this.tracker.setRedetectEvery(1);
    this.face = null;
    this.points = null;
    this.triangles = null;
    this.classifier = new EmotionClassifier();
  }

  public void track(PImage img, boolean draw) {
    this.inImg = img;
    MBFImage frame = convert(this.inImg);
    this.tracker.reset();
    this.tracker.track(frame);

    if(this.tracker.getTrackedFaces().size() > 0) { // jesli znajdzie twarz
      this.face = this.tracker.getTrackedFaces().get(0);
      this.points = this.createPoints(this.face, this.tracker.scale);
      this.triangles = this.tracker.getTriangles(this.face);
      if (draw) {this.drawModel(frame, this.face);}
      this.classifier.classify(this.points);
    } else { // jesli nie znajdzie twarzy
      this.face = null;
      this.points = null;
      this.triangles = null;
    }
    this.outImg = convert(frame);
  }

  private void drawModel(MBFImage image, MultiTracker.TrackedFace f){
    boolean drawTriangles = false;
    boolean drawConnections = false;
    boolean drawPoints = true;
    boolean drawSearchArea = false;
    boolean drawBounds = true;
    CLMFaceTracker.drawFaceModel(image, f, drawTriangles, drawConnections, drawPoints, drawSearchArea, drawBounds,
      this.tracker.triangles, this.tracker.connections, this.tracker.scale,
      this.tracker.getBoundingBoxColour(), this.tracker.getMeshColour(), this.tracker.getConnectionColour(), this.tracker.getPointColour());
  }

  private MBFImage convert(PImage img) { // conwersja z processing na openimaj
    img.loadPixels();
    return new MBFImage(img.pixels, img.width, img.height);
  }

  private PImage convert(MBFImage img) { // conwersja z openiaj na processing
    PImage res = createImage(img.getWidth(), img.getHeight(), ARGB);
    res.pixels = img.toPackedARGBPixels();
    res.updatePixels();
    return res;
  }

  private List<Point2d> createPoints(MultiTracker.TrackedFace f, float scale) { // pozyskiwanie punktow z macierzy
    final int n = f.shape.getRowDimension() / 2;
    final List<Point2d> ps = new ArrayList<Point2d>();
    for (int i = 0; i < n; i++) {
      Point2d p = new Point2dImpl((float) f.shape.get(i, 0) / scale, (float) f.shape.get(i + n, 0) / scale);
      ps.add(p);
    }
    return ps;
  }

}
