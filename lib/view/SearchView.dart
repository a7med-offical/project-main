import 'dart:async';
import 'dart:math';
import 'package:bldapp/Colors.dart';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Colors.dart';
import '../Widget/CustomButton.dart';
import '../Widget/CustomTextFormField.dart';
import '../model/Hospital_info.dart';
import 'map_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);
  static String id = '22';
  @override
  State<SearchView> createState() =>
      _SearchViewState(); // Import the dart:math library
}

class _SearchViewState extends State<SearchView> {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController searchController = TextEditingController();
  List<Hospital> hospitals = [];
  Position? currentPosition;
  bool? serviceEnabled;
  LocationPermission? permission;
  StreamSubscription<Position>? positionStreamSubscription;
  final snackbar = SnackBar(
    content: Text('Location is required to use app'),
  );
  //Directions? _info;
  Future<void> _checkLocationPermissionAndNavigate(BuildContext context) async {
    bool hasPermission = await checkLocationPermission();
    bool isLocationServiceEnabled = await checkLocationServiceEnabled();

    if (hasPermission && isLocationServiceEnabled) {
      // Proceed to the next page
      setState(() {
        getCurrentLocation();
      });
      findHospitals();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: background,
            title: Text(
              'Location Required',
              style: TextStyle(color: Colors.amber[400]),
            ),
            content: Text(
              'Please enable location services and app permissions to continue.',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.amber[400],
                child: Text('Open Location Settings',
                    style: TextStyle(color: background)),
                onPressed: () {
                  Geolocator
                      .openLocationSettings(); // Opens the location settings screen
                },
              ),
              MaterialButton(
                color: Colors.amber[400],
                child: Text('Open App Settings',
                    style: TextStyle(color: background)),
                onPressed: () {
                  openAppSettings(); // Opens the app settings screen
                },
              ),
              MaterialButton(
                color: Colors.amber[400],
                child: Text('Cancel', style: TextStyle(color: background)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus permission = await Permission.locationWhenInUse.status;

    if (permission == PermissionStatus.granted) {
      return true;
    } else {
      PermissionStatus permissionStatus =
          await Permission.locationWhenInUse.request();
      return permissionStatus == PermissionStatus.granted;
    }
  }

  Future<bool> checkLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    } else {
      return true;
    }
  }

  void getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
      });
      findHospitals();
    }
  }

  void startListeningForPositionUpdates() {
    Geolocator.checkPermission().then((permission) {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return 0;
      }

      Geolocator.isLocationServiceEnabled().then((serviceEnabled) {
        if (!serviceEnabled) {
          return;
        }

        setState(() {
          positionStreamSubscription =
              Geolocator.getPositionStream().listen((position) {
            currentPosition = position;
          });
        });
      });
    });
  }

  void stopListeningForPositionUpdates() {
    positionStreamSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    //addHospitalsData();
    startListeningForPositionUpdates();
    // getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {

        var _theme = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, right: 14, left: 14),
          child: SafeArea(
            top: true,
            child: Form(
              key: key,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Find the closest\nblood type for you',
                        style: TextStyle(
                          color: _theme.isDarkMode? Colors.white : background,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextFormField(
                      validator: (value) {
                        final bloodTypePattern =
                            RegExp(r'^(A|B|AB|O)[+-]$', caseSensitive: false);
                        if (bloodTypePattern.hasMatch(value!.toUpperCase())) {
                          return null; // Valid blood type
                        } else {
                          hospitals = [];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: background,
                                title: Text(
                                  'Invalid Blood Type',
                                ),
                                content: Text(
                                  'The blood type you entered is not valid.',
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    color: Colors.amber[400],
                                    child: Text(
                                      'OK',
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      controller: searchController,
                      suffixIcon: Icons.search,
                      text: 'Search',
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      onTap: () {
                        if (key.currentState!.validate()) {
                          _checkLocationPermissionAndNavigate(context);
                        }
                        // findHospitals();
                      },
                      text: 'Find closest blood Type',
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    const SizedBox(height: 30.0),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('HospitalRegisterData')
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return  CircularProgressIndicator(
                            color: _theme.isDarkMode? Colors.amber : background,
                          );
                        }
                        //
                        if (snapshot.hasData && currentPosition != null) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: min(3, hospitals.length),
                              itemBuilder: (BuildContext context, int index) {
                                String bloodType =
                                    searchController.text.toUpperCase();
                                int bloodTypeCount = hospitals[index]
                                        .bloodTypes
                                        .containsKey(bloodType)
                                    ? hospitals[index].bloodTypes[bloodType]!
                                    : 0;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HospitalLocationPage(
                                              hospitalLocation: LatLng(
                                                hospitals[index]
                                                    .location
                                                    .latitude,
                                                hospitals[index]
                                                    .location
                                                    .longitude,
                                              ),
                                              hospitalName:
                                                  hospitals[index].name,
                                              currentPosition: LatLng(
                                                currentPosition!.latitude,
                                                currentPosition!.longitude,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon:
                                          Icon(FontAwesomeIcons.locationArrow),
                                      color:_theme.isDarkMode? Colors.amber : background,
                                    ),
                                    title: Text(
                                      hospitals[index].name,
                                      style: TextStyle(
                                          color: _theme.isDarkMode? Colors.white : background ,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      'Blood Type: $bloodType, available: $bloodTypeCount',
                                      style: TextStyle(color: _theme.isDarkMode? Colors.white : background),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void findHospitals() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: (background),
          title: Text(
            'Location Service Disabled',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
              'Please enable the location service to perform the search.',
              style: TextStyle(color: Colors.amber)),
          actions: [
            MaterialButton(
              color: Colors.amber[400],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text('OK', style: TextStyle(color: background)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    String searchBloodType = searchController.text.toUpperCase();

    // Query Firebase for hospitals
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('HospitalRegisterData')
        .get();

    List<Hospital> allHospitals = [];
    for (var doc in querySnapshot.docs) {
      Hospital hospital = Hospital(
          name: doc['name'],
          location: doc['location'],
          bloodTypes: Map<String, int>.from(doc['bloodtype']),
          image: doc['image']);
      allHospitals.add(hospital);
    }

    hospitals = allHospitals
        .where((hospital) =>
            hospital.bloodTypes.containsKey(searchBloodType) &&
            hospital.bloodTypes[searchBloodType]! > 0)
        .toList();

    if (currentPosition != null) {
      hospitals.sort((a, b) {
        double distanceToA = calculateDistance(
          currentPosition!.latitude,
          currentPosition!.longitude,
          a.location.latitude,
          a.location.longitude,
        );
        double distanceToB = calculateDistance(
          currentPosition!.latitude,
          currentPosition!.longitude,
          b.location.latitude,
          b.location.longitude,
        );
        return distanceToA.compareTo(distanceToB);
      });
    }

    setState(() {});
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const int earthRadius = 6371; // in kilometers

    double lat1 = startLatitude * (3.1415 / 180);
    double lon1 = startLongitude * (3.1415 / 180);
    double lat2 = endLatitude * (3.1415 / 180);
    double lon2 = endLongitude * (3.1415 / 180);

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

}
