import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalModel {
  final String name;
  final GeoPoint location;
  String? image;

HospitalModel({required this.name, required this.location, this.image});
CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addHospital( HospitalModel DataModel ) {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'Hospital_name': name, // John Doe
            'Location': location, // Stokes and Sons
            'image': image // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }}
