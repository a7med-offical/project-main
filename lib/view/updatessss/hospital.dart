import 'package:bldapp/view/Join_app_view.dart';
import 'package:bldapp/view/updatessss/hospital_notfication.dart';
import 'package:bldapp/view/updatessss/my_Notfication._view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:bldapp/services/shared_prefrance.dart';
import 'package:bldapp/view/SearchView.dart';
import 'package:bldapp/view/hospital_dash_board/views/create_notfication_view.dart';
import 'package:bldapp/view/ocr_view.dart';
import 'package:bldapp/view/register_as_hospital.dart';
import 'package:bldapp/view/updatessss/create_qr_coed.dart';
import 'package:bldapp/view/updatessss/inventory_view.dart';
import 'package:bldapp/view/updatessss/remove.dart';

import '../../Colors.dart';
import 'add_blood_type.dart';

class HospitalDashboard extends StatefulWidget {
  // final QueryDocumentSnapshot snap;
  HospitalDashboard({super.key});
  static String id = '989';

  @override
  State<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  final String url =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5GWRHhWN4BMsklL8oXjWMtCQEVMfzM1sub6yDv6hz_uLUSF4WZgCg1XEwakiL-2d6NuQ&usqp=CAU';
  bool load = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  String hospitalData = '';
  var snap = '';
  checkUser() async {
    snap = await getStringData();
  }

  List<String> data = [];
  getDate() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('HospitalRegisterData')
          .where('uid', isEqualTo: await snap)
          .get();
      dataQuery.addAll(snapshot.docs);
      setState(() {});
    } catch (error) {
      print('$error.');
    }
  }

  List<QueryDocumentSnapshot> dataQuery = [];

  @override
  void initState() {
    checkUser();
    getDate();

    super.initState();
  }

  final List<serviceData> list = [
    serviceData('Assets/Images/scan.png', 'Create Qr'),
    serviceData('Assets/Images/search (3).png', 'Search'),
    serviceData('Assets/Images/add (1).png', 'Add '),
    serviceData('Assets/Images/remove.png', 'Remove'),
    serviceData('Assets/Images/check.png', 'Check Donar'),
    serviceData('Assets/Images/info0.png', 'Info'),
  ];

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('HospitalRegisterData')
          .where('uid', isEqualTo: snap)
          .get(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Text(dataQuery.isNotEmpty ? dataQuery[0]['id'] : '');
        // }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var _theme = Provider.of<ThemeProvider>(context, listen: false);

          final List<Widget> pages = [
            CreateQRBloodType(
              hospitalName: dataQuery.isNotEmpty ? dataQuery[0]['name'] : '',
            ),
            SearchView(),
            AddBloodType(
              id: dataQuery.isNotEmpty ? dataQuery[0]['id'] : '',
            ),
            Remove(
              id: dataQuery.isNotEmpty ? dataQuery[0]['id'] : '',
            ),
            OCR_View(),
            NotififcationView(),
          ];
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotififcationView(),
                          ));
                    },
                    icon: Icon(
                      Icons.notifications,
                      size: 30,
                    )),
              ],
            ),
            key: _scaffoldKey,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('HospitalRegisterData')
                                  .where('uid', isEqualTo: snap)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: kSecondary,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .3,
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return SizedBox();
                                } else {
                                  var snap = snapshot.data!.docs;

                                  return BackgroundImageDashboard(
                                    url: snap[0]['image'],
                                    title: snap[0]['name'],
                                  );
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return pages[index];
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              color:
                                  _theme.isDarkMode ? Colors.white : kSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          list[index].image!,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          list[index].serviceText!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff100B20),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: pages.length,
                    ),
                  ),
                ],
              ),
            ),
            drawer: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: AssetImage('Assets/Images/bld.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'Profile',
                  //     style: Style.style16,
                  //   ),
                  //   leading: Icon(Icons.account_circle),
                  //   onTap: () {
                  //     // Handle profile tap
                  //   },
                  // ),
                  ListTile(
                    title: Text(
                      'Department',
                      style: Style.style16,
                    ),
                    leading: Icon(Icons.pie_chart),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => inventoryView(
                            id: dataQuery.isNotEmpty ? dataQuery[0]['id'] : '',
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'My Notification',
                      style: Style.style16,
                    ),
                    leading: Icon(Icons.notifications_active),
                    onTap: () {
                      Navigator.push(
                        context,
                        (MaterialPageRoute(
                          builder: (context) => HospitalForNotification(),
                        )),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Sign Out',
                      style: Style.style16,
                    ),
                    leading: Icon(Icons.output_sharp),
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      await pref.setBool('isLongging', false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinBloodDonationApp(),
                        ),
                        (route) => false,
                      );
                    },
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
                  Spacer(),

                  Divider(),
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
                            height: 40,
                          )),
                      GestureDetector(
                          onTap: () {
                            String url = 'https://www.facebook.com/egypt.mohp';

                            _launchUrl(url: url);
                          },
                          child: Image.asset('Assets/Images/facebook.png',
                              height: 40)),
                      GestureDetector(
                          onTap: () {
                            String url =
                                'https://www.linkedin.com/in/mohamed-hammad-a720a622/';

                            _launchUrl(url: url);
                          },
                          child: Image.asset('Assets/Images/linkedin.png',
                              height: 40))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _launchUrl({required String url}) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  String whatsappCountryCode = '+20';

  String whatsappNumber = '01156915466';
}

class Style {
  static const style16 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

class serviceData {
  String? image;
  String? serviceText;

  serviceData(this.image, this.serviceText);
}

class BackgroundImageDashboard extends StatelessWidget {
  const BackgroundImageDashboard({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(
            0.5,
          ),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              url,
            ),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.dstATop),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AppBarDashboard extends StatelessWidget {
  const AppBarDashboard({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.menu,
              size: 35,
            )),
      ],
    );
  }
}
