import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LocalNotifications {
  void init({
    @required SelectNotificationCallback onSelectNotification,
    @required DidReceiveLocalNotificationCallback onDidReceiveLocalNotification,
  });
}

class WebLocalNotifications extends LocalNotifications {
  @override
  void init({onSelectNotification, onDidReceiveLocalNotification}) {
    // no-op
  }
}

class MobileLocalNotifications extends LocalNotifications {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MobileLocalNotifications()
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void init({
    @required SelectNotificationCallback onSelectNotification,
    @required DidReceiveLocalNotificationCallback onDidReceiveLocalNotification,
  }) {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin
        .initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    )
        .then((init) {
      _setupNotification();
    });
  }

  void _setupNotification() async {
    var time = new Time(16, 11, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'daily-notifications', 'Daily Notifications', 'Daily Notifications');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Spend-o-meter',
        "Don't forget to add your expenses", time, platformChannelSpecifics);
  }
}
