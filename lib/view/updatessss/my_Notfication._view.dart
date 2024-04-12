import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bldapp/Colors.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:bldapp/services/shared_prefrance.dart';
import 'package:bldapp/widget/custom_card_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNotificationView extends StatefulWidget {
  const MyNotificationView({super.key});

  @override
  State<MyNotificationView> createState() => _MyNotificationViewState();
}

class _MyNotificationViewState extends State<MyNotificationView> {
  final TextStyle dropdownMenuItem =
      const TextStyle(color: Colors.black, fontSize: 18);
  var snap = '';
  
  checkUser() async {
    snap = await getStringData();
    await getDate();
         SharedPreferences pref = await SharedPreferences.getInstance();
     await pref.getBool('isLongging');
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
            var _theme = Provider.of<ThemeProvider>(context);

    return Scaffold(     
    floatingActionButton: FloatingActionButton(
            backgroundColor: _theme.isDarkMode? Colors.amber : background,

        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.rightSlide,
            title: 'Are you sure to delete all Notification ?',
            desc: 'The notifications will be completely deleted ',
            btnCancelOnPress: () {},
            btnOkOnPress: ()  {
             deleteItem();
            },
          )..show();
        },
        child: Icon(Icons.delete,color:  _theme.isDarkMode? Colors.white: background),
      ),

      appBar: AppBar(
        title: Text('My Notification'),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
          stream: notification
              .where('id',
                  isEqualTo:
             FirebaseAuth.instance.currentUser!.uid)
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
    );
  }
 void deleteItem() {
    FirebaseFirestore.instance
        .collection('notification')
        .where('id', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
        print("Document with ID ${doc.id} deleted successfully.");
      });
    }).catchError((error) {
      print("Failed to delete documents: $error");
    });
  }
}
