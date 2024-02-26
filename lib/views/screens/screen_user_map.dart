import 'dart:async';
// import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ScreenUserMap extends StatefulWidget {
  @override
  State<ScreenUserMap> createState() => ScreenUserMapState();
}

class ScreenUserMapState extends State<ScreenUserMap> {

  GoogleMapController? _controller;

  LatLng _center = LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    _controller = controller;
    // _customInfoWindowController.googleMapController = controller;
  }

  // CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  Location currentLocation = Location();
  Set<Marker> _markers={};


  void getLocation() async{
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc){

      _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        ));
      });
    });
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition:CameraPosition(
              target: LatLng(48.8561, 2.2930),
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller){
              _controller = controller;
            },
            markers: _markers,

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching,color: Colors.white,),
        onPressed: (){
          getLocation();
        },
      ),
    );
  }
}
