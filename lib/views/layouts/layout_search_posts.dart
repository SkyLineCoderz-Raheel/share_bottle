import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_bottle/extensions/extensions.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/models/report.dart';
import 'package:share_bottle/views/layouts/item_user_feed_post.dart';

import '../../enums/location_status.dart';

class LayoutSearchPosts extends StatefulWidget {
  double radius;
  String searchString;

  @override
  State<LayoutSearchPosts> createState() => _LayoutSearchPostsState();

  LayoutSearchPosts({
    required this.radius,
    required this.searchString,
  });
}

class _LayoutSearchPostsState extends State<LayoutSearchPosts> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationStatus>(
        future: checkPermissionStatus(),
        builder: (context, permissionSnapshot) {
          if (!permissionSnapshot.hasData || permissionSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          var locationStatus = permissionSnapshot.data!;
          print(locationStatus);

          if (locationStatus != LocationStatus.AccessGrantedAndLocationTurnedOn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Share Loko requires location to get nearby results!",
                    style: normal_h3Style,
                  ),
                  CustomButton(
                      onPressed: () {
                        if (locationStatus == LocationStatus.AccessDenied) {
                          AppSettings.openLocationSettings(asAnotherTask: true);
                        } else if (locationStatus == LocationStatus.AccessGrantedAndLocationTurnedOff) {
                          setState(() {});
                        }
                      },
                      text: "Provide Access")
                ],
              ),
            );
          }

          return FutureBuilder<Position>(
              future: Geolocator.getCurrentPosition(),
              builder: (context, futureSnapshot) {
                if (!futureSnapshot.hasData || futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }

                var myLocationPosition = futureSnapshot.data!;
                print(myLocationPosition);

                return FutureBuilder<Map<String, dynamic>>(
                    future: getBlockedPostsAndUsers(uid),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      List<Report> reports = futureSnapshot.data!['reports'] ?? [];
                      List<String> blockedUsers = futureSnapshot.data!['blockedUsers'] ?? [];

                      return StreamBuilder<QuerySnapshot>(
                          stream: postsRef.snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator.adaptive());
                            }

                            var posts = snapshot.data!.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList();

                            posts = posts.where((element) {
                              var user = allUsersData[element.user_id] ?? initUser();
                              double distance =
                                  getDistance(myLocationPosition.latitude, myLocationPosition.longitude, user.latitude ?? 0, user.longitude ?? 0);
                              return distance.toMiles() <= widget.radius;
                            }).toList();

                            posts.removeWhere((element) {
                              if (reports.where((report) => report.post_id == element.id).toList().isNotEmpty) {
                                return true;
                              } else if (blockedUsers.where((blocked_uid) => element.user_id == blocked_uid).toList().isNotEmpty) {
                                return true;
                              } else {
                                return false;
                              }
                            });

                            if (widget.searchString.isNotEmpty) {
                              posts =
                                  posts.where((element) => element.description.toLowerCase().contains(widget.searchString.toLowerCase())).toList();
                            }

                            return posts.isNotEmpty
                                ? CustomListviewBuilder(
                                    itemBuilder: (BuildContext context, int index) => ItemUserFeedPost(post: posts[index]),
                                    itemCount: posts.length,
                                    scrollDirection: CustomDirection.vertical)
                                : NotFound(message: "No posts in this radius");
                          });
                    });
              });
        });
  }

}
