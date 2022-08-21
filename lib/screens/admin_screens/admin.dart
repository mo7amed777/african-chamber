import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/admin_screens/admin_courses.dart';
import 'package:demo/screens/admin_screens/complaints.dart';
import 'package:demo/screens/admin_screens/post.dart';
import 'package:demo/screens/admin_screens/requests.dart';
import 'package:demo/screens/admin_screens/sem_users.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/drawer.dart';
import 'package:demo/widgets/message.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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

  bool? firstTerm;

  bool is_open = true;
  @override
  void initState() {
    super.initState();
    firestore.collection('materials').doc('term').get().then((term) {
      setState(() {
        firstTerm = term.get(term) == 1 ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _visible
          ? MainDrawer(
              isAdmin: true,
              items: Column(
                children: [
                  drawerItem(
                    icon: Icons.people,
                    title: 'عرض جميع الطلاب',
                    callback: () => setStudents(),
                  ),
                  drawerItem(
                    icon: Icons.ondemand_video_sharp,
                    title: 'عرض الفيديوهات',
                    callback: () => showVideos(),
                  ),
                  drawerItem(
                    icon: Icons.chrome_reader_mode_rounded,
                    title: 'طلبات الإشتراك',
                    callback: () => uploadCoursesRequests(coursid!),
                  ),
                  drawerItem(
                    icon: Icons.post_add,
                    title: 'نشر بوست جديد',
                    callback: () => Get.toNamed(Post.routeName),
                  ),
                  drawerItem(
                    icon: Icons.video_library,
                    title: 'تحميل الفيديوهات',
                    callback: () => uploadFiles(video: true),
                  ),
                  drawerItem(
                    icon: Icons.upload_file_rounded,
                    title: 'تحميل المذكرات',
                    callback: () => getSubscribedUsers(),
                  ),
                  drawerItem(
                    icon: Icons.live_help_rounded,
                    title: 'الشكاوي والمقترحات',
                    callback: () async {
                      Get.back();
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      QuerySnapshot<Map<String, dynamic>> complaints =
                          await firestore
                              .collection('complaints')
                              .doc(sem)
                              .collection('data')
                              .orderBy('date', descending: true)
                              .limit(50)
                              .get();

                      Get.back();
                      Get.to(Complaints(), arguments: {
                        'complaints': complaints.docs,
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/admin.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  elevation: 0,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: SECONDARYCOLOR,
                    hintText:
                        Get.locale == Locale('en') ? 'Semester' : 'الفرقة',
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
                        Get.locale == Locale('en') ? 'First' : 'الأولى',
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
                        Get.locale == Locale('en') ? 'Second' : 'الثانية',
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
                        Get.locale == Locale('en') ? 'Third' : 'الثالثة',
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
                        Get.locale == Locale('en') ? 'Fourth' : 'الرابعة',
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: coursid,
                    isExpanded: true,
                    elevation: 0,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: SECONDARYCOLOR,
                      hintText:
                          Get.locale == Locale('en') ? 'Course' : 'المادة',
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
                    items: SEMs[sem]
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
                    onChanged: (newVal) async {
                      setState(() {
                        coursid = newVal!;
                        _visible = true;
                      });
                      DocumentSnapshot<Map<String, dynamic>> isOpenDoc =
                          await firestore
                              .collection('materials')
                              .doc(sem)
                              .collection(coursid!)
                              .doc('is_open')
                              .get();
                      if (isOpenDoc.exists) {
                        is_open = isOpenDoc.get('is_open');
                      }
                    },
                  ),
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
            Spacer(),
            Visibility(
              visible: _visible,
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: RaisedButton(
                  color: PRIMARYCOLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () async {
                    setState(() {
                      is_open = !is_open;
                    });
                    await firestore
                        .collection('materials')
                        .doc(sem)
                        .collection(coursid!)
                        .doc('is_open')
                        .set({
                      'is_open': is_open,
                    });
                    // show toaster
                    Get.snackbar(
                      'تم',
                      is_open ? 'تم فتح المادة' : 'تم إغلاق المادة',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      borderRadius: 25.0,
                      margin: EdgeInsets.all(10),
                      snackStyle: SnackStyle.FLOATING,
                      duration: Duration(seconds: 2),
                      animationDuration: Duration(seconds: 2),
                    );
                  },
                  child: Text(
                    Get.locale == Locale('en')
                        ? 'Open or Cancel Course'
                        : 'فتح أو إغلاق المادة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SwitchListTile(
              value: firstTerm ?? false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              subtitle: Text(
                Get.locale == Locale('en')
                    ? 'Enable for first term & disable for second term'
                    : 'تفعيل للفصل الأول وإلغاء للفصل الثاني',
                style: TextStyle(
                  color: SECONDARYCOLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              title: Text(
                Get.locale == Locale('en') ? 'First Term' : 'الفصل الأول',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onChanged: (val) async {
                setState(() {
                  firstTerm = val;
                });
                if (val) {
                  await firestore.collection('materials').doc('term').set({
                    'id': 1,
                  });
                  //show snackbar to enable first term
                  Get.snackbar(
                    Get.locale == Locale('en') ? 'First Term' : 'الفصل الأول',
                    Get.locale == Locale('en')
                        ? 'First Term is enabled'
                        : 'تم تفعيل الفصل الأول',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: SECONDARYCOLOR,
                    backgroundColor: SECONDARYCOLOR,
                    backgroundGradient: LinearGradient(colors: [
                      Color.fromARGB(255, 57, 152, 230),
                      Color.fromARGB(255, 89, 231, 94),
                    ]),
                    borderRadius: 30.0,
                    margin: EdgeInsets.all(8.0),
                    duration: Duration(seconds: 2),
                  );
                } else {
                  await firestore.collection('materials').doc('term').set({
                    'id': 2,
                  });
                  // show snackbar to enable second term
                  Get.snackbar(
                    Get.locale == Locale('en') ? 'Second Term' : 'الفصل الثاني',
                    Get.locale == Locale('en')
                        ? 'Second Term is enabled'
                        : 'تم تفعيل الفصل الثاني',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: SECONDARYCOLOR,
                    backgroundColor: SECONDARYCOLOR,
                    backgroundGradient: LinearGradient(colors: [
                      Color.fromARGB(255, 57, 152, 230),
                      Color.fromARGB(255, 89, 231, 94),
                    ]),
                    borderRadius: 30.0,
                    margin: EdgeInsets.all(8.0),
                    duration: Duration(seconds: 2),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
    // make dropdown for opening or closing courses
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
      for (String sem in SEMs.keys) {
        if (sem == sem) {
          for (String title in SEMs[sem]!.keys) {
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
      for (var request in requests) {
        for (var user in sem_users) {
          if (request.containsKey(user.id) &&
              !names.contains(user.get('name')!)) {
            names.add(user.get('name')!);
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
              //showAdInterstitial();
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
          //showAdInterstitial();
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
    //showAdInterstitial();
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
