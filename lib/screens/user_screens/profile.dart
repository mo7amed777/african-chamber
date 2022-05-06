import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Profile extends StatelessWidget {
  final CurrentUser user;
  Profile(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            text(user.name, size: 25),
            text(' الفرقة  : ' + user.sem),
            text(user.set_num + ' : رقم الجلوس '),
            text(user.courses.isEmpty
                ? 'لم يتم التسجيل في أى محتوى'
                : 'الإشتراكات'),
            user.courses.isNotEmpty
                ? Column(
                    children:
                        user.courses.map((course) => text(course)).toList(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget text(String label, {double size = 20}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: PRIMARYCOLOR,
        ),
      ),
    );
  }
}
