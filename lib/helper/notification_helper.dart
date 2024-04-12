import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../view/hospital_dash_board/views/create_notfication_view.dart';

class NotificationHelper {
  sendNotification(topic,
      {required String userName,
      required String bloodType,
      required String place,
      required String phoneNumber}) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA8a_Wm9c:APA91bGmxIeIoPxiEExpV4i2KaMeKe6lMygjv9MZsCWNq5FGTY8FiDIEtWCzUzWCfxtjcwUptRirifcayFSIR_VzlSioxf9T1SnYj1jChid4tjCatGBcv5I5D6JWa0FbenOmqKgVisBs'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = await {
      "to": "/topics/$topic",
      "notification": {
        "title": 'New Notification',
        'body': '${userName} \n${bloodType} \n${place}',
        "mutable_content": true,
        "sound": "Tri-tone"
      },
      "data": {
        "userName": '${userName}',
        "place": '$place',
        "phoneNumber": '$phoneNumber',
      },
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  getForGroundMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.notification!.title}');
        print(message.notification!.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${message.data['userName']}'),
              Text('${message.notification!.body}'),
              Text('${message.data['place']}'),
            ],
          ),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) =>const NotififcationView()));
            },
          ),
        ));
      } else {
        print('error');
      }
    });
  }

  getMyToken() async {
    print('======================================================');
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print(token);
    } catch (e) {
      print(e.toString());
    }
    print('======================================================');
  }

  getRequest() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
