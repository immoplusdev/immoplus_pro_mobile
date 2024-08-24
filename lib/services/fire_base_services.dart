import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/cubits/cubits.dart';
import 'package:immoplus_pro/services/firebase_utils.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FireBaseServices {
  BuildContext context;
  FireBaseServices(this.context);
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Your custom logic to handle the background message goes here.

    // If you want to perform an action or show a notification based on the message content:
    // For example, you can check the message data and show a local notification.

    // To show a local notification, you can use a package like 'flutter_local_notifications'.
    // Make sure to add the package to your pubspec.yaml file:
    // dependencies:
    //   flutter_local_notifications: ^x.y.z

    // Here's a simple example using flutter_local_notifications:
    // (Note: You need to configure flutter_local_notifications separately)

    // Import the package:
    // import 'package:flutter_local_notifications/flutter_local_notifications.dart';

    // Create a FlutterLocalNotificationsPlugin instance:
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    // Configure the initialization settings for the plugin (e.g., Android and iOS settings).

    // Use the message data to construct the notification content:
    // final AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails(
    //   'your_channel_id',
    //   'your_channel_name',
    //   'your_channel_description',
    //   importance: Importance.max,
    //   priority: Priority.high,
    // );
    // final NotificationDetails platformChannelSpecifics =
    //     NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification:
    // await flutterLocalNotificationsPlugin.show(
    //   0, // Notification ID
    //   'Notification Title',
    //   'Notification Body',
    //   platformChannelSpecifics,
    //   payload: 'Custom Payload',
    // );
  }
  static loginSubscriptions({required String userId}) async {
    FirebaseMessaging.instance.subscribeToTopic('user_$userId');
  }

  initNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic('users_dev');
    FirebaseMessaging.instance.getToken().then((String? token) {
      assert(token != null);
      //log(token!,name: 'Device Token');
      // Now you can use the device token as needed
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("OUt APP");
      print(message.data.toString());
      print(message.data['path']);
      if (message.data['path'] != null) {
        //GoRouter.of(context).go(message.data['path']);
        AppRouter.router.pushReplacement(message.data['path']);
        //context.pushReplacement(message.data['path']);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // context.read<NotificationCubit>().onGetData(
      //       context: context,
      //     );
      if (message.data['isImage'] != null) {
        print('isImage');
        if (message.data['imageUrl'] != null) {
          if (message.data['imageUrl'] == 'on') {
            print('imageUrl');
            FirebaseUtils.showImageNotification(
                context: context,
                imageUrl: message.data['imageUrl'],
                route: message.data['path']);
          }
        }
      }
    });
  }
}
