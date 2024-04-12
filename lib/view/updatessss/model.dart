// import 'package:cloud_firestore/cloud_firestore.dart';

// class ModelData {
//   Future<void> addUser(String fullName, String bloodType, String id,
//       int serialNum, String date, String exDate) {
//     // Call the user's CollectionReference to add a new user
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     return users
//         .add({
//           'full_name': fullName, // John Doe
//           'blood_type': bloodType, // Stokes and Sons
//           'id': id,
//           'serial_num': serialNum, // John Doe
//           'date': date, // Stokes and Sons
//           'exDate': exDate, // Stokes and Sons
//         })
//         .then((value) => print("User Added"))
//         .catchError((error) => print("Failed to add user: $error"));
//   }
// }
