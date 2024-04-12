import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQRCodeForAdd extends StatefulWidget {
  const ScanQRCodeForAdd({
    super.key,
  });

  @override
  State<ScanQRCodeForAdd> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCodeForAdd> {
  String title = 'Lets Scan QR Code';
  CollectionReference bloodTypeData =
      FirebaseFirestore.instance.collection('bloodTypeData');

  Future<void> addData({
    required String donarName,
    required String bloodType,
    required String donarId,
    required String createdDate,
    required String expiredDate,
    required String moreDetails,
    required String serialNumber,
  }) {
    // Call the user's CollectionReference to add a new user
    return bloodTypeData
        .add({
          'donateName': donarName, // John Doe
          'bloodType': bloodType, // Stokes and Sons
          'donateID': donarId,
          'expiredDate': expiredDate, // John Doe
          'serialNumber': serialNumber,
          'moreDetails': moreDetails,
          'createdDate': createdDate,
          // Stokes and Sons

          // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  String bloodType = '';
  int bloodTypeNum = 0;
  Map<String, int> blood = {
    'A+': 5,
    'A-': 5,
    'B+': 5,
    'B-': 5,
    'O-': 5,
    'O+': 5,
    'AB+': 5,
    'AB-': 5,
  };

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR_Code'),
      ),
      body: Center(
          child: Column(
        children: [
          Text(title),
          MaterialButton(
            color: Colors.blue,
            onPressed: scanQrCode,
            child: const Text('Scan now'),
          ),
          const SizedBox(
            height: 15,
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {},
            child: const Text('Navigate'),
          ),
          const Text(
              '---------------------------------------------------------'),
        ],
      )),
    );
  }

  Future<void> scanQrCode() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'Cancel', true, ScanMode.QR)
          .then(
        (value) {
          List data = value.split(' ');
          addData(
            donarName: data[0],
            donarId: data[1],
            moreDetails: data[2],
            serialNumber: data[3],
            bloodType: data[4],
            createdDate: '',
            expiredDate: '',
          );
        },
      );
    } catch (e) {
      setState(() {
        title = 'unable to Scan QR code';
      });
    }
  }
}
