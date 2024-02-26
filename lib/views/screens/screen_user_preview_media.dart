import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart' as appinio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:share_bottle/views/screens/screen_user_create_new_post.dart';

class ScreenUserPreviewMedia extends StatefulWidget {
  bool image;
  String path;

  @override
  _ScreenUserPreviewMediaState createState() => _ScreenUserPreviewMediaState();

  ScreenUserPreviewMedia({
    required this.image,
    required this.path,
  });
}

class _ScreenUserPreviewMediaState extends State<ScreenUserPreviewMedia> {
  appinio.VideoPlayerController? videoPlayerController;
  appinio.CustomVideoPlayerController? customVideoPlayerController;
  int seconds = 0;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    print(widget.path);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
      customVideoPlayerController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Preview",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (!loaded) {
                  Get.snackbar("Alert", "Please wait while the video is loading");
                  return;
                }
                Get.to(ScreenUserCreateNewPost(videoFile: File(widget.path), seconds: seconds));
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<void>(
            future: initializeVideoPlayer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                seconds = videoPlayerController!.value.duration.inSeconds;
                loaded = true;
                videoPlayerController!.play();
                return Container(
                  height: Get.height,
                  width: Get.width,
                  child: appinio.CustomVideoPlayer(
                    customVideoPlayerController: appinio.CustomVideoPlayerController(
                      context: context,
                      videoPlayerController: videoPlayerController!,
                      customVideoPlayerSettings: appinio.CustomVideoPlayerSettings(
                          customVideoPlayerProgressBarSettings:
                              appinio.CustomVideoPlayerProgressBarSettings(allowScrubbing: true, showProgressBar: true),
                          showPlayButton: true,
                          showFullscreenButton: true,
                          controlBarAvailable: true),
                    ),
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
      ) /**/
      ,
    );
  }

  Future<void> initializeVideoPlayer() async {
    print(widget.path);
    videoPlayerController = await appinio.VideoPlayerController.file(File(this.widget.path));
    customVideoPlayerController = await appinio.CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController!,
    );
    await videoPlayerController!.initialize();
  }
}
