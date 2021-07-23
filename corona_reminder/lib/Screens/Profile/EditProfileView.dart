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
import 'package:intl/intl.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  TextStyle headingStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle valueStyle = TextStyle(color: Colors.black54, fontSize: 16);

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  User currentUser;
  loadData() async {
    currentUser = await DBProvider.db.getUser(AppPreferences.getInt(kUserId));

    txtFirstName.text = getUserFirstName();
    txtLastName.text = getUserLastName();
    txtMobile.text = getUserMobile();
    txtEmail.text = getUserEmail();

    setState(() {

    });
  }

  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Widget addTextField(String placeHolder, bool isReadOnly, TextEditingController txtControl, TextInputType type, TextCapitalization capitalization) {
    return Container(
      margin: EdgeInsets.only(top: 15, right:20, left: 20),
      child: TextField(
        textCapitalization: capitalization,
        controller: txtControl,
        keyboardType: type,
        cursorColor: themeDarkBlue,
        obscureText: false,
        readOnly: isReadOnly,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: placeHolder,
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
    );

  }

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
        title: Text("Edit Profile", style: new TextStyle(color: Colors.white),),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Icon(Icons.save, color: Colors.white,),
              onTap: () async {

                String firstName = txtFirstName.text;
                String lastName = txtLastName.text;
                String mobile = txtMobile.text;
                String email = txtEmail.text;

                if(firstName == null || firstName.length == 0){
                  showToast("Please enter first name");
                  return;
                }else if(lastName == null || lastName.length == 0){
                  showToast("Please enter last name");
                  return;
                }else if(mobile == null || mobile.length == 0){
                  showToast("Please enter mobile number");
                  return;
                }else if(!isValidMobile(mobile)){
                  showToast("Please enter proper mobile number");
                  return;
                }else if(email == null || email.length == 0){
                  showToast("Please enter your email address");
                  return;
                }else if(!isValidEmail(email)){
                  showToast("Please enter proper email address");
                  return;
                }else{

                  try{
                    currentUser.firstName = txtFirstName.text;
                    currentUser.lastName = txtLastName.text;
                    currentUser.mobile = txtMobile.text;
                    currentUser.email = txtEmail.text;

                    var data = await DBProvider.db.updateUser(currentUser);
                    if(data != null && data != 0){
                      setState(() {
                        showToast("Profile updated successfully");
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
                Center(
                  child: GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 120,
                            width: 120,
                            decoration: new BoxDecoration(
                                color: themeLightBlue,
                                borderRadius: BorderRadius.all(Radius.circular(60))
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(60)),
                              child: getUserProfile(),
                            )
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(top: 100, left: 90),
                          decoration: new BoxDecoration(
                              color: themeDarkBlue,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Icon(Icons.edit, color: Colors.white,),
                        )
                      ],
                    ),
                    onTap: () async {
                      imgFromGallery();
                    },
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 20),
                  child: addTextField("First Name", false, txtFirstName, TextInputType.text, TextCapitalization.sentences),
                ),
                addTextField("Last Name", false, txtLastName, TextInputType.text, TextCapitalization.sentences),
                addTextField("Email", false, txtEmail, TextInputType.emailAddress, TextCapitalization.none),
                addTextField("Mobile", false, txtMobile, TextInputType.number, TextCapitalization.none),

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
      return Image.memory(base64Decode(currentUser.profilePicture), fit: BoxFit.cover,);
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
