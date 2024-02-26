import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/interfaces/home_listener.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/views/layouts/item_admin_feed_story.dart';
import 'package:share_bottle/views/layouts/item_user_feed_post.dart';
import 'package:share_bottle/views/layouts/item_user_feed_story.dart';
import 'package:share_bottle/views/screens/screen_user_notifications.dart';
import 'package:share_bottle/views/screens/screen_user_story_view.dart';
import 'package:share_bottle/widgets/my_input_field.dart';

import '../../helpers/helpers.dart';
import '../../models/report.dart';

class LayoutUserFeeds extends StatefulWidget {
  HomeListener listener;

  LayoutUserFeeds(this.listener);

  @override
  _LayoutUserFeedsState createState() => _LayoutUserFeedsState();
}

class _LayoutUserFeedsState extends State<LayoutUserFeeds> {
  String searchQuery = "";

  var searchController = TextEditingController();

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 10.h,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: GestureDetector(
                onTap: () {
                  widget.listener.onPageIndexUpdate(1);
                },
                child: MyInputField(
                  hint: "search",
                  // onChange: (value){
                  //   setState(() {
                  //     if (value != null){
                  //       searchQuery = value.toString();
                  //     }
                  //   });
                  // },
                  onChange: (value) {
                    if (value != null) {
                      searchController.clear();
                    }
                  },
                  controller: searchController,
                  fillColor: Color(0xFFFFE1D3),
                  keyboardType: TextInputType.none,
                  prefix: Icon(Icons.search),
                  showBorder: true,
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Get.to(ScreenUserNotifications());
                    },
                    icon: Image(
                      color: Colors.black,
                      image: AssetImage("assets/images/bell.png"),
                    ))),
            // Expanded(
            //   flex: 1,
            //   child: GestureDetector(
            //     onTap: () {
            //       widget.listener.onPageIndexUpdate(3);
            //     },
            //     child: Container(
            //         margin: EdgeInsets.only(right: 5),
            //         height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.05,
            //         width: Get.width * 0.08,
            //         decoration: BoxDecoration(
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.circular(10),
            //             image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/img_profile_home.png")))),
            //   ),
            // ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getBlockedPostsAndUsers(uid),
        builder: (context, futureSnapshot) {

          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          List<Report> reports = futureSnapshot.data!['reports'] ?? [];
          List<String> blockedUsers = futureSnapshot.data!['blockedUsers'] ?? [];



          return StreamBuilder<QuerySnapshot>(
              stream: postsRef.orderBy("timestamp", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                var posts = snapshot.data!.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList();
                // posts = posts.where((element) => element.timestamp.daysFromNow <= postMaxDays).toList();

                posts.removeWhere((element) {
                  if (reports.where((report) => report.post_id == element.id).toList().isNotEmpty) {
                    return true;
                  } else if (blockedUsers.where((blocked_uid) => element.user_id == blocked_uid).toList().isNotEmpty) {
                    return true;
                  } else {
                    return false;
                  }
                });

                Map<Post, List<Post>> postsMap = getPostsMap(posts);

                var filterPosts = posts.toList();
                if (searchQuery.isNotEmpty) {
                  filterPosts = filterPosts.where((element) => element.description.toLowerCase().contains(searchQuery.toLowerCase())).toList();
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 11.h,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: adminPostsRef.snapshots(),
                          builder: (context, adminSnapshot) {
                            if (!adminSnapshot.hasData || adminSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator.adaptive());
                            }

                            var adminStories = adminSnapshot.data!.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList();
                            adminStories.sort((b, a) => a.timestamp.compareTo(b.timestamp));
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              alignment: Alignment.centerLeft,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: ItemAdminFeedStory(),
                                      onTap: () {
                                        if (adminStories.isEmpty) {
                                          Get.snackbar("Alert", "No stories available");
                                          return;
                                        }
                                        Get.to(ScreenUserStoryView(
                                          posts: adminStories,
                                          isAdmin: true,
                                        ));
                                      },
                                    ),
                                    ...getPostsMapWidgets(postsMap),
                                  ],
                                ),
                              ),
                            );
                          }),
                      filterPosts.isNotEmpty
                          ? CustomListviewBuilder(
                              itemBuilder: (BuildContext context, int index) => ItemUserFeedPost(post: filterPosts[index]),
                              itemCount: filterPosts.length,
                              scrollable: false,
                              scrollDirection: CustomDirection.vertical)
                          : Container(height: Get.height * 0.6, child: NotFound(message: "No posts")),
                    ],
                  ),
                );
              });
        }
      ),
    );
  }

  Map<Post, List<Post>> getPostsMap(List<Post> posts) {
    Map<Post, List<Post>> postsMap = Map();
    var allUserIds = posts.map((e) => e.user_id).toList().toSet().toList();
    print(allUserIds);
    allUserIds.forEach((uid) {
      var userPosts = posts.where((element) => element.user_id == uid).toList();
      postsMap[userPosts.first] = userPosts;
    });
    return postsMap;
  }

  List<Widget> getPostsMapWidgets(Map<Post, List<Post>> postsMap) {
    List<Widget> widgets = [];
    postsMap.forEach((key, value) {
      widgets.add(
        GestureDetector(
            onTap: (){
              Get.to(ScreenUserStoryView(posts: value, isAdmin: false));
            },
            child: ItemUserFeedStory(post: key))
      );
    });
    return widgets;
  }
}
