// import 'dart:convert';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fb_testing/models/user.dart';
// import 'package:fb_testing/screens/chat/chat_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'dart:developer';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static const key =
//       "AAAAC-dfcJI:APA91bEoCD99fv1o2A0YYOwlBVoy29QmFmBQmzO4avwnjYVqM5Pq4tUh05atT_n6cXM_5kuUKhxevfvpma1olUBVCPWDXyb9N3_bXMl9xsqggSMhZ5WXY-y3zxLKVQRwQgedrmUPjpL4";
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//   static AndroidInitializationSettings initializationSettingsAndroid =
//       const AndroidInitializationSettings('app_icon');
//   static const DarwinInitializationSettings initializationSettingsDarwin =
//       DarwinInitializationSettings(
//           requestAlertPermission: true, requestBadgePermission: true);
//   static const LinuxInitializationSettings initializationSettingsLinux =
//       LinuxInitializationSettings(defaultActionName: 'Open notification');
//   final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//       macOS: initializationSettingsDarwin,
//       linux: initializationSettingsLinux);
//   void _initLocalNotification() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         log(details.payload.toString());
//       },
//     );
//   }

//   void firebaseNotification(context) {
//     _initLocalNotification();
//     FirebaseMessaging.onMessageOpenedApp.listen((event) async {
//       final x = await FirebaseFirestore.instance
//           .collection("Users")
//           .doc(event.data['senderId'])
//           .get();

//       UserModel user = UserModel.fromJson(x.data()!);
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatPage(reciever: user),
//           ));
//     });
//     FirebaseMessaging.onMessage.listen((event) {
//       _showLocalNotification(
//           event.notification!.title, event.notification!.body, event.data);
//     });
//   }

//   Future _showLocalNotification(title, body, payload) async {
//     final styleInfo = BigTextStyleInformation(body,
//         htmlFormatBigText: true, contentTitle: title, htmlFormatTitle: true);

//     NotificationDetails details = NotificationDetails(
//         android: AndroidNotificationDetails(
//             "com.example.fb_testing", "myChannel",
//             importance: Importance.high,
//             priority: Priority.max,
//             styleInformation: styleInfo),
//         iOS: const DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true));
//     await flutterLocalNotificationsPlugin.show(0, title, body, details,
//         payload: payload);
//   }

//   Future requestPermissions() async {
//     final messaging = FirebaseMessaging.instance;
//     final settings = await messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: true,
//         provisional: false,
//         sound: true);
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log("permissions granted");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       log("prov permissions granted");
//     } else {
//       log("no permissions");
//     }
//   }

//   Future getToken() async {
//     final token = await FirebaseMessaging.instance.getToken();
//     _saveToken(token);
//   }

//   Future _saveToken(String? token) async {
//     if (token != null) {
//       FirebaseFirestore.instance
//           .collection("Users")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .set({"token": token}, SetOptions(merge: true));
//     }
//   }

//   Future sendNoti({required String body, required String senderId}) async {
//     try {
//       await http.post(
//         Uri.parse("https://fcm.googleapis.com/fcm/send"),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$key'
//         },
//         body: jsonEncode(
//           {
//             'to': recToken,
//             'priority': 'high',
//             'notification': {'title': 'Urgent action needed!', 'body': body},
//             'data': {
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'status': 'done',
//               'senderId': senderId,
//             }
//           },
//         ),
//       );
//     } on HttpException catch (e) {
//       log(e.message);
//     }
//   }

//   String recToken = "";
//   Future<String> getRecToken(String recId) async {
//     final x =
//         await FirebaseFirestore.instance.collection("Users").doc(recId).get();
//     recToken = x.get("token");
//     return x.get("token");
//   }
// }
