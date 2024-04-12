// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bldapp/Provider/ProvidetUser.dart';
import 'package:bldapp/view/Rejected_Donation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../Colors.dart';
import 'Accept_Donation_View.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({
    Key? key,
    required this.bloodType,
    required this.ability,
  }) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
  final String bloodType;
  final int ability;
}

class _LoadingViewState extends State<LoadingView> {
  Position? currentPosition;

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          if (widget.ability == 1) {
            return AcceptDonation(
              bloodType: widget.bloodType,
            );
          } else {
            return RejectedDonation();
          }
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitHourGlass(
                  color: Color(0xffFFCA28),
                  size: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Please wait for check\n your information',
                  style: TextStyle(
                    color: Colors.amber[400],
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
