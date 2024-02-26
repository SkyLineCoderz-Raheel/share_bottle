import 'dart:io';

import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class ScreenFileUploading extends StatefulWidget {
  String uploadPath;
  File file;
  String? name;

  @override
  _ScreenFileUploadingState createState() => _ScreenFileUploadingState();

  ScreenFileUploading({required this.uploadPath, required this.file, this.name});
}

class _ScreenFileUploadingState extends State<ScreenFileUploading> {
  double progress = 0.0;
  String filename = "";
  UploadTask? uploadTask;

  @override
  void initState() {
    filename = widget.name ?? basename(widget.file.path);
    print(filename);
    _uploadFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uploading File"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              basename(widget.file.path).replaceAll("file_picker", "sharebottle").replaceAll("image_picker", "sharebottle"),
              style: normal_h3Style_bold.copyWith(color: appPrimaryColor),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "File Size",
                    style: normal_h3Style,
                  ),
                  Text(getFileSize(widget.file).toString() + " Mb"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerRight,
              child: Text(
                "${progress.toPrecision(2) * 100.0} / 100%",
                style: normal_h3Style,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toPrecision(2);
  }

  Future<String> _uploadFile() async {
    Reference storageReference = FirebaseStorage.instance.ref().child(widget.uploadPath).child(filename);
    uploadTask = storageReference.putFile(widget.file);

    uploadTask!.snapshotEvents.listen((event) {
      if (mounted) {
        setState(() {
          progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          print(progress);
        });
      }
    }).onError((error) {
      // do something to handle error
      Get.snackbar("Error", error.toString());
    });

    final TaskSnapshot downloadUrl = (await uploadTask!);
    String url = "";
    if (mounted) {
      url = await downloadUrl.ref.getDownloadURL();
      Get.back(result: url);
    }
    return url;
  }

  @override
  void dispose() {
    if (uploadTask != null) {
      uploadTask!.cancel();
    }
    super.dispose();
  }
}
