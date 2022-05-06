import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/admin_screens/admin_courses.dart';
import 'package:demo/screens/admin_screens/post.dart';
import 'package:demo/screens/admin_screens/requests.dart';
import 'package:demo/screens/admin_screens/sem_users.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/message.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:demo/models/ad.dart';

class Admin extends StatefulWidget {
  static final routeName = '/admin';

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool _visible = false;
  String? coursid;
  String? sem;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> courses_requests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARYCOLOR,
        elevation: 0.0, //No Elevation
        actions: [
          TextButton(
            onPressed: () {
              SharedPreferences.getInstance().then((value) => value.clear());
              Get.offAllNamed(Login.routeName);
            },
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: SECONDARYCOLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      backgroundColor: PRIMARYCOLOR,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    elevation: 0,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: SECONDARYCOLOR,
                      hintText: 'الفرقة',
                      hintStyle: TextStyle(
                        color: PRIMARYCOLOR,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    iconEnabledColor: PRIMARYCOLOR,
                    iconSize: 25,
                    value: sem,
                    items: [
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        child: Text(
                          'الأولى',
                          style: TextStyle(
                            color: PRIMARYCOLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'الأولى',
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        child: Text(
                          'الثانية',
                          style: TextStyle(
                            color: PRIMARYCOLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'الثانية',
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        child: Text(
                          'الثالثة',
                          style: TextStyle(
                            color: PRIMARYCOLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'الثالثة',
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        child: Text(
                          'الرابعة',
                          style: TextStyle(
                            color: PRIMARYCOLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'الرابعة',
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        sem = val!;
                        coursid = null;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: sem != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: coursid,
                      isExpanded: true,
                      elevation: 0,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: SECONDARYCOLOR,
                        hintText: 'أختر الكورس',
                        hintStyle: TextStyle(
                          color: PRIMARYCOLOR,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      iconEnabledColor: PRIMARYCOLOR,
                      iconSize: 30,
                      items: SEMS[sem]
                          ?.keys
                          .map(
                            (e) => DropdownMenuItem<String>(
                              child: Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: PRIMARYCOLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          coursid = newVal!;
                          _visible = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Visibility(
                visible: _visible,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        coursid ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: SECONDARYCOLOR,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    buildButton(
                      title: 'إضافة بوست',
                      callback: () => Get.toNamed(Post.routeName),
                    ),
                    buildButton(
                      title: 'عرض الطلاب  ',
                      callback: () => setStudents(),
                    ),
                    buildButton(
                      title: 'تحميل الفيديوهات',
                      callback: () => uploadFiles(video: true),
                    ),
                    buildButton(
                      title: 'عرض الفيديوهات   ',
                      callback: () => showVideos(),
                    ),
                    buildButton(
                      title: 'تحميل المذكرات',
                      callback: () => getSubscribedUsers(),
                    ),
                    buildButton(
                      title: 'طلبات الإشتراك  ',
                      callback: () => uploadCoursesRequests(coursid!),
                    ),
                    buildButton(
                      title: 'تحميل مثال للشرح',
                      callback: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                dialogTitle: 'قم بتحميل فيديو مثال للشرح');
                        if (result != null) {
                          Get.dialog(
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          String path = result.paths.first!;
                          firebase_storage.FirebaseStorage.instance
                              .ref('example/${fileName(File(path))}')
                              .putFile(File(path))
                              .then((uplaodedFile) async {
                            String url =
                                await uplaodedFile.ref.getDownloadURL();
                            firestore
                                .collection('materials')
                                .doc('example')
                                .set({
                              'video': url,
                              'name': fileName(File(path)),
                            }).then((value) {
                              showMessage(
                                  title: 'تم التحميل',
                                  text: 'تم تحميل الفيديو بنجاح');
                            });
                          });
                        }
                        ;
                      },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({required String title, required Function callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        child: TextButton(
          onPressed: () {
            showAdRewarded();
            callback();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              title,
              style: TextStyle(
                color: PRIMARYCOLOR,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: SECONDARYCOLOR,
          ),
        ),
      ),
    );
  }

  void uploadCoursesRequests(String couresID) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      courses_requests = [];
      QuerySnapshot courses_snapshot =
          await firestore.collection('crs_requests').get();
      QuerySnapshot users = await firestore.collection('users').get();
      List<QueryDocumentSnapshot> sem_users =
          users.docs.where((user) => user.get('sem') == sem).toList();

      courses_snapshot.docs.forEach((doc) {
        courses_requests.add({
          doc.id: doc.get('requests'),
        });
      });

      List<Map<String, Map<String, String>>> requests = [];
      for (String sem in SEMS.keys) {
        if (sem == sem) {
          for (String title in SEMS[sem]!.keys) {
            if (title == coursid) {
              for (var request in courses_requests) {
                for (var crs in request.values.first!) {
                  if (crs.values.last == couresID) {
                    if (!requests.contains(request)) {
                      requests.add({
                        request.keys.first: {
                          'code': crs.values.first,
                          'coursID': couresID,
                        },
                      });
                    }
                  }
                }
              }
            }
          }
        }
      }
      List<String> names = [];
      if (coursid == 'Terminologies  مصطلحات تجارية') sem_users = users.docs;

      for (var request in requests) {
        for (var user in sem_users) {
          if (request.containsKey(user.id)) {
            names.add(user.get('name'));
          }
        }
      }
      Get.back();
      Get.toNamed(
        Requests.routeName,
        arguments: [requests, names],
      );
    } catch (e) {
      showMessage(
        title: 'خطأ في التحميل',
        text:
            'حدث خطأ أثناء تحميل البيانات يرجي التأكد من الإتصال بالإنترنت وإعادة المحاولة',
        error: true,
      );
    }
  }

  List<String> subscribedUsers = [];
  void getSubscribedUsers() async {
    QuerySnapshot users = await firestore.collection('users').get();
    List sem_users = users.docs
        .where((user) => user.get('sem') == sem && !user.get('blocked'))
        .toList();
    subscribedUsers = sem_users
        .where((user) => user.get('courses').contains(coursid))
        .toList()
        .map((e) => '${e.get('name')}')
        .toList();
    ;

    Get.defaultDialog(
      barrierDismissible: false,
      title: 'اختر الطالب',
      content: Expanded(
        child: ListView.builder(
          itemCount: subscribedUsers.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              showAdInterstitial();
              semUser = subscribedUsers.elementAt(index);
              Get.back();
              uploadFiles();
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              color: PRIMARYCOLOR,
              child: Center(
                child: Text(
                  subscribedUsers.elementAt(index),
                  style: TextStyle(
                    color: SECONDARYCOLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('إغلاق')),
      confirm: TextButton(
        onPressed: () {
          showAdInterstitial();
          Get.back();
          uploadFiles(all: true);
        },
        child: Text('تحديد الكل'),
      ),
    );
  }

  String? semUser;
  void uploadFiles({bool video = false, bool all = false}) async {
    try {
      int progress = 0;
      List<File> files = [];
      List<String> urls = [];
      List<String> names = [];
      String type = 'files/$semUser';
      if (video) {
        type = 'videos';

        AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
          if (!isAllowed) {
            showMessage(
                title: 'السماح للإشعارات',
                text: 'يرجي السماح بإرسال إشعارات التحميل');
            AwesomeNotifications().requestPermissionToSendNotifications();
          }
        });
      }
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true, dialogTitle: 'قم بتحديد ملفات المحاضرة');

      if (result != null) {
        files = result.paths.map((path) => File(path!)).toList();
        files.forEach((file) {
          progress = 0;

          firebase_storage.UploadTask uplaodedFile = firebase_storage
              .FirebaseStorage.instance
              .ref('$sem/$coursid/$type/${fileName(file)}')
              .putFile(file);
          uplaodedFile.snapshotEvents.listen((event) async {
            progress =
                ((event.bytesTransferred.toInt() / event.totalBytes.toInt()) *
                        100)
                    .toInt();
            int uploaded = event.bytesTransferred ~/ 1048576;
            int total = event.totalBytes ~/ 1048576;

            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: files.indexOf(file),
                channelKey: 'basic_channel',
                locked: true,
                autoDismissible: false,
                category: NotificationCategory.Progress,
                notificationLayout: NotificationLayout.ProgressBar,
                progress: progress,
                title: fileName(file),
                body: ' $progress%       $uploaded/$total MB',
              ),
            );
            if (event.state == firebase_storage.TaskState.success) {
              String url = await uplaodedFile.snapshot.ref.getDownloadURL();
              showMessage(title: 'تم التحميل', text: 'تم تحميل الملفات بنجاح');
              await AwesomeNotifications().dismiss(files.indexOf(file));
              if (!urls.contains(url)) urls.add(url);
              if (!names.contains(fileName(file))) names.add(fileName(file));
              DocumentSnapshot doc = video
                  ? await firestore
                      .collection('materials')
                      .doc(sem)
                      .collection(coursid!)
                      .doc(type)
                      .get()
                  : await firestore
                      .collection('materials')
                      .doc(sem)
                      .collection(coursid!)
                      .doc('files')
                      .collection('users')
                      .doc(semUser)
                      .get();
              if (doc.exists) {
                if (video) {
                  List updatedURLs = doc.get('urls');
                  List updatedNames = doc.get('names');
                  updatedURLs.addAll(urls);
                  updatedNames.addAll(names);

                  await firestore
                      .collection('materials')
                      .doc(sem)
                      .collection(coursid!)
                      .doc(type)
                      .update(
                    {
                      'urls': updatedURLs,
                      'names': updatedNames,
                    },
                  );
                } else {
                  if (all)
                    for (var one in subscribedUsers) {
                      await firestore
                          .collection('materials')
                          .doc(sem)
                          .collection(coursid!)
                          .doc('files')
                          .collection('users')
                          .doc(one)
                          .update(
                        {
                          'urls': urls,
                          'names': names,
                        },
                      );
                    }
                  else
                    await firestore
                        .collection('materials')
                        .doc(sem)
                        .collection(coursid!)
                        .doc('files')
                        .collection('users')
                        .doc(semUser)
                        .update(
                      {
                        'urls': urls,
                        'names': names,
                      },
                    );
                }
              } else {
                if (video) {
                  await firestore
                      .collection('materials')
                      .doc(sem)
                      .collection(coursid!)
                      .doc(type)
                      .set(
                    {
                      'urls': urls,
                      'names': names,
                    },
                  );
                } else {
                  if (all)
                    for (var one in subscribedUsers) {
                      await firestore
                          .collection('materials')
                          .doc(sem)
                          .collection(coursid!)
                          .doc('files')
                          .collection('users')
                          .doc(one)
                          .set(
                        {
                          'urls': urls,
                          'names': names,
                        },
                      );
                    }
                  else
                    await firestore
                        .collection('materials')
                        .doc(sem)
                        .collection(coursid!)
                        .doc('files')
                        .collection('users')
                        .doc(semUser)
                        .set(
                      {
                        'urls': urls,
                        'names': names,
                      },
                    );
                }
              }
            }
          });
        });
      } else {
        Get.back();
      }
    } catch (e) {
      showMessage(
          title: 'خطأ في التحميل',
          error: true,
          text: 'برجاء التأكد من الإتصال بالإنترنت وإعادة المحاولة');
    }
  }

  String fileName(File file) {
    return file.path.substring(file.path.lastIndexOf('/') + 1);
  }

  void setStudents() async {
    states state = states.all;
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    QuerySnapshot users =
        await firestore.collection('users').orderBy('name').get();
    List<QueryDocumentSnapshot> sem_users =
        users.docs.where((user) => user.get('sem') == sem).toList();
    Get.back();
    Get.defaultDialog(
      title: 'برجاء اختيار النوع',
      content: PopupMenuButton(
        child: text('أختر النوع', color: PRIMARYCOLOR!),
        itemBuilder: (ctx) => <PopupMenuItem<states>>[
          PopupMenuItem<states>(
            child: Text('مشترك'),
            value: states.subscribed,
          ),
          PopupMenuItem<states>(
            child: Text('غير مشترك'),
            value: states.non,
          ),
          PopupMenuItem<states>(
            child: Text('الكل'),
            value: states.all,
          ),
        ],
        onSelected: (states s) {
          Get.back();
          Get.dialog(
            Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
          if (s == states.subscribed) {
            List<QueryDocumentSnapshot> sub_users = sem_users
                .where(
                    (user) => (user.get('courses') as List).contains(coursid))
                .toList();
            state = s;
            Get.back();
            Get.toNamed(SemUsers.routeName,
                arguments: [sub_users, sem, state, coursid]);
          } else if (s == states.non) {
            state = s;
            sem_users.removeWhere(
                (user) => (user.get('courses') as List).contains(coursid));
            Get.back();
            Get.toNamed(SemUsers.routeName,
                arguments: [sem_users, sem, state, coursid]);
          } else {
            state = s;
            Get.back();
            Get.toNamed(SemUsers.routeName,
                arguments: [sem_users, sem, state, coursid]);
          }
        },
      ),
    );
  }

  void showVideos() {
    showAdInterstitial();
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    List videoURLs = [];
    List videosNames = [];

    firestore
        .collection('materials')
        .doc(sem)
        .collection(coursid!)
        .doc('videos')
        .get()
        .then((videoDoc) {
      if (videoDoc.exists) {
        videoURLs = videoDoc.get('urls');
        videosNames = videoDoc.get('names');
        List<ChewieController> _videoPlayerControllers = List.generate(
          videoURLs.length,
          (index) => ChewieController(
            videoPlayerController: VideoPlayerController.network(
              videoURLs[index],
            ),
            fullScreenByDefault: true,
            allowedScreenSleep: false,
            placeholder: Center(
              child: Text(
                'جارى التحميل',
                style: TextStyle(
                  color: PRIMARYCOLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

        Get.back();
        Get.toNamed(AdminCourses.routeName, arguments: {
          'videoURLs': videoURLs,
          'videosNames': videosNames,
          'coursID': coursid,
          'videoPlayerControllers': _videoPlayerControllers,
        });
      }
    });
  }
}
