import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/Reminder.dart';
import 'package:coronareminder/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class UpdatePasswordView extends StatefulWidget {
  @override
  _UpdatePasswordViewState createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {

  TextStyle headingStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle valueStyle = TextStyle(color: Colors.black54, fontSize: 16);

  TextEditingController txtOldPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmNewPassword = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmNewObscure = true;

  User currentUser;
  loadData() async {
    currentUser = await DBProvider.db.getUser(AppPreferences.getInt(kUserId));

    setState(() {

    });
  }

  static TextStyle style1 = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);

  final picker = ImagePicker();
  Future imgFromGallery() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        File _image = File(pickedFile.path);
        Uint8List bytes = _image.readAsBytesSync();
        String base64 = base64Encode(bytes);
        currentUser.profilePicture = base64;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response =
    await picker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
//          _handleVideo(response.file);
        } else {
//          _handleImage(response.file);
          setState(() {
            File _image = File(response.file.path);
            Uint8List bytes = _image.readAsBytesSync();
            String base64 = base64Encode(bytes);
            currentUser.profilePicture = base64;
          });
        }
      });
    } else {
//      _handleError(response.exception);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    if(defaultTargetPlatform == TargetPlatform.android){
      retrieveLostData();
    }
    super.initState();
    loadData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Password", style: new TextStyle(color: Colors.white),),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Icon(Icons.save, color: Colors.white,),
              onTap: () async {

                String oldPassword = txtOldPassword.text;
                String newPassword = txtNewPassword.text;
                String confirmNewPassword = txtConfirmNewPassword.text;

                if(oldPassword == null || oldPassword.length == 0){
                  showToast("Please enter Old Password");
                  return;
                }else if(newPassword == null || newPassword.length == 0){
                  showToast("Please enter New Password");
                  return;
                }else if(newPassword.length < 8 || newPassword.length > 12){
                  showToast("New Password must be 8-12 characters long");
                  return;
                }else if(confirmNewPassword == null || confirmNewPassword.length == 0){
                  showToast("Please enter Confirm New Password");
                  return;
                }else if(confirmNewPassword != newPassword){
                  showToast("New password and Confirm new password must be same");
                  return;
                }else if(oldPassword != currentUser.password){
                  showToast("Old password is not correct");
                  return;
                }else{

                  try{
                    currentUser.password = newPassword;

                    var data = await DBProvider.db.updateUser(currentUser);
                    if(data != null && data != 0){
                      setState(() {
                        showToast("Password updated successfully");
                        Navigator.pop(context, 'Profile updated');
                      });
                    }else{
                      showToast(DBProvider.db.errorMsg);
                    }
                  }catch(err){
                    print('Dinal Add Reminder Error : ' + err.toString());
                    showToast(err.toString());
                  }
                }

              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    themeLightBlue,
                    themeDarkBlue
                  ])
          ),
        ),
      ),
      body: KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Padding(padding: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.only(top: 15, right:20, left: 20),
                    child: TextField(
                      controller: txtOldPassword,
                      cursorColor: themeDarkBlue,
                      obscureText: oldObscure,
                      style: style1,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: (){
                              oldObscure = !oldObscure;
                              setState(() {

                              });
                            },
                            icon: Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: oldObscure?Icon(Icons.visibility, color: Colors.black54,):Icon(Icons.visibility_off, color: Colors.black54,),
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Enter Old Password",
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: themeDarkBlue, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          border:
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          )
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15, right:20, left: 20),
                  child: TextField(
                    controller: txtNewPassword,
                    cursorColor: themeDarkBlue,
                    obscureText: newObscure,
                    style: style1,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            newObscure = !newObscure;
                            setState(() {

                            });
                          },
                          icon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: newObscure?Icon(Icons.visibility, color: Colors.black54,):Icon(Icons.visibility_off, color: Colors.black54,),
                          )
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Enter New Password",
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: themeDarkBlue, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        border:
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, right:20, left: 20),
                  child: TextField(
                    controller: txtConfirmNewPassword,
                    cursorColor: themeDarkBlue,
                    obscureText: confirmNewObscure,
                    style: style1,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            confirmNewObscure = !confirmNewObscure;
                            setState(() {

                            });
                          },
                          icon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: confirmNewObscure?Icon(Icons.visibility, color: Colors.black54,):Icon(Icons.visibility_off, color: Colors.black54,),
                          )
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Enter Confirm New Password",
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: themeDarkBlue, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        border:
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        )
                    ),
                  ),
                ),

//                Container(
//                  height: 50,
//                  margin: EdgeInsets.only(top: 70, right: 10, left: 10, bottom: 15),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(25.0),
//                    color: themeDarkBlue,
//                  ),
//                  child: GestureDetector(
//                    child: Container(
//                      color: Colors.transparent,
//                      child: Center(
//                        child: Text('Update Profile',
//                            style: TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 20.0,
//                                color: Colors.white)),
//                      ),
//                    ),
//                    onTap: () async {
//
//                    },
//                  ),
//                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getUserProfile(){
    if(currentUser != null && currentUser.profilePicture != null && currentUser.profilePicture != ""){
      return Image.memory(base64Decode(currentUser.profilePicture), fit: BoxFit.fill,);
    }else{
      return Image.asset('assets/images/app_icon.jpg');
    }
  }

  String getUserFirstName(){
    if(currentUser != null && currentUser.firstName != null && currentUser.firstName != ""){
      return currentUser.firstName;
    }else{
      return "--";
    }
  }

  String getUserLastName(){
    if(currentUser != null && currentUser.lastName != null && currentUser.lastName != ""){
      return currentUser.lastName;
    }else{
      return "--";
    }
  }

  String getUserMobile(){
    if(currentUser != null && currentUser.mobile != null && currentUser.mobile != ""){
      return currentUser.mobile;
    }else{
      return "--";
    }
  }

  String getUserEmail(){
    if(currentUser != null && currentUser.email != null && currentUser.email != ""){
      return currentUser.email;
    }else{
      return "--";
    }
  }

}
