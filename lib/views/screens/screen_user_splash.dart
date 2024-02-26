
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/views/screens/screen_user_log_in.dart';
import 'package:share_bottle/views/screens/screen_user_otp_verification.dart';
import 'package:share_bottle/views/screens/screen_user_sign_up.dart';

class ScreenUserSplash extends StatefulWidget {
  ScreenUserSplash({Key? key}) : super(key: key);

  @override
  _ScreenUserSplashState createState() => _ScreenUserSplashState();
}

class _ScreenUserSplashState extends State<ScreenUserSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/img_splash.png"), fit: BoxFit.cover,),
              ),
            ),
            new Center(
              child: new Text("Share Loko",style: heading1_style.copyWith(color: Colors.white),),
            ),
            Positioned(
              bottom: 80,
              right: 10,
              left: 10,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.all(7),
                          side: BorderSide(
                              color: Colors.white
                          )),
                      onPressed: () {
                        Get.to(ScreenUserLogIn());
                      },
                      child: Text('Login',style: normal_h1Style_bold.copyWith(color: Colors.white),)),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.all(7),
                          side: BorderSide(
                              color: Colors.white
                          )),
                      onPressed: () {
                        Get.to(ScreenUserSignUp());
                      },
                      child: Text('Signup',style: normal_h1Style_bold.copyWith(color: Colors.white),)),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              left: 10,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      width: Get.width*0.05,
                      image: AssetImage("assets/images/icon_info.png")),
                  Text(" You must be 22 to use this app.",style: normal_h2Style.copyWith(color: Colors.white),)
                ],
              ),
            ),
          ],
        )
    );
  }
}