import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_bottle/enums/location_status.dart';
import 'package:share_bottle/extensions/extensions.dart';
import 'package:share_bottle/helpers/helpers.dart';

import '../../models/user.dart' as model;

class LayoutSearchMap extends StatefulWidget {
  double radius;
  double? lat, lng;

  @override
  _LayoutSearchMapState createState() => _LayoutSearchMapState();

  LayoutSearchMap({required this.radius, this.lat, this.lng});
}

class _LayoutSearchMapState extends State<LayoutSearchMap> {
  GoogleMapController? googleMapController;

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    googleMapController = controller;
  }

  @override
  void initState() {
    addMarkers();
    super.initState();
  }

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

              return StreamBuilder<QuerySnapshot>(
                stream: usersRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }

                  var users = snapshot.data!.docs.map((e) => model.User.fromMap(e.data() as Map<String, dynamic>)).toList();
                  final radiusUsers = users.where((e) {
                    double metersAway =
                        Geolocator.distanceBetween(myLocationPosition.latitude, myLocationPosition.longitude, e.latitude ?? 0, e.longitude ?? 0);
                    return metersAway.toMiles() <= widget.radius;
                  }).toList();
                  print(radiusUsers.length);

                  Set<Marker> markers = radiusUsers
                      .map((e) => Marker(
                          markerId: MarkerId(e.id),
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: InfoWindow(
                              title: e.username,
                              snippet:
                                  "${getDistance(myLocationPosition.latitude, myLocationPosition.longitude, e.latitude ?? 0, e.longitude ?? 0)} m"),
                          position: LatLng(e.latitude ?? 0, e.longitude ?? 0)))
                      .toList()
                      .toSet();

                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      zoom: 18,
                      target: LatLng(
                        myLocationPosition.latitude,
                        myLocationPosition.longitude,
                      ),
                    ),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    markers: markers,
                  );
                },
              );
            },
          );
        });
  }

  void addMarkers() async {
    BitmapDescriptor? markerBitmap;

    await getBytesFromAsset("assets/images/Icon_location_marker.png", 100).then((onValue) {
      markerBitmap = BitmapDescriptor.fromBytes(onValue);
    });

    // var currentPosition = await Geolocator.getCurrentPosition();

    setState(() {});
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}
