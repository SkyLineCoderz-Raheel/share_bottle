import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_bottle/models/notification.dart' as noti;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/views/layouts/item_user_notification.dart';

class ScreenUserNotifications extends StatefulWidget {
  ScreenUserNotifications({Key? key}) : super(key: key);

  @override
  _ScreenUserNotificationsState createState() =>
      _ScreenUserNotificationsState();
}

class _ScreenUserNotificationsState extends State<ScreenUserNotifications> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,size: 18,color: Colors.black,),
          ),
          title: Text("Notifications"),
          centerTitle: true,
        ),
        body:
        StreamBuilder<QuerySnapshot>(
          stream: usersRef.doc(uid).collection("notifications").orderBy("timestamp", descending: true).snapshots(),
          builder: (context, snapshot) {

            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            var notifications = snapshot.data!.docs.map((e) => noti.Notification.fromMap(e.data() as Map<String, dynamic>)).toList();

            return notifications.isNotEmpty ? CustomListviewBuilder(
                itemBuilder: (BuildContext context, int index) =>
                    ItemUserNotification(notification: notifications[index]),
                itemCount: notifications.length,
                scrollDirection: CustomDirection.vertical) : NotFound(message: "No notifications");
          }
        ),
      ),
    );
  }
}