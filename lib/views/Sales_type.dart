import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/AppPermission.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../palatte.dart';
import '../widgets/background-image.dart';
import 'Login/login.dart';

class SalesType extends StatefulWidget {
  const SalesType({Key key}) : super(key: key);

  @override
  _SalesTypeState createState() => _SalesTypeState();
}

class _SalesTypeState extends State<SalesType> {

  //final Permission _permission;
  bool permissionEnabled = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


   isAppPermissionChecked() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkPermission = prefs.getBool('permissionEnabled');
    if(checkPermission == null){
      return true;
    }
    else {
      return false;
    }
  }

  permissionAccepted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('permissionEnabled', true);
  }


  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Builder(
        builder: (context) {

          return Stack(
            children: [
              BackgroundImage(),
              BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 140,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              height: 140,
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/images/cdl_logo2.svg",
                                        height: 50.0,
                                        width: 50.0,),
                                      SizedBox(width: 10,),
                                      Text('Sales Toolkit', style: kHeading,),

                                    ],
                                  )
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    // GestureDetector(
                                    //   onTap: () async{
                                    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    //     bool checkPermission = prefs.getBool('permissionEnabled');
                                    //     if(checkPermission == null){
                                    //       return Flushbar(
                                    //           flushbarPosition: FlushbarPosition.TOP,
                                    //           flushbarStyle: FlushbarStyle.GROUNDED,
                                    //         backgroundColor: Colors.blueAccent,
                                    //         title: 'Hold ✊',
                                    //         message: 'Please accept neccessary permissions below\n before you proceed',
                                    //         duration: Duration(seconds: 3),
                                    //       ).show(context);
                                    //     }
                                    //     else {
                                    //       MyRouter.pushPage(context, LoginScreen(login_type: 'Asset Management',));
                                    //
                                    //     }
                                    //
                                    //
                                    //
                                    //   },
                                    //   child: Column(
                                    //     crossAxisAlignment: CrossAxisAlignment.end,
                                    //     children: [
                                    //       Container(
                                    //         height: mediaSize.height * 0.26,
                                    //         width: mediaSize.width * 0.38,
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(15)),
                                    //             color: Colors.white
                                    //         ),
                                    //         child: Card(
                                    //           elevation: 0,
                                    //           child: Container(
                                    //             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    //             child: Column(
                                    //               crossAxisAlignment: CrossAxisAlignment.start,
                                    //               children: [
                                    //                 SizedBox(height: mediaSize.height * 0.01,),
                                    //                 SvgPicture.asset('assets/images/asset_mgt.svg',
                                    //                   height: 90,
                                    //                   width: 90,
                                    //                 ),
                                    //                 SizedBox(height: 10,),
                                    //                 Text('Asset \nFinance',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       )
                                    //
                                    //     ],
                                    //   ),
                                    // ),

                                    GestureDetector(
                                      onTap: () async{

                                      //  MyRouter.pushPage(context, LoginScreen(login_type: 'Loan Management',));
                                      //  MyRouter.pushPage(context, AppPermission());
                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        bool checkPermission = prefs.getBool('permissionEnabled');

                                        // if(checkPermission == null){
                                   //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
                                        //     backgroundColor: Colors.blueAccent,
                                        //     title: 'Hold ✊',
                                        //     message: 'Please accept neccessary permissions below\n before you proceed',
                                        //     duration: Duration(seconds: 3),
                                        //   ).show(context);
                                        // }
                                        // else {
                                          MyRouter.pushPage(context, LoginScreen(login_type: 'Loan Management',));

                                        // }

                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: mediaSize.height * 0.26,
                                            width: mediaSize.width * 0.38,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                color: Colors.white
                                            ),
                                            child: Card(
                                              elevation: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: mediaSize.height * 0.01,),
                                                    SvgPicture.asset('assets/images/loan_mgt.svg',
                                                      height: 90,
                                                      width: 90,
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Text('Loan \nManagement',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),




                                    SizedBox(
                                      height: 80,
                                    ),

                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                      // Center(
                      //       child: InkWell(
                      //           onTap: (){
                      //
                      //            MyRouter.pushPage(context, AppPermission());
                      //           permissionAccepted();
                      //           },
                      //           child: Text('Enable Permission',style: TextStyle(color: Colors.white),)),
                      //     )
                        ],
                      ),
                    ),
                  ),
                 ),
              ),
            ],
          );
        }
    );
  }
}
