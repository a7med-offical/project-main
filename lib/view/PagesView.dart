// ignore_for_file: file_names
import 'package:bldapp/view/Join_app_view.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';
import '../widget/PageViews_Widget.dart';
import 'LoginView.dart';

class PagesView extends StatefulWidget {
  const PagesView({Key? key}) : super(key: key);

  static String id = '2';

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  final PageController pageController = PageController();
  int currentEndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (int indexPage) {
                setState(() {
                  currentEndex = indexPage;
                });
              },
              children: [
                CustomPageView(
                  image: 'Assets/Images/pageViewer1.png',
                  text: 'Donate and \nsave People',
                  onTap: () {},
                  indexx: currentEndex,
                  onPressed: () {
                    if (currentEndex < 2) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
                CustomPageView(
                  image: 'Assets/Images/image-removebg-preview.png',
                  text: 'Find Cloest \nBlood Tybe',
                  onTap: () {
                    if (currentEndex < 2) {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.ease,
                      );
                    }
                  },
                  indexx: currentEndex,
                  onPressed: () {
                    if (currentEndex < 2) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
                CustomPageView(
                  image: 'Assets/Images/image5.png',
                  text: 'Discover more \n      service',
                  onTap: () {
                    if (currentEndex <= 2) {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  indexx: currentEndex,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinBloodDonationApp(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
