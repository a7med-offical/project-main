import 'package:awesome_icons/awesome_icons.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:bldapp/view/hospital_dash_board/views/create_notfication_view.dart';
import 'package:bldapp/view/ocr_view.dart';
import 'package:bldapp/view/updatessss/hospital.dart';
import 'package:bldapp/view/updatessss/my_Notfication._view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/CustomButton.dart';
import 'DonationView.dart';
import 'LoginView.dart';
import 'SearchView.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});
  static String id = '4';
  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  List<QueryDocumentSnapshot> dataList = [];
  bool isLoading = true;
  getUserName() async {
    QuerySnapshot response = await FirebaseFirestore.instance
        .collection('user')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    dataList.addAll(response.docs);
    isLoading = false;
    setState(() {});
  }

  bool? serviceEnabled;
  LocationPermission? permission;

  @override
  void initState() {
    getUserName();
    determinePosition();
    super.initState();
  }

  final snackbar = SnackBar(
    content: Text(
      'Location is required to use app! ',
    ),
  );
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {}

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    return await Geolocator.getCurrentPosition();
  }

  GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var _theme = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      key: key,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.open_in_new,
        ),
        onPressed: () {
          key.currentState!.openDrawer();
        },
      ),
      drawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(80),
            ),
          ),
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      margin: EdgeInsets.all(0),
                      child: DrawerHeader(
                          padding: EdgeInsets.all(0),
                          curve: Curves.easeInOutCubicEmphasized,
                          // duration: Duration(seconds: 2),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("Assets/Images/1111.jfif"),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dataList[index]['url'] != null
                                      ? CircleAvatar(
                                          radius: 70,
                                          backgroundImage: NetworkImage(
                                            dataList[index]['url'],
                                            scale: 2,
                                          ))
                                      : CircleAvatar(
                                          radius: 70,
                                          backgroundImage: NetworkImage(
                                            'https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg',
                                            scale: 2,
                                          ),
                                        ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '${dataList[0]['frist_name']} ${dataList[index]['last_name']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    dataList[index]['email'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  CustomListTitle(
                    onpressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OCR_View(),
                          ));
                    },
                    text: 'Blood Donate',
                    icon: Icons.bloodtype,
                  ),
                  CustomListTitle(
                    text: 'Find blood type',
                    onpressed: () {
                      Navigator.pushNamed(context, SearchView.id);
                      key.currentState!.closeDrawer();
                    },
                    icon: FontAwesomeIcons.search,
                  ),
                  CustomListTitle(
                    onpressed: () async {
                      key.currentState!.closeDrawer();
                      await OpenAppSettings.openAppSettings();
                    },
                    text: 'Permission',
                    icon: Icons.settings_input_antenna_rounded,
                  ),
                  ListTile(
                    title: Text(
                      'Dark Mode',
                      style: Style.style16,
                    ),
                    leading: Switch(
                      value: _theme.isDarkMode,
                      onChanged: (value) {
                        _theme.toggleTheme();
                      },
                    ),
                  ),
                  CustomListTitle(
                      text: 'My Notification',
                      onpressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyNotificationView(),
                            ));
                      },
                      icon: Icons.notifications),
                  CustomListTitle(
                    text: 'Sign out',
                    onpressed: () {
                      key.currentState!.closeDrawer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Do you want to sign out ?",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            actions: [
                              MaterialButton(
                                  onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginView(),
                                        ),
                                        (route) => false);
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          );
                          // show the dialog ;
                        },
                      );
                      // set up the button
                      // set up the AlertDialog
                    },
                    icon: Icons.output_outlined,
                  ),
                  CustomListTitle(
                    onpressed: () async {
                      key.currentState!.closeDrawer();
                    },
                    text: 'Close',
                    icon: Icons.close,
                  ),
                ],
              );
            },
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                'Hello , ',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 22,
                                    fontFamily: 'Borel-Regular'),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 200,
                              child: ListView.builder(
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: dataList.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            dataList[index]['frist_name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            dataList[index]['last_name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotififcationView(),
                            ));
                        },
                        icon: Icon(
                          Icons.notifications_active,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  Image.asset('Assets/Images/image2.png', height: 200),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Blood Locator Donation',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'choose the Service you want',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationView(),
                            ));
                      },
                      text: 'Donate blood'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      text: 'Find blood type',
                      onTap: () {
                        Navigator.pushNamed(context, SearchView.id);
                      }),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    height: 1,
                  )
                ],
              ),
      ),
    );
  }
}

class CustomListTitle extends StatelessWidget {
  const CustomListTitle({
    super.key,
    required this.text,
    required this.onpressed,
    required this.icon,
  });
  final String? text;
  final VoidCallback onpressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: ListTile(
        title: Text(
          text!,
        ),
        leading: Icon(
          icon,
        ),
      ),
    );
  }
}
