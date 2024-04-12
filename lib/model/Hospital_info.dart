import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String name;
  final GeoPoint location;
  final Map<String, int> bloodTypes;
  String? image;

  Hospital(
      {required this.name,
      required this.location,
      required this.bloodTypes,
      this.image});
}
