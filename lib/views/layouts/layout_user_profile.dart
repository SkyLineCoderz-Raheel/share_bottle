import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/user.dart' as model;
import 'package:share_bottle/views/screens/screen_user_edit_profile.dart';
import 'package:share_bottle/views/screens/screen_user_settings.dart';

import '../screens/screen_user_log_in.dart';

class LayoutUserProfile extends StatefulWidget {
  LayoutUserProfile({Key? key}) : super(key: key);

  @override
  _LayoutUserProfileState createState() => _LayoutUserProfileState();
}

class _LayoutUserProfileState extends State<LayoutUserProfile> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<DocumentSnapshot>(
        stream: usersRef.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator.adaptive();
          }

          model.User user = model.User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return SafeArea(
              child: Stack(
            children: [
              Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: Get.height / 1.4,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(Get.width / 2, Get.height / 10),
                              topRight: Radius.elliptical(Get.width / 2, Get.height / 10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            padding: EdgeInsets.all(8),
                            width: Get.width,
                            color: Colors.grey,
                            child: Text(
                              "Preferences",
                              style: normal_h1Style_bold,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(ScreenUserEditProfile(user: user));
                            },
                            leading: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), shape: BoxShape.rectangle, color: Color(0xFFC4C4C4)),
                              child: Image(
                                width: 15.sp,
                                height: 15.sp,
                                image: AssetImage("assets/images/icon_account.png"),
                              ),
                            ),
                            title: Text(
                              "Edit Profile",
                              style: normal_h2Style_bold,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(ScreenUserSettings());
                            },
                            leading: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), shape: BoxShape.rectangle, color: Color(0xFFC4C4C4)),
                              child: Image(
                                width: 15.sp,
                                height: 15.sp,
                                image: AssetImage("assets/images/img_setting.png"),
                              ),
                            ),
                            title: Text(
                              "Settings",
                              style: normal_h2Style_bold,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                            title: Text("Delete Account"),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text("Are you sure to delete your account. You will not be able to access it again"),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              OutlinedButton(
                                                onPressed: () async {
                                                  Get.back();
                                                  var user = FirebaseAuth.instance.currentUser!;
                                                  // bool authenticated = await reAuthUser(user.email!, password);
                                                  FirebaseAuth.instance.currentUser!.delete().then((value) async {
                                                      usersRef.doc(uid).delete();
                                                      await FirebaseAuth.instance.signOut();
                                                      Get.offAll(ScreenUserLogIn());
                                                    });
                                                },
                                                child: Text("Delete"),
                                                style: OutlinedButton.styleFrom(primary: Colors.white, backgroundColor: Colors.red),
                                              )
                                            ],
                                          );
                                  });
                            },
                            leading: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), shape: BoxShape.rectangle, color: Color(0xFFC4C4C4)),
                              child: Icon(Icons.delete),
                            ),
                            title: Text(
                              "Permanently Delete Account",
                              style: normal_h2Style_bold,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              showIosDialog(
                                  context: context,
                                  title: "Logout",
                                  message: "Are you sure to logout?",
                                  onConfirm: () {
                                    FirebaseAuth.instance.signOut();
                                    Get.offAll(ScreenUserLogIn());
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                  cancelText: "Cancel",
                                  confirmText: "Logout");
                            },
                            leading: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), shape: BoxShape.rectangle, color: Color(0xFFC4C4C4)),
                              child: Image(
                                width: 15.sp,
                                height: 15.sp,
                                image: AssetImage("assets/images/img_logout.png"),
                              ),
                            ),
                            title: Text(
                              "Logout",
                              style: normal_h2Style_bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: Get.height / 55.h,
                child: Container(
                    child: Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: Get.height / 16,
                    ),
                    Container(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: Get.width / 3,
                            width: Get.width / 3,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.all(Radius.circular(Get.width / 4)),
                              border: Border.all(width: 3, color: Colors.white),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/images/avatar (${user.image_index}).png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      user.username,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
              )
            ],
          ));
        },
      ),
    );
  }

  Future<bool> reAuthUser(String email, String password) async {
    bool result = false;
    var credentials = await EmailAuthProvider.credential(email: email, password: password);
    await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credentials).then((value) {
      result = true;
    }).catchError((error) {
      result = false;
    });

    return result;
  }
}
