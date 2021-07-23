import 'dart:async';
import 'dart:io';
import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Screens/Dashboard/DashboardView.dart';
import 'package:coronareminder/Screens/Login/LoginView.dart';
import 'package:coronareminder/Screens/OnBoarding/OnBoardingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  loadPreference() async {
    HttpOverrides.global = new MyHttpOverrides();

  }

  @override
  Widget build(BuildContext context) {
    loadPreference();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'SureCareNg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SureCareNg'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    loadPreference();
    Timer(Duration(seconds: 3), (){

      if(AppPreferences != null && AppPreferences.getBool(kIsLogin) != null && AppPreferences.getBool(kIsLogin)){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
              (context) => DashboardView()
            )
        );
      }else{
        if(AppPreferences != null && AppPreferences.getBool(kAppOpened) != null && AppPreferences.getBool(kAppOpened)){
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => LoginView()
              )
          );
        }else{
          AppPreferences.setBool(kAppOpened, true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => OnBoardingView()
              )
          );
        }

      }
    });
  }

  loadPreference() async {
    HttpOverrides.global = new MyHttpOverrides();
    AppPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  themeLightBlue,
                  themeDarkBlue,
                ])
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.width / 2.5,
            child: Image.asset('assets/images/app_icon.jpg'),
          ),
        )
    );
  }

}
