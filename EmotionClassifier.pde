import java.util.Map;


class EmotionClassifier {
  List<Point2d> points;
  PointList pointList;
  Map<String, Float> valueMap;
  String currentEmotion;

  EmotionClassifier() {
  }

  public void classify(List<Point2d> points) {
    this.valueMap = new HashMap<String, Float>();
    this.points = new ArrayList<Point2d>();
    for (int i = 0; i < points.size(); i++) {
      Point2d p = points.get(i).copy();
      this.points.add(p);
    }

    this.pointList = new PointList(this.points);

    //println("before");
    //println(this.points);

    this.rotatePoints();
    this.shiftPoints();
    this.scalePoints();

    //println("after");
    //println(this.points);

    valueMap.put("corners", corners());
    valueMap.put("eyebrows", eyebrows());
    valueMap.put("nose", nose());
    valueMap.put("chin", chin());
    valueMap.put("leftEyeOpenness", leftEyeOpenness());
    valueMap.put("rightEyeOpenness", rightEyeOpenness());
    valueMap.put("mouthOpenness", mouthOpenness());
    valueMap.put("mouthWidth", mouthWidth());
    valueMap.put("innerEyebrows", innerEyebrows());

    this.decide();

    println(this.currentEmotion);
    println("corners; eyebrows;  nose;  chin;  leftEyeOpenness;  rightEyeOpenness;  mouthOpenness;  mouthWidth;  innerEyebrows");
    println(corners(),eyebrows(),nose(),chin(),leftEyeOpenness(),rightEyeOpenness(),mouthOpenness(),mouthWidth(),innerEyebrows());
  }

  private void rotatePoints() {
    Line2d eyesLine = new Line2d(this.pointList.get(36), this.pointList.get(45));
    this.pointList.rotate(this.pointList.get(30), -eyesLine.calculateHorizontalAngle());
  }

  private void shiftPoints() {
    this.pointList.translate(-this.pointList.get(30).getX(), -this.pointList.get(30).getY());
  }

  private void scalePoints() {
    float outerCornerOfLeftEyeToNoseHorizontalDistance = this.pointList.get(30).getY() - this.pointList.get(39).getY();
    float outerCornerOfRightEyeToNoseHorizontalDistance = this.pointList.get(30).getY() - this.pointList.get(42).getY();
    float scaler = 1 / (outerCornerOfLeftEyeToNoseHorizontalDistance + outerCornerOfRightEyeToNoseHorizontalDistance);
    this.pointList.scale(this.pointList.get(30), scaler);
  }

  private float corners() {
    float leftCornerOfMouthToNoseHorizontalDistance = this.pointList.get(48).getY() - this.pointList.get(30).getY();
    float rightCornerOfMouthToNoseHorizontalDistance = this.pointList.get(54).getY() - this.pointList.get(30).getY();
    float value = (leftCornerOfMouthToNoseHorizontalDistance + rightCornerOfMouthToNoseHorizontalDistance) / 2;
    return value;
  }

  private float eyebrows() {
    float topOfLeftEyebrowToNoseHorizontalDistance = this.pointList.get(30).getY() - this.pointList.get(19).getY();
    float topOfRightEyebrowToNoseHorizontalDistance = this.pointList.get(30).getY() - this.pointList.get(24).getY();
    float value = (topOfLeftEyebrowToNoseHorizontalDistance + topOfRightEyebrowToNoseHorizontalDistance) / 2;
    return value;
  }

  private float innerEyebrows() {
    float topOfLeftEyebrowToNoseHorizontalDistance = this.pointList.get(30).getY() - this.pointList.get(21).getY();
    float topOfRightEyebrowToNoseHorizontalDistance = this.pointList.get(30).getY() - this.pointList.get(22).getY();
    float value = (topOfLeftEyebrowToNoseHorizontalDistance + topOfRightEyebrowToNoseHorizontalDistance) / 2;
    return value;
  }

  private float nose() {
    float noseHorizontalLength = this.pointList.get(30).getY() - this.pointList.get(27).getY();
    return noseHorizontalLength;
  }

  private float chin() {
    float chinToNoseHorizontalDistance = this.pointList.get(8).getY() - this.pointList.get(30).getY();
    return chinToNoseHorizontalDistance;
  }

  private float leftEyeOpenness() {
    float leftSideOpenness = this.pointList.get(41).getY() - this.pointList.get(37).getY();
    float rightSideOpenness = this.pointList.get(40).getY() - this.pointList.get(38).getY();
    float value = (leftSideOpenness + rightSideOpenness) / 2;
    return value;
  }

  private float rightEyeOpenness() {
    float leftSideOpenness = this.pointList.get(47).getY() - this.pointList.get(43).getY();
    float rightSideOpenness = this.pointList.get(46).getY() - this.pointList.get(44).getY();
    float value = (leftSideOpenness + rightSideOpenness) / 2;
    return value;
  }

  private float mouthOpenness() {
    float leftSideOpenness = this.pointList.get(65).getY() - this.pointList.get(60).getY();
    float middleSideOpenness = this.pointList.get(64).getY() - this.pointList.get(61).getY();
    float rightSideOpenness = this.pointList.get(63).getY() - this.pointList.get(62).getY();
    float value = (leftSideOpenness + middleSideOpenness + rightSideOpenness) / 3;
    return value;
  }

  private float mouthWidth() {
    float value = this.pointList.get(54).getX() - this.pointList.get(48).getX();
    return value;
  }

  private void decide() {
    if (this.valueMap.get("nose") < 0.52 || this.valueMap.get("innerEyebrows") < 0.82) {
      if (this.valueMap.get("mouthOpenness") > 0.05) {
        this.currentEmotion = "disgust";
      } else {
        this.currentEmotion = "anger";
      }
    } else
    if (this.valueMap.get("mouthOpenness") > 0.1 || this.valueMap.get("chin") > 1.5) {
      if (this.valueMap.get("mouthWidth") > 0.8) {
        this.currentEmotion = "fear";
      } else {
        this.currentEmotion = "surprise";
      }
    } else
    if (this.valueMap.get("corners") > 0.55) {
      this.currentEmotion = "sadness";
    } else
    if (this.valueMap.get("corners") < 0.45) {
      this.currentEmotion = "happiness";
    } else
    this.currentEmotion = "unknown";
  }

}
