import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/screens/screen_user_chating_screen.dart';

import '../../models/message_dummy.dart';

class ItemUserChat extends StatefulWidget {
  MessageDummy dummy;


  @override
  _ItemUserChatState createState() => _ItemUserChatState();

  ItemUserChat({
    required this.dummy,
  });
}

class _ItemUserChatState extends State<ItemUserChat> {

  late User receiver;
  @override
  void initState() {
    receiver = allUsersData[widget.dummy.receiver_id] ?? initUser();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        // onTap: (){Get.to(ScreenUserChattingScreen(receiver: allUsersData[widget.post.user_id] ?? initUser()));},
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(getImageByIndex(receiver.image_index)),
        ),
        title: Text(receiver.username,style: normal_h3Style,),
        subtitle: Text(widget.dummy.last_message),
        trailing:Text(timestampToDateFormat(widget.dummy.timestamp, "hh:mm a")),
        onTap: (){
          Get.to(ScreenUserChattingScreen(receiver: receiver));
        },
      ),
    );
  }
}