import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Requests extends StatefulWidget {
  static final routeName = '/Requests';
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List requests = Get.arguments[0];
  List names = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلبات الإشتراك',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PRIMARYCOLOR,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: PRIMARYCOLOR,
      body: requests.isEmpty
          ? Center(
              child: Text(
                'لا يوجد طلبات',
                style: TextStyle(
                  color: SECONDARYCOLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) => buildItem(
                context,
                index,
                requests[index].values.first,
                requests[index].keys.first,
                names[index],
              ),
              itemCount: requests.length,
            ),
    );
  }

  buildItem(
    BuildContext context,
    int index,
    Map<String, String> request,
    String userID,
    String name,
  ) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 10.0,
      child: Column(
        children: [
          ListTile(
            isThreeLine: true,
            trailing: TextButton(
              onPressed: () {
                getRequestInfo(
                    userID, request['coursID']!, request['code']!, index);
              },
              child: Text('عرض'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                primary: SECONDARYCOLOR,
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                color: PRIMARYCOLOR,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      request['code'] ?? 'Code Error',
                      style: TextStyle(
                        color: PRIMARYCOLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ' : كود الإشتراك ',
                      style: TextStyle(
                        color: PRIMARYCOLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  request['coursID'] ?? 'Title Error',
                  style: TextStyle(
                    color: PRIMARYCOLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
        ],
      ),
    );
  }

  void getRequestInfo(
      String userID, String coursID, String code, int index) async {
    DocumentSnapshot user =
        await firestore.collection('users').doc(userID).get();
    showRequestInfo(user, coursID, code, index);
  }

  void showRequestInfo(
      DocumentSnapshot user, String coursID, String code, int index) {
    Get.dialog(
      Material(
        child: Center(
          child: ListView(
            children: [
              text(
                'بيانات الطلب',
              ),
              Card(
                elevation: 10.0,
                child: Image.network(
                  user.get('id_card'),
                  fit: BoxFit.fill,
                  height: 200,
                ),
              ),
              Text(
                coursID,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: PRIMARYCOLOR),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              text(
                user.get('name'),
                size: 25,
                color: PRIMARYCOLOR!,
              ),
              SizedBox(height: 5),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                    code,
                    size: 22,
                    color: PRIMARYCOLOR!,
                  ),
                  SizedBox(width: 10),
                  text(' : كود الإشتراك'),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          Get.back();
                          reject(user, coursID, index);
                        },
                        child: Text('رفض'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          primary: SECONDARYCOLOR,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          Get.back();
                          accept(user, coursID, index);
                        },
                        child: Text('قبول'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          primary: SECONDARYCOLOR,
                        ),
                      ),
                    ),
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
      useSafeArea: true,
    );
  }

  void reject(DocumentSnapshot user, String coursID, int index) async {
    DocumentSnapshot crs_request =
        await firestore.collection('crs_requests').doc(user.id).get();
    List crs_req = crs_request.get('requests');
    crs_req.removeWhere((req) => req['coursID'] == coursID);

    await firestore.collection('crs_requests').doc(user.id).update({
      'requests': crs_req,
    });
    setState(() {
      requests.removeAt(index);
      names.removeAt(index);
    });
  }

  void accept(DocumentSnapshot user, String coursID, int index) async {
    try {
      List courses = user.get('courses');
      if (!courses.contains(coursID)) courses.add(coursID);
      await firestore.collection('users').doc(user.id).update({
        'courses': courses,
      });

      reject(user, coursID, index);
    } catch (e) {
      print(e.toString());
      showMessage(
        title: 'خطأ',
        text:
            'حدث خطأ أثناء قبول الطلب يرجي التأكد من الإتصال بالإنترنت وإعادة المحاولة',
        error: true,
      );
    }
  }
}
