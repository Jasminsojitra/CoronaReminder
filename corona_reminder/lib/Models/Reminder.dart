class Reminder {

  int id;
  int userId;
  String title;
  String description;
  String type;
  String repeat;
  String creationDate;
  String reminderDateTime;
  bool isDeleted;

  Reminder({this.id, this.userId, this.title, this.description, this.type, this.repeat, this.creationDate, this.reminderDateTime, this.isDeleted});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id : json["id"],
      userId : json["userId"],
      title : json["title"],
      description : json["description"],
      type : json["type"],
      repeat : json["repeat"],
      creationDate : json["creationDate"],
      reminderDateTime : json["reminderDateTime"],
      isDeleted : json["isDeleted"] == 0 ? false:true,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "userId": userId,
    "title": title,
    "description": description,
    "type": type,
    "repeat": repeat,
    "creationDate": creationDate,
    "reminderDateTime": reminderDateTime,
    "isDeleted" : isDeleted,
  };

}