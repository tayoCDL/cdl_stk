import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sales_toolkit/domain/user.dart';
import 'package:sales_toolkit/palatte.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/auth_provider.dart';
import 'package:sales_toolkit/view_models/user_provider.dart';
import 'package:sales_toolkit/views/confirm_otp/confirm_otp.dart';
import '../../view_models/save_userRequest.dart';
import '../../widgets/widgets.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';


class LoginScreen extends StatefulWidget {
  final String login_type;
  const LoginScreen({Key key,this.login_type}):super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState(
    login_type: this.login_type
  );
}

bool isObscured = false;
bool  isAgent =  false;

class _LoginScreenState extends State<LoginScreen> {
  AuthProvider authProvider;
    String login_type;
    _LoginScreenState({this.login_type});

  @override
  void initState() {
    // signInWithAppCloak();
    isObscured = true;

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // authProvider = Provider.of<AuthProvider>(context);
    // authProvider.appCloakLogin();
  }



  final formKey = GlobalKey<FormState>();
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
   // String username,password;

  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Press back again to leave'),
    duration: snackBarDuration,
  );

  DateTime backButtonPressTime;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);


    var doLogin = (){

   //   MyRouter.pushPage(context, ConfirmOtp());

      final form = formKey.currentState;

      // if(form.validate()){
      //
      //   form.save();

      if(username.text.length < 2 && password.text.length < 2){
       return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: " Login failed!",
          message: 'Your official email address and password is required',
          duration: Duration(seconds: 6),
        ).show(context);
      }

      if(username.text.length < 2 ){
      return   Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: " Login failed!",
          message: 'Your email is required',
          duration: Duration(seconds: 6),
        ).show(context);
      }

    //  || password.text.length < 2
      if(password.text.length < 2 ){
      return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.red,
      title: " Login failed!",
      message: 'Your password is required',
      duration: Duration(seconds: 6),
      ).show(context);
      }


      else {
        final Future<Map<String,dynamic>> respose =  authProvider.login(username.text.trim(),password.text,login_type,isAgent: isAgent);
        print('start response from login ');

     //   print(respose.toString());

        respose.then((response) {

          //    print('hello__ reposs ${response}');

            if(response == null || response['status'] == null){
              return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                title: "Login failed!",
                message: 'Connection timed out',
                duration: Duration(seconds: 3),
              ).show(context);
            }

          if (response['status']) {

            User user = response['user'];

            Provider.of<UserProvider>(context, listen: false).setUser(user);

            // Navigator.pushReplacementNamed(context, '');
         //   MyRouter.pushPage(context, SelectDeliveryMethod());
            MyRouter.pushPage(context, ConfirmOtp());
          } else {

            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: "Login failed!",
              message: 'Invalid username or password',
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      }


    };

    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.transparent),
            child: CircularProgressIndicator(
              color: Colors.white,
            )),
        Text("    Please wait ...",style: TextStyle(color: Colors.white),)
      ],
    );

    return Builder(
      builder: (context) {

        return
          WillPopScope(
          onWillPop: () => handleWillPop(context),
          child:
          Stack(
            children: [
              BackgroundImage(),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2
                ),
                child: Scaffold(
                  appBar: AppBar(
                    leading: InkWell(
                        onTap: (){
                       //   MyRouter.popPage(context);
                        },
                        child: SizedBox()
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
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
                          SizedBox(
                            height: 10,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Sign In to continue to \n${login_type}', style: kHeading1_half,),
                                Text('')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Enter your official email address to continue', style: kHeading_2,),
                                Text('')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextInput(
                                      controls: username,
                                        isObsure: false,
                                        isIconAvailable: false,
                                      icon: FontAwesomeIcons.solidEnvelope,
                                      hint: 'Email Address',
                                      inputType: TextInputType.emailAddress,
                                      inputAction: TextInputAction.next,
                                    //  onSave: (value)=> username   = value,
                                   //     validate: (value)=> value.isEmpty?"Username cannot be empty":null
                                    ),

                                    // TextFormField(
                                    //   autofocus: false,
                                    //   obscureText: true,
                                    //   validator: (value)=> value.isEmpty?"Please enter password":null,
                                    //   onSaved: (value)=> username = value,
                                    //   decoration: buildInputDecoration('Enter Password',Icons.lock),
                                    // ),

                                    TextInput(
                                      controls: password,
                                      isObsure: isObscured,
                                     eyeOpen: isObscured,
                                     onButtonPressed: (){
                                        print('pressed');
                                        setState(() {
                                          isObscured = !isObscured;
                                        });
                                      print('isObsured ${isObscured}');
                                     },
                                     isIconAvailable: true,
                                      icon: FontAwesomeIcons.solidEnvelope,
                                      hint: 'Password',
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                   //   onSave: (value)=> password = value,
                                     //  validate: (value)=> value.isEmpty?  'Username cannot be empty':null,
                                    ),

                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        // Checkbox(
                                        //   value: isAgent,
                                        //   fillColor: MaterialStateProperty.all(Colors.white),
                                        //   activeColor: Colors.white,
                                        //   checkColor: Colors.black,
                                        //
                                        //   onChanged: (bool value) {
                                        //     setState(() {
                                        //       isAgent = value;
                                        //       print('>> ${isAgent}');
                                        //     });
                                        //   },
                                        // ),

                                        Checkbox(
                                          value: isAgent,
                                          fillColor: MaterialStateProperty.all(Colors.white),
                                          onChanged: (bool value) {
                                            setState(() {
                                              isAgent = value;
                                              print('>> ${isAgent}');
                                            });
                                          },
                                        ),

                                        InkWell(
                                         onTap: (){
                                           setState(() {
                                             isAgent = !isAgent;
                                             print('>> ${isAgent}');
                                           });
                                         },
                                          child: Text(
                                            'Agent/Merchant',
                                             style: kHeading2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: (){
                                      AppHelper().launchURL();
                                      },
                                      child:    Text('Forgot Password?', style: kHeading2,),
                                    ),

                                  ],
                                ),
                                // Align(
                                //   alignment: Alignment.topRight,
                                //     child:   InkWell(
                                //       onTap: (){
                                //         _launchURL(context);
                                //       },
                                //       child:    Text('Forgot Password?', style: kHeading2,),
                                //
                                //     )
                                // ),

                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),

                                    authProvider.loggedInStatus == Status.Authenticating ? loading : authProvider.loggedInStatus == Status.NotLoggedIn ?

                                          RoundedButton(
                                      onbuttonPressed: (){
                                      doLogin();
                                      },
                                      buttonText: 'Login',
                                    )
                                              :
                                    RoundedButton(
                                      onbuttonPressed: (){
                                        doLogin();
                                      },
                                      buttonText: 'Login',
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    SizedBox(
                                      height: 80,
                                    ),


                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("")));
      //Scaffold.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }

}
