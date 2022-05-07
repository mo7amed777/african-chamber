import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Profile extends StatelessWidget {
  final CurrentUser user;
  Profile(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARYCOLOR,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Card(
              child: Image.network(
                user.id_card,
                fit: BoxFit.fill,
                height: 200,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  text('بيانات الطالب', color: SECONDARYCOLOR),
                  text(user.name, color: SECONDARYCOLOR),
                  text(' الفرقة  : ' + user.sem, color: SECONDARYCOLOR),
                  text(user.set_num + ' : رقم الجلوس ', color: SECONDARYCOLOR),
                  text(user.phone + ' : رقم الهاتف ', color: SECONDARYCOLOR),
                  text(user.email + ' : البريد الإلكتروني ',
                      color: SECONDARYCOLOR),
                  text(
                      user.courses.isEmpty
                          ? 'لم يتم التسجيل في أى محتوى'
                          : 'الإشتراكات',
                      color: SECONDARYCOLOR),
                  user.courses.isNotEmpty
                      ? Column(
                          children: user.courses
                              .map((course) =>
                                  text(course, color: SECONDARYCOLOR))
                              .toList(),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
