// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:chewie/chewie.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/widgets/drawer.dart';
import 'package:demo/widgets/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Course extends StatefulWidget {
  static final String routeName = '/course';
  final List videoURLs = Get.arguments['videoURLs'];
  final List docURLs = Get.arguments['docURLs'];
  final List filesNames = Get.arguments['filesNames'];
  final List videosNames = Get.arguments['videosNames'];
  final String courseID = Get.arguments['coursID'];
  final List<ChewieController> videoPlayerControllers =
      Get.arguments['videoPlayerControllers'];
  final CurrentUser user = Get.arguments['user'];

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  void dispose() {
    for (var playerController in widget.videoPlayerControllers) {
      playerController.videoPlayerController
          .dispose()
          .then((_) => playerController.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARYCOLOR,
        elevation: 0.0,
        title: Text(
          widget.courseID,
          style: TextStyle(
            color: SECONDARYCOLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      drawer: MainDrawer(
        user: widget.user,
      ),
      backgroundColor: PRIMARYCOLOR,
      body: widget.docURLs.isNotEmpty || widget.videoURLs.isNotEmpty
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
        children: widget.videoURLs
            .map(
              (video) => Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.defaultDialog(
                        title: widget.videosNames
                            .elementAt(widget.videoURLs.indexOf(video)),
                        onWillPop: () async {
                          await widget.videoPlayerControllers[
                              widget.videoURLs.indexOf(video)]
                            ..pause();
                          return true;
                        },
                        content: Container(
                          child: Expanded(
                            child: Chewie(
                              controller: widget.videoPlayerControllers[
                                  widget.videoURLs.indexOf(video)],
                            ),
                          ),
                        ),
                      );
                    },
                    title: Text(
                      widget.videosNames
                          .elementAt(widget.videoURLs.indexOf(video)),
                      style: TextStyle(
                        color: SECONDARYCOLOR,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    leading: Icon(
                      Icons.play_circle_filled,
                      color: SECONDARYCOLOR,
                      size: 50,
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
        children: widget.docURLs
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
                                widget.filesNames
                                    .elementAt(widget.docURLs.indexOf(e)),
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
                  widget.filesNames.elementAt(widget.docURLs.indexOf(e)),
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
    //showAdInterstitial();
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
