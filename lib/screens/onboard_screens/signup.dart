import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/ad.dart';
import 'package:demo/screens/onboard_screens/login.dart';
import 'package:demo/widgets/input_field.dart';
import 'package:demo/widgets/message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUP extends StatefulWidget {
  static String routeName = '/signUP';

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _numController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARYCOLOR,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  'قم بإنشاء حساب',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: SECONDARYCOLOR,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'للإنضمام إلى الغرفة الأفريقية',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: SECONDARYCOLOR,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                inputField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  icon: Icons.person_pin,
                  label: 'الإسم رباعي (مثل البطاقة)',
                  validate: (String name) {
                    if (name.length >= 12) return null;
                    return 'برجاء إدخال الإسم رباعي صحيح';
                  },
                ),
                inputField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,
                  label: 'رقم الهاتف',
                  validate: (String name) {
                    if (name.length == 11) return null;
                    return 'برجاء إدخال رقم الهاتف صحيح';
                  },
                ),
                inputField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                  label: 'البريد الإلكتروني',
                  validate: (String email) {
                    if (email.isEmail) return null;
                    return 'البريد الإلكتروني غير متاح';
                  },
                ),
                inputField(
                  controller: _passController,
                  keyboardType: TextInputType.visiblePassword,
                  obsecured: true,
                  icon: Icons.lock,
                  label: 'كلمة المرور',
                  validate: (String password) {
                    if (password.length >= 6) return null;
                    return 'كلمة المرور قصيرة جدا';
                  },
                ),
                inputField(
                  controller: _numController,
                  keyboardType: TextInputType.number,
                  icon: Icons.person,
                  label: 'رقم الجلوس',
                  validate: (String password) {
                    if (password.isNotEmpty) return null;
                    return 'يجب إدخال رقم جلوسك';
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: SECONDARYCOLOR,
                      iconSize: 30,
                      hint: Center(
                        child: Text(
                          'الفرقة',
                          style: TextStyle(
                            color: SECONDARYCOLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      value: selected,
                      dropdownColor: PRIMARYCOLOR,
                      items: [
                        DropdownMenuItem(
                          child: Center(
                            child: Text(
                              'الأولى',
                              style: TextStyle(
                                color: SECONDARYCOLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          value: 'الأولى',
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text(
                              'الثانية',
                              style: TextStyle(
                                color: SECONDARYCOLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          value: 'الثانية',
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text(
                              'الثالثة',
                              style: TextStyle(
                                color: SECONDARYCOLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          value: 'الثالثة',
                        ),
                        DropdownMenuItem(
                          child: Center(
                            child: Text(
                              'الرابعة',
                              style: TextStyle(
                                color: SECONDARYCOLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          value: 'الرابعة',
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selected = val!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => uploadFiles(),
                    icon: Icon(Icons.upload_file_rounded),
                    label: Text(
                      'تحميل صورة البطاقة',
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
                TextButton(
                  onPressed: url == null || selected == null
                      ? null
                      : () => sign_up(
                            context,
                            _emailController.text,
                            _passController.text,
                            _nameController.text,
                          ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'إنشاء حساب جديد   ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: PRIMARYCOLOR,
                      ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Get.toNamed(Login.routeName),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: SECONDARYCOLOR,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'لدي حساب بالفعل',
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
      ),
    );
  }

  void sign_up(
      BuildContext context, String email, String password, String name) {
    //showAdInterstitial();

    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          PlatformDeviceId.getDeviceId.then(
            (id) => firestore.collection('users').doc(id).set({
              'blocked': false,
              'email': email,
              'name': name,
              'sem': selected,
              'courses': [],
              'id_card': url,
              'set_num': _numController.text,
              'phone': _phoneController.text,
            }),
          );
          value.user?.updateDisplayName(name);
          Get.offAllNamed(
            Login.routeName,
          );
        },
      ).catchError((_) {
        Get.back();
        showMessage(
          title: 'خطأ في تسجيل البيانات',
          text: 'برجاء التأكد من إدخال البيانات صحيحة وإعادة المحاولة',
          error: true,
        );
      });
    } else {
      Get.back();
    }
  }

  String? url;
  void uploadFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(dialogTitle: 'يرجي اختيار صورة البطاقة');

      if (result != null) {
        Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false);
        String file = result.paths.first!;
        firebase_storage.FirebaseStorage.instance
            .ref('البطاقات/${_nameController.text}/${fileName(file)}')
            .putFile(File(file))
            .then((uplaodedFile) async {
          url = await uplaodedFile.ref.getDownloadURL();
          showMessage(title: 'تم التحميل', text: 'تم التحميل بنجاح');
        });
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
