import 'package:bldapp/Colors.dart';
import 'package:bldapp/view/ServiceView.dart';
import 'package:bldapp/view/chat_bot.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RejectedDonation extends StatefulWidget {
  const RejectedDonation({
    super.key,
  });

  @override
  _RejectedDonationState createState() => _RejectedDonationState();
}

class _RejectedDonationState extends State<RejectedDonation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Position? currentPosition;
  bool? serviceEnabled;
  LocationPermission? permission;

  @override
  void initState() {
    super.initState();

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
                  'Assets/Images/Wrong_Mark_Png_-_pngio-removebg-preview.png',
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
                  'Sorry , you can\'t donate ',
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
                  'According to the personal examination analysis, you can\'t donate blood',
                  style: TextStyle(fontSize: 18,),
                  textAlign: TextAlign.center,
                ),
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => ChatPage())));
                },
                style: TextButton.styleFrom(
                                    backgroundColor: kSecondary,

                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  fixedSize:
                      Size.fromWidth(MediaQuery.of(context).size.width / 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(color: Colors.amber),
                  ),
                ),
                child: const Text(
                  'Continue ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding:  EdgeInsets.only(
                  right: 40.0, left: 40.0, top: 20, bottom: 20),
              child: TextButton(

                onPressed: () {
                  Navigator.pushReplacementNamed(context, ServiceView.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: kSecondary,
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
