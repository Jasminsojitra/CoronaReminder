import 'dart:async';
import 'dart:io';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/Reminder.dart';
import 'package:coronareminder/Models/User.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider.load();

  static final DBProvider db = DBProvider.load();
  Database _database;
  String errorMsg;
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  Future<Database> get database async {
    await initializeNotifications();
    try{
      if (_database != null) return _database;
      // if _database is null we instantiate it
      _database = await initDB();
      return _database;
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
    }
  }

  initDB() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "ReminderApp.db");
      print("Database Path: " + path);
      return await openDatabase(path, version: 1, onOpen: (db) {},
          onCreate: (Database db, int version) async {

          await db.execute("CREATE TABLE User ("
              "id INTEGER PRIMARY KEY,"
              "firstName TEXT,"
              "lastName TEXT,"
              "mobile TEXT,"
              "email TEXT,"
              "profilePicture TEXT,"
              "password TEXT,"
              "registrationDate TEXT"
              ")");

          await db.execute("CREATE TABLE Reminder ("
              "id INTEGER PRIMARY KEY,"
              "userId INTEGER,"
              "title TEXT,"
              "description TEXT,"
              "type TEXT,"
              "repeat TEXT,"
              "creationDate TEXT,"
              "reminderDateTime TEXT,"
              "isDeleted TINYINT,"
              "FOREIGN KEY (userId) REFERENCES User (id)"
              ")");

          });
    }catch(err) {
      print('Dinal DB Error : ' + err.toString());
    }
  }

  Future<int> newReminder(Reminder newReminder) async {

    try{
      final db = await database;
      //get the biggest id in the table
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Reminder");
      int id = table.first["id"];
      if(id == null)
      {
        id = 1;
      }
      int userId = AppPreferences.getInt(kUserId);
      //insert to the table using the new id
      var raw = await db.rawInsert(
          "INSERT Into Reminder (id,userId,title,description,type,repeat,creationDate,reminderDateTime,isDeleted)"
              " VALUES (?,?,?,?,?,?,?,?,?)",
          [id, userId, newReminder.title, newReminder.description, newReminder.type, newReminder.repeat, newReminder.creationDate, newReminder.reminderDateTime, newReminder.isDeleted]);
      return raw;
    }catch(err){
      print('Dinal DB Error : ' + err.toString());

    }

  }

  updateReminder(Reminder newReminder) async {
    try{
      final db = await database;
      var res = await db.update("Reminder", newReminder.toMap(),
          where: "id = ?", whereArgs: [newReminder.id]);
      return res;
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
    }
  }

  Future<List<Reminder>> getAllReminders() async {
    try{
      final db = await database;

      int userId = AppPreferences.getInt(kUserId);
      var res = await db.query("Reminder", where: "isDeleted = ? AND userId = ?", whereArgs: [0, userId]); //0:F || 1:T
      List<Reminder> list =
      res.isNotEmpty ? res.map((c) => Reminder.fromJson(c)).toList() : [];
      return list.reversed.toList();
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
      return null;
    }
  }

//  Future<List<Reminder>> getAllDeletedReminders() async {
//    try{
//      final db = await database;
//      var res = await db.query("Reminder", where: "isDeleted = ?", whereArgs: [1]); //0:F || 1:T
//      List<Reminder> list =
//      res.isNotEmpty ? res.map((c) => Reminder.fromJson(c)).toList() : [];
//      return list.reversed.toList();
//    }catch(err){
//      print('Dinal DB Error : ' + err.toString());
//    }
//
//  }

  deleteReminder(Reminder newReminder) async {
    try{
      final db = await database;
      newReminder.isDeleted = true;
      localNotificationsPlugin.cancel(newReminder.id);

      var res = await db.update("Reminder", newReminder.toMap(),
          where: "id = ?", whereArgs: [newReminder.id]);
      return res;
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
    }
  }

  deleteForeverReminder(int id) async {
    try{
      final db = await database;
      //print("Reminder deleted successfuly");
      return db.delete("Reminder", where: "id = ?", whereArgs: [id]);
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
    }
  }

  deleteAllReminder() async {
    try{
      final db = await database;
      db.delete("Reminder", where: "isDeleted = ?", whereArgs: [true]); //0:F || 1:T
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
    }

  }

  getReminder(int id) async {
    final db = await database;
    var res = await db.query("Reminder", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Reminder.fromJson(res.first) : null;
  }


  //USER

  Future<int> registerUser(User newUser) async {
    errorMsg = "Dinal";
    try{
      final db = await database;
      //get the biggest id in the table

      var res = await db.query("User", where: "email = ?", whereArgs: [newUser.email]);
      if(res != null && res.isNotEmpty){
        throw "Email Id already exist";
      }

      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
      int id = table.first["id"];
      if(id == null)
      {
        id = 1;
      }
      //insert to the table using the new id

      var raw = await db.rawInsert(
          "INSERT Into User (id,firstName,lastName,mobile,email,profilePicture,password,registrationDate)"
              " VALUES (?,?,?,?,?,?,?,?)",
          [id, newUser.firstName, newUser.lastName, newUser.mobile, newUser.email, newUser.profilePicture, newUser.password, newUser.registrationDate]);

      AppPreferences.setInt(kUserId, id);
      return raw;
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
      throw err;
    }

  }

  Future<bool> checkUserEmail(String email) async {
    final db = await database;
    var res = await db.query("User", where: "email = ?", whereArgs: [email]);
    if(res != null && res.isNotEmpty){
      return true;
    }else{
      return false;
    }
//    return res.isNotEmpty ? User.fromJson(res.first) : null;
  }

  Future<User> getUser(int id) async {
    final db = await database;
    var res = await db.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromJson(res.first) : null;
  }

  updateUser(User newUser) async {
    try{
      final db = await database;
      var res = await db.update("User", newUser.toMap(),
          where: "id = ?", whereArgs: [newUser.id]);
      return res;
    }catch(err){
      print('Dinal DB Error : ' + err.toString());
    }
  }

  Future<bool> userLogin(String email, String password) async {
    final db = await database;
    var res = await db.query("User", where: "email = ? AND password = ?", whereArgs: [email, password]);
    if(res != null && res.isNotEmpty){
      AppPreferences.setInt(kUserId, User.fromJson(res.first).id);
      return true;
    }else{
      return false;
    }
//    return res.isNotEmpty ? User.fromJson(res.first) : null;
  }

}