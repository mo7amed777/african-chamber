import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/check_courses.dart';
import 'package:demo/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SemUsers extends StatefulWidget {
  static final routeName = '/sem_users';
  SemUsers({Key? key}) : super(key: key);

  @override
  State<SemUsers> createState() => _SemUsersState();
}

enum states {
  subscribed,
  non,
  all,
}

class _SemUsersState extends State<SemUsers> {
  List<QueryDocumentSnapshot> sem_users = Get.arguments[0];
  final String sem = Get.arguments[1];
  states state = Get.arguments[2];
  String coursID = Get.arguments[3];
  String title = '';
  List<QueryDocumentSnapshot> search_users = [];
  TextEditingController searchController = TextEditingController();

  bool search = false;
  @override
  Widget build(BuildContext context) {
    switch (state) {
      case states.subscribed:
        title = 'المشتركين';
        break;
      case states.non:
        title = 'الغير مشتركين';
        break;
      default:
        title = 'الفرقة $sem';
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: text(
            title + ' (${sem_users.length}) ',
            color: SECONDARYCOLOR,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.file_download_outlined,
                color: Colors.lightGreenAccent,
                size: 35.0,
              ),
              onPressed: () {
                savePdf();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AnimSearchBar(
                width: MediaQuery.of(context).size.width - 75,
                textController: searchController,
                color: PRIMARYCOLOR,
                rtl: true,
                style: TextStyle(color: SECONDARYCOLOR),
                suffixIcon: Icon(Icons.search),
                closeSearchOnSuffixTap: true,
                onSuffixTap: () {
                  search_users.clear();
                  for (var user in sem_users) {
                    if ((user.get('name') as String)
                        .isCaseInsensitiveContainsAny(searchController.text)) {
                      search_users.add(user);
                    }
                  }
                  setState(() {
                    search = search_users.isNotEmpty;
                    searchController.clear();
                  });
                },
              ),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: search ? search_users.length : sem_users.length,
            itemBuilder: (context, index) => buildItem(context, index,
                search ? search_users[index] : sem_users[index], state)));
  }

  buildItem(
    BuildContext context,
    int index,
    QueryDocumentSnapshot user,
    states state,
  ) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 10.0,
      child: Column(
        children: [
          ListTile(
            trailing: TextButton(
              onPressed: () {
                List crs = user.get('courses');
                showRequestInfo(user, index, crs);
              },
              child: Text('عرض'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                primary: SECONDARYCOLOR,
              ),
            ),
            title: Text(
              user.get('name'),
              style: TextStyle(
                color: PRIMARYCOLOR,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          buildButton(() async {
            if (state == states.subscribed)
              reject(user, index);
            else if (state == states.non)
              accept(user, index);
            else
              add(user);
          }),
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
    );
  }

  void showRequestInfo(QueryDocumentSnapshot user, int index, List crs) {
    Get.dialog(
      Material(
        child: Center(
          child: ListView(
            children: [
              text(
                user.get('name'),
                color: PRIMARYCOLOR!,
              ),
              Card(
                elevation: 10.0,
                child: Image.network(
                  user.get('id_card'),
                  fit: BoxFit.fill,
                  height: 200,
                ),
              ),
              text(crs.isEmpty ? 'لم يتم التسجيل في أى محتوى' : 'الإشتراكات'),
              crs.isNotEmpty
                  ? Column(
                      children: crs
                          .map(
                            (course) => Dismissible(
                                child: text(course),
                                key: Key(course),
                                direction: DismissDirection.horizontal,
                                background: Container(
                                  color: Colors.red,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                onDismissed: (_) async {
                                  crs.remove(course);
                                  await firestore
                                      .collection('users')
                                      .doc(user.id)
                                      .update({
                                    'courses': crs,
                                  });
                                }),
                          )
                          .toList(),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                    user.get('sem'),
                    color: PRIMARYCOLOR!,
                  ),
                  text(' : الفرقة'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                    user.get('set_num'),
                    color: PRIMARYCOLOR!,
                  ),
                  SizedBox(width: 10),
                  text(' : رقم الجلوس'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(user.get('email'), color: PRIMARYCOLOR!, size: 15),
                  SizedBox(width: 5),
                  text(' : البريد الإلكتروني'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                    user.get('phone'),
                    color: PRIMARYCOLOR!,
                  ),
                  SizedBox(width: 10),
                  text(' : رقم الهاتف'),
                ],
              ),
              buildButton(() async {
                Get.back();
                if (state == states.subscribed)
                  reject(user, index);
                else if (state == states.non)
                  accept(user, index);
                else
                  add(user);
              }),
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
      useSafeArea: true,
    );
  }

  Widget buildButton(Function callBack) {
    if (state == states.all)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        width: double.infinity,
        height: 50,
        child: TextButton(
          onPressed: () => callBack(),
          child: Text('تسجيــل الـمــواد'),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            primary: SECONDARYCOLOR,
          ),
        ),
      );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () => callBack(),
        child: Text(state == states.subscribed ? 'حذف الطالب' : 'تسجيل الطالب'),
        style: TextButton.styleFrom(
          backgroundColor:
              state == states.subscribed ? Colors.red : Colors.green,
          primary: SECONDARYCOLOR,
        ),
      ),
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void reject(DocumentSnapshot user, int index) async {
    List courses = user.get('courses');
    courses.removeWhere((crs) => crs == coursID);
    await firestore.collection('users').doc(user.id).update({
      'courses': courses,
    });
    setState(() {
      sem_users.removeAt(index);
    });
  }

  void accept(DocumentSnapshot user, int index) async {
    List courses = user.get('courses');
    courses.add(coursID);
    await firestore.collection('users').doc(user.id).update({
      'courses': courses,
    });
    DocumentSnapshot crs_request =
        await firestore.collection('crs_requests').doc(user.id).get();
    if (crs_request.exists) {
      List crs_req = crs_request.get('requests');
      crs_req.removeWhere((req) => req['coursID'] == coursID);
      await firestore.collection('crs_requests').doc(user.id).update({
        'requests': crs_req,
      });
    }
    setState(() {
      sem_users.removeAt(index);
    });
  }

  void add(DocumentSnapshot user) {
    List allCourses = SEMS[sem]!.keys.toList();
    List subscribedCourses = user.get('courses');
    List<String> unSubscribedCourses = [];

    for (var course in allCourses) {
      if (!subscribedCourses.contains(course)) {
        unSubscribedCourses.add(course);
      }
    }
    List<Map<String, bool>> checkedUnSubscribedCourses = List.generate(
        unSubscribedCourses.length,
        (index) => {unSubscribedCourses[index]: false});
    Get.to(CheckCourse(checkedUnSubscribedCourses, unSubscribedCourses,
        subscribedCourses, user));
  }

  void savePdf() async {
    //showAdInterstitial();
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final pdf = pw.Document();
      var dir;
      try {
        dir = await getExternalStorageDirectory();
      } catch (e) {
        dir = getApplicationDocumentsDirectory();
      }
      var data =
          await rootBundle.load("assets/fonts/Cairo-VariableFont_wght.ttf");
      final ttf = pw.Font.ttf(data);
      int indx = 0;
      int pages = sem_users.length ~/ 19;
      for (var i = 0; i <= pages; i++) {
        addPage(indx, pdf, ttf);
        indx += 19;
      }

      final file = File('${dir.path}/$sem/$coursID.pdf');
      await file.writeAsBytes(await pdf.save());
      showMessage(title: 'تم التحميل', text: 'تم التحميل بنجاح');
    } catch (e) {
      showMessage(title: 'خطأ', text: 'حدث خطأ في تحميل الملف', error: true);
    }
  }

  void addPage(int indx, pw.Document pdf, pw.Font ttf) {
    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          orientation: pw.PageOrientation.natural,
          textDirection: pw.TextDirection.rtl,
          clip: true,
          margin: pw.EdgeInsets.all(0),
          buildBackground: (pw.Context context) => pw.Container(
            decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(colors: [
              PdfColors.cyan,
              PdfColors.indigo,
            ])),
          ),
        ),
        build: (pw.Context context) => pw.Center(
          child: pw.ListView(
            children: sem_users.map((_) {
              if (indx >= sem_users.length) {
                return pw.Container();
              }
              return pw.Text(
                '    ${indx + 1}    ' + sem_users[indx++].get('name'),
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                  color: PdfColors.white,
                ),
              );
            }).toList()
              ..insert(
                0,
                pw.Container(
                  margin: pw.EdgeInsets.only(top: 10, bottom: 10),
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}
