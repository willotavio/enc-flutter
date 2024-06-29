import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static Future<bool> requestStoragePermission() async {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    bool granted = false;
    if(androidInfo.version.sdkInt < 30) {
      var storagePermissionStatus = await Permission.storage.request();
      if(storagePermissionStatus.isDenied) {
        storagePermissionStatus = await Permission.storage.request();
      }
      else if(storagePermissionStatus.isPermanentlyDenied) {
        openAppSettings();
      }
      else {
        granted = true;
      }
    }
    else {
      granted = true;
    }
    return granted;
  }
  
}