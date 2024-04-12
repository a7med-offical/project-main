import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bldapp/Colors.dart';
// import 'package:bldapp/Provider/notification_provider.dart';
import 'package:bldapp/helper/notification_helper.dart';
import 'package:bldapp/services/shared_prefrance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Provider/theme_provider.dart';
import 'updatessss/hospital.dart';

// ignore: must_be_immutable
class RegisterAsHospitalView extends StatefulWidget {
  RegisterAsHospitalView({super.key});

  @override
  State<RegisterAsHospitalView> createState() => _RegisterAsHospitalViewState();
}

class _RegisterAsHospitalViewState extends State<RegisterAsHospitalView> {
  TextEditingController idController = TextEditingController();
  NotificationHelper notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hospital Register',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Card(
                  color: _theme.isDarkMode ? background : kSecondary,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage('Assets/Images/hospital.png'),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: idController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter secret key',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      MaterialButton(
                        color: _theme.isDarkMode ? background : Colors.white,
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minWidth: MediaQuery.of(context).size.width - 20,
                        onPressed: () async {
                          load();
                          final CollectionReference Hospital = FirebaseFirestore
                              .instance
                              .collection('HospitalRegisterData');
                          final QuerySnapshot snapshot = await Hospital.where(
                                  'id',
                                  isEqualTo: idController.text)
                              .get();
                          if (snapshot.docs.isEmpty) {
                            load();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.scale,
                              title: 'Error',
                              desc: 'Invalid secret number',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {},
                            )..show();
                          } else {
                            await Future.delayed(Duration(seconds: 2),
                                () async {
                                     await FirebaseMessaging.instance
                                               .subscribeToTopic('bloodType');
                              SharedPreferences pref =await SharedPreferences.getInstance();
                              await pref.setBool('isLongging', true);

                              await saveStringData(
                                snapshot.docs[0]['uid'],
                              );

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          HospitalDashboard())));
                            });
                          }
                        },
                        child: loading
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: _theme.isDarkMode
                                      ? Colors.white
                                      : background,
                                ),
                              )
                            : Text(
                                'Register',
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Or Contact us ',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () {
                                String url =
                                    'https://wa.me/$whatsappCountryCode$whatsappNumber';

                                _launchUrl(url: url);
                              },
                              child: Image.asset(
                                'Assets/Images/whatsapp.png',
                                height: 50,
                              )),
                          GestureDetector(
                              onTap: () {
                                String url =
                                    'https://www.facebook.com/egypt.mohp';

                                _launchUrl(url: url);
                              },
                              child: Image.asset('Assets/Images/facebook.png',
                                  height: 50)),
                          GestureDetector(
                              onTap: () {
                                String url =
                                    'https://www.linkedin.com/in/mohamed-hammad-a720a622/';

                                _launchUrl(url: url);
                              },
                              child: Image.asset('Assets/Images/linkedin.png',
                                  height: 50))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String whatsappCountryCode = '+20';

  String whatsappNumber = '01156915466';

  bool loading = false;

  void load() {
    loading = !loading;
    setState(() {});
  }
}

Future<void> _launchUrl({required String url}) async {
  final Uri _url = Uri.parse(url);

  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
