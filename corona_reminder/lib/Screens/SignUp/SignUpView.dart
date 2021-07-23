import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/User.dart';
import 'package:coronareminder/Screens/Dashboard/DashboardView.dart';
import 'package:coronareminder/Screens/Login/LoginView.dart';
import 'package:coronareminder/Screens/TermsCondition/TermsAndConditions.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  bool isAgree = false;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool confirmPasswordObscure = true;
  bool passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height<800?800:MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: 160,
                              width: 160,
                              child: Image.asset('assets/images/app_icon.jpg'),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: txtFirstName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter your first name",
                                labelText: "First Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: txtLastName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter your last name",
                                labelText: "Last Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: txtMobile,
                              maxLengthEnforced: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter your mobile number",
                                labelText: "Mobile",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: txtEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: txtPassword,
                              obscureText: passwordObscure,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      passwordObscure = !passwordObscure;
                                      setState(() {

                                      });
                                    },
                                    icon: Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: passwordObscure?Icon(Icons.visibility, color: Colors.black54,):Icon(Icons.visibility_off, color: Colors.black54,),
                                    )
                                ),
                                hintText: "8-12 characters password",
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: txtConfirmPassword,
                              obscureText: confirmPasswordObscure,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      confirmPasswordObscure = !confirmPasswordObscure;
                                      setState(() {

                                      });
                                    },
                                    icon: Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: confirmPasswordObscure?Icon(Icons.visibility, color: Colors.black54,):Icon(Icons.visibility_off, color: Colors.black54,),
                                    )
                                ),
                                hintText: "8-12 characters password",
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeDarkBlue),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  value: isAgree,
                                  activeColor: themeDarkBlue,
                                  onChanged: (value){
                                    isAgree = value;
                                    setState(() {

                                    });
                                  },
                                ),
                                Text(
                                  "I Agree with ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                GestureDetector(
                                  child: Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                        color: themeDarkBlue,
                                        fontSize: 15
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context)=>TermsAndConditionView()
                                    ));
                                  },
                                )
                              ],
                            ),
                          ),

                          Container(
                            height: 50,
                            width: 200,
                            margin: EdgeInsets.only(top: 20),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: themeDarkBlue, width: 1)),
                              color: Colors.white,
                              textColor: themeDarkBlue,
                              onPressed: () async {

                                String firstName = txtFirstName.text;
                                String lastName = txtLastName.text;
                                String mobile = txtMobile.text;
                                String email = txtEmail.text;
                                String password = txtPassword.text;
                                String confirmPassword = txtConfirmPassword.text;

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
                                }else if(password == null || password.length == 0){
                                  showToast("Please enter password");
                                  return;
                                }else if(password.length < 8 || password.length > 12){
                                  showToast("Password must be 8-12 characters long");
                                  return;
                                }else if(confirmPassword == null || confirmPassword.length == 0){
                                  showToast("Please enter confirm password");
                                  return;
                                }else if(password != confirmPassword){
                                  showToast("Password & Confirm Password must be same");
                                  return;
                                }else if(!isAgree){
                                  showToast("Please agree with Reminder's T&C");
                                  return;
                                }else{
                                  User newUser = User(
                                      firstName: firstName,
                                      lastName: lastName,
                                      mobile: mobile,
                                      email: email,
                                      profilePicture: "",
                                      password: password,
                                      registrationDate: DateTime.now().toString()
                                  );
                                  try{
                                    var data = await DBProvider.db.registerUser(newUser);

                                    if(data != null){
                                      setState(() {

                                        showToast("Registration successful");
                                        AppPreferences.setBool(kIsLogin, true);
                                        AppPreferences.setInt(kUserId, data);
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder:
                                                (context) => DashboardView()
                                            )
                                        );

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
                              child: Text(
                                "Start Reminding!",
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Already Have An Account? "),
                                GestureDetector(
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: themeDarkBlue
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder:
                                        (context) => LoginView()
                                      )
                                    );
                                  },
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
