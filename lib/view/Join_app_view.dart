import 'package:bldapp/helper/notification_helper.dart';
import 'package:bldapp/view/LoginView.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bldapp/Colors.dart';
import 'register_as_hospital.dart';

class JoinBloodDonationApp extends StatefulWidget {
  @override
  State<JoinBloodDonationApp> createState() => _JoinBloodDonationAppState();
}

class _JoinBloodDonationAppState extends State<JoinBloodDonationApp> {
  @override
  NotificationHelper notificationHelper = NotificationHelper();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initState() {
    // TODO: implement initState
    // notificationHelper.getMyToken();

    notificationHelper.getForGroundMessage(context);
    notificationHelper.getRequest();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/Images/gif.gif', // Replace with your image URL
              width: 350,
              height: 350,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[400],
              ),
              onPressed: () async {
                // await _firebaseMessaging.subscribeToTopic('bloodType');
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => LoginView())));
              },
              child: Text(
                'Register as User',
                style: TextStyle(color: background),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[400],
              ),
              onPressed: () async {
                // await _firebaseMessaging.subscribeToTopic('bloodType');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => RegisterAsHospitalView())));
              },
              child: Text(
                'Register as Hospital',
                style: TextStyle(color: background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
