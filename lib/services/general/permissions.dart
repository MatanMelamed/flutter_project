import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static bool isLocationGranted = false;

  static void Initialize() async {
    isLocationGranted = await Permission.location.isGranted;
    if(!isLocationGranted){
      var respond = await Permission.location.request();
      isLocationGranted = respond.isGranted;
    }
  }
}
