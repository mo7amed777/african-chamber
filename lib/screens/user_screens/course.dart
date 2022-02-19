import 'dart:async';

import 'package:demo/constants.dart';
import 'package:demo/models/ad.dart';
import 'package:demo/widgets/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

class Course extends StatefulWidget {
  static final String routeName = '/course';
  static final List videoURLs = Get.arguments['videoURLs'];
  static final List docURLs = Get.arguments['docURLs'];
  static final List filesNames = Get.arguments['filesNames'];
  static final List videosNames = Get.arguments['videosNames'];
  static final String courseID = Get.arguments['coursID'];
  static final List<VideoPlayerController> videos = Get.arguments['videos'];

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    dis();
    super.dispose();
  }

  void dis() async {
    for (VideoPlayerController video in Course.videos) {
      video.removeListener(() {});
      await video.pause();
    }
  }

  void initialize() {
    for (VideoPlayerController video in Course.videos) {
      video.initialize().then((_) {
        video.addListener(() {
          Timer(Duration(minutes: 7), () => showAdRewarded());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARYCOLOR,
        elevation: 0.0,
        title: Text(
          Course.courseID,
          style: TextStyle(
            color: SECONDARYCOLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: PRIMARYCOLOR,
      body: Course.docURLs.isNotEmpty || Course.videoURLs.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  videosPlayer(context),
                  docs(),
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
          : Center(
              child: Text(
                'لم يتم رفع أى محتوى',
                style: TextStyle(
                  color: SECONDARYCOLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
    );
  }

  Column videosPlayer(BuildContext context) => Column(
        children: Course.videoURLs
            .map(
              (video) => Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Chewie(
                      controller: ChewieController(
                        aspectRatio: 1.2,
                        videoPlayerController:
                            Course.videos[Course.videoURLs.indexOf(video)],
                        placeholder: Center(
                          child: Text(
                            'جاري تحميل الفيديو',
                            style: TextStyle(
                              color: SECONDARYCOLOR,
                            ),
                          ),
                        ),
                        showControlsOnInitialize: false,
                        showOptions: false,
                      ),
                    ),
                  ),
                  Text(
                    Course.videosNames
                        .elementAt(Course.videoURLs.indexOf(video)),
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
                          onAdClosed: (ad) async => await ad.dispose(),
                        ),
                        request: AdRequest(),
                      )..load(),
                    ),
                  ),
                  Divider(
                    color: SECONDARYCOLOR,
                    endIndent: 5,
                    indent: 10,
                  ),
                ],
              ),
            )
            .toList(),
      );

  Wrap docs() => Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        children: Course.docURLs
            .map(
              (e) => TextButton(
                onPressed: () {
                  Get.dialog(
                    Material(
                      child: Stack(
                        children: [
                          SfPdfViewer.network(
                            e,
                            onDocumentLoadFailed: (_) => showMessage(
                                title: 'خطأ',
                                error: true,
                                text:
                                    'حدث خطأ أثناء تحميل الملف يرجي المحاولة في وقت لاحق'),
                          ),
                          Positioned(
                            child: IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () => download(
                                e,
                                Course.filesNames
                                    .elementAt(Course.docURLs.indexOf(e)),
                              ),
                            ),
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          Positioned(
                            child: Container(
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
                            bottom: 5.0,
                            right: 20.0,
                          ),
                        ],
                      ),
                    ),
                    barrierDismissible: false,
                    useSafeArea: true,
                  );
                },
                child: Text(
                  Course.filesNames.elementAt(Course.docURLs.indexOf(e)),
                  style: TextStyle(
                    color: SECONDARYCOLOR,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
            .toList(),
      );

  void download(String url, String fileName) async {
    showAdInterstitial();
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    var dir;
    try {
      dir = await getExternalStorageDirectory();
    } catch (e) {
      dir = getApplicationDocumentsDirectory();
    }
    var res = await Dio().download(url, '${dir.path}/$fileName');
    if (res.statusCode == 200)
      showMessage(title: 'تم التحميل', text: 'تم التحميل بنجاح');
    else
      showMessage(title: 'خطأ', text: 'حدث خطأ في تحميل الملف', error: true);
  }
}
