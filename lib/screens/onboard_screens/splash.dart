import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/admin_screens/admin.dart';
import 'package:demo/screens/user_screens/home.dart';
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatelessWidget {
  static String routeName = '/';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), loadUsersData);
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, PRIMARYCOLOR!],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/logo.jpg',
              ),
              radius: 75,
            ),
            SizedBox(height: 10),
            Text(
              'African Chamber',
              style: TextStyle(
                color: SECONDARYCOLOR,
                fontSize: 50,
                fontWeight: FontWeight.w900,
              ),
            ),
            Container(
              height: 50.0,
              child: AdWidget(
                ad: BannerAd(
                  size: AdSize.banner,
                  adUnitId: bannerAdUnitId,
                  listener: BannerAdListener(
                    onAdClosed: (ad) async => await ad.dispose(),
                  ),
                  request: AdRequest(),
                )..load(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            CircularProgressIndicator(
              color: SECONDARYCOLOR,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'جاري التحميل برجاء الإنتظار',
                style: TextStyle(
                  color: SECONDARYCOLOR,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future loadUsersData() async {
    SharedPreferences.getInstance().then((pref) async {
      String uid = pref.getString('uid') ?? 'Not Authorized';
      switch (uid) {
        case 'admin':
          Get.offAndToNamed(Admin.routeName);
          break;
        case 'Not Authorized':
          Get.offAndToNamed(Login.routeName);
          break;
        default:
          {
            String name = FirebaseAuth.instance.currentUser!.displayName ?? '';
            QuerySnapshot snapshot = await firestore.collection('users').get();
            List<QueryDocumentSnapshot> docs = snapshot.docs;
            String deviceId = await PlatformDeviceId.getDeviceId ?? '';

            for (QueryDocumentSnapshot doc in docs) {
              if (doc.id == deviceId) {
                CurrentUser user = CurrentUser(
                  uid: uid,
                  name: name,
                  sem: doc.get('sem'),
                  email: doc.get('email'),
                  courses: doc.get('courses'),
                  id_card: doc.get('id_card'),
                  set_num: doc.get('set_num'),
                  phone: doc.get('phone'),
                );
                Get.offAndToNamed(Home.routeName, arguments: user);
                return;
              }
            }
          }
      }
    });
  }
}
