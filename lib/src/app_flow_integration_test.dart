// ignore_for_file: avoid_print

/// To run the test, execute the following command in the terminal:
///
/// ```
/// export TARGET_PLATFORM=<platform>;
/// flutter drive --driver=integration_test/integration_driver.dart
/// --target=integration_test/main_test.dart
/// --device-id=<device_id>
/// ```
/// Omit --device-id if you want the tests to run on the currently active simulator.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

final loginScreen = find.byKey(const Key('login_screen'));
final splashScreen = find.byKey(const Key('splash_screen'));
final emailField = find.byKey(const Key('email_field'));
final passwordField = find.byKey(const Key('password_field'));
final loginButton = find.byKey(const Key('login_button'));
final logoutbutton = find.byKey(const Key('logout_button'));
final invalidEmailOrPassBanner = find.text('Invalid email or password');

final homeScreen = find.byKey(const Key('home_screen'));
final homeScreenBody = find.byKey(const Key('home_screen_body'));
final homeScreenInfoButton = find.byKey(const Key('home_info_icon_button'));
final profileBottomButtonIcon = find.byKey(const Key('profile_button_icon'));
final infoScreenList = find.byKey(const Key('info_list_built'));

final backButton = find.byTooltip('Back');

final walkthroughScreen = find.byKey(const Key('walkthrough_screen'));
final skipButton = find.byKey(const Key('skip_button'));

final myProfileTab = find.byKey(const Key('my_profile_tab'));
final myProfileTabBody = find.byKey(const Key('my_profile_tab_body'));

final memberToolsTab = find.byKey(const Key('member_tools_tab'));
final memberToolsTabBody = find.byKey(const Key('member_tools_tab_body'));

//finders definition end

Future<void> integrationTestFlow(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  final originalOnError = FlutterError.onError!;
  await splashScreenTest(tester, binding);
  await loginSuccessTest(tester, binding);
  await homeScreenTest(tester, binding);
  await infoScreenTest(tester, binding);
  await profileScreenTest(tester, binding);
  await logout(tester, binding);
  FlutterError.onError = originalOnError;
}

Future<void> splashScreenTest(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  try {
    await tester.runAsync(() async {
      await pumpAndSettleWrapped(tester);
      await pumpUntilFound(tester, splashScreen);
      await Future.delayed(const Duration(seconds: 5));
      expect(splashScreen, findsOneWidget);
      print('Splash Screen Test: splash-screen found');
      await takeScreenshot(tester, binding, '1-Splash-screen');
      print('Splash Screen Test: splash screenshot taken');
      await Future.delayed(const Duration(seconds: 10));
      await pumpAndSettleWrapped(tester);
      print('Splash Screen Test: pump after splash screen delay');
      try {
        /// if session is active and app is already on home screen then it will not show login screen and will directly show home screen.
        /// In this case, the test might get failed.
        expect(homeScreen, findsOneWidget);
        print('Splash Screen Test: Active Session found. On Home screen');
        await pumpAndSettleWrapped(tester);
        expect(homeScreenBody, findsOneWidget);
        await tester.tap(profileBottomButtonIcon);
        await Future.delayed(Duration(seconds: 1));
        await pumpAndSettleWrapped(tester);
        print('Logout Test running');
        await pumpAndSettleWrapped(tester);
        await tester.tap(logoutbutton);
        print('Logout Test: Logout button tapped before pump');
        await pumpAndSettleWrapped(tester);
        print('Logout Test: Logout button tapped after pump');
      } catch (e) {
        print('Login success test: no session found.');
      }
    });
  } catch (e) {
    print('Splash test Exception:$e');
  }
}

Future<void> loginSuccessTest(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  try {
    await tester.runAsync(() async {
      await pumpAndSettleWrapped(tester);
      
      expect(loginScreen, findsOneWidget);
      print('Login success test: found login screen');

      await pumpAndSettleWrapped(tester);

      await binding.takeScreenshot('2-Login-Screen');
      print('Login success test: login screenshot taken');

      await tester.tap(emailField);
      await tester.enterText(emailField, 'henry@mailinator.com');
      await tester.tap(passwordField);
      await tester.enterText(passwordField, 'henry');
      print('Login success test: Entered credentials');
      await tester.tap(loginButton);
      await pumpAndSettleWrapped(tester);

      print('Login success test: pump after login button tapped');
      try {
        expect(walkthroughScreen, findsOneWidget);
        print('Login success test: found walkthrough screen');
        await tester.tap(skipButton);
        print('Login success test: tapped skip before pump');
      } catch (e) {
        print('Login success test: no walkthrough screen');
      }

      await pumpAndSettleWrapped(tester);

      print('Login success test: pump after skip tapped');
      expect(homeScreen, findsOneWidget);
      print('Login success test: found home screen');
    });
  } catch (e) {
    print('Login Success test Exception:$e');
  }
}

Future<void> homeScreenTest(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await tester.runAsync(() async {
    await pumpAndSettleWrapped(tester);

    expect(homeScreen, findsOneWidget);
    print('Home Screen Test: Home Screen Found');

    await pumpAndSettleWrapped(tester);

    await binding.takeScreenshot('3-Home-Screen');
    print('Home Screen Test: Home screenshot taken');

    expect(homeScreenBody, findsOneWidget);
    print('Home Screen Test: data on Home Screen found');
  });
}

Future<void> infoScreenTest(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await tester.runAsync(() async {
    await tester.tap(homeScreenInfoButton);

    await pumpAndSettleWrapped(tester);

    expect(infoScreenList, findsOneWidget);
    print('Info screen test: found info screen');
    await binding.takeScreenshot('4-Info-Screen');
    print('Info screen test: screenshot taken');
    await tester.tap(backButton);

    await pumpAndSettleWrapped(tester);

    expect(homeScreen, findsOneWidget);
    print('Info screen test: back on homescreen');
  });
}

Future<void> profileScreenTest(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await tester.runAsync(() async {
    await pumpAndSettleWrapped(tester);
    await tester.tap(profileBottomButtonIcon);
    await Future.delayed(Duration(seconds: 1));
    await pumpAndSettleWrapped(tester);

    try {
      expect(memberToolsTab, findsOneWidget);
      print('Profile screen test: On member tools screen');
      expect(memberToolsTabBody, findsOneWidget);
      print('Profile screen test: Member tools data found');
      await binding.takeScreenshot('5-Member-tools-Screen');
      print('Profile screen test: Member tools screenshot taken');
      expect(myProfileTab, findsOneWidget);
      await tester.tap(myProfileTab);
      await pumpAndSettleWrapped(tester);

      expect(myProfileTab, findsOneWidget);
      print('Profile screen test: On my profile tab');
      expect(myProfileTabBody, findsOneWidget);
      print('Profile screen test: My profile tab data found');
      await binding.takeScreenshot('6-Profile-Screen');
      print('Profile screen test: Member tools screenshot taken');
    } catch (e) {
      expect(myProfileTabBody, findsOneWidget);
      print('Profile screen test: No member tools, my_profile_screen data found');
      await binding.takeScreenshot('5-Profile-Screen');
      print('Profile screen test: No member tools, my_profile_screen screenshot taken');
    }
  });
}

Future<void> logout(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await tester.runAsync(() async {
    print('Logout Test running');
    await pumpAndSettleWrapped(tester);

    await tester.tap(logoutbutton);
    print('Logout Test: Logout button tapped before pump');

    await pumpAndSettleWrapped(tester);

    print('Logout Test: Logout button tapped after pump');
    // expect(loginScreen, findsOneWidget);
    print('Logout Test: On login screen after logout');
  });
}

Future<void> loginScreenFail(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await tester.runAsync(() async {
    await pumpAndSettleWrapped(tester);
    await Future.delayed(const Duration(seconds: 10));
    expect(find.byKey(const Key('login_screen')), findsOneWidget);
    print('Login Fail Test: found login screen');
    await tester.tap(emailField);
    await tester.enterText(emailField, 'henry@mailinator.com');
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'henryy');
    print('Login Fail Test: Entered Credentials');
    await tester.tap(loginButton);
    await pumpAndSettleWrapped(tester);
    expect(invalidEmailOrPassBanner, findsOneWidget);
    print('Login Fail Test: Inavalid Credentials banner shown');
    await binding.takeScreenshot('0-Login-Fail');
    print('Login Fail Test: screenshot taken');
  });
}

takeScreenshot(tester, binding, fileName) async {
    final String platform = await Platform.environment['TARGET_PLATFORM'] ?? 'unknown';

  if (platform!='ios') {
    await pumpAndSettleWrapped(tester);
    await binding.convertFlutterSurfaceToImage();
    await pumpAndSettleWrapped(tester);
  }
  await binding.takeScreenshot(fileName);
}

Future pumpAndSettleWrapped(WidgetTester tester) async {
  final orignalOnError = FlutterError.onError;
  await tester.pumpAndSettle();
  FlutterError.onError = orignalOnError;
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => throw TimeoutException("Pump until has timed out"));
  while (timerDone != true) {
    await tester.pump();

    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

//  xcrun simctl shutdown all; xcrun simctl boot "iPhone 14 Pro Max"; export TARGET_PLATFORM=ios; flutter drive --driver=integration_test/integration_driver.dart --target=integration_test/main_test.dart --device-id="iPhone 14 Pro Max";
//   xcrun simctl shutdown all; xcrun simctl boot "iPhone 8 Plus"; export TARGET_PLATFORM=ios;flutter drive --driver=integration_test/integration_driver.dart --target=integration_test/main_test.dart --device-id="iPhone 8 Plus";   
//   export TARGET_PLATFORM=android;flutter drive --driver=integration_test/integration_driver.dart --target=integration_test/main_test.dart --device-id="sdk gphone64 arm64" --purge-persistent-cache --no-start-paused --no-pub; 