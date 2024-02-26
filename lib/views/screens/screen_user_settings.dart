import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/views/screens/screen_user_about.dart';
import 'package:share_bottle/views/screens/screen_user_help.dart';
import 'package:share_bottle/views/screens/screen_user_notification_setting.dart';
import 'package:share_bottle/views/screens/screen_user_terms_and_condition.dart';

class ScreenUserSettings extends StatefulWidget {
  ScreenUserSettings({Key? key}) : super(key: key);

  @override
  _ScreenUserSettingsState createState() => _ScreenUserSettingsState();
}

class _ScreenUserSettingsState extends State<ScreenUserSettings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          title: Text("Settings"),
          centerTitle: true,

          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,size: 18,color: Colors.black,),
          ),
        ),
        body: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 10,),

            ListTile(
              onTap: () {
                Get.to(ScreenUserNotificationSetting());
              },
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                    color: Color(0xFFC4C4C4)
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Notification Settings",
                style: normal_h3Style_bold,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
                color: Colors.black,
              ),
            ),
              SizedBox(height: 10,),

              ListTile(
              onTap: () {
                Get.to(ScreenUserTermsAndCondition());
              },
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                    color: Color(0xFFC4C4C4)
                ),
                child: Icon(
                  Icons.history_edu_sharp,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Terms & Conditions",
                style: normal_h3Style_bold,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              onTap: () {
                Get.to(ScreenUserHelp());
              },
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                    color: Color(0xFFC4C4C4)
                ),
                child: Icon(
                  Icons.help,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Help",
                style: normal_h3Style_bold,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
                color: Colors.black,
              ),
            ),
              SizedBox(height: 10,),

              ListTile(
              onTap: () {
                Get.to(ScreenUserAbout());
              },
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                    color: Color(0xFFC4C4C4)
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "About",
                style: normal_h3Style_bold,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
                color: Colors.black,
              ),
            ),

          ],),
        ),
      ),
    );
  }
}