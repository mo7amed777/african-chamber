import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/drawer.dart';
import 'package:demo/widgets/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complaint extends StatefulWidget {
  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  TextEditingController complaintTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();

  CurrentUser user = Get.arguments['user'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الشكاوى والمقترحات'),
        backgroundColor: PRIMARYCOLOR,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      drawer: MainDrawer(
        user: null,
      ),
      backgroundColor: PRIMARYCOLOR,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleTextController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'عنوان الطلب',
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                  fillColor: SECONDARYCOLOR,
                  filled: true,
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: complaintTextController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'يرجى توضيح الشكوى أوالمقترحات الخاصة بك',
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                  fillColor: SECONDARYCOLOR,
                  filled: true,
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                minLines: 2,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  text('بيانات الطالب', color: SECONDARYCOLOR),
                  text(user.name, color: SECONDARYCOLOR),
                  text(' الفرقة  : ' + user.sem, color: SECONDARYCOLOR),
                  text(user.set_num + ' : رقم الجلوس ', color: SECONDARYCOLOR),
                  text(user.phone + ' : رقم الهاتف ', color: SECONDARYCOLOR),
                  text(user.email + ' : البريد الإلكتروني ',
                      color: SECONDARYCOLOR),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    complain();
                  },
                  child: Text(
                    'إرسال الطلب',
                    style: TextStyle(
                      color: PRIMARYCOLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: SECONDARYCOLOR,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await Get.defaultDialog(
                      titleStyle: TextStyle(color: Colors.red),
                      title: 'Delete Account Permanently',
                      middleText: Get.locale == Locale('en')
                          ? 'Are you sure you want to permanently delete your account ? '
                          : 'هل أنت متأكد أنك تريد حذف حسابك بشكل نهائي ؟ ',
                      cancel: TextButton(

                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Cancel',style: TextStyle(color: Colors.black),),
                      ),
                      confirm: TextButton(

                        onPressed: () async {

                         await FirebaseAuth.instance.currentUser?.delete();
                         await firestore.collection('users').doc(user.uid).delete();
                          showMessage(title: 'Deleting Account', text: 'Your Account deleted successfully...',error: true);
                         SharedPreferences.getInstance()
                             .then((value) => value.clear());
                         Get.offAllNamed(Login.routeName);
                        },
                        child: Text('Delete',style: TextStyle(color: Colors.red),),
                      ),
                    );
                  },
                  child: Text(
                    'Delete my account',
                    style: TextStyle(
                      color: SECONDARYCOLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void complain() async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      firestore.collection('complaints').doc(user.sem).collection('data').add({
        'title': titleTextController.text,
        'content': complaintTextController.text,
        'date': DateTime.now(),
        'seen': false,
        'user data': {
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'sem': user.sem,
          'set_num': user.set_num,
        },
      });
      showMessage(
          title: 'تم الإرسال',
          text: 'تم إرسال طلب الشكوى / الإقتراح وسيتم مراجعته في أقرب وقت');
    } catch (e) {
      showMessage(
          title: 'خطأ في الإرسال',
          error: true,
          text: 'برجاء التأكد من الإتصال بالإنترنت وإعادة المحاولة');
    }
  }
}
