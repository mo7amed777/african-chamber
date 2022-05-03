import 'package:chewie/chewie.dart';
import 'package:demo/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdminCourses extends StatefulWidget {
  static final String routeName = '/admin-courses';
  final List videoURLs = Get.arguments['videoURLs'];
  final List videosNames = Get.arguments['videosNames'];
  final String courseID = Get.arguments['coursID'];
  final List<ChewieController> videoPlayerControllers =
      Get.arguments['videoPlayerControllers'];

  @override
  State<AdminCourses> createState() => _AdminCoursesState();
}

class _AdminCoursesState extends State<AdminCourses> {
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
      ),
      backgroundColor: PRIMARYCOLOR,
      body: SingleChildScrollView(
        child: videosPlayer(context),
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
}
