import 'package:bldapp/Colors.dart';
import 'package:bldapp/services/shared_prefrance.dart';
import 'package:bldapp/widget/custom_card_notification.dart';
import 'package:bldapp/widget/show_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotififcationView extends StatefulWidget {
  const NotififcationView({super.key});

  @override
  State<NotififcationView> createState() => _NotififcationViewState();
}

class _NotififcationViewState extends State<NotififcationView> {
  final TextStyle dropdownMenuItem =
      const TextStyle(color: Colors.black, fontSize: 18);
  var snap = '';
  checkUser() async {
    snap = await getStringData();
    await getDate();
  }

  Future<void> removeNotification(String notificationId, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notification')
          .doc(notificationId)
          .delete();
      print('Notification removed');
    } catch (e) {
      print('Error removing notification: $e');
    }
    setState(() {});
  }

  List<QueryDocumentSnapshot> data = [];
  getDate() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('HospitalRegisterData')
          .where('uid', isEqualTo: await snap)
          .get();
      data.addAll(snapshot.docs);
      setState(() {});
    } catch (error) {
      print('$error.');
    }
  }

  @override
  void initState() {
    checkUser();
    // TODO: implement initState
    super.initState();
  }

  CollectionReference notification =
      FirebaseFirestore.instance.collection('notification');
  bool myNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
    SharedPreferences pref = await SharedPreferences.getInstance();

          customShowBottomSheet(
              context,
              await pref.getBool('isLongging') == false
                  ? FirebaseAuth.instance.currentUser!.uid
                  : data[0]['id']);
        },
        child: Icon(
          Icons.notification_add,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
                    stream: notification
                        .snapshots()
                        .map((snapshot) => snapshot.docs),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Something went wrong'),
                        );
                      } else {
                        List<QueryDocumentSnapshot> dataList = snapshot.data!;
                        return ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomCardNotification(
                                snap: dataList[index],
                              );
                            });
                      }
                    }),
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: const Text(
                      "Notification",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
