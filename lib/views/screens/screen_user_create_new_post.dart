import 'dart:io';

import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';

import '../../helpers/helpers.dart';
import '../../widgets/my_button.dart';

class ScreenUserCreateNewPost extends StatefulWidget {
  File videoFile;
  int seconds;

  @override
  _ScreenUserCreateNewPostState createState() => _ScreenUserCreateNewPostState();

  ScreenUserCreateNewPost({
    required this.videoFile,
    required this.seconds,
  });
}

class _ScreenUserCreateNewPostState extends State<ScreenUserCreateNewPost> {
  var titleController = TextEditingController();
  late File thumbnail;
  var loading = false;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var acceptedTerms = false;

  @override
  void initState() {
    print(widget.videoFile.lengthSync());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
          title: Text("New Post"),
          centerTitle: true,
        ),
        body: CustomProgressWidget(
          loading: loading,
          text: "Uploading video",
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<File>(
                    future: getVideoThumbnail(widget.videoFile.path),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      thumbnail = snapshot.data!;

                      return Container(
                        height: 60.h,
                        width: Get.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(snapshot.data!),
                            ),
                            boxShadow: appBoxShadow),
                        child: Icon(
                          Icons.play_circle,
                          size: 40.sp,
                          color: Colors.white,
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        //Do something with the user input.
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Write description about post....',
                        fillColor: myFieldColor,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        value: acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            acceptedTerms = value!;
                          });
                        },
                        title: Text("I agree this video does not contain any kind of abusive or racism content. If I uploaded such video then there will be no tolerance for objectionable content or abusive users."),
                      ),
                      MyButton(
                        width: 65.w,
                        onPressed: acceptedTerms
                            ? () {
                                String title = titleController.text;
                                if (title.isEmpty) {
                                  Get.snackbar("Alert", "Description required", colorText: Colors.black, backgroundColor: Colors.white);
                                  return;
                                }
                                addPost();
                              }
                            : null,
                        text: 'Publish',
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addPost() async {
    int id = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      loading = true;
    });

    String url = await _uploadFile(widget.videoFile, "posts/$id/$id.mp4");
    String thumb_url = await _uploadFile(thumbnail, "posts/$id/thumbnail.png");
    if (url.isEmpty) {
      Get.snackbar("Error", "Something went wrong!");
      setState(() {
        loading = false;
      });
      return;
    }
    print(url);
    Post post = Post(
      id: id.toString(),
      user_id: uid,
      media_url: url,
      state_id: "",
      city_id: "",
      timestamp: id,
      video_sec: widget.seconds,
      description: titleController.text,
      thumbnail: thumb_url,
    );
    await postsRef.doc(id.toString()).set(post.toMap());
    Get.offAll(ScreenUserHomePage());
  }

  Future<String> _uploadFile(File file, String path) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    final UploadTask uploadTask = storageReference.putFile(file);

    uploadTask.snapshotEvents.listen((event) {}).onError((error) {
      // do something to handle error
      Get.snackbar("Error", error.toString());
    });

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }
}
