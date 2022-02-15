import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/ad.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/admin_screens/admin.dart';
import 'package:demo/screens/user_screens/home.dart';
import 'package:demo/screens/onboard_screens/signup.dart';
import 'package:demo/widgets/input_field.dart';
import 'package:demo/widgets/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  static String routeName = '/login';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARYCOLOR,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Center(
                child: Text(
                  'قم بتسجيل الدخول',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: SECONDARYCOLOR,
                    fontSize: 22,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'للإنضمام إلى الغرفة الأفريقية',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: SECONDARYCOLOR,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              inputField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
                label: 'البريد الإلكتروني',
                validate: (String email) {
                  if (email.isEmail) return null;
                  return 'البريد الإلكتروني غير صحيح';
                },
              ),
              inputField(
                controller: _passController,
                keyboardType: TextInputType.visiblePassword,
                icon: Icons.lock,
                label: 'كلمة المرور',
                validate: (String password) {
                  if (password.length < 6) return 'كلمة المرور قصيرة جدا';
                  return null;
                },
                obsecured: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextButton(
                onPressed: () =>
                    login(_emailController.text, _passController.text, context),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: PRIMARYCOLOR,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  alignment: Alignment.centerRight,
                  backgroundColor: SECONDARYCOLOR,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.toNamed(SignUP.routeName),
                    child: Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(
                        color: SECONDARYCOLOR,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'ليس لدي حساب ',
                    style: TextStyle(color: SECONDARYCOLOR),
                  ),
                ],
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
    );
  }

  String route = Home.routeName;

  login(String email, String password, context) async {
    showAdInterstitial();

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      if (email == 'admin' && password == '123456') {
        route = Admin.routeName;
        SharedPreferences.getInstance().then((pref) {
          pref.setString('uid', 'admin');
        });
        Get.offAllNamed('$route');
        return;
      }
      if (_formKey.currentState!.validate()) {
        String deviceId = await PlatformDeviceId.getDeviceId ?? '';
        QuerySnapshot snapshot = await firestore.collection('users').get();
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          if (doc.id == deviceId) {
            if (!doc.get('blocked') && doc.get('email') == email) {
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('uid', deviceId);
              String name =
                  FirebaseAuth.instance.currentUser!.displayName ?? '';
              CurrentUser currentUser = CurrentUser(
                uid: deviceId,
                name: name,
                sem: doc.get('sem'),
                email: email,
                courses: doc.get('courses'),
                id_card: doc.get('id_card'),
                set_num: doc.get('set_num'),
                phone: doc.get('phone'),
              );
              Get.offAllNamed('$route', arguments: currentUser);
              return;
            } else if (doc.get('blocked') && doc.get('email') == email) {
              Get.back();
              showMessage(
                title: 'تم حظر الحساب',
                text:
                    'تم حظر الحساب الخاص بك يرجي الإتصال بالشخص المسئول وإعادة المحاولة ',
                error: true,
              );
              return;
            }
          } else {
            if (doc.get('email') == email) {
              Get.back();
              await firestore.collection('users').doc(doc.id).set({
                'id': doc.id,
                'email': email,
                'blocked': true,
                'sem': doc.get('sem'),
                'courses': doc.get('courses'),
              });
              showMessage(
                title: 'تم حظر الحساب',
                text:
                    'تم حظر الحساب الخاص بك يرجي الإتصال بالشخص المسئول وإعادة المحاولة ',
                error: true,
              );

              return;
            }
          }
        }
      } else
        Get.back();
    } catch (e) {
      print(e.toString());
      showMessage(
        title: 'خطأ في تسجيل البيانات',
        text: 'برجاء التأكد من إدخال البيانات صحيحة وإعادة المحاولة',
        error: true,
      );
    }
    showMessage(
      title: 'خطأ في تسجيل الدخول',
      text: 'برجاء التأكد من إدخال البيانات صحيحة وإعادة المحاولة',
      error: true,
    );
  }
}
