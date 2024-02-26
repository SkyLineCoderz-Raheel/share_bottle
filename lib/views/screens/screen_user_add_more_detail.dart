import 'dart:ui';

import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/screens/screen_user_allow_location.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';

import '../../widgets/my_button.dart';

class ScreenUserAddMoreDetail extends StatefulWidget {
  User user;

  @override
  _ScreenUserAddMoreDetailState createState() => _ScreenUserAddMoreDetailState();

  ScreenUserAddMoreDetail({
    required this.user,
  });
}

class _ScreenUserAddMoreDetailState extends State<ScreenUserAddMoreDetail> {
  var index = 1;
  var dobController = TextEditingController();
  var lastDate = DateTime.now();
  var selectedDateTime = 0;
  var usernameController = TextEditingController();

  @override
  void initState() {
    lastDate = DateTime.fromMillisecondsSinceEpoch(widget.user.dateOfBirth);
    index = widget.user.image_index;
    setUniqueUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // leadingWidth: Get.width*0.3,
          automaticallyImplyLeading: false,
          title: Text("Add more details"),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.18,
                                width: Get.width * 0.36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(fit: BoxFit.contain, image: AssetImage("assets/images/avatar ($index).png")),
                                  ),
                                )),
                            Positioned(
                                right: 12,
                                bottom: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            alignment: Alignment.center,
                                            elevation: 5,
                                            actionsAlignment: MainAxisAlignment.center,
                                            actionsPadding: EdgeInsets.symmetric(horizontal: 20),
                                            actions: [
                                              OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                      minimumSize: const Size(250, 40),
                                                      maximumSize: const Size(250, 40),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                      side: BorderSide(
                                                        color: Colors.red,
                                                      )),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: normal_h2Style_bold.copyWith(color: Colors.red),
                                                  )),
                                            ],
                                            title: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Select an Avatar",
                                                  style: normal_h1Style_bold,
                                                )),
                                            content: Container(
                                              height: Get.height * 0.32,
                                              width: 90.w,
                                              child: GridView(
                                                children: avatarsList.map((e) {
                                                  return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          index = avatarsList.indexOf(e);
                                                          Get.back();
                                                        });
                                                      },
                                                      child: Image.asset(e));
                                                }).toList(),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4, crossAxisSpacing: 10, childAspectRatio: 0.8),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      )),
                                ))
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      //   child: TextField(
                      //     onChanged: (value) {
                      //       //Do something with the user input.
                      //     },
                      //     decoration: InputDecoration(
                      //       hintText: 'UserName',
                      //       fillColor: fillColor,
                      //       filled: true,
                      //       contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //       ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.white, width: 1.0),
                      //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.white, width: 2.0),
                      //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                          child: CustomInputField(
                            text: timestampToDateFormat(widget.user.dateOfBirth, "dd MMM, yyyy"),
                            label: "Date of birth",
                            keyboardType: TextInputType.none,
                            controller: dobController,
                          ),
                        ),
                        onTap: () async {
                          var dateTime = await showDatePicker(
                              context: context, initialDate: lastDate, firstDate: DateTime.fromMillisecondsSinceEpoch(0), lastDate: lastDate);
                          if (dateTime != null) {
                            setState(() {
                              selectedDateTime = dateTime.millisecondsSinceEpoch;
                              dobController.text = timestampToDateFormat(selectedDateTime, "dd MMM, yyyy");
                            });
                            widget.user.dateOfBirth = selectedDateTime;
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                        child: /*TextField(
                          onChanged: (value) {
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                            hintText: 'Date of birth',
                            fillColor: fillColor,
                            filled: true,

                            contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )*/
                            CustomInputField(
                          text: widget.user.username,
                          label: "Username",
                          controller: usernameController,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20.h,
                alignment: Alignment.topCenter,
                child: MyButton(
                  onPressed: () async {
                    String response = await updateDatabase();
                    if (response == "success") {
                      Get.offAll(ScreenUserAllowLocation(user: widget.user,));
                    } else {
                      Get.snackbar("Alert", response);
                    }
                  },
                  text: 'Finish',
                  textStyle: normal_h2Style_bold.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> updateDatabase() async {
    String response = "";
    String username = usernameController.text;
    if (username.isEmpty) {
      return "Username required";
    }
    bool exists = (await checkUsername(username)) != null;
    if (exists) {
      return "Username already exists";
    }
    await usersRef.doc(widget.user.id).update({
      "dateOfBirth": widget.user.dateOfBirth,
      "username": username,
      "image_index": index,
    }).then((value) {
      response = "success";
    });
    return response;
  }



  void setUniqueUsername() async {
    String username = await generateUniqueUsername();
    if (mounted) {
      setState(() {
        usernameController.text = username;
      });
    }
  }
}
