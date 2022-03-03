import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  @override
  Widget build(BuildContext context) {
    switch (state) {
      case states.subscribed:
        title = 'الطلاب المشتركين';
        break;
      case states.non:
        title = 'الطلاب الغير مشتركين';
        break;
      default:
        title = 'جميع طلاب الفرقة$sem';
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: text(title, color: SECONDARYCOLOR),
          actions: [],
        ),
        body: ListView.builder(
            itemBuilder: (context, index) =>
                buildItem(context, index, sem_users[index], state)));
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
          Container(
            child: buildButton(() async {
              if (state == states.subscribed)
                reject(user, coursID, index);
              else
                accept(user, coursID, index);
            }),
            width: double.infinity,
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
                      children: crs.map((course) => text(course)).toList(),
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
                  reject(user, coursID, index);
                else
                  accept(user, coursID, index);
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
    if (state == states.all) return Container();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: TextButton(
          onPressed: () => callBack(),
          child:
              Text(state == states.subscribed ? 'حذف الطالب' : 'تسجيل الطالب'),
          style: TextButton.styleFrom(
            backgroundColor:
                state == states.subscribed ? Colors.red : Colors.green,
            primary: SECONDARYCOLOR,
          ),
        ),
      ),
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void reject(DocumentSnapshot user, String coursID, int index) async {
    List courses = user.get('courses');
    courses.removeWhere((crs) => crs == coursID);
    await firestore.collection('users').doc(user.id).update({
      'courses': courses,
    });
    setState(() {
      sem_users.removeAt(index);
    });
  }

  void accept(DocumentSnapshot user, String coursID, int index) async {
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
}
