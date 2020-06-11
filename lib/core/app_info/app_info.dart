import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';

class AppInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppInfo({
    @required this.appName,
    @required this.packageName,
    @required this.version,
    @required this.buildNumber,
  });

  factory AppInfo.get(PackageInfo packageInfo) {
    return AppInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }
}
