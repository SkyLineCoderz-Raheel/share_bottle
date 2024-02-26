import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/fcm.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/interfaces/home_listener.dart';
import 'package:share_bottle/views/layouts/layout_user_chat.dart';
import 'package:share_bottle/views/layouts/layout_user_feeds.dart';
import 'package:share_bottle/views/layouts/layout_user_search.dart';
import 'package:share_bottle/views/screens/screen_user_create_new_post.dart';
import 'package:share_bottle/views/screens/screen_user_record_video.dart';

import '../layouts/layout_user_profile.dart';

class ScreenUserHomePage extends StatefulWidget {
  @override
  _ScreenUserHomePageState createState() => _ScreenUserHomePageState();
}

class _ScreenUserHomePageState extends State<ScreenUserHomePage> implements HomeListener {
  PageController _myPage = PageController(initialPage: 0);
  int selectedIndex = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.to(ScreenUserRecordVideo());
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.white,
          elevation: 5,
          notchMargin: 5.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 75,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                      icon: Image(
                        width: 20.sp,
                        height: 20.sp,
                        image: AssetImage("assets/images/img_home.png"),
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(0);
                        });
                      },
                    ),
                    Text("Feeds")
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image(
                        width: 20.sp,
                        height: 20.sp,
                        image: AssetImage("assets/images/img_search_bottom.png"),
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(1);
                        });
                      },
                    ),
                    Text("Search")
                  ],
                ),
                Container(),
                Column(
                  children: [
                    IconButton(
                      icon: Image(
                        width: 20.sp,
                        height: 20.sp,
                        image: AssetImage("assets/images/img_chat.png"),
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(2);
                        });
                      },
                    ),
                    Text("Chat")
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image(
                        width: 20.sp,
                        height: 20.sp,
                        image: AssetImage("assets/images/bottom_profile.png"),
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(3);
                        });
                      },
                    ),
                    Text("Profile")
                  ],
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (selectedIndex == 0){
              return true;
            }
            setState(() {
              _myPage.jumpToPage(0);
            });
            return false;
          },
          child: SafeArea(
            child: PageView(
              controller: _myPage,
              onPageChanged: (index){
                selectedIndex = index;
              },
              children: <Widget>[
                LayoutUserFeeds(this),
                LayoutUserSearch(),
                LayoutUserChat(),
                LayoutUserProfile(),
              ],
              physics: NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onPageIndexUpdate(int newIndex) {
    setState(() {
      _myPage.jumpToPage(newIndex);
    });
  }

  void updateToken() async {
    String token = await FCM.generateToken() ?? "";
    usersRef.doc(uid).update({"notificationToken": token});
  }
}
