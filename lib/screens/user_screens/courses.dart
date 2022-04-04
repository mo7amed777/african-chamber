import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/user_screens/course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Courses extends StatelessWidget {
  static final String routeName = '/courses';
  final CurrentUser user;
  Courses(this.user);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SECONDARYCOLOR,
      body: user.courses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم يتم التسجيل في أى محتوى',
                    style: TextStyle(
                      color: PRIMARYCOLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: PRIMARYCOLOR,
                      primary: SECONDARYCOLOR,
                    ),
                    onPressed: () async {
                      Get.dialog(Center(
                        child: CircularProgressIndicator(),
                      ));
                      String exampleURL, exampleName;
                      DocumentSnapshot exampleDoc = await firestore
                          .collection('materials')
                          .doc('example')
                          .get();
                      if (exampleDoc.exists) {
                        exampleURL = exampleDoc.get('video');
                        exampleName = exampleDoc.get('name');
                        BetterPlayerController exampleVideo =
                            BetterPlayerController(
                                BetterPlayerConfiguration(
                                  aspectRatio: 1.2,
                                  placeholder: Center(
                                    child: Text(
                                      'جاري تحميل الفيديو',
                                      style: TextStyle(
                                        color: SECONDARYCOLOR,
                                      ),
                                    ),
                                  ),
                                  showPlaceholderUntilPlay: true,
                                ),
                                betterPlayerDataSource:
                                    BetterPlayerDataSource.network(exampleURL));
                        Get.back();
                        Get.dialog(
                          Material(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: BetterPlayer(
                                    controller: exampleVideo,
                                  ),
                                ),
                                Text(
                                  exampleName,
                                  style: TextStyle(
                                    color: SECONDARYCOLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 50.0,
                                  child: AdWidget(
                                    ad: BannerAd(
                                      size: AdSize.banner,
                                      adUnitId: bannerAdUnitId,
                                      listener: BannerAdListener(
                                        onAdClosed: (ad) async =>
                                            await ad.dispose(),
                                      ),
                                      request: AdRequest(),
                                    )..load(),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    exampleVideo.videoPlayerController!
                                        .dispose()
                                        .then((value) => Get.back());
                                  },
                                  child: Text('إغلاق'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'عرض مثال للشرح',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) => buildItem(
                imgURL: SEMS[user.sem]![user.courses[index]]!,
                title: user.courses[index],
              ),
              itemCount: user.courses.length,
            ),
    );
  }

  Widget buildItem({required String imgURL, required String title}) {
    return InkWell(
      onTap: () async {
        //showAdInterstitial();
        Get.dialog(
          Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );
        List videoURLs = [];
        List docURLs = [];
        List filesNames = [];
        List videosNames = [];

        DocumentSnapshot fileDoc = await firestore
            .collection('materials')
            .doc(user.sem)
            .collection(title)
            .doc('files')
            .collection('users')
            .doc(user.name)
            .get();
        DocumentSnapshot videoDoc = await firestore
            .collection('materials')
            .doc(user.sem)
            .collection(title)
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
        List<BetterPlayerController> _videoPlayerControllers = List.generate(
          videoURLs.length,
          (index) => BetterPlayerController(
            BetterPlayerConfiguration(
              aspectRatio: 1.2,
              placeholder: Center(
                child: Text(
                  'جاري تحميل الفيديو',
                  style: TextStyle(
                    color: SECONDARYCOLOR,
                  ),
                ),
              ),
            ),
            betterPlayerDataSource: BetterPlayerDataSource.network(
              videoURLs[index],
              cacheConfiguration: BetterPlayerCacheConfiguration(
                useCache: true,
                preCacheSize: 10 * 1024 * 1024,
                maxCacheSize: 10 * 1024 * 1024,
                maxCacheFileSize: 10 * 1024 * 1024,
              ),
            ),
          ),
        );

        Get.back();
        Get.toNamed(Course.routeName, arguments: {
          'videoURLs': videoURLs,
          'docURLs': docURLs,
          'filesNames': filesNames,
          'videosNames': videosNames,
          'coursID': title,
          'videos': _videoPlayerControllers,
        });
      },
      
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
}
