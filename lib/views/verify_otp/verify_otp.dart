import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/verifyotp_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_toolkit/views/fingerprint_auth/fingerprint_page.dart';
import 'package:sales_toolkit/widgets/text-input-with-border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/widgets.dart';

class VerifyOtp extends StatefulWidget {
  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> with AutomaticKeepAliveClientMixin {
  TextEditingController secureCode = TextEditingController();
  TextEditingController confirmSecureCode = TextEditingController();

 void createSecureCode() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(secureCode.text.isEmpty || confirmSecureCode.text.isEmpty){
      return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.redAccent,
        title: "Error!",
        message: 'PIN values cannot be empty',
        duration: Duration(seconds: 3),
      ).show(context);
    }
    else if(confirmSecureCode.text.length != 4 || secureCode.text.length != 4){
      return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.redAccent,
        title: "Error!",
        message: 'PIN must be 4-digits',
        duration: Duration(seconds: 3),
      ).show(context);
    }
    else if(secureCode.text != confirmSecureCode.text) {
      return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.redAccent,
        title: "Error!",
        message: 'PIN values do not match',
        duration: Duration(seconds: 3),
      ).show(context);
    }
    else {
      var saveSecurcode = prefs.setString('securecode', secureCode.text);



      Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.green,
        title: "Success",
        message: 'Secure code created',
        duration: Duration(seconds: 3),
      ).show(context);

      MyRouter.pushPage(context, FingerprintPage());
    }

 }
  bool isObscured = false;

  @override
  void initState() {
    super.initState();
    isObscured = true;
    SchedulerBinding.instance.addPostFrameCallback(
          (_) => Provider.of<VerifyOtpProvider>(context, listen: false),
    );
  }

  @override


  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(

          body: _buildForm(),
        );

  }


  Widget _buildBodyList(VerifyOtpProvider verifyOtpProvider) {

       return  _buildForm();

  }



  _buildForm(){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cdlBg.png'),
              fit: BoxFit.cover,
            //  colorFilter: ColorFilter.mode(Color(0xff3593c4).withOpacity(0.7), BlendMode.darken),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                Divider(height: MediaQuery.of(context).size.height * 0.11,thickness: 0,color: Colors.transparent,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width:60,
                        height: 60,
                        child:    SvgPicture.asset("assets/images/cdl_logo.svg",
                          height: 50.0,
                          width: 50.0,),
                      ),
                    )
                  ],
                ),
                Divider(height: 25,thickness: 0,color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Create a 4-digit PIN', style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff205072),
                          fontFamily: 'Nunito Bold')),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('This code will be used to access your account \nsubsequently.', style: TextStyle(
                        color:Color(0xff205072),fontSize: 13
                      ),),

                    ],
                  ),
                ),

                Divider(height: 19,thickness: 0,color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputWithBorder(
                    isObscure: isObscured,
                    eyeOpen: isObscured,
                    onButtonPressed: (){
                      print('pressed');
                      setState(() {
                        isObscured = !isObscured;
                      });
                      print('isObsured ${isObscured}');
                    },

                      maxLenght: 4,
                    controls: secureCode,
                    isIconAvailable: false,
                   hint: 'Enter PIN',
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                  ),
                ),
                Divider(height: 8,thickness: 0,color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputWithBorder(
                    isObscure: isObscured,
                    eyeOpen: isObscured,
                    onButtonPressed: (){
                      print('pressed');
                      setState(() {
                        isObscured = !isObscured;
                      });
                      print('isObsured ${isObscured}');
                    },

                    maxLenght: 4,
                    controls: confirmSecureCode,
                    isIconAvailable: false,
                    hint: 'Confirm PIN',
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                  ),
                ),
                Divider(height: 29,thickness: 0,color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:RoundedButton(
                    onbuttonPressed: (){
                      // MyRouter.pushPage(
                      //     context,
                      //     FingerprintPage()
                      // );
                      createSecureCode();
                    },
                    buttonText: "Continue",
                  ),
                ),

                Divider(height:15,thickness: 0,color: Colors.transparent,),

                Divider(height:15,thickness: 0,color: Colors.transparent,),
              ],
            ),
          ),
        ),
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;
}

