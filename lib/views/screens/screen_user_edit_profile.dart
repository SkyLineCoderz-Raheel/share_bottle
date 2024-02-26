import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/models/user.dart';

import '../../helpers/helpers.dart';

class ScreenUserEditProfile extends StatefulWidget {
User? user;
  @override
  _ScreenUserEditProfileState createState() => _ScreenUserEditProfileState();

ScreenUserEditProfile({
    this.user,
  });
}

class _ScreenUserEditProfileState extends State<ScreenUserEditProfile> {

  var index=0;


  var dobController = TextEditingController();
  final RestorableDateTimeN _startDate =
  RestorableDateTimeN(DateTime(2000, 1, 1));
  final RestorableDateTimeN _endDate =
  RestorableDateTimeN(DateTime(1950, 1, 1));
  var lastDate = DateTime.now();
  var selectedDateTime = 0;
  @override
  void initState() {
    lastDate = DateTime.fromMillisecondsSinceEpoch(widget.user!.dateOfBirth);
    index = widget.user!.image_index;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,size: 18,color: Colors.black,),
          ),
          actions: [TextButton(onPressed: (){
           setState(() {
             index=widget.user!.image_index;
             usersRef.doc(widget.user!.id).update({
               "dateOfBirth": widget.user!.dateOfBirth,
               "image_index": index,
             });
             Get.back();
           });
            }, child: Text("Save",style: normal_h2Style.copyWith(color: Colors.red),))],
        ),
        body: SingleChildScrollView(child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.topCenter,
                  height: Get.height *
                      (SizerUtil.orientation == Orientation.landscape
                          ? 2
                          : 1) *
                      0.18,
                  width: Get.width * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    shape: BoxShape.circle,
                    boxShadow: appBoxShadow,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/images/avatar (${widget.user?.image_index}).png"),
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                        bottom: 24,
                        right: 0,
                        child: GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (context){
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
                                      child: Text("Cancel",style: normal_h2Style_bold.copyWith(color: Colors.red),)),
                                ],
                                title: Align(
                                    alignment: Alignment.center,
                                    child: Text("Select an Avatar",style: normal_h1Style_bold,)),
                                content: Container(
                                  height: Get.height*0.32,
                                  width: 90.w,
                                  child: GridView(
                                    children: avatarsList.map((e) {
                                      return GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              widget.user!.image_index = avatarsList.indexOf(e);
                                              Get.back();
                                            });
                                          },
                                          child: Image.asset(e));
                                    }).toList(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 0.8
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.black,                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Icon(Icons.edit,size: 20,
                                color: Colors.white,
                              )),
                        ))
                  ],),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("UserName"),
                CustomInputField(
                  text: widget.user?.username,
                  showBorder: false,
                  keyboardType: TextInputType.none,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp
                  ),
                  fillColor: Color(0xFFD6D6D6),
                  onChange: (String){
                    usersRef.doc(widget.user!.id).update({
                      "dateOfBirth": widget.user!.dateOfBirth,
                    });
                  },
                ),
                Text("Phone"),
                CustomInputField(
                  keyboardType: TextInputType.none,
                  text: widget.user?.phone,
                  showBorder: false,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp
                  ),
                  fillColor: Color(0xFFD6D6D6),
                ),
                Text("Date of birth"),
                GestureDetector(
                  onTap: () async {
                    var dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000, 0),
                        firstDate: DateTime(1900, 8),
                        lastDate: DateTime(2000)
                    );
                    if (dateTime != null) {
                      setState(() {
                        selectedDateTime = dateTime.millisecondsSinceEpoch;
                        dobController.text = timestampToDateFormat(selectedDateTime, "dd MMM, yyyy");
                      });
                      widget.user!.dateOfBirth = selectedDateTime;
                    }
                  },
                  child: CustomInputField(
                    textStyle: TextStyle(
                      color: Colors.black,
                        fontSize: 16.sp
                    ),
                    controller: dobController,
                    keyboardType: TextInputType.none,
                    text: timestampToDateFormat(widget.user!.dateOfBirth, "dd MMM, yyyy"),
                    showBorder: false,
                    fillColor: Color(0xFFD6D6D6),
                  ),
                )
              ],),
            )
        ],),),
      ),
    );
  }
}