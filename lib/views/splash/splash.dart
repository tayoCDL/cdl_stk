import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/Login/login.dart';
import 'package:sales_toolkit/views/Sales_type.dart';
import 'package:sales_toolkit/views/fingerprint_auth/fingerprint_page.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_toolkit/views/verify_otp/verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Widget page = MainScreen();

  @override
  void initState(){
    super.initState();
    checkLogin();
    Timer(Duration(seconds: 2), () => MyRouter.pushPageReplacement(context, page));
  }



  startTimeout() {
    return new Timer(Duration(seconds: 2), handleTimeout);
  }

  void checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print('token is ${prefs}');
//    String token = await preferences.get("token");
      if(prefs.getString('base64EncodedAuthenticationKey') == null && prefs.getString('tfa-token') == null){
        setState(() {
          page = LoginScreen(login_type: 'Loan Management',);
          //page = VerifyOtp();

        });
      }

   else if (prefs.getString('tfa-token') != null && prefs.getString('securecode') != null) {
      setState(() {
        page = FingerprintPage();
        //page = VerifyOtp();

      });
    }

    else if(prefs.getString('tfa-token') != null && prefs.getString('securecode') == null){
      setState(() {
        page = VerifyOtp();
      });
    }
    else {
      setState(() {
        page = LoginScreen(login_type: 'Loan Management',);
      });
    }

  }


  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    MyRouter.pushPageReplacement(
      context,
      page,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            SvgPicture.asset("assets/images/cdl_logo.svg",
             height: 50.0,
              width: 50.0,)
            // Image.asset(
            //   "assets/images/app-icon.png",
            //   height: 300.0,
            //   width: 300.0,
            // ),
          ],
        ),
      ),
    );
  }
}
