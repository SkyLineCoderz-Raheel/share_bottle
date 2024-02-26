import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/views/layouts/item_user_video_play.dart';

import '../../controllers/controller_story_player.dart';
import '../../helpers/helpers.dart';

class ScreenUserStoryView extends StatefulWidget {
  final int? index;
  List<Post> posts;
  bool isAdmin;


  @override
  _ScreenUserStoryViewState createState() => _ScreenUserStoryViewState();

  ScreenUserStoryView({
    this.index,
    required this.posts,
    required this.isAdmin,
  });
}

class _ScreenUserStoryViewState extends State<ScreenUserStoryView> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
          future: putAllController(widget.posts),
          builder: (context, controllersSnapshot) {
            print(controllersSnapshot.connectionState);
            if (controllersSnapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }

            return PageView.builder(
                itemCount: widget.posts.length,
                scrollDirection: Axis.vertical,
                controller: PageController(initialPage: widget.index ?? 0, keepPage: true, viewportFraction: 1),
                key: UniqueKey(),
                onPageChanged: (index){
                  String id = widget.posts[index].id;
                  widget.posts.forEach((element) {
                    Get.find<StoryPlayerController>(tag: element.id).pauseVideo();
                  });
                  Get.find<StoryPlayerController>(tag: id).playVideo();
                },
                itemBuilder: (context, index) {
                  print(index);
                  return ItemUserVideoPlay(post: widget.posts[index], key: UniqueKey(), controller: Get.find(tag: widget.posts[index].id), isAdmin: widget.isAdmin,);
                });
          }),
    );
  }

  Future<void> putAllController(List<Post> posts) async {
    await Future.forEach(posts, (Post element) async {
      print("putting");
      await Get.put<StoryPlayerController>(StoryPlayerController(video_url: element.media_url, id: element.id, isAdmin: widget.isAdmin), tag: element.id);
    });
  }
}
