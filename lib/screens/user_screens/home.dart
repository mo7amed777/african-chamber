import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/user_screens/courses.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/screens/user_screens/posts.dart';
import 'package:demo/screens/user_screens/profile.dart';
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  static String routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DocumentSnapshot> posts = Get.arguments[1];

  bool showBadge = true;
  @override
  void initState() {
    super.initState();
    secure();
  }

  @override
  void dispose() {
    super.dispose();
    unsecure();
  }

  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  unsecure() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //showAdInterstitial();

        bool res = false;
        await Get.defaultDialog(
          title: 'إغلاق',
          middleText: 'هل تريد الخروج من التطبيق ؟',
          cancel: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('لا'),
          ),
          confirm: TextButton(
            onPressed: () {
              Get.back();
              res = true;
            },
            child: Text('نعم'),
          ),
        );
        return res;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles.elementAt(_selectedIndex)),
          backgroundColor: PRIMARYCOLOR,
          actions: [
            IconButton(
              onPressed: () async {
                await AwesomeNotifications().resetGlobalBadge();
                setState(() {
                  showBadge = false;
                });
                Get.toNamed(Posts.routeName, arguments: posts);
              },
              icon: Badge(
                child: Icon(
                  Icons.notifications,
                  size: 30,
                ),
                showBadge: showBadge && posts.isNotEmpty,
                position: BadgePosition.topEnd(end: -4, top: -9),
                badgeContent: Text(
                  '${posts.length}',
                  style: TextStyle(
                    color: SECONDARYCOLOR,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                //showAdInterstitial();
                SharedPreferences.getInstance().then((value) => value.clear());
                Get.offAllNamed(Login.routeName);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            backgroundColor: SECONDARYCOLOR,
            gap: 8,
            activeColor: SECONDARYCOLOR,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: PRIMARYCOLOR!,
            color: PRIMARYCOLOR,
            tabs: [
              GButton(
                icon: Icons.menu_book_rounded,
                text: titles[0],
              ),
              GButton(
                icon: Icons.home,
                text: titles[1],
              ),
              GButton(
                icon: Icons.person_pin,
                text: titles[2],
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        //body: Test(),
        body: widgets.elementAt(_selectedIndex),
      ),
    );
  }

  List<String> titles = [
    'الإشتراكات',
    'الصفحة الرئيسية',
    'الصفحة الشخصية',
  ];
  List<Widget> widgets = [
    Courses(Get.arguments[0]),
    HomePage(Get.arguments[0]),
    Profile(Get.arguments[0]),
  ];
}
