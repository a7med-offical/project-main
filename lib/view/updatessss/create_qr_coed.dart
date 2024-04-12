import 'package:barcode_widget/barcode_widget.dart';
import 'package:bldapp/Colors.dart';
import 'package:bldapp/model/donar_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../Provider/theme_provider.dart';

class CreateQRBloodType extends StatefulWidget {
  final String hospitalName;

  const CreateQRBloodType({super.key, required this.hospitalName});

  @override
  _CreateQRBloodTypeState createState() => _CreateQRBloodTypeState();
}

class _CreateQRBloodTypeState extends State<CreateQRBloodType> {
  // String bloodType = 'A+';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.hospitalName);
  }

  String postId = Uuid().v1();

  Map<String, int> bloodTypes = {
    'A+': 0,
    'A-': 0,
    'B+': 0,
    'B-': 0,
    'AB+': 0,
    'AB-': 0,
    'O+': 0,
    'O-': 0,
  };

  @override
  Widget build(BuildContext context) {
    var _theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create QR Blood Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: BarcodeWidget(
                    color: _theme.isDarkMode ? Colors.white : background,
                    data:
                        '${donar.donarName} ${donar.donarId} ${donar.serialNum} ${donar.bloodType} ${postId} ${donar.expiredDate} ${widget.hospitalName.replaceAll(' ', '-')} ${donar.moreDetails}',
                    barcode: Barcode.qrCode(),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: Donar.nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Donor Name'),
                  onChanged: (value) => setState(
                      () => donar.donarName = value.replaceAll(' ', '-')),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: Donar.idController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'National Id'),
                  onChanged: (value) =>
                      setState(() => donar.donarId = value.replaceAll(' ', '')),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: Donar.serialNumber,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabled: false,
                      labelText: 'S-N : ' + donar.serialNum),
                  onChanged: (value) => setState(() {
                    donar.serialNum = donar.generateSerialNumber();
                  }),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: Donar.expiredDateController,
                  decoration: InputDecoration(
                      enabled: false,
                      border: OutlineInputBorder(),
                      labelText: 'Expired : ' + donar.expiredDate),
                  onChanged: (value) => setState(
                      () => donar.expiredDate = value.replaceAll(' ', '')),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: Donar.detailsController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Add more data'),
                  onChanged: (value) =>
                      setState(() => donar.moreDetails = value),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: donar.bloodType,
                  onChanged: (value) =>
                      setState(() => donar.bloodType = value.toString()),
                  items: bloodTypes.keys.map((String bloodType) {
                    return DropdownMenuItem<String>(
                      value: bloodType,
                      child: Text(bloodType),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Blood Type'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[400],
                  ),
                  onPressed: () {
                    Donar.clearTextFields();
                    donar.serialNum = donar.generateSerialNumber();
                    donar.expiredDate =
                        donar.formatDate(donar.add35DaysToDateFromNow());

                    setState(() {});
                  },
                  child: const Text(
                    'Print Barcode ',
                    style: style.style18,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

CollectionReference bloodTypeData =
    FirebaseFirestore.instance.collection('bloodTypeData');
Donar donar = Donar(
    createdDate: '',
    donarName: '',
    donarId: 'donarId',
    serialNum: '5679',
    expiredDate: '',
    bloodType: 'A+',
    moreDetails: '//');

Future<void> addData() {
  return bloodTypeData
      .add({
        'donateName': donar.donarName,
        'bloodType': donar.bloodType,
        'donateID': donar.donarId,
        'expiredDate': donar.expiredDate,
        'serialNumber': donar.serialNum,
        'moreDetails': donar.moreDetails

        // 42
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

class style {
  static const style18 = TextStyle(
    fontSize: 18,
    color: Color(0xff100B20),
    fontWeight: FontWeight.bold,
  );
}
