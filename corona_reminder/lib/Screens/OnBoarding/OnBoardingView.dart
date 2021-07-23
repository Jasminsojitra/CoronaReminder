import 'package:coronareminder/Common/Global.dart';
import 'package:coronareminder/Screens/Login/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnBoardingView extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {

  List<PageViewModel> pageList = List<PageViewModel>();
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width - 50;
    pageList = [
      PageViewModel(
        pageColor: themeLightBlue,
        iconColor: null,
        bubbleBackgroundColor: Colors.transparent,
        mainImage: Image.asset(
          'assets/images/app_icon.jpg',
          height: 200.0,
          width: 200.0,
          alignment: Alignment.center,
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Text('Corona Reminder'),
        ),
        titleTextStyle: TextStyle(color: themeDarkBlue, fontSize: 30, fontWeight: FontWeight.w600),
        body: Text(
          'Reminding solution for you to stay safer and healthier.',
        ),
        bodyTextStyle: TextStyle(color: themeDarkBlue, fontSize: 25,),
        iconImageAssetPath: 'assets/onboarding/reminder.png',
      ),
      PageViewModel(
        pageColor: themeDarkBlue,
        iconColor: null,
        bubbleBackgroundColor: Colors.transparent,
        mainImage: Container(
          height: screenWidth,
          width: screenWidth,
          decoration: new BoxDecoration(
            color: themeLightBlue,
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
            child: Image.asset(
              'assets/onboarding/sanitizing_main.png',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Text('Sanitizing'),
        ),
        titleTextStyle: TextStyle(color: themeLightBlue, fontSize: 30, fontWeight: FontWeight.w600),
        body: Text(
          'Set reminder for you to sanitize time to time.',
        ),
        bodyTextStyle: TextStyle(color: themeLightBlue, fontSize: 25,),
        iconImageAssetPath: 'assets/onboarding/sanitizing.png',
      ),
      PageViewModel(
        pageColor: themeLightBlue,
        iconColor: null,
        bubbleBackgroundColor: Colors.transparent,
        mainImage: Container(
          height: screenWidth,
          width: screenWidth,
          decoration: new BoxDecoration(
            color: themeDarkBlue,
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
            child: Image.asset(
              'assets/onboarding/hand-wash_main.png',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Text('Hand Wash'),
        ),
        titleTextStyle: TextStyle(color: themeDarkBlue, fontSize: 30, fontWeight: FontWeight.w600),
        body: Text(
          'Set reminder for you to wash your hands on time.',
        ),
        bodyTextStyle: TextStyle(color: themeDarkBlue, fontSize: 25,),
        iconImageAssetPath: 'assets/onboarding/hand-wash.png',
      ),
      PageViewModel(
        pageColor: themeDarkBlue,
        iconColor: null,
        bubbleBackgroundColor: Colors.transparent,
        mainImage: Container(
          height: screenWidth,
          width: screenWidth,
          decoration: new BoxDecoration(
            color: themeLightBlue,
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
            child: Image.asset(
              'assets/onboarding/medication_main.png',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Text('Medication'),
        ),
        titleTextStyle: TextStyle(color: themeLightBlue, fontSize: 30, fontWeight: FontWeight.w600),
        body: Text(
          'Set reminder so that you don\'t forget to take medication.',
        ),
        bodyTextStyle: TextStyle(color: themeLightBlue, fontSize: 25,),
        iconImageAssetPath: 'assets/onboarding/medication.png',
      ),
      PageViewModel(
        pageColor: themeLightBlue,
        iconColor: null,
        bubbleBackgroundColor: Colors.transparent,
        mainImage: Container(
          height: screenWidth,
          width: screenWidth,
          decoration: new BoxDecoration(
            color: themeDarkBlue,
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(screenWidth/2)),
            child: Image.asset(
              'assets/onboarding/distancing_main.png',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Text('Medication'),
        ),
        titleTextStyle: TextStyle(color: themeDarkBlue, fontSize: 30, fontWeight: FontWeight.w600),
        body: Text(
          'Set reminder so that you remember to maintain social distance.',
        ),
        bodyTextStyle: TextStyle(color: themeDarkBlue, fontSize: 25,),
        iconImageAssetPath: 'assets/onboarding/distancing.png',
      )
    ];
    return IntroViewsFlutter(
      pageList,
      onTapDoneButton: (){
        //Void Callback
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
            (context) => LoginView()
          )
        );
      },
      onTapSkipButton: (){
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
            (context) => LoginView()
          )
        );
      },
      showSkipButton: true,
      pageButtonTextStyles: new TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontFamily: "Regular",
      ),
    );
  }

}
