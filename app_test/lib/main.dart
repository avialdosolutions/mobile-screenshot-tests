// library app_test;

// export 'src/main_test.dart';

// export TARGET_PLATFORM=ios;
// TARGET_PLATFORM=ios;flutter drive --driver=integration_test/integration_driver.dart --target=integration_test/main_test.dart
// --device-id=<device_id>
import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final String platform = await Platform.environment['TARGET_PLATFORM'] ?? 'unknown';


  try {
    await integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes, [Map<String, Object?>? args]) async {
        File image;
        print("running tests on $platform");
        if (platform == "ios") {
          if (!File('screenshots/en-US/iPhone-$screenshotName-14-pro.png').existsSync()) {
            image = await File('screenshots/en-US/iPhone-$screenshotName-14-pro.png').create(recursive: true);
          } else {
            image = await File('screenshots/en-US/iPhone-${screenshotName}-8-plus.png').create(recursive: true);
          }
        } else {
          image = await File('metadata/android/en-US/images/phoneScreenshots/$screenshotName-android.png').create(recursive: true);
        }
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );
  } catch (e) {
    print('Error ${e.toString()}');
  }
}
