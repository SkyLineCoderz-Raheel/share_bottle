import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/message_dummy.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/layouts/item_user_chat.dart';
import 'package:share_bottle/views/layouts/item_user_online_chat.dart';

class LayoutUserChat extends StatefulWidget {
  LayoutUserChat({Key? key}) : super(key: key);

  @override
  _LayoutUserChatState createState() => _LayoutUserChatState();
}

class _LayoutUserChatState extends State<LayoutUserChat> {
  String uid = auth.FirebaseAuth.instance.currentUser!.uid;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Chats",
          style: heading1_style.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        fillColor: Colors.transparent,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: usersRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        var users = snapshot.data!.docs.map((e) => User.fromMap(e.data() as Map<String, dynamic>)).toList();

                        users = users.where((element) => (getLastSeen(element.last_seen) == "Online" && element.id != uid)).toList();

                        return users.isNotEmpty
                            ? CustomListviewBuilder(
                                itemBuilder: (BuildContext context, int index) => ItemUserOnlineChat(
                                      user: users[index],
                                    ),
                                itemCount: users.length,
                                scrollDirection: CustomDirection.horizontal)
                            : SizedBox();
                      }),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: usersRef.doc(uid).collection("chats").orderBy("timestamp", descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  var dummies = snapshot.data!.docs.map((e) => MessageDummy.fromMap(e.data() as Map<String, dynamic>)).toList();

                  if (searchQuery.isNotEmpty) {
                    dummies = dummies
                        .where((element) => (element.last_message.contains(searchQuery) ||
                            (allUsersData[element.receiver_id] ?? initUser()).username.contains(searchQuery)))
                        .toList();
                  }

                  return dummies.isNotEmpty
                      ? CustomListviewBuilder(
                          itemBuilder: (BuildContext context, int index) => ItemUserChat(
                                dummy: dummies[index],
                              ),
                          itemCount: dummies.length,
                          scrollDirection: CustomDirection.vertical)
                      : Container(
                      height: Get.height * .5,
                      child: NotFound(message: "No chats", imageHeight: 60,));
                }),
          ],
        ),
      ),
    );
  }
}
