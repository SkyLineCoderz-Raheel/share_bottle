import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/notification.dart' as noti;

import '../screens/screen_user_chating_screen.dart';

class ItemUserNotification extends StatelessWidget {
  noti.Notification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: appBoxShadow,
      ),
      child: ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.subtitle ?? ""),
        onTap: () {
          if (notification.type == "image"){
            return;
          }
          Get.to(ScreenUserChattingScreen(
            receiver: allUsersData[notification.refId] ?? initUser(),
          ));
        },
        leading: notification.type == "image" ? Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                notification.leading_image_url??""
              ),
              fit: BoxFit.cover
            )
          ),
        ) : null,
        trailing: notification.type == "image" ? null : Image(
          width: 15.sp,
          height: 15.sp,
          image: AssetImage("assets/images/notification_read_${notification.read}.png"),
        ),
      ),
    );
  }

  ItemUserNotification({
    required this.notification,
  });
}
