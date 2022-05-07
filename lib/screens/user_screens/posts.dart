import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/constants.dart';
import 'package:demo/models/user.dart';
import 'package:demo/screens/user_screens/home_page.dart';
import 'package:demo/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Posts extends StatefulWidget {
  static final routeName = '/posts';
  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<DocumentSnapshot> posts = Get.arguments['posts'];
  CurrentUser user = Get.arguments['user'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('آخر الأخبار', color: SECONDARYCOLOR),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      drawer: MainDrawer(
        user: user,
      ),
      backgroundColor: PRIMARYCOLOR,
      body: posts.isEmpty
          ? Center(
              child: text('لم يتم نشر أى بوست', color: SECONDARYCOLOR),
            )
          : SingleChildScrollView(
              child: Column(
                children: posts
                    .map(
                      (post) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: text(
                              post.get('text') ?? '',
                              size: 18,
                              color: SECONDARYCOLOR,
                            ),
                          ),
                          post.get('url') == 'Not Found!'
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Image.network(
                                    post.get('url'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                          Divider(
                            color: Colors.blue[100],
                            height: 1.0,
                            thickness: 3.0,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
