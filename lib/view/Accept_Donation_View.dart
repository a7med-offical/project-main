import 'package:bldapp/view/ServiceView.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Colors.dart';
import 'DonationHospitals.dart';

class AcceptDonation extends StatefulWidget {
  final String bloodType;

  const AcceptDonation({super.key, required this.bloodType});

  @override
  _AcceptDonationState createState() => _AcceptDonationState();
}

class _AcceptDonationState extends State<AcceptDonation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Position? currentPosition;
  bool? serviceEnabled;
  LocationPermission? permission;

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    setState(() {});
  }

  Future<void> _checkLocationPermissionAndNavigate(BuildContext context) async {
    bool hasPermission = await checkLocationPermission();
    bool isLocationServiceEnabled = await checkLocationServiceEnabled();

    if (hasPermission && isLocationServiceEnabled) {
      // Proceed to the next page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return DonationHospitalResualt(
          searchController: widget.bloodType,
        );
      }));
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

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2), // Adjust the duration as needed
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: Image.asset(
                  'Assets/Images/Accepted.png',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 8),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Now , you can donate ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Text(
                  'You can go to the cloest needed hospital to donate.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size.fromWidth(MediaQuery.of(context).size.width / 1.5),
                    textStyle: const TextStyle(color: Colors.amber),
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: const BorderSide(color: Color(0xff101530)),
                    ),
                    backgroundColor: Colors.amber),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff101530)),
                ),
                onPressed: () {
                  _checkLocationPermissionAndNavigate(context);
                  // Handle login pressed
                },
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 40.0, left: 40.0, top: 20, bottom: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, ServiceView.id);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  fixedSize:
                      Size.fromWidth(MediaQuery.of(context).size.width / 1.5),
                  shape: RoundedRectangleBorder(
                  
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(color: Colors.amber),
                  ),
                ),
                child: const Text(
                  'Back ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
