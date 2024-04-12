import 'dart:math';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:bldapp/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_view.dart';

class HospitalData {
  final String name;
  final GeoPoint location;
  final Map<String, int> bloodTypes;
  final String? path;
  // final String? rate;
  HospitalData({
    required this.name,
    required this.location,
    required this.bloodTypes,
    this.path,
  });
}

class DonationHospitalResualt extends StatefulWidget {
  @override
  final String searchController;
  const DonationHospitalResualt({super.key, required this.searchController});
  _DonationHospitalResualtState createState() =>
      _DonationHospitalResualtState();
}

class _DonationHospitalResualtState extends State<DonationHospitalResualt> {
  List<HospitalData> hospitals = [];

  Position? currentPosition;
  bool isInitialized = false;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      findHospitals();
      isInitialized = true;
    }
  }

  GlobalKey googleMapKey = GlobalKey();
  List<Marker> marker = [];
  bool position = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // Set the desired height here
          child: AppBar(
            toolbarHeight: 70,
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.amber[400],
                )),
            title: Text('Hospitals',
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Text(
                        widget.searchController,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: (hospitals.isEmpty && currentPosition == null)
            ? Center(
                child: CircularProgressIndicator(
                    // color: Colors.amber[400],
                    ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('HospitalRegisterData')
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                                    // color: Colors.amber,
                                    ));
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return Center(
                                child: CircularProgressIndicator(
                                    // color: Colors.amber,
                                    ));
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: min(3, hospitals.length),
                              itemBuilder: (BuildContext context, int index) {
                                String bloodType =
                                    widget.searchController.toUpperCase();
                                int bloodTypeCount = hospitals[index]
                                        .bloodTypes
                                        .containsKey(bloodType)
                                    ? hospitals[index].bloodTypes[bloodType]!
                                    : 0;
                                return Column(
                                  children: [
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 40,
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            '${hospitals[index].path}',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ListTile(
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
                                                        currentPosition!
                                                            .latitude,
                                                        currentPosition!
                                                            .longitude,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(FontAwesomeIcons
                                                  .locationArrow),
                                              // color: Colors.amber,
                                            ),
                                            leading: const Icon(
                                              Icons.location_on_outlined,
                                              // color: Colors.amber,
                                            ),
                                            title: Text(hospitals[index].name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  // color: Colors.amber
                                                )),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Blood Type: $bloodType, available: $bloodTypeCount',
                                                  style: const TextStyle(),
                                                ),
                                                Text(
                                                  '${double.parse(
                                                    (Geolocator.distanceBetween(
                                                                hospitals[index]
                                                                    .location
                                                                    .latitude,
                                                                hospitals[index]
                                                                    .location
                                                                    .longitude,
                                                                currentPosition!
                                                                    .latitude,
                                                                currentPosition!
                                                                    .longitude) /
                                                            1000)
                                                        .toStringAsFixed(2),
                                                  )} Km ',
                                                  style: const TextStyle(
                                                      // color: Colors.white
                                                      //
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 10),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                                    // color: Colors.amber,
                                    ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    setState(() {});
  }

  void findHospitals() async {
    hospitals.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('HospitalRegisterData')
        .get();
    List<HospitalData> allHospitals = [];
    for (var doc in querySnapshot.docs) {
      HospitalData hospital = HospitalData(
        path: doc['image'],
        name: doc['name'],
        location: doc['location'],
        bloodTypes: Map<String, int>.from(doc['bloodtype']),
      );
      allHospitals.add(hospital);
    }
    allHospitals.sort((a, b) {
      int bloodTypeValueA =
          a.bloodTypes[widget.searchController.toUpperCase()] ?? 0;
      int bloodTypeValueB =
          b.bloodTypes[widget.searchController.toUpperCase()] ?? 0;
      int bloodTypeComparison = bloodTypeValueA.compareTo(bloodTypeValueB);
      if (bloodTypeComparison != 0) {
        return bloodTypeComparison;
      } else {
        if (currentPosition != null) {
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
        } else {
          return 0;
        }
      }
    });
    hospitals = allHospitals
        .where((hospital) =>
            hospital.bloodTypes
                .containsKey(widget.searchController.toUpperCase()) &&
            hospital.bloodTypes[widget.searchController.toUpperCase()]! >= 0)
        .toList();

    setState(() {});
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const int earthRadius = 6371;

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
