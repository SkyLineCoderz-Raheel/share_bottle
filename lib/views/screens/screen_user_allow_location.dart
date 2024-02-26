import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker_advance/google_places_picker_advance.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/models/user.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';
import 'screen_user_map.dart';

import '../../widgets/my_button.dart';

class ScreenUserAllowLocation extends StatefulWidget {
 User user;

ScreenUserAllowLocation({required this.user});

  @override
  _ScreenUserAllowLocationState createState() =>
      _ScreenUserAllowLocationState();


}

class _ScreenUserAllowLocationState extends State<ScreenUserAllowLocation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Container(
             alignment: Alignment.center,
             margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
             height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.3,

             decoration: BoxDecoration(
                 image: DecorationImage(

                 fit: BoxFit.contain,
                 image: AssetImage("assets/images/img_share_location.png")
               )
             ),
           ),
              Text('Allow "Share Loko" to \n   use your location',style: normal_h1Style_bold,),
              SizedBox(height: Get.height*0.03,),
              Text('This app requires access to your',style: normal_h3Style,),
              Text('location to match with the nearest',style: normal_h3Style,),
              Text('Clubs!',style: normal_h3Style,),
              // Text('   This app requires access to your \n location to match with the nearest \n                       Clubs!',style: normal_h3Style,),
              SizedBox(height: Get.height*0.05,),
              MyButton(
                width: 60.w,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: googleAPIKey,   // Put YOUR OWN KEY here.
                        onPlacePicked: (result) {
                          Get.offAll(ScreenUserHomePage());
                          var lati=result.geometry!.location.lat;
                          var lngi=result.geometry!.location.lng;
                          usersRef.doc(widget.user.id).update({
                            "latitude":lati,
                            "longitude":lngi,
                          });
                        },
                        initialPosition: LatLng(0,0),
                        useCurrentLocation: true,
                      ),
                    ),
                  );
                },
                text: 'Allow',
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(215, 40),
                      maximumSize: const Size(215, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: Colors.black

                      )),
                  onPressed: () {
                    Get.to(ScreenUserMap());
                  },
                  child: Text('Allow while using app')),
              SizedBox(height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.03,
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(215, 40),
                      maximumSize: const Size(215, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: Colors.black

                      )),
                  onPressed: () {},
                  child: Text("Don't  Allow")),


            ],),
        ),
      ),
    );
  }
}