import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/views/layouts/item_user_profile.dart';
import 'package:share_bottle/widgets/my_button.dart';

class ScreenUserProfileOld extends StatefulWidget {
  ScreenUserProfileOld({Key? key}) : super(key: key);

  @override
  _ScreenUserProfileOldState createState() => _ScreenUserProfileOldState();
}

class _ScreenUserProfileOldState extends State<ScreenUserProfileOld> {
  double WIDTH = 1.w;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: Get.height*0.28,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(Get.width * 0.15),
                        )
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),

                                  padding: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey
                                  ),
                                  child:  Icon(Icons.arrow_back_ios,size: 14,color: Colors.white,),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                },
                                icon: Icon(Icons.more_vert_outlined,size: 24,color: Colors.white,),
                              ),
                            ],),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ListTile(
                                leading:  CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage("assets/images/img_profile.png"),
                                ),
                                title: Text("Monika Stuff",style: normal_h2Style_bold.copyWith(color: Colors.white),),
                                subtitle: Text("Journalist, beloggr ❤",style: normal_h4Style_bold.copyWith(color: Colors.white),),
                              ),
                              GestureDetector(
                                onTap: (){},
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(color: Colors.white,width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add,size:16,color: Colors.white,),
                                      Text(" Follow",style:normal_h2Style.copyWith(color: Colors.white))


                                    ],
                                  ),
                                ),
                              )


                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  CustomListviewBuilder(
                      itemBuilder: (BuildContext context, int index) =>
                          ItemUserProfile(),
                      itemCount: 10,
                      scrollDirection: CustomDirection.vertical)
                ],
              ),
            )
        ),
      ),
    );
  }
}