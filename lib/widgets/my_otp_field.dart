import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyOtpField extends StatefulWidget {
  MyOtpField({Key? key}) : super(key: key);

  @override
  _MyOtpFieldState createState() => _MyOtpFieldState();
}

class _MyOtpFieldState extends State<MyOtpField> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
      height: 45,
      width: 45,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      decoration: BoxDecoration(boxShadow: appBoxShadow, color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        onSaved: (pin1){},
        onChanged: (value){
          if (value.length==1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        showCursor: false,
        decoration: InputDecoration(
          hintText: '0',

          contentPadding:
          EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}