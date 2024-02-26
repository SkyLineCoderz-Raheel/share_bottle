import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/screens/screen_user_chating_screen.dart';

class ItemUserOnlineChat extends StatefulWidget {
  User user;

  @override
  _ItemUserOnlineChatState createState() => _ItemUserOnlineChatState();

  ItemUserOnlineChat({
    required this.user,
  });
}

class _ItemUserOnlineChatState extends State<ItemUserOnlineChat> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ScreenUserChattingScreen(receiver: widget.user));
      },
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.07,
              width: Get.width * 0.14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(fit: BoxFit.contain, image: AssetImage(getImageByIndex(widget.user.image_index))),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      margin: EdgeInsets.only(top: 5, left: 3),
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              )),
          Text(
            widget.user.username,
            style: normal_h5Style.copyWith(color: appPrimaryColor),
          )
        ],
      ),
    );
  }
}
