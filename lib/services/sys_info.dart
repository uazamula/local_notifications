import 'package:device_info_plus/device_info_plus.dart';

class SysInfo {
  static int? getSdkIntInfo;
  static Future<void> getSdkInfo() async{
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    getSdkIntInfo=androidInfo.version.sdkInt;
  }
}