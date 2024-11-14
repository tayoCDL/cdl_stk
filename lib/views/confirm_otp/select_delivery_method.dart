import 'dart:ui';


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/sendOtp.dart';
import 'package:sales_toolkit/views/confirm_otp/confirm_otp.dart';
import 'package:sales_toolkit/widgets/background-image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectDeliveryMethod extends StatefulWidget {
  const SelectDeliveryMethod({Key key}) : super(key: key);

  @override
  _SelectDeliveryMethodState createState() => _SelectDeliveryMethodState();
}

class _SelectDeliveryMethodState extends State<SelectDeliveryMethod> {
  @override

  Color bulbColor = Colors.black;
    String DeliveryMethod ='';
  Widget build(BuildContext context) {
    SendOtpProvider sendOtpProvider = SendOtpProvider();
        var realDelivery = '';

    var sendOTP = (String mtd) async{

        print('this is real deliver ${realDelivery}');
        final Future<Map<String,dynamic>> respose =  sendOtpProvider.twofactor(mtd);
        print('start response from login');

        print(respose.toString());

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('delivery', mtd);
        respose.then((response) {

          MyRouter.pushPage(context, ConfirmOtp());
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "OTP Sent",
            message: 'OTP has being sent to your ${mtd}',
            duration: Duration(seconds: 3),
          ).show(context);
        });



    };

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2
            ),
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Delivery Method', style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            fontFamily: 'Nunito Bold')
                        ),



                        SizedBox(height: 30,),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Text('Choose how you want to receive OTP', style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            fontFamily: 'Nunito Bold')
                        ),
                        Text('')
                      ],
                    ),
                  ),
                    SizedBox(height: 50,),
                  //
                  //
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  //   child: Container(
                  //     color: Colors.white,
                  //     child: DropDownComponent(items: ["Email Address","Phone Number",],
                  //         label: "",
                  //         selectedItem: "Email Address",
                  //         validator: (String item){
                  //
                  //         },
                  //       onChange: (String item){
                  //         setState(() {
                  //
                  //           DeliveryMethod = item;
                  //           print('this is deliery');
                  //           print(DeliveryMethod);
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),


                  InkWell(
                    onTap: (){
                      sendOTP('email');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                      height: MediaQuery.of(context).size.height * 0.125,
                      child: Card(
                        elevation: 1,
                        child: ListTile(
                          leading:  Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Icons.email_outlined,color: Colors.blue,size: 27,)),
                          title: Text('Email'),
                          subtitle: Text('Receive OTP from email'),
                          trailing: Icon(Icons.arrow_forward_ios,color: Colors.blue,size: 25,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      sendOTP('sms');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                      height: MediaQuery.of(context).size.height * 0.125,
                      child: Card(
                        elevation: 1,
                        child: ListTile(
                      leading:  Padding(
                            padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.phone_android,color: Colors.blue,size: 27,)),
                          title: Text('Phone'),
                          subtitle: Text('Receive OTP from phone'),
                          trailing: Icon(Icons.arrow_forward_ios,color: Colors.blue,size: 25,),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  //   child: RoundedButton(
                  //     onbuttonPressed: (){
                  //       sendOTP();
                  //     },
                  //     buttonText:sendOtpProvider.otpStatus == Status.Sending ?
                  //     'Processing' : sendOtpProvider.otpStatus == Status.NotSent ?
                  //     'Unable to send' : sendOtpProvider.otpStatus == Status.Sent
                  //         ? 'OTP Sent' : 'Proceed',
                  //   ),
                  // )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
