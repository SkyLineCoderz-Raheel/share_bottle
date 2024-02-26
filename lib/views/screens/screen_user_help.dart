import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';

import '../../widgets/my_button.dart';

class ScreenUserHelp extends StatefulWidget {
  ScreenUserHelp({Key? key}) : super(key: key);

  @override
  _ScreenUserHelpState createState() => _ScreenUserHelpState();
}

class _ScreenUserHelpState extends State<ScreenUserHelp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,size: 18,color: Colors.black,),
          ),
          title: Text("Help"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: Get.width,
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: appBoxShadow,
                color: Colors.white
              ),
              child: Column(children: [
                Text("Contact Us",style: heading4_style.copyWith(color: Colors.black),),
                CustomInputField(
                  showBorder: true,
                  hint: "Your Name ",
                ),
                CustomInputField(
                  showBorder: true,
                  hint: "Your Contact Number ",
                ),
                CustomInputField(
                  showBorder: true,
                  hint: "Your Email ",
                ),
                CustomInputField(
                  showBorder: true,
                  maxLines: 5,
                  hint: "Your feedback is important to us.",
                ),
                MyButton(
                  onPressed: () {
                  },
                  text: 'Send',
                  width: Get.width*0.5,
                  textStyle: normal_h2Style_bold.copyWith(color: Colors.white),
                ),
              ],),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
                  child: Text("We Are Available On",style: normal_h2Style_bold.copyWith(color: Colors.black),),
                ),
                ListTile(leading: Image(
                  width: 20.sp,
                  height: 20.sp,
                  image: AssetImage("assets/images/img_webLink.png"),

                ), title: Text("www.sharebottle.com"),),
                ListTile(leading: Image(
                  width: 20.sp,
                  height: 20.sp,
                  image: AssetImage("assets/images/img_gmail.png"),

                ), title: Text("Contact@sharebottle.com"),),
              ],
            ))
          ],),
        ),
      ),
    );
  }
}