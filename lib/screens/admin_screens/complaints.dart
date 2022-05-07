import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_format/date_format.dart';

class Complaints extends StatefulWidget {
  Complaints({Key? key}) : super(key: key);

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> complaints =
      Get.arguments['complaints'];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARYCOLOR,
        elevation: 0.0,
        title: Text(
          'الشكاوى',
          style: TextStyle(
            color: SECONDARYCOLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: PRIMARYCOLOR,
      body: complaints.isEmpty
          ? Center(
              child: text('لا يوجد أي شكاوى أو مقترحات', color: SECONDARYCOLOR),
            )
          : ListView.builder(
              itemBuilder: (context, index) => complaintItem(complaints[index]),
              itemCount: complaints.length,
            ),
    );
  }

  Widget complaintItem(QueryDocumentSnapshot<Map<String, dynamic>> complaint) {
    return Card(
      color: Colors.transparent.withOpacity(0.5),
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          complaint.get('title'),
          style: TextStyle(
            color: SECONDARYCOLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          formatDate(
            (complaint.get('date') as Timestamp).toDate(),
            [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, am],
          ).toString(),
          style: TextStyle(
            color: SECONDARYCOLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: SECONDARYCOLOR),
        leading: Icon(
          checked || complaint.get('seen')
              ? Icons.pending_actions
              : Icons.notification_important_rounded,
          color: checked || complaint.get('seen') ? Colors.green : Colors.red,
          size: 30,
        ),
        onTap: () {
          Get.defaultDialog(
            title: complaint.get('title'),
            barrierDismissible: false,
            actions: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    Get.back();

                    await firestore
                        .collection('complaints')
                        .doc(complaint.get('user data')['sem'])
                        .collection('data')
                        .doc(complaint.id)
                        .delete();
                    setState(() {
                      complaints.remove(complaint);
                    });
                  },
                  child: Text('تم مراجعة الطلب'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: SECONDARYCOLOR,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    Get.back();
                    setState(() {
                      checked = true;
                    });
                    await firestore
                        .collection('complaints')
                        .doc(complaint.get('user data')['sem'])
                        .collection('data')
                        .doc(complaint.id)
                        .update({
                      'title': complaint.get('title'),
                      'content': complaint.get('content'),
                      'date': complaint.get('date'),
                      'seen': checked,
                      'user data': {
                        'name': complaint.get('user data')['name'],
                        'email': complaint.get('user data')['email'],
                        'phone': complaint.get('user data')['phone'],
                        'sem': complaint.get('user data')['sem'],
                        'set_num': complaint.get('user data')['set_num'],
                      }
                    });
                  },
                  child: Text('تعليق الطلب'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    primary: SECONDARYCOLOR,
                  ),
                ),
              ),
            ],
            content: Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent.withOpacity(0.5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      text('تفاصيل الطلب', color: SECONDARYCOLOR),
                      Text(
                        complaint.get('content'),
                        style: TextStyle(color: SECONDARYCOLOR, fontSize: 18.0),
                      ),
                      text('بيانات الطالب', color: SECONDARYCOLOR),
                      Text(
                        complaint.get('user data')['name'],
                        style: TextStyle(color: SECONDARYCOLOR, fontSize: 20.0),
                      ),
                      Text(
                        ' الفرقة  : ' + complaint.get('user data')['sem'],
                        style: TextStyle(color: SECONDARYCOLOR, fontSize: 18.0),
                      ),
                      Text(
                        complaint.get('user data')['set_num'] +
                            ' : رقم الجلوس ',
                        style: TextStyle(color: SECONDARYCOLOR, fontSize: 18.0),
                      ),
                      Text(
                        complaint.get('user data')['phone'] + ' : رقم الهاتف ',
                        style: TextStyle(color: SECONDARYCOLOR, fontSize: 18.0),
                      ),
                      Text(
                        complaint.get('user data')['email'] +
                            ' : البريد الإلكتروني ',
                        style: TextStyle(color: SECONDARYCOLOR, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
