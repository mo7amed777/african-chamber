import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/ad.dart';
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

  List requests = Get.arguments;

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
          : RefreshIndicator(
              onRefresh: () {
                setState(() {});
                return Future.delayed(Duration(seconds: 1));
              },
              child: ListView.builder(
                itemBuilder: (context, index) => buildItem(
                  context,
                  index,
                  requests[index].values.first,
                  requests[index].keys.first,
                ),
                itemCount: requests.length,
              ),
            ),
    );
  }

  DocumentSnapshot? user_snapshot;

  buildItem(
    BuildContext context,
    int index,
    Map<String, String> request,
    String userID,
  ) {
    firestore
        .collection('users')
        .doc(userID)
        .get()
        .then((doc) => user_snapshot = doc);

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 10.0,
      child: Column(
        children: [
          ListTile(
            isThreeLine: true,
            trailing: TextButton(
              onPressed: () async {
                showAdInterstitial();
                try {
                  firestore
                      .collection('users')
                      .doc(userID)
                      .get()
                      .then((snapshot) async {
                    List courses = snapshot.get('courses');
                    courses.add(request.values.last);
                    await firestore.collection('users').doc(userID).update({
                      'courses': courses,
                    });
                  });

                  await firestore
                      .collection('courses_requests')
                      .doc(userID)
                      .delete();
                  setState(() {
                    requests.removeAt(index);
                  });
                } catch (e) {
                  print(e.toString());
                  showMessage(
                    title: 'خطأ',
                    text:
                        'حدث خطأ أثناء قبول الطلب يرجي التأكد من الإتصال بالإنترنت وإعادة المحاولة',
                    error: true,
                  );
                }
              },
              child: Text('قبول'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                primary: SECONDARYCOLOR,
              ),
            ),
            title: Text(
              user_snapshot?.get('name') ?? '',
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
}
