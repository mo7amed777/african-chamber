import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/admin_screens/admin.dart';
import 'package:demo/screens/admin_screens/admin_courses.dart';
import 'package:demo/screens/admin_screens/post.dart';
import 'package:demo/screens/admin_screens/requests.dart';
import 'package:demo/screens/admin_screens/sem_users.dart';
import 'package:demo/screens/user_screens/course.dart';
import 'package:demo/screens/user_screens/home.dart';
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:demo/screens/onboard_screens/signup.dart';
import 'package:demo/screens/onboard_screens/splash.dart';
import 'package:demo/screens/user_screens/posts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDxdloIscDMyWAgCkus77vZ5jw1IpXDcg8",
            appId: "1:727474785846:ios:af38ce07502e802538d297",
            messagingSenderId: "727474785846",
            projectId: "fir-a062a"));
  } else {
    await Firebase.initializeApp();
  }

  await MobileAds.instance.initialize();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: PRIMARYCOLOR,
        ledColor: SECONDARYCOLOR,
      ),
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en'),
      theme: ThemeData(
        fontFamily: 'Amiri',
      ),
      title: 'African Chamber',
      routes: {
        Splash.routeName: (_) => Splash(),
        Home.routeName: (_) => Home(),
        Requests.routeName: (_) => Requests(),
        Course.routeName: (_) => Course(),
        AdminCourses.routeName: (_) => AdminCourses(),
        Admin.routeName: (_) => Admin(),
        Post.routeName: (_) => Post(),
        Posts.routeName: (_) => Posts(),
        Login.routeName: (_) => Login(),
        SignUP.routeName: (_) => SignUP(),
        SemUsers.routeName: (_) => SemUsers(),
      },
    );
  }
}
