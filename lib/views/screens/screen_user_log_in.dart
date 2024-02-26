import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:apple_sign_in_safety/apple_sign_in.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_bottle/models/user.dart' as model;
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:share_bottle/helpers/helpers.dart';
import 'package:share_bottle/views/screens/screen_user_add_more_detail.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';
import 'package:share_bottle/views/screens/screen_user_otp_verification.dart';
import 'package:share_bottle/views/screens/screen_user_sign_up.dart';
import 'package:share_bottle/widgets/my_button.dart';
import 'package:share_bottle/widgets/my_input_field.dart';

class ScreenUserLogIn extends StatefulWidget {
  ScreenUserLogIn({Key? key}) : super(key: key);

  @override
  _ScreenUserLogInState createState() => _ScreenUserLogInState();
}

class _ScreenUserLogInState extends State<ScreenUserLogIn> {
  var phoneController = TextEditingController();
  var countryCode = "+1";
  model.User newUser = initUser();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Login",
            style: heading3_style.copyWith(color: appColor),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      AutoSizeText(
                        "Share Loko",
                        style: heading1_style.copyWith(color: Color(0xFF767676), fontFamily: 'Comfortaa'),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: (GetPlatform.isIOS ? 6 : 4).h,
                      ),
                      Text(
                        "Welcome Back!",
                        style: heading4_style.copyWith(color: Color(0xFF303030)),
                      ),
                      SizedBox(
                        height: (GetPlatform.isIOS ? 6 : 4).h,
                      ),

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
                      SizedBox(
                        height: (GetPlatform.isIOS ? 10 : 5).h,
                      ),
                      //
                      MyButton(
                        onPressed: () async {
                          var user = initUser();
                          String phone = phoneController.text;
                          if (phone.isEmpty) {
                            Get.snackbar("Alert", "Phone is required");
                            return;
                          }

                          if (!(await isPhoneValid(phone, countryCode))) {
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
                        text: 'Login',
                      ),
                      if (GetPlatform.isIOS && double.parse(osVersionDouble.toString()) > 13.0 )
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text("__________________ or __________________"),
                            ),
                            FutureBuilder<bool>(
                              future: AppleSignIn.isAvailable(),
                              builder: (context, snapshot) {


                                if (snapshot.connectionState == ConnectionState.waiting || (snapshot.data ?? false) == false){
                                  return SizedBox();
                                }


                                return MyButton(
                                  onPressed: () async {
                                    var appleUser = await signInWithApple();
                                    if (appleUser != null) {
                                      bool alreadyExists = await userAlreadyExists(appleUser.uid);
                                      if (alreadyExists) {
                                        Get.offAll(ScreenUserHomePage());
                                      } else {
                                        await completeRegistration(appleUser);
                                      }
                                    }
                                  },
                                  icon: ImageIcon(AssetImage("assets/images/icon_apple.png")),
                                  text: 'Sign in with Apple',
                                );
                              }
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  ),
                ),
              ),
              Text.rich(TextSpan(
                  text: "Don’t have an account ",
                  children: [
                    TextSpan(text: " |  "),
                    TextSpan(
                      text: "Signup",
                      style: TextStyle(fontWeight: FontWeight.w800),
                      recognizer: TapGestureRecognizer()..onTap = () => nextScreen(),
                    ),
                  ],
                  style: normal_h3Style)),
            ],
          ),
        ),
      ),
    );
  }

  void nextScreen() {
    Get.to(ScreenUserSignUp());
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    print("try");

    try {
      // Request credential for the currently signed in Apple account.
      print("Requesting credential for the currently signed in Apple account.");
      final AuthorizationResult appleResult = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);


      if (appleResult.error != null) {
        return null;
      }
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken: String.fromCharCodes(appleResult.credential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(appleResult.credential?.identityToken ?? []),
      );



      print(credential);

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      var _firebaseAuth = FirebaseAuth.instance;
      final authResult =
      await _firebaseAuth.signInWithCredential(credential);

      final displayName =
          '${appleResult.credential?.fullName}';
      final userEmail = '${appleResult.credential?.email}';

      final firebaseUser = authResult.user;
      print(displayName);
      await firebaseUser?.updateDisplayName(displayName);
      await firebaseUser?.updateEmail(userEmail);

      return firebaseUser;
    } catch (exception) {
      print(exception);
    }

    return null;
  }

  Future<bool> userAlreadyExists(String uid) async {
    final doc = await usersRef.doc(uid).get();
    return doc.exists;
  }

  Future<String> completeRegistration(User user) async {
    String response = "";

    newUser.id = user.uid;

    await setDatabase(newUser).then((value) {
      if (value == "success") {
        Get.to(ScreenUserAddMoreDetail(
            user: this.newUser
        ));
      }
    });


    return response;
  }

  Future<String> setDatabase(model.User user) async {
    String response = "";
    await usersRef.doc(user.id).set(user.toMap()).then((value) {
      response = "success";
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
      response = error;
    });

    return response;
  }
}
