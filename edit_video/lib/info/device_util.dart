import 'dart:convert';
import 'dart:io';

import 'package:advertising_identifier/advertising_identifier.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:edit_video/const/const.dart';
import 'package:uuid/uuid.dart';
import '../data/app_prefs.dart';
import '../di/locator.dart';

class DeviceUtil {
  DeviceUtil();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        await _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
      if (Platform.isIOS) {
        await _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      PackageInfo info = await PackageInfo.fromPlatform();
      _readPackageInfo(info);
    } on PlatformException {}
  }

  void _readPackageInfo(PackageInfo info) {
    Map<String, dynamic> infoData = {
      "appName": info.appName,
      "packageName": info.packageName,
      "version": info.version,
      "buildNumber": info.buildNumber,
      "buildSignature": info.buildSignature
    };
    packageInfo = infoData;
  }

  Future<void> _readAndroidBuildData(AndroidDeviceInfo build) async {
    Map<String, dynamic> deviceData = <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
    deviceData = deviceData;
    AppPrefs prefs = locator<AppPrefs>();
    final deviceUniqueId = await getDeviceUniqueId(build);
    deviceId = await prefs.saveAndroidDeviceId(deviceUniqueId);
    deviceInfo = deviceData;
  }

  Future<void> _readIosDeviceInfo(IosDeviceInfo data) async {
    Map<String, dynamic> deviceData = <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname': data.utsname.sysname,
      'utsname.nodename': data.utsname.nodename,
      'utsname.release': data.utsname.release,
      'utsname.version': data.utsname.version,
      'utsname.machine': data.utsname.machine,
    };
    deviceInfo = deviceData;
    AppPrefs prefs = locator<AppPrefs>();
    String udid = deviceData['identifierForVendor'];
    try {
      udid = await FlutterUdid.udid;
    } catch (_) {
      udid = deviceData['identifierForVendor'];
    }
    deviceId = await prefs.saveDeviceId(udid);
  }

  Future<String> getDeviceUniqueId(AndroidDeviceInfo buildInfo) async {
    var uuid = const Uuid();
    String deviceId;
    try {
      final AdvertisingIdInfo info =
          await AdvertisingIdentifier.instance.getAdvertisingIdInfo();
      if (info.id != null && info.id?.isNotEmpty == true) {
        deviceId = md5
            .convert(utf8.encode(
                '${info.id}_${buildInfo.hardware}_${buildInfo.id}_${buildInfo.product}'))
            .toString();
      } else {
        deviceId = md5
            .convert(utf8.encode(
                '${uuid.v4()}_${buildInfo.hardware}_${buildInfo.id}_${buildInfo.product}'))
            .toString();
      }
    } on PlatformException {
      deviceId = uuid.v4();
    }
    return deviceId;
  }

  // static Future<bool> checkNetworkState() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   return isEnableConnectStatus(connectivityResult);
  // }
  //
  // static bool isEnableConnectStatus(ConnectivityResult status) {
  //   return (status == ConnectivityResult.mobile) ||
  //       (status == ConnectivityResult.wifi) ||
  //       (status == ConnectivityResult.vpn) ||
  //       (status == ConnectivityResult.ethernet);
  // }
}
