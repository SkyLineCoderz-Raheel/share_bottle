import 'package:appinio_video_player/appinio_video_player.dart' as appinio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class ScreenUserVideoView extends StatefulWidget {
  String video_url;

  @override
  State<ScreenUserVideoView> createState() => _ScreenUserVideoViewState();

  ScreenUserVideoView({
    required this.video_url,
  });
}

class _ScreenUserVideoViewState extends State<ScreenUserVideoView> {
  appinio.VideoPlayerController? videoPlayerController;
  appinio.CustomVideoPlayerController? customVideoPlayerController;

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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<void>(
            future: initializeVideoPlayer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }),
      ),
    );
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = await appinio.VideoPlayerController.network(widget.video_url);
    customVideoPlayerController = await appinio.CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController!,
    );
    await videoPlayerController!.initialize();
  }
}
