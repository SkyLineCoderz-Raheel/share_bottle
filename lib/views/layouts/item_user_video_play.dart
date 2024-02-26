import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/controllers/controller_story_player.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/post.dart';

import '../screens/screen_user_chating_screen.dart';

class ItemUserVideoPlay extends StatefulWidget {
  Post post;
  Key key;
  StoryPlayerController controller;
  bool isAdmin;

  @override
  State<ItemUserVideoPlay> createState() => _ItemUserVideoPlayState();

  ItemUserVideoPlay({
    required this.post,
    required this.key,
    required this.controller,
    required this.isAdmin,
  });
}

class _ItemUserVideoPlayState extends State<ItemUserVideoPlay> {
  bool isFav = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    print(widget.post.state_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: widget.controller.initializeVideoPlayer(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Container(
                      height: Get.height,
                      width: Get.width,
                      child: CustomVideoPlayer(
                        customVideoPlayerController: widget.controller.customVideoPlayerController,
                      ),
                    ),
                    Positioned(
                        right: 20,
                        bottom: 30.h,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black.withOpacity(.7), borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(getImageByIndex((allUsersData[widget.post.user_id] ?? initUser()).image_index)),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Obx(() {
                                      return IconButton(
                                        onPressed: () {
                                          widget.controller.updateLikes();
                                        },
                                        icon: Image(
                                          image: AssetImage("assets/images/heart_${widget.controller.isFav.value}.png"),
                                          fit: BoxFit.contain,
                                          color: widget.controller.isFav == false ? Colors.white : null,
                                          height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                                        ),
                                      );
                                    }),
                                    Obx(() {
                                      return Text(
                                        "${widget.controller.likes.value}",
                                        style: normal_h3Style_bold.copyWith(color: Colors.white),
                                      );
                                    })
                                  ],
                                ),
                              ),
                              if (widget.post.user_id != uid && widget.isAdmin == false)
                                Container(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.to(ScreenUserChattingScreen(
                                            post: widget.post,
                                            receiver: allUsersData[widget.post.user_id] ?? initUser(),
                                          ));
                                        },
                                        icon: Image(
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                                          image: AssetImage(
                                            "assets/images/icon_message.png",
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Request",
                                        style: normal_h4Style_bold.copyWith(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              // Container(
                              //   child: Column(
                              //     children: [
                              //       IconButton(
                              //         onPressed: () {
                              //           Get.to(ScreenUserChattingScreen(
                              //             post: post,
                              //           ));
                              //         },
                              //         icon: Image(
                              //           color: Colors.white,
                              //           fit: BoxFit.contain,
                              //           height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.02,
                              //           image: AssetImage("assets/images/icon_share.png"),
                              //         ),
                              //       ),
                              //       Text(
                              //         "Share",
                              //         style: normal_h3Style_bold.copyWith(color: Colors.white),
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        )),
                      Positioned(
                        width: Get.width,
                        child: Column(
                          children: [
                            if (widget.post.state_id != "")
                              Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black.withOpacity(.7)),
                              child: ListTile(
                                title: Text(
                                  "${widget.post.city_id}, ${usStatesMap[widget.post.state_id.toUpperCase()] ?? " "}",
                                  style: normal_h3Style_bold.copyWith(color: Colors.white),
                                ),
                                leading: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ListTile(title: Text(widget.post.description, style: TextStyle(
                              color: Colors.white
                            ),),)
                          ],
                        ),
                        bottom: 7.h,
                        left: 0,
                      ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
