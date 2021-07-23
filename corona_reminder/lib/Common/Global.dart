import 'package:coronareminder/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


SharedPreferences AppPreferences;

Color themeLightBlue = Color.fromRGBO(0xD7, 0xEF, 0xFF, 1);
Color themeDarkBlue = Color.fromRGBO(0x14, 0x89, 0xD4, 1);
Color loaderColor = themeDarkBlue;
Color textEntryColor = Colors.black54;

//Loader
Widget getLoader(){
  return SpinKitChasingDots(//SpinKitWanderingCubes
    color: themeDarkBlue,
    size: 50.0,
  );
}

//Toast Message
showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themeLightBlue,
      textColor: themeDarkBlue,
      fontSize: 17.0
  );
}

//Check Mobile Number
isValidMobile(String mobile){
  bool mobileValid = RegExp(r'^[0-9]+$').hasMatch(mobile);
  return mobileValid;
}

//Check Email
isValidEmail(String email){
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}

//KeySet

String kIsLogin = "IsLoggedIn";
String kUserId = "UserId";
String kAppOpened = "IsAppOpened";

//First letter capital
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}