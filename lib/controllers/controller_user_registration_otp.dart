
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:share_bottle/models/user.dart' as model;
import 'package:share_bottle/views/screens/screen_user_add_more_detail.dart';
import 'package:share_bottle/views/screens/screen_user_home_page.dart';
import '../helpers/helpers.dart';

class ControllerUserRegistrationOtp extends GetxController {
  ControllerUserRegistrationOtp({required this.newUser});

  final pinPutController = TextEditingController().obs;
  final isButtonEnabled = false.obs;
  final _auth = FirebaseAuth.instance;
  final model.User newUser;
  String _verificationId = "";
  int _resendToken = 0;
  final showLoading = false.obs;
  var otpLoading = true.obs;
  var full_phone = "".obs;

  @override
  void onInit() {
    sendVerificationCode();
    super.onInit();
  }

  void verifyPin(String pin) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: pin);
    showLoading.value = true;
    try {
      await _auth.signInWithCredential(phoneAuthCredential).then((value) {
        return verificationCompleted(value);
      }).catchError((error){
        showLoading.value = false;
        showSnackBar(error.toString());
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(e.message.toString());
      showLoading.value = false;
    }
  }

  Future<void> verificationCompleted(UserCredential credential) async {
    otpLoading.value = false;
    showLoading.value = true;
    update();
    bool alreadyExists = await userAlreadyExists(credential.user!.uid);
    if (alreadyExists){
      Get.offAll(ScreenUserHomePage());
    } else {
      await completeRegistration(credential);
    }
  }

  Future<void> sendVerificationCode() async {
    full_phone.value = newUser.country_code + newUser.phone;
    print(full_phone);
    await _auth.verifyPhoneNumber(
      phoneNumber: (full_phone.value),
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        _auth.signInWithCredential(credential).then((value) {
          pinPutController.value.text = credential.smsCode ?? "";
          otpLoading.value = false;
          update();
          verificationCompleted(value);
        }).catchError((error) {
          showSnackBar(error.toString());
          print(error.toString());
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar(e.message.toString());
        print(e);
        Get.back();
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken ?? 0;
        otpLoading.value = false;
        update();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void showSnackBar(String message) {
    Get.snackbar("Alert", message);
  }

  Future<String> completeRegistration(UserCredential userCredential) async {
    String response = "";

    newUser.id = userCredential.user!.uid;

    await setDatabase(newUser).then((value) {
      if (value == "success") {
        Get.to(ScreenUserAddMoreDetail(
          user: this.newUser
        ));
      }
    });

    showLoading.value = false;
    update();

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

  Future<bool> userAlreadyExists(String uid) async {
    final doc = await usersRef.doc(uid).get();
    return doc.exists;
  }


}
