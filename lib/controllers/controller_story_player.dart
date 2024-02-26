import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:share_bottle/interfaces/likes_listener.dart';

import '../helpers/helpers.dart';

class StoryPlayerController extends GetxController implements LikesListener {
  VideoPlayerController? videoPlayerController;
  late CustomVideoPlayerController customVideoPlayerController;
  String video_url;
  String id;
  bool isAdmin;
  var isFav = false.obs;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool initialized = false;
  var likes = 0.obs;


  var customSettings = CustomVideoPlayerSettings(
      customVideoPlayerProgressBarSettings: CustomVideoPlayerProgressBarSettings(allowScrubbing: true, showProgressBar: true),
      showPlayButton: true,
      showFullscreenButton: false,
      playOnlyOnce: false,
      settingsButtonAvailable: false,
      controlBarAvailable: true);

  Future<void> initializeVideoPlayer(BuildContext context) async {
    if (videoPlayerController == null || !videoPlayerController!.value.isInitialized) {
      videoPlayerController = await VideoPlayerController.network(video_url);
      customVideoPlayerController = await CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController!,
        customVideoPlayerSettings: customSettings,
      );
      await videoPlayerController!.initialize();
      videoPlayerController!.play();
      initialized = true;
    }
  }

  StoryPlayerController({
    required this.video_url,
    required this.id,
    required this.isAdmin
  });

  @override
  void onPostLikes(List<String> likes) {
    isFav.value = likes.contains(uid);
    this.likes.value = likes.length;
  }

  @override
  void onInit() {
    getPostLikes(id, this, isAdmin);
    super.onInit();
  }

  void updateLikes() {

    var ref = isAdmin ? adminPostsRef : postsRef;

    if (isFav.value == true) {
      ref.doc(id).collection("likes").doc(uid).delete();
    } else {
      ref.doc(id).collection("likes").doc(uid).set({"uid": uid});
    }
  }

  void pauseVideo(){
    if (initialized){
      videoPlayerController!.pause();
    }
  }
  void playVideo(){
    if (initialized){
      videoPlayerController!.play();
    }
  }
}
