import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/ad.dart';
import 'package:demo/screens/admin_screens/requests.dart';
import 'package:demo/widgets/message.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatefulWidget {
  static final routeName = '/admin';

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool _visible = false;
  String? _value;
  String? selected;
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
                    value: selected,
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
                        selected = val!;
                        _value = null;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: selected != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _value,
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
                      items: SEMS[selected]
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
                          _value = newVal!;
                          _visible = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Visibility(
                visible: _visible,
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _value ?? '',
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
                      height: 32,
                    ),
                    buildButton(
                      title: 'تحميل الفيديوهات',
                      callback: () => uploadFiles(video: true),
                    ),
                    buildButton(
                      title: 'تحميل المذكرات',
                      callback: () {
                        getSubscribedUsers();
                        Get.defaultDialog(
                          barrierDismissible: false,
                          title: 'اختر الطالب',
                          content: Expanded(
                            child: ListView.builder(
                              itemCount: subscribedUsers.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  showAdInterstitial();
                                  selectedUser = subscribedUsers[index];
                                  Get.back();
                                  uploadFiles();
                                },
                                child: Card(
                                  margin: EdgeInsets.all(8.0),
                                  color: PRIMARYCOLOR,
                                  child: Center(
                                    child: Text(
                                      subscribedUsers[index],
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
                          cancel: TextButton(
                              onPressed: () => Get.back(),
                              child: Text('إغلاق')),
                          confirm: TextButton(
                            onPressed: () {
                              showAdInterstitial();
                              Get.back();
                              uploadFiles(all: true);
                            },
                            child: Text('تحديد الكل'),
                          ),
                        );
                      },
                    ),
                    buildButton(
                      title: 'طلبات الإشتراك  ',
                      callback: () => uploadCoursesRequests(_value!),
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
      courses_snapshot.docs.forEach((doc) {
        courses_requests.add({
          doc.id: doc.get('requests'),
        });
      });

      List<Map<String, Map<String, String>>> requests = [];
      for (String sem in SEMS.keys) {
        if (sem == selected) {
          for (String title in SEMS[sem]!.keys) {
            if (title == _value) {
              for (var request in courses_requests) {
                for (var crs in request.values.first!) {
                  if (crs.values.last == couresID) {
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
      Get.back();
      Get.toNamed(
        Requests.routeName,
        arguments: requests,
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

  List<File> files = [];
  List<String> urls = [];
  List<String> names = [];
  List<String> subscribedUsers = [];
  getSubscribedUsers() async {
    QuerySnapshot<Map<String, dynamic>> users =
        await firestore.collection('users').get();
    users.docs.forEach((doc) {
      if ((doc.get('courses') as List).contains(_value)) {
        if (!subscribedUsers.contains(doc.get('name'))) {
          subscribedUsers.add(doc.get('name'));
        }
      }
    });
  }

  String? selectedUser;
  void uploadFiles({bool video = false, bool all = false}) async {
    try {
      String type = 'files/$selectedUser';
      if (video) type = 'videos';
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true, dialogTitle: 'قم بتحديد ملفات المحاضرة');

      if (result != null) {
        files = result.paths.map((path) => File(path!)).toList();
        files.forEach((file) {
          firebase_storage.FirebaseStorage.instance
              .ref('$selected/$_value/$type/${fileName(file)}')
              .putFile(file)
              .then((uplaodedFile) async {
            String url = await uplaodedFile.ref.getDownloadURL();
            if (files.indexOf(file) == 0) {
              urls.clear();
              names.clear();
            }
            if (!urls.contains(url)) urls.add(url);
            if (!names.contains(fileName(file))) names.add(fileName(file));
            DocumentSnapshot doc = video
                ? await firestore
                    .collection('materials')
                    .doc(selected)
                    .collection(_value!)
                    .doc(type)
                    .get()
                : await firestore
                    .collection('materials')
                    .doc(selected)
                    .collection(_value!)
                    .doc('files')
                    .collection('users')
                    .doc(selectedUser)
                    .get();
            if (doc.exists) {
              if (video) {
                await firestore
                    .collection('materials')
                    .doc(selected)
                    .collection(_value!)
                    .doc(type)
                    .update(
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
                        .doc(selected)
                        .collection(_value!)
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
                      .doc(selected)
                      .collection(_value!)
                      .doc('files')
                      .collection('users')
                      .doc(selectedUser)
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
                    .doc(selected)
                    .collection(_value!)
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
                        .doc(selected)
                        .collection(_value!)
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
                      .doc(selected)
                      .collection(_value!)
                      .doc('files')
                      .collection('users')
                      .doc(selectedUser)
                      .set(
                    {
                      'urls': urls,
                      'names': names,
                    },
                  );
              }
            }
          });
          showMessage(title: 'تم التحميل', text: 'تم تحميل الملفات بنجاح');
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
}
