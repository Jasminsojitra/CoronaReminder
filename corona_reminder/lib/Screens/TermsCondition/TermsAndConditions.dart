import 'package:coronareminder/Common/Global.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionView extends StatefulWidget {
  @override
  _TermsAndConditionViewState createState() => _TermsAndConditionViewState();
}

class _TermsAndConditionViewState extends State<TermsAndConditionView> {

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms & Conditions"
        ),

        centerTitle: true,
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
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: loaderColor,
        progressIndicator: getLoader(),
        child: WebView(
          initialUrl: "https://www.termsfeed.com/blog/sample-terms-and-conditions-template/",
          javascriptMode: JavascriptMode.unrestricted,

          onPageStarted: (String url) {
            isLoading = true;
            setState(() {

            });
          },
          onPageFinished: (String url) {
            isLoading = false;
            setState(() {

            });
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

}
