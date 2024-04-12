import 'package:flutter/material.dart';
import '../Colors.dart';
import '../widget/Custom_Clipper.dart';
import 'PagesView.dart';

class SplashView extends StatefulWidget {
  static String id = '1';
  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, PagesView.id);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Expanded(
            child: Image.asset('Assets/Images/images6.png'),
          ),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator(color: Colors.white),
                ],
              ),
              height: 300,
              color: Colors.orange[400],
            ),
          ),
        ],
      ),
    );
  }
}
