import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/extensions/extensions.dart';
import 'package:share_bottle/views/screens/screen_user_preview_media.dart';

import '../../main.dart';

class ScreenUserRecordVideo extends StatefulWidget {
  const ScreenUserRecordVideo({Key? key}) : super(key: key);

  @override
  _ScreenUserRecordVideoState createState() => _ScreenUserRecordVideoState();
}

class _ScreenUserRecordVideoState extends State<ScreenUserRecordVideo> with TickerProviderStateMixin {
  // // Notifiers
  // ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  // ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  // ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  // ValueNotifier<Size> _photoSize = ValueNotifier(Size(1920, 1080));
  // ValueNotifier<double> _zoom = ValueNotifier(1);
  // ValueNotifier<bool> _enableZooming = ValueNotifier(true);
  // ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  //
  // // Controllers
  // PictureController _pictureController = new PictureController();
  // VideoController _videoController = new VideoController();
  //
  String idle = "click", animating = "record", slow_animating = "record_alt";
  bool recording = false;
  int seconds = 0;
  double x = 0;
  double y = 0;
  bool flashOn = false;

  //
  String _lastVideoPath = "";

  late CameraController controller;

  bool showFocusCircle = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            GestureDetector(
              onTapUp: (details) {
                _onTap(details);
              },
              child: Container(
                height: Get.height,
                width: Get.width,
                child: CameraPreview(controller),
              ),
            ),
            Positioned(
              height: 10.h,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  color: Colors.black.withOpacity(.7),
                ),
                width: Get.width,
                padding: EdgeInsets.only(left: 10, right: 10, top: 1.h, bottom: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (recording) {
                          Get.snackbar("Alert", "Cannot swap camera during video recording");
                          return;
                        }
                        _toggleCameraLens();
                      },
                      icon: ImageIcon(
                        AssetImage("assets/images/icon_camera_simple.png"),
                      ),
                      iconSize: 4.h,
                      color: Colors.white,
                    ),
                    Container(
                      width: 22.w,
                      child: AutoSizeText(
                        "${seconds.toDuration}",
                        maxLines: 1,
                        style: heading3_style.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    _recordVideo();
                  },
                  child: Container(
                    height: 10.h,
                    width: 100,
                    alignment: Alignment.center,
                    child: FlareActor(
                      "assets/flare/video_recorder_flare.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: recording ? slow_animating : idle,
                    ),
                  ),
                ),
              ),
            ),
            if (showFocusCircle)
              Positioned.fill(
                  top: y - 50,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.filter_center_focus,
                        color: Colors.white,
                        size: 5.h,
                      ))),
            Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    if (flashOn) {
                      controller.setFlashMode(FlashMode.off).then((value) {
                        flashOn = false;
                        setState(() {});
                      });
                    } else {
                      controller.setFlashMode(FlashMode.torch).then((value) {
                        flashOn = true;
                        setState(() {});
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(.7)),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.flash_on,
                      color: flashOn ? Colors.yellow : Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _recordVideo() async {
    // lets just make our phone vibrate
    // HapticFeedback.mediumImpact();

    if (controller.value.isRecordingVideo) {
      XFile videoFile = await controller.stopVideoRecording();
      _lastVideoPath = videoFile.path;
      recording = false;
      setState(() {});
      if (_timer != null) {
        _timer?.cancel();
        seconds = 0;
      }

      final file = File(_lastVideoPath);
      print("----------------------------------");
      print("VIDEO RECORDED");
      print("==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
      print("----------------------------------");

      await Future.delayed(Duration(milliseconds: 300));
      Get.to(ScreenUserPreviewMedia(image: false, path: file.path));
    } else {
      // final Directory extDir = await getTemporaryDirectory();
      // final testDir =
      // await Directory('${extDir.path}/test').create(recursive: true);
      // final String filePath = '${testDir.path}/video_test.mp4';
      // await _videoController.recordVideo(filePath);

      await controller.prepareForVideoRecording();
      await controller.startVideoRecording();
      recording = true;
      seconds = 0;
      startTimer();
      setState(() {});
    }
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      setState(() {
        showFocusCircle = true;
      });
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await controller.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (seconds == 10) {
          timer.cancel();
          _recordVideo();
          return;
        }
        setState(() {
          seconds++;
        });
      },
    );
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  Future<void> _initCamera(CameraDescription description) async {
    controller = CameraController(description, ResolutionPreset.high, enableAudio: true);

    try {
      await controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
