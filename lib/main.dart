import 'package:demo/screens/admin_screens/admin.dart';
import 'package:demo/screens/admin_screens/requests.dart';
import 'package:demo/screens/admin_screens/sem_users.dart';
import 'package:demo/screens/user_screens/course.dart';
import 'package:demo/screens/user_screens/home.dart';
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:demo/screens/onboard_screens/signup.dart';
import 'package:demo/screens/onboard_screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Amiri',
      ),
      title: 'African Chamber',
      routes: {
        Splash.routeName: (_) => Splash(),
        Home.routeName: (_) => Home(),
        Requests.routeName: (_) => Requests(),
        Course.routeName: (_) => Course(),
        Admin.routeName: (_) => Admin(),
        Login.routeName: (_) => Login(),
        SignUP.routeName: (_) => SignUP(),
        SemUsers.routeName: (_) => SemUsers(),
      },
    );
  }
}
