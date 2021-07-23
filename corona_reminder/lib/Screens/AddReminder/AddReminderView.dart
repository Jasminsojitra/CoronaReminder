import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/Reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddReminderView extends StatefulWidget {

  final bool isEditing;
  final Reminder reminder;
  AddReminderView({Key key, @required this.isEditing, this.reminder}) : super(key: key);


  @override
  _AddReminderViewState createState() => _AddReminderViewState(isEditing, reminder);

}

class _AddReminderViewState extends State<AddReminderView> {

  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool isEditing;
  Reminder reminder;
  _AddReminderViewState(this.isEditing, this.reminder);


  @override
  void dispose() {
    // TODO: implement dispose
    txtTitleController.dispose();
    txtDescriptionController.dispose();
    txtDateTimeController.dispose();
//    didReceiveLocalNotificationSubject.close();
//    selectNotificationSubject.close();

    super.dispose();
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
    loadReminderData();

//    _configureDidReceiveLocalNotificationSubject();
//    _configureSelectNotificationSubject();
  }

  loadReminderData(){
    if(isEditing){
      new Future.delayed(new Duration(seconds: 0), () {
        txtTitleController.text = getReminderTitle();
        txtDescriptionController.text = getReminderDescription();
        txtDateTimeController.text = getReminderDateTime();

        txtTypeController.text = getReminderType();
        if(getReminderRepeat() == "Once"){
          _groupValue = 0;
        }else if(getReminderRepeat() == "Daily"){
          _groupValue = 1;
        }else if(getReminderRepeat() == "Weekly"){
          _groupValue = 2;
        }else{
          _groupValue = -1;
        }
        setState(() {

        });
      });
    }

  }

  initializeNotifications() async {
    await _configureLocalTimeZone();

    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  int valueHolder = 1;

  Widget addTextField(String hint, String label, bool IsEnabled, TextEditingController txtContol) {
    return Container(
      margin: EdgeInsets.only(top: 15, right:20, left: 20),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: txtContol,
        cursorColor: themeDarkBlue,
        obscureText: false,
        readOnly: IsEnabled,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black38),
          labelText: label,
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

  Widget addTextArea(String hint, String label, bool IsEnabled, TextEditingController txtControl) {

    return Container(
      margin: EdgeInsets.only(top: 15, right:20, left: 20),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: txtControl,
        cursorColor: themeDarkBlue,
        obscureText: false,
        readOnly: IsEnabled,
        keyboardType: TextInputType.multiline,
        maxLines: 6,
        maxLength: 250,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black38),
            labelText: label,
            alignLabelWithHint: true,
            focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(color: themeDarkBlue, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border:
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
      ),
    );

  }

  Widget getAddReminderView() {

    return Container(
        margin: EdgeInsets.only(top: 10),

        child: Column(
          children: <Widget>[
            addTextField('Enter Reminder Title', 'Title', false, txtTitleController),
            addTextArea('Enter Reminder Description', 'Description', false, txtDescriptionController),
            Stack(
              children: <Widget>[
                addTextField('Date & Time','Date & Time', true, txtDateTimeController),
                Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.blue,
                  ),
                  child: Builder(
                    builder: (context) => GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        child: Container(
                          color: Colors.white.withOpacity(0),
                        ),
                      ),
                      onTap: (){
                        _selectDate(context);
                      },
                    ),
                  ),
                )
              ],
            ),
            _buildTypeSelection(),
//                Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Container(
//                    margin: EdgeInsets.only(left: 25, top: 15),
//                    child: Text('Delay between reminders: ' + valueHolder.toString() + " Hour(s)", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 16)),
//                  ),
//                  Container(
//                      margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
//                      child: Slider(
//                          value: valueHolder.toDouble(),
//                          min: 1,
//                          max: 10,
//                          divisions: 100,
//                          activeColor: Colors.blue,
//                          inactiveColor: Colors.grey,
//                          label: '${valueHolder.round()}',
//                          onChanged: (double newValue) {
//                            setState(() {
//                              valueHolder = newValue.round();
//                            });
//                          },
//                          semanticFormatterCallback: (double newValue) {
//                            return '${newValue.round()}';
//                          }
//                      )
//                  ),
//                ]
//            ),
            Column(
              children: <Widget>[
                _myRadioButton(
                  title: "Once",
                  value: 0,
                  onChanged: (newValue) => setState(() => _groupValue = newValue),
                ),
                _myRadioButton(
                  title: "Daily",
                  value: 1,
                  onChanged: (newValue) => setState(() => _groupValue = newValue),
                ),
                _myRadioButton(
                  title: "Weekly",
                  value: 2,
                  onChanged: (newValue) => setState(() => _groupValue = newValue),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: themeDarkBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(27.5),
                        topRight: Radius.circular(27.5),
                        bottomLeft: Radius.circular(27.5),
                        bottomRight: Radius.circular(27.5)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Container(

                            child: GestureDetector(
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(isEditing?"Update Reminder":"Save Reminder", style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white)),
                                ),
                              ),
                              onTap: () async {

                                String txtTitle = txtTitleController.text;
                                String txtDescription = txtDescriptionController.text;
                                String txtDateTime = txtDateTimeController.text;
                                String txtType = txtTypeController.text;

                                if(txtTitle == null || txtTitle.length == 0){
                                  showToast("Please enter title for reminder");
                                  return;
                                }else if(txtDescription == null || txtDescription.length == 0){
                                  showToast("Please enter description for reminder");
                                  return;
                                }else if(txtDateTime == null || txtDateTime.length == 0){
                                  showToast("Please select date & time for reminder");
                                  return;
                                }else if(txtType == null || txtType.length == 0 || txtType == "--- Select Type ---"){
                                  showToast("Please select type for reminder");
                                  return;
                                }else if(_groupValue == -1){
                                  showToast("Please select reminder timing");
                                  return;
                                }else{

                                  String repeat;
                                  if(_groupValue == 0){
                                    repeat = "Once";
                                  }else if(_groupValue == 1){
                                    repeat = "Daily";
                                  }else if(_groupValue == 2){
                                    repeat = "Weekly";
                                  }else{
                                    repeat = "";
                                  }

                                  int userId = AppPreferences.getInt(kUserId);

                                  Reminder newReminder = Reminder(
                                    userId: userId,
                                    title: txtTitle,
                                    description: txtDescription,
                                    type: txtType,
                                    repeat: repeat,
                                    reminderDateTime: selectedDate.toString(),
                                    creationDate: isEditing?reminder.creationDate:DateTime.now().toString(),
                                    isDeleted: false,
                                  );

                                  try{
                                    int data = 0;
                                    if(isEditing){
                                      newReminder.id = reminder.id;
                                      data = await DBProvider.db.updateReminder(newReminder);
                                    }else{
                                      data = await DBProvider.db.newReminder(newReminder);
                                    }

                                    if(data != null && data != 0){
                                      int reminderId = data;
                                      if(isEditing){
                                        localNotificationsPlugin.cancel(reminderId);
                                        if(_groupValue == 0){
                                          //Once
                                          DateTime date = selectedDate.toUtc();
                                          await onceNotification(
                                            date,
                                            txtType + " - " + txtTitle,
                                            txtDescription,
                                            reminderId,
                                          );

                                        }else if(_groupValue == 1){
                                          //Daily
                                          DateTime date = selectedDate.toUtc();
                                          await dailyNotification(
                                            date,
                                            txtType + " - " + txtTitle,
                                            txtDescription,
                                            reminderId,
                                          );
                                        }else if(_groupValue == 2){
                                          //Weekly
                                          DateTime date = selectedDate.toUtc();
                                          await weeklyNotification(
                                            date,
                                            txtType + " - " + txtTitle,
                                            txtDescription,
                                            reminderId,
                                          );
                                        }else{
                                          //None selected
                                          showToast("Please select reminder repeat");
                                          return;
                                        }
                                      }else{
                                        if(_groupValue == 0){
                                          //Once
                                          DateTime date = selectedDate.toUtc();
                                          await onceNotification(
                                            date,
                                            txtType + " - " + txtTitle,
                                            txtDescription,
                                            reminderId,
                                          );

                                        }else if(_groupValue == 1){
                                          //Daily
                                          DateTime date = selectedDate.toUtc();
                                          await dailyNotification(
                                            date,
                                            txtType + " - " + txtTitle,
                                            txtDescription,
                                            reminderId,
                                          );
                                        }else if(_groupValue == 2){
                                          //Weekly
                                          DateTime date = selectedDate.toUtc();
                                          await weeklyNotification(
                                            date,
                                            txtType + " - " + txtTitle,
                                            txtDescription,
                                            reminderId,
                                          );
                                        }else{
                                          //None selected
                                          showToast("Please select reminder repeat");
                                          return;
                                        }
                                      }

                                      setState(() {
                                        showToast(isEditing?"Reminder updated successfully":"Reminder saved successfully");
                                        Navigator.pop(context, 'Added New Reminder');
                                      });
                                    }else{
                                      showToast(DBProvider.db.errorMsg);
                                    }

                                  }catch(err){
                                    print('Dinal Add Reminder Error : ' + err.toString());
                                  }
                                  
                                }

                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
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
//    localNotificationsPlugin.periodicallyShow(hashcode, message, subtext, RepeatInterval, platformChannel);
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

  int _groupValue = -1;
  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  final txtTitleController = TextEditingController();
  final txtDescriptionController = TextEditingController();
  final txtDateTimeController = TextEditingController();
  TextEditingController txtTypeController = new TextEditingController();

  Widget _buildTypeSelection() {
    String selectionName = "Reminder Type";
    List<String> items = ["--- Select Type ---","Sanitizing", "Hand Wash", "Medication", "Social Distancing", "Other"];
    return Container(
      margin: EdgeInsets.only(top: 20, right: 15, left: 15, bottom: 15),
      child: FormField(
        builder: (FormFieldState state) {
          return DropdownButtonHideUnderline(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new InputDecorator(
                  decoration: InputDecoration(
                      filled: false,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: 'Select $selectionName',
                      labelText: '$selectionName',
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: themeDarkBlue, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      border:
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  ),
                  isEmpty: items == null,
                  child: new DropdownButton<String>(
                    value: txtTypeController.text!=""?txtTypeController.text:"--- Select Type ---",
                    isDense: true,
                    onChanged: (String newValue) {
                      if(newValue != null || newValue != ""){
                        setState(() {
                          txtTypeController.text = newValue;
                        });
                      }else{

                      }
                    },
                    items: items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year+1,DateTime.now().month,DateTime.now().day)
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _selectTime(context);
      });
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);

        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String date = formatter.format(selectedDate);

        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        final String time = localizations.formatTimeOfDay(selectedTime);

        txtDateTimeController.text = date + " " + time;
      });
  }

//  void _configureDidReceiveLocalNotificationSubject() {
//    didReceiveLocalNotificationSubject.stream
//        .listen((ReceivedNotification receivedNotification) async {
//      await showDialog(
//        context: context,
//        builder: (BuildContext context) => CupertinoAlertDialog(
//          title: receivedNotification.title != null
//              ? Text(receivedNotification.title)
//              : null,
//          content: receivedNotification.body != null
//              ? Text(receivedNotification.body)
//              : null,
//          actions: <Widget>[
//            CupertinoDialogAction(
//              isDefaultAction: true,
//              onPressed: () async {
//                Navigator.of(context, rootNavigator: true).pop();
//                await Navigator.push(
//                  context,
//                  MaterialPageRoute<void>(
//                    builder: (BuildContext context) =>
//                        SecondScreen(receivedNotification.payload),
//                  ),
//                );
//              },
//              child: const Text('Ok'),
//            )
//          ],
//        ),
//      );
//    });
//  }

//  void _configureSelectNotificationSubject() {
//    selectNotificationSubject.stream.listen((String payload) async {
//      await Navigator.push(
//        context,
//        MaterialPageRoute<void>(
//            builder: (BuildContext context) => SecondScreen(payload)),
//      );
//    });
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Reminder", style: new TextStyle(color: Colors.white),),
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
          GestureType.onPanDown
        ],
        child: SingleChildScrollView(
          child: Container(
            height: 710,
            child: getAddReminderView(),
          ),
        ),
      ),
    );
  }


  bool hasReminder() {
    if(reminder != null){
      return true;
    }else{
      return false;
    }
  }

  String getReminderTitle() {
    if(hasReminder() && reminder.title != null && reminder.title != null){
      return reminder.title;
    }else{
      return "--";
    }
  }

  String getReminderDescription() {
    if(hasReminder() && reminder.description != null && reminder.description != null){
      return reminder.description;
    }else{
      return "--";
    }
  }

  String getReminderType() {
    if(hasReminder() && reminder.type != null && reminder.type != null){
      return reminder.type;
    }else{
      return "--";
    }
  }

  String getReminderRepeat() {
    if(hasReminder() && reminder.repeat != null && reminder.repeat != null){
      return reminder.repeat;
    }else{
      return "--";
    }
  }

  String getReminderDateTime() {
    if(hasReminder() && reminder.reminderDateTime != null && reminder.reminderDateTime != null){

      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectedDate = DateTime.parse(reminder.reminderDateTime);
      final String date = formatter.format(selectedDate);

      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      selectedTime = TimeOfDay.fromDateTime(DateTime.parse(reminder.reminderDateTime));
      final String time = localizations.formatTimeOfDay(selectedTime);

      return date + " " + time;
    }else{
      return "--";
    }
  }

}
