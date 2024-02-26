import 'package:country_code_picker/country_code_picker.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/views/screens/screen_user_otp_verification.dart';

import '../../widgets/my_button.dart';
import '../../widgets/my_input_field.dart';

class ScreenUserSignUp extends StatefulWidget {
  ScreenUserSignUp({Key? key}) : super(key: key);

  @override
  _ScreenUserSignUpState createState() => _ScreenUserSignUpState();
}

class _ScreenUserSignUpState extends State<ScreenUserSignUp> {
  bool _check = false;

  var phoneController = TextEditingController();
  var countryCode = "+1";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: Get.width * 0.08,
          title: Text("SignUp"),
          leading: IconButton(
            padding: EdgeInsets.only(left: 15),
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Phone Verification",
                  style: heading2_style.copyWith(color: appPrimaryColor),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Add your phone number we will send you a "
                  " verification codes we know you’r real.",
                  style: normal_h3Style,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 80.w,
                        child: MyInputField(
                          hint: "Phone",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          prefix: CountryCodePicker(
                            initialSelection: "US",
                            onChanged: (value) {
                              countryCode = value.dialCode.toString();
                            },
                          ),
                        )),
                    CustomCheckboxListTile(
                        title: Text.rich(TextSpan(
                            text: "Agree with ",
                            children: [
                              TextSpan(
                                text: " Terms and Conditions",
                                style: TextStyle(fontWeight: FontWeight.w800, color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = () => nextScreen(),
                              ),
                            ],
                            style: normal_h3Style)),
                        fillColor: Colors.black,
                        checkColor: Colors.white,
                        value: _check,
                        rightCheck: false),
                    SizedBox(
                      height: 3.h,
                    ),
                    MyButton(
                      width: 65.w,
                      onPressed: () async {
                        var user = initUser();
                        String phone = phoneController.text;
                        if (phone.isEmpty) {
                          Get.snackbar("Alert", "Phone required");
                          return;
                        }
                        bool valid = await isPhoneValid(phone, countryCode);
                        if (!valid){
                          Get.snackbar("Error", "Invalid Phone entered");
                          return;
                        }

                        Get.to(ScreenUserOtpVerification(
                            user: user.copyWith(
                          phone: phone,
                          country_code: countryCode,
                          authType: "phone",
                        )));
                      },
                      text: 'Send OTP',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void nextScreen() {
    Get.to(ScreenUserSignUp());
  }
}
