import 'dart:io';

class AdmobService {
  AdmobService({required this.isProduction});

  final bool isProduction;

  String? getBannerUnitId() {
    if (Platform.isAndroid) {
      if (isProduction) {
        return 'ca-app-pub-4057311172335348/9977882935';
      } else {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
    } else {
      return 'ca-app-pub-4057311172335348/2913781139';
    }
  }

  String? getNativeUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4057311172335348/7915111781';
    } else {
      return 'ca-app-pub-4057311172335348/6897543585';
    }
  }
}
