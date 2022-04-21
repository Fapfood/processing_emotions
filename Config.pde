static class Config {
  static boolean audioButton = false;
  static boolean textButton = false;
  static boolean imageButton = false;
  static boolean dataButton = false;
  static boolean audioMarker = false;
  static boolean textMarker = false;
  static boolean imageMarker = false;
  static boolean dataMarker = false;

  Config() {
  }

  public static boolean useAudio() {
    return audioButton ^ audioMarker; // XOR zeby uzgledniac oba zrodla
  }

  public static boolean useText() {
    return textButton ^ textMarker;
  }

  public static boolean useImage() {
    return imageButton ^ imageMarker;
  }

  public static boolean useData() {
    return dataButton ^ dataMarker;
  }

  public static void toogleAudioButton() {
    audioButton = !audioButton;
  }

  public static void toogleTextButton() {
    textButton = !textButton;
  }

  public static void toogleImageButton() {
    imageButton = !imageButton;
  }

  public static void toogleDataButton() {
    dataButton = !dataButton;
  }

}
