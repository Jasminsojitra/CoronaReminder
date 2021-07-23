import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/Reminder.dart';
import 'package:coronareminder/Screens/AddReminder/AddReminderView.dart';
import 'package:coronareminder/Screens/Login/LoginView.dart';
import 'package:coronareminder/Screens/Profile/ProfileView.dart';
import 'package:coronareminder/Screens/Reminder/ReminderDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();

  TextStyle headingStyle = TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 14);
  TextStyle valueStyle = TextStyle(color: themeDarkBlue.withOpacity(0.9), fontSize: 13);
  
  @override
  void initState() {
    super.initState();

    loadReminders();

  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  initializeNotifications() async {
    await _configureLocalTimeZone();

    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }


  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<Reminder> allReminders = List<Reminder>();
  Future<void> loadReminders() async {
    await initializeNotifications();
    allReminders = await DBProvider.db.getAllReminders();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Dashboard", style: new TextStyle(color: Colors.white),),
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
          leading: Container(
            margin: EdgeInsets.only(left: 5),
            child: GestureDetector(
              child: Icon(Icons.person_sharp, color: Colors.white,),
              onTap: () async {
                var result = await Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>ProfileView()
                ));
                loadReminders();
                setState(() {

                });
              },
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Icon(Icons.login_outlined, color: Colors.white,),
                onTap: (){
                  showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: false,
          color: loaderColor,
          progressIndicator: getLoader(),
          child: getCustomerList(),
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alarm),
          backgroundColor: themeDarkBlue,
          onPressed: () async {
            var result = await Navigator.push(context, MaterialPageRoute(
              builder: (context)=>AddReminderView(isEditing: false, reminder: null,)
            ));
            loadReminders();
            setState(() {

            });
          },
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext context) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Yes, Logout", style: TextStyle(fontWeight: FontWeight.bold, )),
      onPressed: () async {
        AppPreferences.setBool(kIsLogin, false);
        AppPreferences.remove(kUserId);

        Navigator.pop(context);
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
            (context) => LoginView()
          )
        );
        setState(() {
          showToast("Successfully logged out");
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(

      title: Text("Logout"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to logout?"),
      ),
      actions: [
        FlatButton(
          child: Text("No", style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getCustomerList() {
    if(allReminders != null && allReminders.length > 0){
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(allReminders[index].id.toString()),
            background: Container(
              color: Colors.red,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text('Delete Reminder', style: TextStyle(color: Colors.white, fontSize: 20),),
                    )
                  ],
                ),
              ),
            ),
            direction: DismissDirection.endToStart,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 5, left: 5),
                child: Card(
                  child: Container(
//                  height: 100,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                height: 70,
                                width: 70,
                                decoration: new BoxDecoration(
                                    color: themeLightBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(35))
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(35)),
                                  child: getProfilePicture(),
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 13),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(getReminderTitle(index), style: TextStyle(color: themeDarkBlue, fontWeight: FontWeight.w500, fontSize: 17),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(getReminderDescription(index), style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 14), textAlign: TextAlign.left, maxLines: 3, overflow: TextOverflow.ellipsis,),
                                  ),
//                              Container(
//                                child: Text("3", style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 14), textAlign: TextAlign.right,),
//                                //AD563S
//                              )
                                ],
                              ),
                            ),
                            Center(
                              child: getIsActive(index),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Reminder Type', style: headingStyle, overflow: TextOverflow.ellipsis,),
                                    Padding(padding: EdgeInsets.only(top: 5),),
                                    Text(getReminderType(index), style: valueStyle, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 30,
                              child: VerticalDivider(color: Colors.grey,),
                            ),

                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Reminder Repeat', style: headingStyle,overflow: TextOverflow.ellipsis,),
                                    Padding(padding: EdgeInsets.only(top: 5),),
                                    Text(getReminderRepeat(index), style: valueStyle,overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Reminder Date', style: headingStyle, overflow: TextOverflow.ellipsis,),
                                    Padding(padding: EdgeInsets.only(top: 5),),
                                    Text(getReminderDate(index), style: valueStyle, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 30,
                              child: VerticalDivider(color: Colors.grey,),
                            ),

                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Reminder Time', style: headingStyle,overflow: TextOverflow.ellipsis,),
                                    Padding(padding: EdgeInsets.only(top: 5),),
                                    Text(getReminderTime(index), style: valueStyle,overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {
                final result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>ReminderDetailView(reminderId: allReminders[index].id,)
                ));
                loadReminders();
                setState(() {

                });
              },
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text("Delete Reminder"),
                    content: const Text("Are you sure you want delete this Reminder?"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => {
                          Navigator.of(context).pop(false)
                        },
                        child: const Text("No"),
                      ),
                      FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            localNotificationsPlugin.cancel(allReminders[index].id);
                            await DBProvider.db.deleteReminder(allReminders[index]);
                            loadReminders();
                            setState(() {

                            });
                          },
                          child: const Text("Yes, Delete", style: TextStyle(color: Colors.red),)
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction){
              loadReminders();
              setState(() {

              });
            },
          );
        },
        itemCount: allReminders.length,
      );
    }else{
      return Center(
        child: Text("No reminder to show", style: TextStyle(fontSize: 17, color: Colors.grey),),
      );
    }

  }

  getProfilePicture() {
    return Image.asset('assets/images/app_icon.jpg');
  }

  getIsActive(int index) {
    if(index % 2 == 0){
      return Icon(
        Icons.notifications_active,
        size: 20,
        color: Colors.transparent,
      );
    }else{
      return Icon(
        Icons.notifications_off,
        size: 21,
        color: Colors.transparent,
      );
    }
  }

  bool hasReminder(int index) {
    if(allReminders != null && allReminders.length > 0 && allReminders[index] != null){
      return true;
    }else{
      return false;
    }
  }

  String getReminderTitle(int index) {
    if(hasReminder(index) && allReminders[index].title != null && allReminders[index].title != null){
      return allReminders[index].title;
    }else{
      return "--";
    }
  }

  String getReminderDescription(int index) {
    if(hasReminder(index) && allReminders[index].description != null && allReminders[index].description != null){
      return allReminders[index].description;
    }else{
      return "--";
    }
  }

  String getReminderType(int index) {
    if(hasReminder(index) && allReminders[index].type != null && allReminders[index].type != null){
      return allReminders[index].type;
    }else{
      return "--";
    }
  }

  String getReminderRepeat(int index) {
    if(hasReminder(index) && allReminders[index].repeat != null && allReminders[index].repeat != null){
      return allReminders[index].repeat;
    }else{
      return "--";
    }
  }

  String getReminderDate(int index) {
    if(hasReminder(index) && allReminders[index].reminderDateTime != null && allReminders[index].reminderDateTime != null){
      DateTime NewDate = DateTime.parse(allReminders[index].reminderDateTime);
      String prnDate = DateFormat("d/MM/yyyy").format(NewDate);
      return prnDate;
    }else{
      return "--";
    }
  }

  String getReminderTime(int index) {
    if(hasReminder(index) && allReminders[index].reminderDateTime != null && allReminders[index].reminderDateTime != null){

      DateTime NewDate = DateTime.parse(allReminders[index].reminderDateTime);
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      final String prnTime = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(NewDate));
      return prnTime;
    }else{
      return "--";
    }
  }

}
