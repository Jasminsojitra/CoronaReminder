import 'dart:convert';
import 'dart:math';

import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/Reminder.dart';
import 'package:coronareminder/Models/User.dart';
import 'package:coronareminder/Screens/Password/UpdatePasswordView.dart';
import 'package:coronareminder/Screens/Profile/EditProfileView.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  TextStyle headingStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle valueStyle = TextStyle(color: Colors.black54, fontSize: 16);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }
  User currentUser;
  List<Reminder> listReminder;
  loadData() async {
    currentUser = await DBProvider.db.getUser(AppPreferences.getInt(kUserId));
    listReminder = await DBProvider.db.getAllReminders();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile", style: new TextStyle(color: Colors.white),),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Transform.rotate(
                angle: 120,
                child: Tooltip(
                  child: Icon(Icons.vpn_key, color: Colors.white),
                  message: "Update Password",
                ),
              ),
              onTap: () async {
                var result = await Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>UpdatePasswordView()
                ));
                loadData();
                setState(() {

                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Tooltip(
                child: Icon(Icons.edit, color: Colors.white,),
                message: "Edit Profile",
              ),
              onTap: () async {
                var result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>EditProfileView()
                ));
                loadData();
                setState(() {

                });
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
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
                ),

                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 25,bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("First Name:",style: headingStyle,),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(getUserFirstName(), style: valueStyle,overflow: TextOverflow.ellipsis)
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Last Name:", style: headingStyle,),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(getUserLastName(), style: valueStyle,overflow: TextOverflow.ellipsis)
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey,
                ),

                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 10,bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Mobile Number:",style: headingStyle,),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(getUserMobile(), style: valueStyle,overflow: TextOverflow.ellipsis)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey,
                ),

                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Email:",style: headingStyle,),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(getUserEmail(), style: valueStyle,overflow: TextOverflow.ellipsis)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey,
                ),

                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Total Reminders Added:",style: headingStyle,),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(getUserReminders(), style: valueStyle,overflow: TextOverflow.ellipsis)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey,
                ),

                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Registered on:",style: headingStyle,),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(getUserRegistrationDate(), style: valueStyle,overflow: TextOverflow.ellipsis)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getUserFirstName(){
    if(currentUser != null && currentUser.firstName != null && currentUser.firstName != ""){
      return currentUser.firstName;
    }else{
      return "--";
    }
  }

  Widget getUserProfile(){
    if(currentUser != null && currentUser.profilePicture != null && currentUser.profilePicture != ""){
      return Image.memory(base64Decode(currentUser.profilePicture), fit: BoxFit.cover,);
    }else{
      return Image.asset('assets/images/app_icon.jpg');
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

  String getUserReminders() {
    if(currentUser != null && currentUser.id != null){
      if(listReminder != null && listReminder.length>0){
        if(listReminder.length > 50){
          return "50+";
        }else if(listReminder.length > 20){
          return "20+";
        }else{
          return listReminder.length.toString();
        }

      }else{
        return "No Reminders Added";
      }
      return "100+";
    }else{
      return "--";
    }
  }

  String getUserRegistrationDate(){
    if(currentUser != null && currentUser.registrationDate != null && currentUser.registrationDate != ""){

      DateTime dateTime = DateTime.parse(currentUser.registrationDate);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String date = formatter.format(dateTime);

      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      final String time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime));

      return date + " " + time;
    }else{
      return "--";
    }
  }

}
