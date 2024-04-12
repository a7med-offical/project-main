import 'package:bldapp/Colors.dart';
import 'package:bldapp/Provider/ProvidetUser.dart';
import 'package:bldapp/services/shared_prefrance.dart';
import 'package:bldapp/view/DonationView.dart';
import 'package:bldapp/view/Join_app_view.dart';
import 'package:bldapp/view/LoginView.dart';
import 'package:bldapp/view/PagesView.dart';
import 'package:bldapp/view/RegisterView.dart';
import 'package:bldapp/view/SearchView.dart';
import 'package:bldapp/view/ServiceView.dart';
import 'package:bldapp/view/Splash_Screen.dart';
import 'package:bldapp/view/chat_bot.dart';
import 'package:bldapp/view/register_as_hospital.dart';
import 'package:bldapp/view/updatessss/hospital.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) {
        return FormProvider();
      },
    ),
    ChangeNotifierProvider(create: (context) {
      return ThemeProvider();
    }),
  ], child: const BloodDonationLocator()));
}

class BloodDonationLocator extends StatefulWidget {
  const BloodDonationLocator({Key? key}) : super(key: key);
  @override
  State<BloodDonationLocator> createState() => _BloodDonationLocatorState();
}

class _BloodDonationLocatorState extends State<BloodDonationLocator> {
  @override
  getdata() async {
    await getStringLogin();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    var _theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: _theme.isDarkMode ? background : Colors.white,
        brightness: _theme.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      title: 'Blood Locator Donate',
      debugShowCheckedModeBanner: false,
      routes: {
        SplashView.id: (context) => SplashView(),
        PagesView.id: (context) => const PagesView(),
        LoginView.id: (context) => LoginView(),
        RegisterView.id: (context) => RegisterView(),
        ServiceView.id: (context) => const ServiceView(),
        SearchView.id: (context) => const SearchView(),
        DonationView.id: (context) => const DonationView(),
      },
      home: FutureBuilder<bool>(
        future: checkUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return HospitalDashboard();
          }
          
           else if (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified) {
            return ServiceView();
          } else {
            return SplashView();
          }
        },
      ),
    
      

    );
  }

  Future<bool> checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isLoggedIn') ?? false;
  }
}
