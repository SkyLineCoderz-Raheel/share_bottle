import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ScreenUserNotificationSetting extends StatefulWidget {
  ScreenUserNotificationSetting({Key? key}) : super(key: key);

  @override
  _ScreenUserNotificationSettingState createState() => _ScreenUserNotificationSettingState();
}

class _ScreenUserNotificationSettingState extends State<ScreenUserNotificationSetting> {
  bool checkAll = true;
  bool checkChat = true;
  bool checkPost = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
          title: Text("Notification Setting"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            CustomSwitchListTile(
                sizeScale: 1,
                activeColor: Colors.green,
                title: Text(
                  "All Notification",
                  style: normal_h1Style.copyWith(color: Colors.black),
                ),
                value: checkAll || (checkPost && checkChat),
                onChanged: (value) {
                  setState(() {
                    checkAll = value;
                    if (!checkAll){
                      checkPost = checkChat = false;
                    }
                  });
                }),
            Divider(
              color: Colors.grey,
              height: 10,
              thickness: 0.1,
            ),
            CustomSwitchListTile(
                sizeScale: 1,
                activeColor: Colors.green,
                title: Text(
                  "Post Notification",
                  style: normal_h1Style.copyWith(color: Colors.black),
                ),
                value: checkPost || checkAll,
                onChanged: (value) {
                  setState(() {
                    checkPost = value;
                    if (!checkPost){
                      var check = checkPost;
                      checkAll = false;
                      checkPost = check;
                    }
                  });
                }),
            Divider(
              color: Colors.grey,
              height: 10,
              thickness: 0.1,
            ),
            CustomSwitchListTile(
                sizeScale: 1,
                activeColor: Colors.green,
                title: Text(
                  "Chat Notification",
                  style: normal_h1Style.copyWith(color: Colors.black),
                ),
                value: checkChat || checkAll,
                onChanged: (value) {
                  setState(() {
                    checkChat = value;
                    if (!checkChat){
                      var check = checkChat;
                      checkAll = false;
                      checkChat = check;
                    }
                  });
                }),
            Divider(
              color: Colors.grey,
              height: 10,
              thickness: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
