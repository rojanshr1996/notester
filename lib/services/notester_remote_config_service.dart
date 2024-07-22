import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:notester/model/min_app_version_response_entity.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NotesterRemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      const minAppVersion = MinAppVersionResponseModel(
          iosRecommendedMinVersion: '1.1.0+1',
          iosRequiredMinVersion: '1.1.0+1',
          androidRecommendedMinVersion: '1.1.0+12',
          androidRequiredMinVersion: '1.1.0+12');

      await remoteConfig.setDefaults({
        'isAppUnderMaintenance': false,
        'appMinimumVersion': json.encode(minAppVersion.toJson()),
      });

      // Fetch the values from Firebase Remote Config
      await remoteConfig.fetchAndActivate();

      // Optional: listen for and activate changes to the Firebase Remote Config values
      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
      });
    } catch (e) {
      // log('Remote config exception');
    }
  }

  // Helper methods to simplify using the values in other parts of the code
  String getIsAppUnderMaintenance() =>
      remoteConfig.getString('isAppUnderMaintenance');

  MinAppVersionResponseModel getAppMinimumVersion() {
    final appMinVersion = remoteConfig.getString('appMinimumVersion');
    return MinAppVersionResponseModel.fromJson(json.decode(appMinVersion));
  }
}

class NotesterPackageInfo {
  late String version;
  late String versionWithoutBuild;

  Future<void> initialize() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = '${packageInfo.version}+${packageInfo.buildNumber}';
      versionWithoutBuild = packageInfo.version;
    } catch (e) {
      log('Package info exception');
    }
  }
}
