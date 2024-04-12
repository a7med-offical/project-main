import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:bldapp/model/donar_model.dart';
import 'package:bldapp/view/updatessss/donar_details_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class RemoveQrCode extends StatefulWidget {
  const RemoveQrCode({Key? key}) : super(key: key);

  @override
  State<RemoveQrCode> createState() => _RemoveQrCodeState();
}

class _RemoveQrCodeState extends State<RemoveQrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Blood Type'),
      ),
      backgroundColor: Color(0xff100B20),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) => searchFunc(query),
              decoration: InputDecoration(
                hintText: 'Search by Serial Num',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    searchFunc('');
                  },
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Blood Type',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Serial Num',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Details',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(data.length, (index) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data[index]['bloodType'])),
                      DataCell(Text(data[index]['serialNumber'])),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            size: 22,
                            FontAwesomeIcons.info,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DonarDetailsInfo(
                                    donar: Donar(
                                      createdDate: data[index]['createdDate'],
                                      donarName: data[index]['donateName'],
                                      donarId: data[index]['donateID'],
                                      serialNum: data[index]['serialNumber'],
                                      expiredDate: data[index]['expiredDate'],
                                      bloodType: data[index]['bloodType'],
                                      moreDetails: data[index]['moreDetails'],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanQrCode,
        child: Icon(
          Icons.remove,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }

  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> searchData = [];
  TextEditingController searchController =
      TextEditingController(); // Controller for the search query

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('bloodTypeData').get();
    data.addAll(querySnapshot.docs);
    searchData.addAll(data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> scanQrCode() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'Cancel', true, ScanMode.QR)
          .then(
        (value) {
          List data = value.split(' ');
          addData(uid: data[5]);
        },
      );
    } catch (e) {
      setState(() {
        title = 'unable to Scan QR code';
      });
    }
  }

  void searchFunc(String query) {
    setState(() {
      searchData = data.where((doc) {
        String? serialNumber = doc['serialNumber'];
        return serialNumber != null &&
            serialNumber.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> addData({required String uid}) {
    // Call the user's CollectionReference to add a new user
    return bloodTypeData
        .doc(uid)
        .delete()
        .then((value) => () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Removed',
                desc: 'Removed',
                btnCancelOnPress: () {
                  setState(() {});
                },
                btnOkOnPress: () {
                  setState(() {});
                },
              )..show();
            })
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Error',
        btnCancelOnPress: () {
          setState(() {});
        },
        btnOkOnPress: () {
          setState(() {});
        },
      )..show();
    });
  }

  String title = 'Lets Scan QR Code';
  CollectionReference bloodTypeData =
      FirebaseFirestore.instance.collection('bloodTypeData');
}
