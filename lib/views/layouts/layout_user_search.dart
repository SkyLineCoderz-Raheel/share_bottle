import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_bottle/views/layouts/item_user_feed_post_search.dart';
import 'package:share_bottle/views/layouts/layout_search_map.dart';
import 'package:share_bottle/views/screens/screen_user_create_new_post.dart';
import 'package:sizer/sizer.dart';

import '../../helpers/helpers.dart';
import '../../widgets/my_input_field.dart';
import 'item_user_feed_post.dart';
import 'layout_search_posts.dart';

class LayoutUserSearch extends StatefulWidget {
  @override
  _LayoutUserSearchState createState() => _LayoutUserSearchState();
}

class _LayoutUserSearchState extends State<LayoutUserSearch> {
  double radius = 4;
  bool showPosts = true;
  int? sliding = 0;
  String searchString = "";


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 8,
                  right: 8,
                ),
                decoration:
                    BoxDecoration(color: Colors.white, boxShadow: appBoxShadow),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchString = value;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                hintText: 'Search',
                                fillColor: fillColor,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: CupertinoSlidingSegmentedControl(
                              onValueChanged: (int? value) {
                                setState(() {
                                  sliding = value;
                                  showPosts = !showPosts;
                                });
                              },
                              children: {
                                0: Icon(Icons.menu),
                                1: Icon(Icons.location_on)
                              },
                              groupValue: sliding,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("In Radius"),
                        Text("${radius.toString()}" " miles"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.black,
                            overlayColor: Colors.white,
                            thumbShape: RoundSliderThumbShape(
                                elevation: 2,
                                pressedElevation: 6,
                                enabledThumbRadius: 5.0),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 10),
                            thumbColor: Colors.black),
                        child: Slider(
                          value: radius.toDouble(),
                          min: 1,
                          max: 25,
                          onChanged: (double v) {
                            setState(() {
                              radius = v.roundToDouble();
                            });
                          },
                        )),
                  ],
                ),
              ),
              Expanded(
                child: showPosts
                    ? LayoutSearchPosts(radius: radius, searchString: searchString,)
                    : LayoutSearchMap(radius: radius),
              )
            ],
          )),
    );
  }
}
