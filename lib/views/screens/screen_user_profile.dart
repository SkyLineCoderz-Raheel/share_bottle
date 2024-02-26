import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/views/layouts/item_user_feed_post.dart';
import 'package:share_bottle/views/layouts/item_user_profile.dart';

import '../../models/user.dart';

class ScreenUserProfile extends StatefulWidget {
  String uid;

  @override
  _ScreenUserProfileState createState() => _ScreenUserProfileState();

  ScreenUserProfile({
    required this.uid,
  });
}

class _ScreenUserProfileState extends State<ScreenUserProfile> {
  double WIDTH = 1.w;

  User user = initUser();

  @override
  void initState() {
    user = allUsersData[widget.uid] ?? initUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(Get.width * 0.15),
                      )),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.back();
                            //   },
                            //   child: Container(
                            //     margin: EdgeInsets.symmetric(horizontal: 20),
                            //     padding: EdgeInsets.all(4),
                            //     alignment: Alignment.center,
                            //     decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                            //     child: Icon(
                            //       Icons.arrow_back_ios,
                            //       size: 14,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: Icon(
                            //     Icons.more_vert_outlined,
                            //     size: 24,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(getImageByIndex(user.image_index)),
                                  ),
                                ],
                              ),
                              title: Text(
                                user.username,
                                style: normal_h2Style_bold.copyWith(color: Colors.white),
                              ),
                              // subtitle: Text(
                              //   "Journalist, beloggr ❤",
                              //   style: normal_h4Style_bold.copyWith(color: Colors.white),
                              // ),
                            ),
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(32),
                            //       border: Border.all(color: Colors.white, width: 1),
                            //     ),
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         Icon(
                            //           Icons.add,
                            //           size: 16,
                            //           color: Colors.white,
                            //         ),
                            //         Text(" Follow", style: normal_h2Style.copyWith(color: Colors.white))
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: postsRef.where("user_id", isEqualTo: widget.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator.adaptive());
                      }

                      var posts = snapshot.data!.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList();

                      return posts.isNotEmpty ? CustomListviewBuilder(
                        itemBuilder: (BuildContext context, int index) => ItemUserFeedPost(post: posts[index]),
                        itemCount: posts.length,
                        scrollDirection: CustomDirection.vertical,
                      ) : NotFound(message: "No posts found");
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
