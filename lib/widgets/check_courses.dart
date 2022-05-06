import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/admin_screens/admin.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/models/ad.dart';

class CheckCourse extends StatefulWidget {
  final List<Map<String, bool>> checkedUnSubscribedCourses;
  final List<String> unSubscribedCourses;
  final List subscribedCourses;
  final DocumentSnapshot user;
  CheckCourse(this.checkedUnSubscribedCourses, this.unSubscribedCourses,
      this.subscribedCourses, this.user);

  @override
  State<CheckCourse> createState() => _CheckCourseState();
}

class _CheckCourseState extends State<CheckCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('إختر المواد', color: SECONDARYCOLOR),
      ),
      body: widget.unSubscribedCourses.isEmpty
          ? Center(child: text('لا يوجد أي مواد لإضافتها '))
          : SingleChildScrollView(
              child: Column(
                children: widget.unSubscribedCourses
                    .map((course) => Container(
                          child: CheckboxListTile(
                              title: Text(
                                course,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              value: widget.checkedUnSubscribedCourses[widget
                                  .unSubscribedCourses
                                  .indexOf(course)][course],
                              onChanged: (check) {
                                setState(() {
                                  widget.checkedUnSubscribedCourses[widget
                                          .unSubscribedCourses
                                          .indexOf(course)][course] =
                                      check ?? false;
                                });
                              }),
                        ))
                    .toList()
                  ..add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      width: 200,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          List<int> indxs = [];
                          for (var checked
                              in widget.checkedUnSubscribedCourses) {
                            if (checked.values.first) {
                              int index = widget.checkedUnSubscribedCourses
                                  .indexOf(checked);
                              if (!widget.subscribedCourses
                                  .contains(widget.unSubscribedCourses[index]))
                                widget.subscribedCourses
                                    .add(widget.unSubscribedCourses[index]);
                              indxs.add(index);
                            }
                          }
                          add(widget.user, indxs);
                        },
                        child: Text('تسجيــل'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          primary: SECONDARYCOLOR,
                        ),
                      ),
                    ),
                  ),
              ),
            ),
    );
  }

  void add(DocumentSnapshot user, List<int> indxs) async {
    Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('users').doc(user.id).update({
      'courses': widget.subscribedCourses,
    });
    DocumentSnapshot crs_request =
        await firestore.collection('crs_requests').doc(user.id).get();
    if (crs_request.exists) {
      List crs_req = crs_request.get('requests');
      for (var req in crs_req) {
        for (var crs in widget.subscribedCourses) {
          if (req['coursID'] == crs) {
            crs_req.remove(crs);
          }
        }
      }
      await firestore.collection('crs_requests').doc(user.id).update({
        'requests': crs_req,
      });
    }
    for (var indx in indxs) {
      widget.unSubscribedCourses.removeAt(indx);
      widget.checkedUnSubscribedCourses.removeAt(indx);
      setState(() {});
    }
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'تم بنجاح',
      cancel: TextButton(
        onPressed: () {
          Get.offAllNamed(Admin.routeName);
          showAdInterstitial();
        },
        child: Text('إغلاق'),
      ),
      middleTextStyle: TextStyle(color: Colors.green),
      middleText: 'تم تسجيل المواد بنجاح',
    );
  }
}
