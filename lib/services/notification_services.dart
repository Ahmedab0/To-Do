
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../Ui/pages/notification_screen.dart';
import '../models/task.dart';

class NotifyHelper {
  //LocalNotificationService

  Task task = Task();

  /// ** Instance of Flutter notification plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 1# create Initialisation method
  initializeNotification() async {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Initialization setting for android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');
    // for new ios permission
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // for older ios permission
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  /// 2# requestPermissions Method For IOS
  requestIOSPermissions() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// 3# For Older IOS Permission / onDidReceiveLocalNotification
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // create dialog with GetX
    Get.dialog(Text(body!));
  }

  // onDidReceiveNotificationResponse method
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // use Get to moving NotificationScreen
    await Get.to(() => NotificationScreen(
          payload: payload!,
        ));
  }

  /// 4# method for Displaying a notification
  displayNotification({required String title, required String body}) async {
    // displaying for Android
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // showing Notifications
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: 'Default_Sound'); //Default_Sound

    // displaying for IOS
    //IOSNotificationDetails _iosNotificationDetails = IOSNotificationDetails(); ...> adding with course and is not fount in package
    //NotificationDetails notificationDetails =
    //NotificationDetails(android: androidNotificationDetails);
    //iOS: _iosNotificationDetails ...> adding with course and is not fount in packag
  } // End Display Method

  /// 5# Method For Schedule Notifications
  // Not Working
/*  scheduleNotification(int hour, int minutes, Task task) async {
    print('*****scheduleNotification 1111111*****');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
       // _nextInstanceOfTenAM(hour, minutes);

        const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('*****scheduleNotification 2222222 *****');
  }*/ // End scheduleNotification

  // cancelNotification
  cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  // cancelAllNotification
  cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(hour, minutes, task.repeat!, task.date!, task.remind!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name', channelDescription: 'your channel description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, String repeat,String date, int remind) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    DateTime formattedDate = DateFormat.yMd().parse(date);
    final tz.TZDateTime fd = tz.TZDateTime.from(formattedDate, tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);

    scheduledDate = afterRemind(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if(repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, (formattedDate.day)+1, hour, minutes);
      }
      if(repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, (formattedDate.day)+7, hour, minutes);
      }
      if(repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, (formattedDate.month)+1, formattedDate.day, hour, minutes);
      }
      scheduledDate = afterRemind(remind, scheduledDate);
    }


    print('next scheduledDate ==> $scheduledDate');

    return scheduledDate;
  }

  // Start afterRemind Method to remind before some time
  tz.TZDateTime afterRemind(int remind, tz.TZDateTime scheduledDate) {
    if(remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if(remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if(remind == 16) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 16));
    }
    if(remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }
}

/// End The Class NotifyHelper

//***********
//# 2 way to call Local_Notifications

/// 1 #
/// using
//   WidgetsFlutterBinding.ensureInitialized();
//   NotifyHelper().setupInitialize();
///    inside main function and before RunApp function

/// 1 #
/// using
///  on the page we need to notify in
//   @override
//   void initState() {
//     super.initState();
/// Initialise  local notification
//     notifyHelper.setupInitialize();
/// requestIosPermissions when app start for only one time
//     notifyHelper.requestIosPermissions();
//   }

/// Calling displayNotification Method &&  scheduleNotification Method

//NotifyHelper().displayNotification();
//NotifyHelper().scheduleNotification();

/*

  // Instance of Flutter notification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization setting for android
    const InitializationSettings initializationSettingsAndroid =
    InitializationSettings(
        android: AndroidInitializationSettings("@drawable/ic_launcher"));
    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }

 /// on the page we need to notify
  @override
  void initState() {
    super.initState();
    // Initialise  local notification
    NotifyHelper.setupInitialize();
  }


*/

//end top Comment
