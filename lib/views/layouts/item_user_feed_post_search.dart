import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/extensions/extensions.dart';
import 'package:share_bottle/interfaces/likes_listener.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/screens/screen_user_chating_screen.dart';
import 'package:share_bottle/views/screens/screen_user_profile.dart';
class ItemUserFeedPostSearch extends StatefulWidget {

  Post post;


  @override
  State<ItemUserFeedPostSearch> createState() => _ItemUserFeedPostSearchState();

  ItemUserFeedPostSearch({
    required this.post,
  });
}

class _ItemUserFeedPostSearchState extends State<ItemUserFeedPostSearch> implements LikesListener {
  bool isFav = false;
  String uid = auth.FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    if (widget.post.timestamp.daysFromNow > postMaxDays) {
      deleteContent();
    }
    getPostLikes(widget.post.id, this, false);
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
                      // Container(
                      //   margin: EdgeInsets.only(top: 5, left: 3, right: 3),
                      //   alignment: Alignment.bottomCenter,
                      //   padding: EdgeInsets.all(3),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     child: Text(
                      //       "Follow",
                      //       style: normal_h4Style,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  subtitle: Text(timestampToDateFormat(widget.post.timestamp, "dd MMM, hh:mm a")),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: ExpandableText(
                    widget.post.description,
                    trimLines: 3,
                    widgetTextStyle: normal_h3Style.copyWith(color: Colors.black),
                  ),
                ),
                Container(
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
                      Positioned(
                          top: 0,
                          right: 4,
                          child: Container(
                            child: Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.to(ScreenUserChattingScreen(
                                        post: widget.post, receiver: allUsersData[widget.post.user_id] ?? initUser()
                                      ));
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
                Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (isFav) {
                            postsRef.doc(widget.post.id).collection("likes").doc(uid).delete();
                          } else {
                            postsRef.doc(widget.post.id).collection("likes").doc(uid).set({"uid": uid});
                          }
                        },
                        icon: Image(
                          image: AssetImage("assets/images/heart_$isFav.png"),
                          fit: BoxFit.contain,
                          height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                        ),
                      ),
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
    FirebaseStorage.instance.refFromURL(widget.post.media_url).delete();
    FirebaseStorage.instance.refFromURL(widget.post.thumbnail).delete();
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
      });
    }
  }
}
