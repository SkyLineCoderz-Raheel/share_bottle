import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ItemUserProfile extends StatefulWidget {
  ItemUserProfile({Key? key}) : super(key: key);

  @override
  _ItemUserProfileState createState() => _ItemUserProfileState();
}

class _ItemUserProfileState extends State<ItemUserProfile> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/img_profile.png"),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "James Rock",
                  style: normal_h3Style,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 3),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Follow",
                    style: normal_h4Style,
                  ),
                )
              ],
            ),
            subtitle: Text("02:03 AM"),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                size: 26,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.5,
            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/img_bottle.png"))),
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    right: 4,
                    child: Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Image(
                                image: AssetImage('assets/images/icon_request.png'),
                              )),
                          Text(
                            "Request",
                            style: normal_h4Style_bold.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isFav = false;
                  });
                },
                icon: Image(
                  image: AssetImage(isFav ? "assets/images/heart_false.png" : "assets/images/img_heart.png"),
                  fit: BoxFit.contain,
                  height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  fit: BoxFit.contain,
                  height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
                  image: AssetImage(
                    "assets/images/icon_message.png",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  fit: BoxFit.contain,
                  height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.02,
                  image: AssetImage("assets/images/icon_share.png"),
                ),
              ),
            ],
          ),
          Divider(height: 5,color: Colors.grey,thickness: 1,),

        ],
      ),
    );
  }
}
