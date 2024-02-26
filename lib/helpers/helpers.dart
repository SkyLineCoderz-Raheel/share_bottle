import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_number/phone_number.dart';
import 'package:share_bottle/enums/location_status.dart';
import 'package:share_bottle/extensions/extensions.dart';
import 'package:share_bottle/interfaces/likes_listener.dart';
import 'package:share_bottle/models/message_dummy.dart';
import 'package:share_bottle/models/post.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/username_gen/generator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/report.dart';

Color appColor = Color(0xFF000000);
Color fillColor = Color(0xFFF6F6F6);
Color myFieldColor = Color(0xFFC4C4C4);
List<String> avatarsList = [];

var dbInstance = FirebaseFirestore.instance;
CollectionReference usersRef = dbInstance.collection("users");
CollectionReference postsRef = dbInstance.collection("posts");
CollectionReference reportedPostsRef = dbInstance.collection("reported_posts");
String googleAPIKey = "AIzaSyB2tfPVP5CVeqDZAtuMjzE_tz0K62Gb_LY";
const postMaxDays = 2;
var adminPostsRef = dbInstance.collection("admin_posts");
var adminNotiRef = dbInstance.collection("admin_notifications");
const usernameMaxDays = 7;
Map<String, User> allUsersData = Map();
var osVersion;
var osVersionDouble;

User initUser() {
  return User(
      id: "id",
      username: "loading...",
      country_code: "country_code",
      phone: "phone",
      dateOfBirth: generateDob(),
      image_index: -1,
      last_seen: 0,
      joining_time: 0,
      latitude: 30.9436351,
      longitude: 70.9375668,
      notificationToken: "",
      about: "about",
      username_last_update_time: 0,
      authType: "authType");
}

Post initPost() {
  return Post(
    id: "id",
    user_id: "user_id",
    media_url: "media_url",
    description: "Post Unavailable",
    thumbnail: "thumbnail",
    state_id: "",
    city_id: "",
    timestamp: 0,
    video_sec: 0,
  );
}

int generateDob() {
  var now = DateTime.now();
  return DateTime((now.year - 22), now.month, now.day).millisecondsSinceEpoch;
}

void initAvatars() {
  for (int i = 0; i <= 18; i++) {
    avatarsList.add("assets/images/avatar ($i).png");
  }
}

String generateRandomUsername() {
  var username = UsernameGen()
    ..setSeperator('_')
    ..setNames(["user"]);
  return username.generate();
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

double getDistance(double lat1, double lng1, double lat2, double lng2) {
  double metersAway = Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  // final kmAway = metersAway/1000;
  return roundDouble(metersAway, 2);
}

Future<bool> isPhoneValid(String phone, String countryCode) async {
  return true;
  PhoneNumberUtil plugin = PhoneNumberUtil();
  return await plugin.validate(phone, countryCode.replaceAll("+", ""));
}

Future<LocationStatus> checkPermissionStatus() async {
  var status = await Permission.location.status;

  if (status != PermissionStatus.granted) {
    print(status);
    var requestStatus = await Permission.location.request();
    if (requestStatus == PermissionStatus.granted) {
      return await enableLocationService();
    } else {
      return LocationStatus.AccessDenied;
    }
  } else {
    return await enableLocationService();
  }
}

Future<LocationStatus> enableLocationService() async {
  var location = loc.Location();
  bool enabled = await location.requestService();

  if (enabled) {
    var myPosition = await Geolocator.getCurrentPosition();
    usersRef.doc(auth.FirebaseAuth.instance.currentUser!.uid).update({
      "latitude": myPosition.latitude,
      "longitude": myPosition.longitude,
    });
  }

  return enabled ? LocationStatus.AccessGrantedAndLocationTurnedOn : LocationStatus.AccessGrantedAndLocationTurnedOff;
}

Future<File> getVideoThumbnail(String url) async {
  var thumbTempPath = await VideoThumbnail.thumbnailFile(
    video: url,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.JPEG,
    maxHeight: 1000,
    // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 100, // you can change the thumbnail quality here
  );
  return File(thumbTempPath!);
}

Future<User> getUserById(String uid) async {
  if (allUsersData.containsKey(uid)) {
    return allUsersData[uid]!;
  }
  var userDoc = await usersRef.doc(uid).get();
  User user = User.fromMap(userDoc.data() as Map<String, dynamic>);
  return user;
}

String getImageByIndex(int index) {
  return "assets/images/avatar ($index).png";
}

void getPostLikes(String id, LikesListener listener, bool isAdmin) {
  var ref = isAdmin ? adminPostsRef : postsRef;
  ref.doc(id).collection("likes").snapshots().listen((event) {
    List<String> likes = event.docs.map((e) => "${e.data()['uid']}").toList();
    listener.onPostLikes(likes);
  });
}

String getLastSeen(int timestamp) {
  DateTime old = DateTime.fromMillisecondsSinceEpoch(timestamp);
  DateTime current = DateTime.now();
  int minutes = current.difference(old).inMinutes;
  // print("Last seen mins: " + minutes.toString());
  if (minutes <= 10) {
    return "Online";
  } else {
    return convertTimeToText(timestamp, "ago");
  }
}

Future<String> generateUniqueUsername() async {
  String username = generateRandomUsername();
  print(username);
  String? response = await checkUsername(username);
  if (response != null) {
    return generateUniqueUsername();
  }
  return username;
}

Future<String?> checkUsername(String username) async {
  var docs = (await usersRef.get()).docs;
  bool exists = docs.where((element) => (element.data() as Map<String, dynamic>)['username'] == username).toList().isNotEmpty;
  return exists ? "Username already exists" : null;
}

Future<void> clearUserData(User user) async {
  String newUserName = await generateUniqueUsername();
  await usersRef.doc(user.id).update({"username": newUserName, "username_last_update_time": DateTime.now().millisecondsSinceEpoch});
  var chatUsers = await usersRef.doc(user.id).collection("chats").get();
  await Future.forEach(chatUsers.docs, (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    var userMessages = await element.reference.collection("messages").get();
    userMessages.docs.forEach((messageElement) {
      messageElement.reference.delete();
    });
    element.reference.delete();
  });
}


Map<String, String> usStatesMap = {
  "AL": "Alabama",
  "AK": "Alaska",
  // "AS": "American Samoa",
  "AZ": "Arizona",
  // "AR": "Arkansas",
  "CA": "California",
  "CO": "Colorado",
  // "CT": "Connecticut",
  "DE": "Delaware",
  "DC": "District Of Columbia",
  // "FM": "Federated States Of Micronesia",
  "FL": "Florida",
  "GA": "Georgia",
  "GU": "Guam",
  "HI": "Hawaii",
  "ID": "Idaho",
  "IL": "Illinois",
  // "IN": "Indiana",
  "IA": "Iowa",
  "KS": "Kansas",
  "KY": "Kentucky",
  // "LA": "Louisiana",
  "ME": "Maine",
  // "MH": "Marshall Islands",
  "MD": "Maryland",
  "MA": "Massachusetts",
  "MI": "Michigan",
  "MN": "Minnesota",
  "MS": "Mississippi",
  "MO": "Missouri",
  "MT": "Montana",
  "NE": "Nebraska",
  // "NV": "Nevada",
  "NH": "New Hampshire",
  "NJ": "New Jersey",
  "NM": "New Mexico",
  "NY": "New York",
  // "NC": "North Carolina",
  "ND": "North Dakota",
  // "MP": "Northern Mariana Islands",
  "OH": "Ohio",
  "OK": "Oklahoma",
  "OR": "Oregon",
  // "PW": "Palau",
  "PA": "Pennsylvania",
  // "PR": "Puerto Rico",
  // "RI": "Rhode Island",
  // "SC": "South Carolina",
  "SD": "South Dakota",
  "TN": "Tennessee",
  "TX": "Texas",
  // "UT": "Utah",
  "VT": "Vermont",
  "VI": "Virgin Islands",
  "VA": "Virginia",
  "WA": "Washington",
  "WV": "West Virginia",
  "WI": "Wisconsin",
  // "WY": "Wyoming"
};

void checkOsVersion(){
  osVersion = Platform.operatingSystemVersion;
  osVersionDouble = osVersion.toString().substring(8, 12).trim();
}

Future<Map<String, dynamic>> getBlockedPostsAndUsers(String uid) async {
  var postsDoc = (await reportedPostsRef.get());
  List<Report> reports = [];
  List<String> blockedUsers = [];
  if (postsDoc.docs.isNotEmpty) {
    reports = postsDoc.docs.map((e) => Report.fromMap(e.data() as Map<String, dynamic>)).toList();
    reports.removeWhere((element) => element.reporter_id != uid);
  }
  var blockedUsersDoc = await usersRef.doc(uid).collection("blocked_users").get();
  if (blockedUsersDoc.docs.isNotEmpty) {
    blockedUsers = blockedUsersDoc.docs.map((e) => e.data()['id'].toString()).toList();
  }

  Map<String, dynamic> result = {};
  result['blockedUsers'] = blockedUsers;
  result['reports'] = reports;

  return result;
}
