import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ScreenUserAbout extends StatefulWidget {
  ScreenUserAbout({Key? key}) : super(key: key);

  @override
  _ScreenUserAboutState createState() => _ScreenUserAboutState();
}

class _ScreenUserAboutState extends State<ScreenUserAbout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: Text("About"),
          elevation: 3,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Share Loko",
                  style: heading1_style.copyWith(color: Color(0xFF767676), fontFamily: 'Comfortaa'),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Help protect your website and its users with clear "),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("and fair website terms and conditions."),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "Version",
                      style: normal_h2Style_bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("1.0.1"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Powered by",
                      style: normal_h2Style_bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Share Loko"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Contact us",
                      style: normal_h2Style_bold,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Image(
                  width: 20.sp,
                  height: 20.sp,
                  image: AssetImage("assets/images/img_webLink.png"),
                ),
                title: Text("https://www.shareloko.com/policy"),
              ),
              ListTile(
                leading: Image(
                  width: 20.sp,
                  height: 20.sp,
                  image: AssetImage("assets/images/img_gmail.png"),
                ),
                title: Text("contact@shareloko.com"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
