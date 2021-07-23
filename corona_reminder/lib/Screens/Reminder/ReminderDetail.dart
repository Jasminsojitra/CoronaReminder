import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/Reminder.dart';
import 'package:coronareminder/Screens/AddReminder/AddReminderView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderDetailView extends StatefulWidget {
  final int reminderId;

  ReminderDetailView({Key key, @required this.reminderId}) : super(key: key);

  @override
  _ReminderDetailViewState createState() =>
      _ReminderDetailViewState(this.reminderId);
}

class _ReminderDetailViewState extends State<ReminderDetailView> {
  TextStyle headingStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle valueStyle = TextStyle(color: Colors.black54, fontSize: 16);

  int reminderId;

  _ReminderDetailViewState(this.reminderId);

  Reminder currentReminder;
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isPending = false;

  initializeNotifications() async {

    await _configureLocalTimeZone();

    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  getPendingNotification() async {

    var list = await localNotificationsPlugin.pendingNotificationRequests();
    isPending = false;
    for(int i=0; i<list.length; i++){
      if(list[i].id == currentReminder.id){
        isPending = true;
        setState(() {

        });
        break;
      }
    }
  }

  Future onceNotification(DateTime datetime, String message, String subtext, int hashcode, {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.max,
      priority: Priority.max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
    localNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
  }

  tz.TZDateTime _getTimeForDaily(DateTime datetime) {
    final tz.TZDateTime now = tz.TZDateTime.from(datetime, tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future dailyNotification(DateTime datetime, String message, String subtext, int hashcode, {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.max,
      priority: Priority.max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);

//    localNotificationsPlugin.showDailyAtTime(hashcode, message, subtext, Time(datetime.hour, datetime.minute, datetime.second), platformChannel, payload: hashCode.toString());
    localNotificationsPlugin.zonedSchedule(hashcode, message, subtext, _getTimeForDaily(datetime), platformChannel, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true, matchDateTimeComponents: DateTimeComponents.time);
  }

  Future weeklyNotification(DateTime datetime, String message, String subtext, int hashcode, {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.max,
      priority: Priority.max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
//    print(DateTime.now().weekday.toString());
    String day = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    Day reminderDay;
    if(day == "monday"){
      reminderDay = Day.monday;
    }else if(day == "tuesday"){
      reminderDay = Day.tuesday;
    }else if(day == "wednesday"){
      reminderDay = Day.wednesday;
    }else if(day == "thursday"){
      reminderDay = Day.thursday;
    }else if(day == "friday"){
      reminderDay = Day.friday;
    }else if(day == "saturday"){
      reminderDay = Day.saturday;
    }else if(day == "sunday"){
      reminderDay = Day.sunday;
    }

//    localNotificationsPlugin.showWeeklyAtDayAndTime(hashcode, message, subtext, reminderDay, Time(datetime.hour, datetime.minute, datetime.second), platformChannel);
    await localNotificationsPlugin.zonedSchedule(hashcode, message, subtext, _getTimeForDaily(datetime), platformChannel, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }


  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeNotifications();
    loadReminder();

  }

  Future<void> loadReminder() async {

    if (reminderId != null) {
      currentReminder = await DBProvider.db.getReminder(reminderId);
    } else {
      currentReminder = null;
    }

    getPendingNotification();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder Detail"),
        actions: [
          isPending?Container(
            margin: EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddReminderView(
                              isEditing: true,
                              reminder: currentReminder,
                            )));

                loadReminder();
                setState(() {});
              },
            ),
          ):Container(),
          Container(
            margin: EdgeInsets.only(right: 12),
            child: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text("Delete Reminder"),
                      content: const Text(
                          "Are you sure you want to delete this Reminder?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => {Navigator.of(context).pop(false)},
                          child: const Text("No"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            localNotificationsPlugin.cancel(currentReminder.id);
                            await DBProvider.db.deleteReminder(currentReminder);
                            showToast("Reminder deleted");
                            Navigator.pop(context, "Reminder deleted");
                          },
                          child: const Text(
                            "Yes, Delete",
                            style: TextStyle(color: Colors.red),
                          )
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[themeLightBlue, themeDarkBlue])),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        padding: EdgeInsets.only(right: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(5),
                    height: 100,
                    width: 100,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        border: Border.all(
                            width: 1,
                            color: themeDarkBlue,
                            style: BorderStyle.solid)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child: Image.asset('assets/images/app_icon.jpg'),
                    )),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Reminder Title",
                            style: headingStyle,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                getReminderTitle(),
                                style: valueStyle,
                              ))
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
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Reminder Description",
                            style: headingStyle,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                getReminderDescription(),
                                style: valueStyle,
                              ))
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
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Type",
                            style: headingStyle,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                getReminderType(),
                                maxLines: 2,
                                style: valueStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
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
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Repeat",
                            style: headingStyle,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                getReminderRepeat(),
                                maxLines: 2,
                                style: valueStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
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
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Reminder Date",
                            style: headingStyle,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                getReminderDate(),
                                maxLines: 2,
                                style: valueStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
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
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Reminder Time",
                            style: headingStyle,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                getReminderTime(),
                                maxLines: 2,
                                style: valueStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
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
                height: 50,
                margin: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: themeDarkBlue,
                ),
                child: GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Text(isPending?'Mark Complete':'Completed',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              color: Colors.white)),
                    ),
                  ),
                  onTap: () async {
                    if(isPending){

                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text("Complete Reminder"),
                            content: const Text(
                                "\nIf you complete the reminder you will not be notified for this reminder, Are you sure you want to complete this Reminder?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => {Navigator.of(context).pop(false)},
                                child: const Text("No"),
                              ),
                              FlatButton(
                                  onPressed: () async {
                                    await localNotificationsPlugin.cancel(currentReminder.id);
                                    await getPendingNotification();
                                    showToast("Reminder stopped");
                                    setState(() {

                                    });
                                  },
                                  child: const Text(
                                    "Yes, Stop",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                              ),
                            ],
                          );
                        },
                      );

                    }else{
//                      if(getReminderRepeat() == "Once"){
//                        //Once
//                        DateTime date = DateTime.parse(currentReminder.reminderDateTime).toUtc();
//                        await onceNotification(
//                          date,
//                          getReminderType() + " - " + getReminderTitle(),
//                          getReminderDescription(),
//                          currentReminder.id,
//                        );
//
//                      }else if(getReminderRepeat() == "Once"){
//                        //Daily
//                        DateTime date = DateTime.parse(currentReminder.reminderDateTime).toUtc();
//                        await dailyNotification(
//                          date,
//                          getReminderType() + " - " + getReminderTitle(),
//                          getReminderDescription(),
//                          currentReminder.id,
//                        );
//                      }else if(getReminderRepeat() == "Weekly"){
//                        //Weekly
//                        DateTime date = DateTime.parse(currentReminder.reminderDateTime).toUtc();
//                        await weeklyNotification(
//                          date,
//                          getReminderType() + " - " + getReminderTitle(),
//                          getReminderDescription(),
//                          currentReminder.id,
//                        );
//                      }else{
//                        //None selected
//                        showToast("Please add reminder repeat");
//                        return;
//                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool hasReminder() {
    if (currentReminder != null) {
      return true;
    } else {
      return false;
    }
  }

  String getReminderTitle() {
    if (hasReminder() &&
        currentReminder.title != null &&
        currentReminder.title != null) {
      return currentReminder.title;
    } else {
      return "--";
    }
  }

  String getReminderDescription() {
    if (hasReminder() &&
        currentReminder.description != null &&
        currentReminder.description != null) {
      return currentReminder.description;
    } else {
      return "--";
    }
  }

  String getReminderType() {
    if (hasReminder() &&
        currentReminder.type != null &&
        currentReminder.type != null) {
      return currentReminder.type;
    } else {
      return "--";
    }
  }

  String getReminderRepeat() {
    if (hasReminder() &&
        currentReminder.repeat != null &&
        currentReminder.repeat != null) {
      return currentReminder.repeat;
    } else {
      return "--";
    }
  }

  String getReminderDate() {
    if (hasReminder() &&
        currentReminder.reminderDateTime != null) {
      DateTime NewDate = DateTime.parse(currentReminder.reminderDateTime);
      String prnDate = DateFormat("d/MM/yyyy").format(NewDate);
      return prnDate;
    } else {
      return "--";
    }
  }

  String getReminderTime() {
    if (hasReminder() &&
        currentReminder.reminderDateTime != null &&
        currentReminder.reminderDateTime != null) {
      DateTime NewDate = DateTime.parse(currentReminder.reminderDateTime);
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      final String prnTime =
          localizations.formatTimeOfDay(TimeOfDay.fromDateTime(NewDate));
      return prnTime;
    } else {
      return "--";
    }
  }
}
