import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCheck {

  static void requestPermission() async {
    // Here We can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      //Permission.storage,
      Permission.microphone,
    ].request();
    debugPrint("${statuses[Permission.location]}");

    //return statuses;
  }
}