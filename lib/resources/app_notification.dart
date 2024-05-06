// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as dev;

class AppNotifications {
  ///instance of firebase messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  ///instance of flutter local notifications for handling app foreground state
  final FlutterLocalNotificationsPlugin flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();

  ///request notifications permission
  void requestNotificationsPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  ///get device fcm token
  Future<String> getDeviceToken() async {
    dynamic deviceToken = await messaging.getToken();
    return deviceToken!;
  }

  ///check the fcm token validity
  void isDeviceTokenValid() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  ///control notifications on iOS FOREGROUND
  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///initialize local notifications
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings(
      defaultPresentAlert: true,
      requestProvisionalPermission: true,
    );

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    // dynamic planId = message.data['planId'];
    // dynamic tipId = message.data['tipId'];
    dev.log('here 1 ${message.data}');
    dev.log("${message.data['type']}");
    await flutterLocalNotifications.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (notificationPayload) {
        handleMessage(context, message);
        // if (notificationPayload.actionId != null) {
        //   if (notificationPayload.actionId == 'useful') {
        //     callUpdateTipNotifications(isUseful: true, planId: planId ?? '', tipId: tipId ?? '');
        //   } else if (notificationPayload.actionId == 'not useful') {
        //     callUpdateTipNotifications(isUseful: false, planId: planId ?? '', tipId: tipId ?? '');
        //   }
        // } else {
        //   handleMessage(context, message);
        // }
      },
    );
  }

  ///to show notification FOREGROUND
  Future<void> showNotification(RemoteMessage remoteMessage) async {
    ///settle android notifications
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNormalNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    AndroidNotificationDetails androidTipNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(
        remoteMessage.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: remoteMessage.notification!.title.toString(),
        htmlFormatContentTitle: true,
        summaryText: remoteMessage.notification!.body.toString(),
        htmlFormatSummaryText: true,
      ),
      actions: [
        const AndroidNotificationAction('useful', 'This was useful',
            //allowGeneratedReplies: true,
            showsUserInterface: true,
            cancelNotification: true),
        const AndroidNotificationAction('not useful', 'This does\'t help',
            showsUserInterface: true, cancelNotification: true),
      ],
    );

    ///settle ios notifications
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    ///provide notifications details
    NotificationDetails notificationDetails = NotificationDetails(
      android: remoteMessage.data['type'] == 'Tip'
          ? androidTipNotificationDetails
          : androidNormalNotificationDetails,
      // android: androidNormalNotificationDetails,
      iOS: iosNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      flutterLocalNotifications.show(
        0,
        remoteMessage.notification!.title.toString(),
        remoteMessage.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  /// to show notification
  void firebaseNotificationsInitialization(BuildContext context) {
    FirebaseMessaging.onMessage.listen((notificationMessage) {
      // RemoteNotification? notification = notificationMessage.notification;
      // AndroidNotification? android = notificationMessage.notification!.android;
      if (Platform.isIOS) {
        initLocalNotifications(context, notificationMessage);
        foregroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotifications(context, notificationMessage);
        showNotification(notificationMessage);
      }
    });
  }

  ///when notification is opened
  Future<void> setUpInteractMessage(BuildContext context) async {
    ///when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    dev.log('initial message is $initialMessage');
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    ///when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessage(
        context,
        event,
      );

      /// Uncomment the code below to handle action button callbacks
    });
    // FirebaseMessaging.onBackgroundMessage((message) async {
    //   handleMessage(context, message);
    // });
  }

  void handleMessage(BuildContext context, RemoteMessage message) async {
    dev.log('here message ${message.data}');
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
