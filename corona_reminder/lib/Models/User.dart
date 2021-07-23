class User {

  int id;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String profilePicture;
  String password;
  String registrationDate;

  User({this.id, this.firstName, this.lastName, this.mobile, this.email, this.profilePicture, this.password, this.registrationDate});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id : json["id"],
      firstName : json["firstName"],
      lastName : json["lastName"],
      mobile : json["mobile"],
      email : json["email"],
      profilePicture : json["profilePicture"],
      password : json["password"],
      registrationDate : json["registrationDate"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "mobile": mobile,
    "email": email,
    "profilePicture": profilePicture,
    "password": password,
    "registrationDate": registrationDate,
  };

}