import 'package:coronareminder/Common/Database.dart';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Models/User.dart';
import 'package:coronareminder/Screens/Dashboard/DashboardView.dart';
import 'package:coronareminder/Screens/SignUp/SignUpView.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  void initState() {
    // TODO: implement initState

  }

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

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
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
//                    width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              color: Colors.white,
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
                      margin: EdgeInsets.only(top: 30),
                      child: TextField(
                        controller: txtEmail,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(), // move focus to next
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
                          hintText: "Enter your Password",
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

                    getLoginButton(),

                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't Have An Account? "),
                          GestureDetector(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: themeDarkBlue
                              ),
                            ),
                            onTap: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) => SignUpView()
                                  )
                              );
//                              Navigator.push(context, MaterialPageRoute(
//                                builder: (context)=>SignUpView()
//                              ));
                            },
                          )
                        ],
                      ),
                    ),

                    Container(
                      height: 50,
                      child: GestureDetector(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: themeDarkBlue
                          ),
                        ),
                        onTap: (){
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context)=>ResetPasswordView()
//                        ));
                        },
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget getLoginButton() {
    return Container(
      height: 50,
      width: 200,
      margin: EdgeInsets.only(top: 30, bottom: 20),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: themeDarkBlue, width: 1)),
        color: Colors.white,
        textColor: themeDarkBlue,
        onPressed: () async {

          String email = txtEmail.text;
          String password = txtPassword.text;

          if(email == null || email.length == 0){
            showToast("Please enter your email address");
            return;
          }else if(!isValidEmail(email)){
            showToast("Please enter proper email address");
            return;
          }else if(password == null || password.length == 0){
            showToast("Please enter password");
            return;
          }else{
            bool isExist = await DBProvider.db.checkUserEmail(email);

            if(!isExist){
              showToast("Email id does not exist");
            }else{
              bool isCorrect = await DBProvider.db.userLogin(email, password);
              if(!isCorrect){
                showToast("Password doesn't match");
              }else{
                AppPreferences.setBool(kIsLogin, true);
                showToast("Login successful");

                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                    (context) => DashboardView()
                  )
                );
              }
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
    );
  }
}
