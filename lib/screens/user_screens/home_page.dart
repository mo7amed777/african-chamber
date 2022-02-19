import 'dart:math';
import 'package:demo/models/ad.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/user_screens/course.dart';
import 'package:demo/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatelessWidget {
  final CurrentUser user;
  HomePage(this.user);
  @override
  Widget build(BuildContext context) {
    int getCount() {
      switch (user.sem) {
        case 'الأولى':
          return 6;
        case 'الثانية':
          return 4;
        case 'الثالثة':
          return 5;
        default:
          return 9;
      }
    }

    return Scaffold(
      backgroundColor: SECONDARYCOLOR,
      body: ListView.builder(
        itemBuilder: (context, index) => buildItem(
          imgURL: SEMS[user.sem]!.values.elementAt(index),
          title: SEMS[user.sem]!.keys.elementAt(index),
        ),
        itemCount: getCount(),
      ),
    );
  }

  Widget buildItem({required String imgURL, required String title}) {
    return InkWell(
      onTap: () => buyCourse(coursID: title),
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 12.0, right: 8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  imgURL,
                  fit: BoxFit.fill,
                  height: 200,
                  width: double.infinity,
                ),
                Positioned(
                  child: Container(
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
                  bottom: 1.0,
                  right: 1.0,
                  left: 1.0,
                ),
              ],
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PRIMARYCOLOR,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random.secure();

  void buyCourse({required String coursID}) async {
    showAdInterstitial();
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      String code = getRandomString(6);

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot? courses_snapshot =
          await firestore.collection('crs_requests').doc(user.uid).get();
      List courses_requests = [];
      if (courses_snapshot.exists) {
        courses_requests = courses_snapshot.get('requests');
      }

      DocumentSnapshot? snapshot =
          await firestore.collection('users').doc(user.uid).get();
      List? courses = [];
      if (snapshot.exists) {
        courses = snapshot.get('courses');
      }

      if (courses!.contains(coursID)) {
        List videoURLs = [];
        List docURLs = [];
        List filesNames = [];
        List videosNames = [];

        DocumentSnapshot fileDoc = await firestore
            .collection('materials')
            .doc(user.sem)
            .collection(coursID)
            .doc('files')
            .collection('users')
            .doc(user.name)
            .get();
        DocumentSnapshot videoDoc = await firestore
            .collection('materials')
            .doc(user.sem)
            .collection(coursID)
            .doc('videos')
            .get();

        if (fileDoc.exists) {
          docURLs = fileDoc.get('urls');
          filesNames = fileDoc.get('names');
        }
        if (videoDoc.exists) {
          videoURLs = videoDoc.get('urls');
          videosNames = videoDoc.get('names');
        }
        List<VideoPlayerController> videos = List.generate(
          videoURLs.length,
          (index) => VideoPlayerController.network(
            videoURLs[index],
          ),
        );
        Get.back();
        Get.toNamed(Course.routeName, arguments: {
          'videoURLs': videoURLs,
          'docURLs': docURLs,
          'filesNames': filesNames,
          'videosNames': videosNames,
          'coursID': coursID,
          'videos': videos,
        });
      } else {
        Get.back();
        for (var request in courses_requests) {
          if (request.containsValue(coursID)) {
            showMessage(
              title: 'مشترك بالفعل',
              text:
                  'عفواً ! لقد قمت بالإشتراك في هذا المحتوى يرجي الإنتظار حتى يتم الموافقة على طلب إشتراكك من قبل الشخص المسئول',
              error: true,
            );
            return;
          }
        }

        Get.defaultDialog(
          title: 'غير مشترك',
          middleText:
              'أنت غير مشترك بهذا المحتوى برجاء الإشتراك أولا حتى تتمكن من تصفح المحتوى',
          cancel: TextButton(
            onPressed: () {
              Get.back();
              return;
            },
            child: Text('إغلاق'),
          ),
          confirm: TextButton(
            onPressed: () async {
              courses_requests.add({
                'code': code,
                'coursID': coursID,
              });
              DocumentSnapshot snap = await firestore
                  .collection('crs_requests')
                  .doc(user.uid)
                  .get();
              if (snap.exists)
                await firestore
                    .collection('crs_requests')
                    .doc(user.uid)
                    .update({
                  'requests': courses_requests,
                });
              else
                await firestore.collection('crs_requests').doc(user.uid).set({
                  'requests': courses_requests,
                });
              Get.back();
              await FlutterWindowManager.clearFlags(
                  FlutterWindowManager.FLAG_SECURE);
              Get.dialog(
                Material(
                  child: Center(
                    child: ListView(
                      children: [
                        text(
                          'قم بعمل سكرين شوت لهذه الشاشة والتوجه إلى المسئول بالمركز',
                        ),
                        Card(
                          elevation: 10.0,
                          child: Image.network(
                            user.id_card,
                            fit: BoxFit.fill,
                            height: 200,
                          ),
                        ),
                        Text(
                          coursID,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: PRIMARYCOLOR),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        text(
                          user.name,
                          size: 25,
                          color: PRIMARYCOLOR!,
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(
                              user.sem,
                              color: PRIMARYCOLOR!,
                            ),
                            text(' : الفرقة'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(
                              user.set_num,
                              color: PRIMARYCOLOR!,
                            ),
                            SizedBox(width: 10),
                            text(' : رقم الجلوس'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(
                              user.email,
                              color: PRIMARYCOLOR!,
                            ),
                            SizedBox(width: 10),
                            text(' : البريد الإلكتروني'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(
                              user.phone,
                              color: PRIMARYCOLOR!,
                            ),
                            SizedBox(width: 10),
                            text(' : رقم الهاتف'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(
                              code,
                              size: 22,
                              color: PRIMARYCOLOR!,
                            ),
                            SizedBox(width: 10),
                            text(' : كود الإشتراك'),
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            Get.back();
                            await FlutterWindowManager.addFlags(
                                FlutterWindowManager.FLAG_SECURE);
                          },
                          child: Text('إغلاق'),
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
                      ],
                    ),
                  ),
                ),
                useSafeArea: true,
              );
            },
            child: Text('إشتراك'),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      showMessage(
          title: 'خطأ في الإشتراك',
          text: 'لقد حدث خطأ أثناء تسجيل إشتراكك يرجي المحاولة في وقت لاحق',
          error: true);
    }
  }

  Widget text(String label, {double size = 20, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );
}
