import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/views/screens/screen_user_story_view.dart';

class ItemAdminFeedStory extends StatefulWidget {

  @override
  _ItemAdminFeedStoryState createState() => _ItemAdminFeedStoryState();

}

class _ItemAdminFeedStoryState extends State<ItemAdminFeedStory> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.2
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.08,
                width: Get.width * 0.16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(fit: BoxFit.cover, image: AssetImage(getImageByIndex(0))),
                  ),
                )),
            AutoSizeText(
              "Top 10",
              style: normal_h3Style.copyWith(color: appPrimaryColor),
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
