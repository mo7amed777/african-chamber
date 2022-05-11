import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/user_screens/complaint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/onboard_screens/login.dart';

class MainDrawer extends StatelessWidget {
  final CurrentUser? user;
  final bool isAdmin;
  final Column? items;
  MainDrawer({this.user, this.isAdmin = false, this.items});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: PRIMARYCOLOR,
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.indigo],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/logo.jpg'),
                        ),
                      ),
                    ),
                    isAdmin
                        ? Row(
                            children: [
                              Text(
                                ' (Admin) ',
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'الغرفة الأفريقية',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'الغرفة الأفريقية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: isAdmin
                  ? items
                  : Column(
                      children: [
                        drawerItem(
                          icon: Icons.facebook,
                          title: 'الغرفة الأفريقية للدراسات التجارية',
                          callback: () {
                            Get.back();
                            launchUrl(
                              Uri.parse(
                                  'https://www.facebook.com/groups/1515458188707542/'),
                            );
                          },
                        ),
                        drawerItem(
                          icon: Icons.live_help_rounded,
                          title: 'الشكاوي والمقترحات',
                          callback: () {
                            Get.back();
                            Get.to(Complaint(), arguments: {
                              'user': user,
                            });
                          },
                        ),
                        drawerItem(
                          icon: Icons.logout,
                          title: 'تسجيل الخروج',
                          callback: () {
                            //showAdInterstitial();
                            SharedPreferences.getInstance()
                                .then((value) => value.clear());
                            Get.offAllNamed(Login.routeName);
                          },
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Colors.cyan,
                            Colors.indigo,
                          ])),
                          child: Text(
                            '2022 © جميع الحقوق محفوظة لدى الغرفة الأفريقية',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ],
                    )),
        ],
      ),
    );
  }
}

Widget drawerItem({
  required IconData icon,
  required String title,
  required Function callback,
}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: ListTile(
      trailing: Icon(
        icon,
        color: PRIMARYCOLOR,
        size: 30.0,
      ),
      title: Text(
        title,
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: PRIMARYCOLOR,
          fontSize: 18.0,
        ),
      ),
      onTap: () {
        callback();
      },
    ),
  );
}
