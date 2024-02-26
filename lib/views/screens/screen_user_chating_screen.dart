import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_bottle/widgets/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/models/message.dart';
import 'package:share_bottle/models/notification.dart' as notificationModel;
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/widgets/post_bubble_normal.dart';
import 'package:sizer/sizer.dart';

import '../../helpers/helpers.dart';
import '../../models/post.dart';

class ScreenUserChattingScreen extends StatefulWidget {
  Post? post;
  User receiver;

  @override
  _ScreenUserChattingScreenState createState() => _ScreenUserChattingScreenState();

  ScreenUserChattingScreen({
    this.post,
    required this.receiver,
  });
}

class _ScreenUserChattingScreenState extends State<ScreenUserChattingScreen> {
  String uid = auth.FirebaseAuth.instance.currentUser!.uid;
  User sender = initUser();
  User receiver = initUser();

  var controller = TextEditingController();

  @override
  void initState() {
    sender = allUsersData[uid] ?? initUser();
    receiver = widget.receiver;
    readNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10.h,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          automaticallyImplyLeading: false,
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
          actions: [
            Container(
              margin: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(getImageByIndex(widget.receiver.image_index)),
              ),
            ),
          ],
          title: Text(widget.receiver.username),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: usersRef.doc(uid).collection("chats").doc(widget.receiver.id).collection("messages").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    var messages = snapshot.data!.docs.map((e) => Message.fromMap(e.data() as Map<String, dynamic>)).toList();

                    return messages.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                final message = messages[index];
                                bool isSender =  message.sender_id == sender.id;
                                final type = message.message_type;
                                return type == "text" ? BubbleNormal(
                                  text: message.text,
                                  isSender: isSender,
                                  color: isSender ? Colors.blue : Colors.grey.withOpacity(.3),
                                  textStyle: TextStyle(color: isSender ? Colors.white : Colors.black),
                                ) : PostBubbleNormal(
                                  text: message.text,
                                  isSender: isSender,
                                  color: isSender ? Colors.blue : Colors.grey.withOpacity(.3),
                                  textStyle: TextStyle(color: isSender ? Colors.white : Colors.black),
                                  post_id: message.post_id??"",
                                );
                              },
                            ),
                        )
                        : NotFound(
                            imageHeight: 60,
                            message: 'No messages yet',
                          );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: (this.widget.post == null ? 10.5 : 17.5).h,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: appBoxShadow,
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (this.widget.post != null)
                            Container(
                              child: ListTile(
                                title: Text(
                                  this.widget.post!.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text("Replying to post"),
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            this.widget.post!.thumbnail,
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              ),
                            ),
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Type here....',
                              fillColor: fillColor,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      // flex: 2,
                      child: Container(
                        // decoration: BoxDecoration(
                        //     color: fillColor,
                        //     shape: BoxShape.rectangle,
                        //     borderRadius: BorderRadius.circular(10)
                        // ),
                        child: Row(
                          children: [
                            // IconButton(onPressed: () {}, icon: Icon(Icons.attach_file)),
                            IconButton(
                                onPressed: () {
                                  String text = controller.text;
                                  if (text.isNotEmpty) {
                                    int id = DateTime.now().millisecondsSinceEpoch;
                                    Message newMessage = Message(
                                      id: id.toString(),
                                      timestamp: id,
                                      text: text,
                                      sender_id: sender.id,
                                      receiver_id: receiver.id,
                                      post_id: widget.post?.id,
                                      message_type: widget.post == null ? "text" : "post_reply",
                                    );
                                    sendMessage(newMessage);

                                    if (this.widget.post != null) {
                                      setState(() {
                                        this.widget.post = null;
                                      });
                                    }
                                    controller.clear();
                                  }
                                },
                                icon: Icon(Icons.send_rounded)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage(Message newMessage) async {
    await usersRef
        .doc("${sender.id}/chats/${receiver.id}")
        .set({"timestamp": newMessage.timestamp, "last_message": "Me: ${newMessage.text}", "receiver_id": receiver.id}).then((value) {
      setState(() {
        controller.text = "";
      });
      usersRef.doc("${sender.id}/chats/${receiver.id}/messages/${newMessage.id}").set(newMessage.toMap()).then((value) {});

      usersRef
          .doc("${receiver.id}/chats/${sender.id}")
          .set({"timestamp": newMessage.timestamp, "last_message": newMessage.text, "receiver_id": sender.id}).then((value) {
        usersRef.doc("${receiver.id}/chats/${sender.id}/messages/${newMessage.id}").set(newMessage.toMap());
      });
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });

    var notification = notificationModel.Notification(
      id: sender.id,
      title: "${sender.username}",
      subtitle: newMessage.text,
      type: "chat",
      refId: sender.id,
      read: false,
      timestamp: newMessage.timestamp,
      data: {"username": sender.username, "image": newMessage.imageUrl},
      leading_image_url: getImageByIndex(sender.image_index),
    );
    usersRef.doc(receiver.id).collection("notifications").doc(notification.id).set(notification.toMap());
  }

  void readNotification(){
    usersRef.doc(uid).collection("notifications").doc(receiver.id).update({"read":true});
  }
}
