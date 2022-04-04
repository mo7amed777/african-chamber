import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Post extends StatefulWidget {
  static final routeName = '/post';
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  String? sem;
  TextEditingController postTextController = TextEditingController();
  bool canPost = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('إضافة بوست جديد', color: SECONDARYCOLOR),
      ),
      backgroundColor: PRIMARYCOLOR,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
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
                            'الكل',
                            style: TextStyle(
                              color: PRIMARYCOLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: 'الكل',
                        ),
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
                          canPost = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: postTextController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'إضغط لكتابة بوست جديد للنشر ...',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 20,
                        ),
                        fillColor: SECONDARYCOLOR,
                        filled: true,
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      minLines: 5,
                      maxLines: 10,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 8.0),
                    child: TextButton.icon(
                      onPressed: () async {
                        result = await FilePicker.platform.pickFiles(
                          dialogTitle: 'يرجي اختيار ملف ',
                        );
                      },
                      icon: Icon(Icons.upload_file_rounded),
                      label: Text(
                        'إرفاق ملفات',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: PRIMARYCOLOR,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        alignment: Alignment.center,
                        backgroundColor: SECONDARYCOLOR,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      child: TextButton(
                        onPressed: () {
                          post();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'نشر البوست',
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
                  ),
                ],
              ),
              visible: canPost,
            ),
          ],
        ),
      ),
    );
  }

  FilePickerResult? result;
  String url = 'Not Found!';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void post() async {
    try {
      url = 'Not Found!';
      Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
      if (result != null) {
        File file = File(result!.paths.first!);
        firebase_storage.FirebaseStorage.instance
            .ref('البوستات/$sem/${fileName(file.path)}')
            .putFile(File(file.path))
            .then((uplaodedFile) async {
          url = await uplaodedFile.ref.getDownloadURL();
          firestore.collection('posts').doc(sem).collection('posts').add({
            'text': postTextController.text,
            'url': url,
            'date': DateTime.now(),
          });
          showMessage(title: 'تم التحميل', text: 'تم تحميل البوست بنجاح');
          await AwesomeNotifications().setGlobalBadgeCounter(1);
        });
      } else {
        firestore.collection('posts').doc(sem).collection('posts').add({
          'text': postTextController.text,
          'url': url,
          'date': DateTime.now(),
        });
        showMessage(title: 'تم التحميل', text: 'تم تحميل البوست بنجاح');
        await AwesomeNotifications().setGlobalBadgeCounter(1);
      }
    } catch (e) {
      showMessage(
          title: 'خطأ في التحميل',
          error: true,
          text: 'برجاء التأكد من الإتصال بالإنترنت وإعادة المحاولة');
    }
  }

  String fileName(String file) {
    return file.substring(file.lastIndexOf('/') + 1);
  }
}
