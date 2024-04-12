import 'package:bldapp/Colors.dart';
import 'package:bldapp/helper/notification_helper.dart';
import 'package:bldapp/widget/CustomTextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void customShowBottomSheet(BuildContext context, String id) {
  String userName = '';
  String bloodType = '';
  String phoneNumber = '';
  String place = '';
  String date = '';
  var now = DateTime.now();
  var formatDate = DateFormat('yyyy-MM-dd-kk:mm').format(now);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notification');
  Future<void> addNotification() async {
    try {
      await notification.add({
        'userName': userName,
        'bloodType': bloodType,
        'phoneNumber': phoneNumber,
        'place': place,
        'id':id,
        'date':formatDate   ,
      });
      print('Document added to collection "users"');
      print(FirebaseAuth.instance.currentUser == null
          ? FirebaseAuth.instance.currentUser!.uid
          : id);
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  NotificationHelper notificationHelper = NotificationHelper();
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        color: background,
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            right: 16,
            left: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            CustomTextFormField(
              onChanged: (p0) {
                userName = p0;
              },
              text: 'User Name',
            ),
            SizedBox(
              height: 15,
            ),
            CustomTextFormField(
              onChanged: (p0) {
                bloodType = p0;
              },
              text: 'BloodType',
            ),
            SizedBox(
              height: 15,
            ),

            CustomTextFormField(
              text: 'Place',
              onChanged: (p0) {
                place = p0;
              },
            ),
            SizedBox(
              height: 15,
            ),
            CustomTextFormField(
              text: 'Phone Number',
              onChanged: (p0) {
                phoneNumber = p0;
              },
            ),
            SizedBox(
              height: 15,
            ),
            // ده
            MaterialButton(
              minWidth: double.infinity,
              height: 45,
              onPressed: () async {
                // await _firebaseMessaging.unsubscribeFromTopic('bloodType');
                await addNotification();
                Navigator.pop(context);

                await notificationHelper.sendNotification('bloodType',
                    phoneNumber: phoneNumber,
                    place: place,
                    bloodType: bloodType,
                    userName: userName);

                // await _firebaseMessaging.subscribeToTopic('bloodType');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('Send Notification'),
              color: kPrimary,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      );
    },
  );
}
