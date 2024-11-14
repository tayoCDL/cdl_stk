import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_tracker.dart';

import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/auth_provider.dart';
import 'package:sales_toolkit/view_models/sendOtp.dart';
import 'package:sales_toolkit/views/verify_otp/verify_otp.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:sales_toolkit/widgets/text-input-with-border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmOtp extends StatefulWidget {
  const ConfirmOtp({Key key}) : super(key: key);

  @override
  _ConfirmOtpState createState() => _ConfirmOtpState();
}

class _ConfirmOtpState extends State<ConfirmOtp> {

  @override
  void initState() {
    // TODO: implement initState
    startTimeout();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    startTimeout();

    currentSeconds;
    super.dispose();
  }

  @override
  TextEditingController otpToken = TextEditingController();
  SendOtpProvider sendOtpProvider = SendOtpProvider();
  AuthProvider authProvider = AuthProvider();

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 300;

  int currentSeconds = 0;
  bool _isLoading = false;

  bool showTimer= false;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {

      if(mounted){
        setState(() {

          // print(timer.tick);
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds)
          {
            timer.cancel();
            showTimer = true;
          }
          // else if(timer.tick == timerMaxSeconds){
          //   setState(() {
          //     showTimer = true;
          //   });
          // }
        });
      }


    });
  }




  Widget build(BuildContext context) {

    var sendOTP = () async{

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //   prefs.setString('delivery', mtd);

      String getDelivery = prefs.getString('delivery');

      print(' getDelivery ${getDelivery}');

      final Future<Map<String,dynamic>> respose =  sendOtpProvider.twofactor('email');
      print('start response from login');

      print(respose.toString());


      respose.then((response) {

        MyRouter.pushPageReplacement(context, ConfirmOtp());
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: "OTP Sent Successfully",
          message: '.',
          duration: Duration(seconds: 3),
        ).show(context);
      });



    };


    var validateOTP = (){
      print(otpToken.text);
      if(otpToken.text.isEmpty){
        return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: "Invalid OTP!",
          message: 'Kindly enter a valid OTP',
          duration: Duration(seconds: 3),
        ).show(context);
      }
        else {
          setState(() {
            _isLoading = true;
          });
     //   final Future<Map<String,dynamic>> respose =  authProvider.encValidatefactor(otpToken.text);
          final Future<Map<String,dynamic>> respose =  sendOtpProvider.validatetwofactor(otpToken.text);
        print('start response from login');

        print(respose.toString());

        respose.then((response) {

          if(response['status'] == false){

            setState(() {
              _isLoading = false;
            });
            AppTracker().getPeople_Set(props: 'Otp Status',to: 'Unable to validate OTP');

            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.redAccent,
              title: "Invalid OTP!",
              message: 'Kindly provide a valid OTP',
              duration: Duration(seconds: 3),
            ).show(context);

          }
          else {

            setState(() {
              _isLoading = false;
            });
            AppTracker().getPeople_Set(props: 'Otp Status',to: 'Otp validated');
            MyRouter.pushPage(context, VerifyOtp());
            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.green,
              title: "OTP validated",
              message: 'Next,create a PIN',
              duration: Duration(seconds: 3),
            ).show(context);

          }

        }
        ).catchError(
                (error) => {
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.redAccent,
        title: "Server error",
        message: 'Unable to validate OTP',
        duration: Duration(seconds: 3),
        ).show(context)
        });
      }



    };


    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/newBg.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Color(0xff3593c4).withOpacity(0.7), BlendMode.darken),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset("assets/images/cdl_logo2.svg",
                              height: 50.0,
                              width: 50.0,),
                            SizedBox(width: 10,),


                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(height: 15,thickness: 0,color: Colors.transparent,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Verify Your Details', style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Nunito Bold')),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Please enter the code sent to your email address', style: TextStyle(
                              color: Colors.white,fontSize: 13
                          ),),

                        ],
                      ),
                    ),
                    Divider(height: 55,thickness: 0,color: Colors.transparent,),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[

                               Column(
                                 children: <Widget>[
                                   SizedBox(height: 40,),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                          TextInputWithBorder(
                                          controls: otpToken,
                                          isIconAvailable: false,
                                          hint: 'Enter OTP',
                                          inputType: TextInputType.name,
                                          inputAction: TextInputAction.next,
                                        ),
                                      ],
                                    )


                                  )

                                 ],
                               ),
                                SizedBox(height: 30,),
                                RoundedButton(
                                  onbuttonPressed: (){
                                 //   MyRouter.pushPage(context, MainScreen());
                                    validateOTP();
                                  },
                                  buttonText: "Continue",
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                showTimer == false ?  Center(
                                    child: Text("Didn't get OTP? Resend in ${timerText} mins")
                                  ) : Center(
                                    child: InkWell(
                                        onTap: (){
                                          sendOTP();
                                        },
                                        child: Text('Resend OTP',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),))
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
          ),
    );

  }
}
