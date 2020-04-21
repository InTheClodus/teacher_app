enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {

  static Flavor appFlavor;

  static String get helloMessage {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'MacauScholar';
      case Flavor.DEVELOPMENT:
      default:
        return 'MacauScholar';
    }
  }
  static String get keyApplicationName {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'MacauScholar';
      case Flavor.DEVELOPMENT:
      default:
        return 'MacauScholar';
    }
  }
  static String get keyParseApplicationId {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'macauscholar';
      case Flavor.DEVELOPMENT:
      default:
        return 'macauscholar';
    }
  }
  static String get keyParseMasterKey {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return '7GTH8NLumCHd/v/HfLvYSAejq2Xf6K9D9hSNxliIRt0=';
      case Flavor.DEVELOPMENT:
      default:
        return '7GTH8NLumCHd/v/HfLvYSAejq2Xf6K9D9hSNxliIRt0=';
    }
  }
  static String get keyParseServerURL {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'https://macauscholar.uat.macau520.com:8443/api';
      case Flavor.DEVELOPMENT:
      default:
        return 'https://macauscholar.uat.macau520.com:8443/api';
    }
  }
  static bool get keyDebug {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return true;
      case Flavor.DEVELOPMENT:
      default:
        return true;
    }
  }

}