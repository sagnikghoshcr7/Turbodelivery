import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationUtil {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  PushNotificationUtil({Function onSelectNotification}) {
    _init(onSelectNotification: onSelectNotification);
  }

  _init({Function onSelectNotification}) {
    var initSettingsAndroid =
        new AndroidInitializationSettings("@mipmap/ic_launcher");

    var initSettingsIOS = new IOSInitializationSettings();

    var initSettings =
        new InitializationSettings(initSettingsAndroid, initSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future showNotification({String text}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '23', '_sabbarChallenge', 'sabbar delivery status',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Delivery Status',
      text,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
