import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:share_bottle/extensions/extensions.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/interfaces/likes_listener.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/models/report.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/screens/screen_user_chating_screen.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';
import 'package:share_bottle/views/screens/screen_user_profile.dart';
import 'package:share_bottle/views/screens/screen_user_video_view.dart';

class ItemUserFeedPost extends StatefulWidget {
  bool? showHeart;
  Post post;

  @override
  _ItemUserFeedPostState createState() => _ItemUserFeedPostState();

  ItemUserFeedPost({
    this.showHeart,
    required this.post,
  });
}

class _ItemUserFeedPostState extends State<ItemUserFeedPost> implements LikesListener {
  bool isFav = false;
  String uid = auth.FirebaseAuth.instance.currentUser!.uid;
  bool showRequest = true;
  int likesNum = 0;

  @override
  void initState() {
    if (widget.post.timestamp.daysFromNow > postMaxDays) {
      deleteContent();
    }
    getPostLikes(widget.post.id, this, false);
    setState(() {
      showRequest = widget.post.user_id != uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getUserById(widget.post.user_id),
        builder: (context, userSnapshot) {
          User user = userSnapshot.data ?? initUser();

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Get.to(ScreenUserProfile(
                        uid: widget.post.user_id,
                      ));
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(getImageByIndex(user.image_index)),
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.username,
                        style: normal_h3Style,
                      ),
                    ],
                  ),
                  subtitle: Text(timestampToDateFormat(widget.post.timestamp, "dd MMM, hh:mm a")),
                  trailing: widget.post.user_id == uid
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showIosDialog(
                                context: context,
                                title: "Delete Post",
                                message: "Are you sure to delete this video?",
                                onConfirm: () {
                                  Get.back();
                                  deleteContent();
                                },
                                onCancel: () {
                                  Get.back();
                                },
                                confirmText: "Delete",
                                cancelText: "Cancel");
                          },
                        )
                      : PopupMenuButton<int>(
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<int>(
                              child: Text('Report Spam'),
                              value: 0,
                            ),
                            PopupMenuItem<int>(
                              child: Text('Block User'),
                              value: 1,
                            ),
                          ],
                          onSelected: (int? value) {
                            print(value);

                            if (value! == 0) {
                              Get.defaultDialog(
                                  title: "Report Spam",
                                  content: Text("The reported content will never be shown to you again. Are you sure to report this content?"),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel")),
                                    OutlinedButton(
                                        onPressed: ()  async {
                                          Get.back();
                                          var id = DateTime.now().millisecondsSinceEpoch.toString();
                                          var report = Report(id: id, reporter_id: uid, post_id: widget.post.id, timestamp: int.parse(id));
                                          await reportedPostsRef.doc(id).set(report.toMap()).then((value) {
                                            setState(() {});
                                          });
                                          Get.offAll(ScreenUserHomePage());
                                        },
                                        child: Text("Report Spam")),
                                  ]);
                            } else {
                              Get.defaultDialog(
                                  title: "Block ${user.username}",
                                  content: Text("Any content shared by this user will never appear to you again. Are you sure to report this User?"),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel")),
                                    OutlinedButton(
                                        onPressed: () async {
                                          Get.back();
                                          await usersRef.doc(uid).collection("blocked_users").doc(user.id).set({"id": user.id}).then((value) {
                                            setState(() {});
                                          });
                                          Get.offAll(ScreenUserHomePage());
                                        },
                                        child: Text("Block")),
                                  ]);
                            }
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: ExpandableText(
                    widget.post.description.trim(),
                    trimLines: 3,
                    widgetTextStyle: normal_h3Style.copyWith(color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(ScreenUserVideoView(video_url: widget.post.media_url));
                  },
                  child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 5),
                    height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.5,
                    width: Get.width,
                    decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.post.thumbnail))),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(boxShadow: appBoxShadow),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.white,
                              size: 7.h,
                            ),
                          ),
                        ),
                        if (showRequest)
                          Positioned(
                              top: 0,
                              right: 4,
                              child: Container(
                                child: Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Get.to(
                                              ScreenUserChattingScreen(post: widget.post, receiver: allUsersData[widget.post.user_id] ?? initUser()));
                                        },
                                        icon: Image(
                                          image: AssetImage('assets/images/icon_request.png'),
                                        )),
                                    Text(
                                      "Request",
                                      style: normal_h4Style_bold.copyWith(color: Colors.white),
                                    )
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isFav) {
                            postsRef.doc(widget.post.id).collection("likes").doc(uid).delete();
                          } else {
                            postsRef.doc(widget.post.id).collection("likes").doc(uid).set({"uid": uid});
                          }
                        },
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage("assets/images/heart_$isFav.png"),
                              fit: BoxFit.contain,
                              height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                            ),
                            Text("$likesNum")
                          ],
                        ),
                      ),
                      if (showRequest)
                        IconButton(
                          onPressed: () {
                            Get.to(ScreenUserChattingScreen(post: widget.post, receiver: allUsersData[widget.post.user_id] ?? initUser()));
                          },
                          icon: Image(
                            fit: BoxFit.contain,
                            height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                            image: AssetImage(
                              "assets/images/icon_message.png",
                            ),
                          ),
                        ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Image(
                      //     fit: BoxFit.contain,
                      //     height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.02,
                      //     image: AssetImage("assets/images/icon_share.png"),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> deleteContent() async {
    FirebaseStorage.instance.ref("posts/${widget.post.id}/${widget.post.id}.mp4").delete().then((value) {
      print("deleted");
    });
    FirebaseStorage.instance.ref("posts/${widget.post.id}/thumbnail.png").delete().then((value) {
      print("deleted");
    });
    (await postsRef.doc(widget.post.id).collection("likes").get()).docs.forEach((element) {
      element.reference.delete();
    });
    postsRef.doc(widget.post.id).delete();
  }

  @override
  void onPostLikes(List<String> likes) {
    if (mounted) {
      setState(() {
        isFav = likes.contains(uid);
        likesNum = likes.length;
      });
    }
  }
}
