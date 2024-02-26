import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:share_bottle/controllers/controller_user_registration_otp.dart';
import 'package:share_bottle/models/user.dart' as model;

import '../../widgets/my_button.dart';

class ScreenUserOtpVerification extends StatefulWidget {
  model.User user;

  @override
  _ScreenUserOtpVerificationState createState() => _ScreenUserOtpVerificationState();

  ScreenUserOtpVerification({
    required this.user,
  });
}

class _ScreenUserOtpVerificationState extends State<ScreenUserOtpVerification> {
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color(0xFF9FB8FF)),
      color: Color(0xFF9FB8FF),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  String _code = "";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerUserRegistrationOtp>(
        init: ControllerUserRegistrationOtp(newUser: widget.user),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: controller.otpLoading.isTrue ? Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Sending OTP  "),
                  CircularProgressIndicator.adaptive(),
                ],
              ),) : CustomProgressWidget(
                loading: controller.showLoading.value,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.25,
                          decoration: BoxDecoration(
                              // color: Colors.grey,
                              image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/img_otp.png'))),
                        ),
                        Text(
                          "Verification",
                          style: heading2_style.copyWith(color: appPrimaryColor),
                        ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        Text(
                          "Enter the OTP code sent to your phone ${controller.full_phone.value}",
                          style: normal_h2Style.copyWith(color: appPrimaryColor),
                        ),
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PinPut(
                                eachFieldConstraints: BoxConstraints(
                                    minHeight: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * 0.06,
                                    minWidth: Get.width * 0.12),
                                eachFieldPadding: EdgeInsets.all(5),
                                textStyle: normal_h1Style_bold,
                                keyboardType: TextInputType.number,
                                useNativeKeyboard: true,
                                onChanged: (value) {
                                  _code = value;
                                  controller
                                    ..isButtonEnabled.value = _code.length == 6
                                    ..update();
                                },
                                fieldsCount: 6,
                                onSubmit: (String pin) {},
                                focusNode: _pinPutFocusNode,
                                controller: controller.pinPutController.value,
                                submittedFieldDecoration: _pinPutDecoration.copyWith(
                                  color: Color(0xFF9FB8FF),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                cursorColor: Color(0xFF3368FF),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration: _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xFF9FB8FF),
                                  border: Border.all(
                                    color: Color(0xFF9FB8FF),
                                  ),
                                )),
                            SizedBox(
                              height: Get.height * 0.04,
                            ),
                            Text(
                              "Did not receive a code?",
                              style: normal_h2Style.copyWith(color: appPrimaryColor),
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Text(
                              "Resend",
                              style: normal_h1Style_bold.copyWith(color: appPrimaryColor),
                            ),
                            SizedBox(
                              height: Get.height * 0.04,
                            ),
                            MyButton(
                              width: 65.w,
                              onPressed: () {
                                controller.verifyPin(_code);
                              },
                              text: 'Done',
                            ),
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            Text("Change phone Number ?", style: TextStyle(fontSize: 14.sp, decoration: TextDecoration.underline, color: Colors.blue)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
