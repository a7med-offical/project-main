
// import 'package:bldapp/Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// bool? serviceEnabled;
// LocationPermission? permission;
// // var prov = Provider.of<FormProvider>(context as BuildContext, listen: false);

// Future<void> checkLocationPermissionAndNavigate(BuildContext context) async {
//   bool hasPermission = await checkLocationPermission();
//   bool isLocationServiceEnabled = await checkLocationServiceEnabled();

//   if (hasPermission && isLocationServiceEnabled) {
//     // Proceed to the next page
//     // print('selectedGender' + '${prov.selectedGender - 1}');
//     // print('selectedPregnancy' + '${prov.selectedPregnancy == 0 ? 0 : 1}');
//     // print('selectedSmoking' + "${prov.selectedSmoking - 1}");
//     // print('level Hemoglobin' + '$level');
//     // print(bmi);
//     // print(age);
//     // print('selectedChronicKidneyDisease' +
//     //     '${prov.selectedChronicKidneyDisease - 1}');
//     // print('selectedAdrenalAndThyroidDisorders' +
//     //     "${prov.selectedAdrenalAndThyroidDisorders - 1}");
//     // makePrediction();
//   } else {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: background,
//           title: Text(
//             'Location Required',
//             style: TextStyle(color: Colors.amber[400]),
//           ),
//           content: Text(
//             'Please enable location services and app permissions to continue.',
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               color: Colors.amber[400],
//               child: Text('Open Location Settings',
//                   style: TextStyle(color: background)),
//               onPressed: () {
//                 Geolocator
//                     .openLocationSettings(); // Opens the location settings screen
//               },
//             ),
//             MaterialButton(
//               color: Colors.amber[400],
//               child: Text('Open App Settings',
//                   style: TextStyle(color: background)),
//               onPressed: () {
//                 openAppSettings(); // Opens the app settings screen
//               },
//             ),
//             MaterialButton(
//               color: Colors.amber[400],
//               child: Text('Cancel', style: TextStyle(color: background)),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// Future<bool> checkLocationPermission() async {
//   PermissionStatus permission = await Permission.locationWhenInUse.status;

//   if (permission == PermissionStatus.granted) {
//     return true;
//   } else {
//     PermissionStatus permissionStatus =
//         await Permission.locationWhenInUse.request();
//     return permissionStatus == PermissionStatus.granted;
//   }
// }

// Future<bool> checkLocationServiceEnabled() async {
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//   if (!serviceEnabled) {
//     return false;
//   } else {
//     return true;
//   }
// }
