import 'dart:io';
import 'dart:ui';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
//import 'package:in_app_update/in_app_update.dart';
import 'package:sales_toolkit/api/local_auth_api.dart';
import 'package:sales_toolkit/components/numeric_pad.dart';

import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/Login/login.dart';
import 'package:sales_toolkit/views/fingerprint_auth/scrollable_test.dart';

import 'package:sales_toolkit/views/main_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/save_userRequest.dart';
import '../../widgets/widgets.dart';
import 'package:another_flushbar/flushbar.dart';
// import 'package:in_app_update/in_app_update.dart';


class FingerprintPage extends StatefulWidget {

  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

class _FingerprintPageState extends State<FingerprintPage> {

  String code ='';


// AppUpdateInfo _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       _updateInfo = info;
  //     });
  //    // print('app Update ${_updateInfo}');
  //   }).catchError((e) => print(e));
  // }

  // void _showError(dynamic exception) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
  // }


  @override
  void initState() {
   // HiveMethods().readCredential(1);

   // checkForUpdate();
    // TODO: implement initState

   // _updateInfo?.updateAvailable ==  true ? isUpdateAvailable(): null;
   //
   //  _updateInfo?.updateAvailable == true
   //      ? () {
   //    InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
   //  }
   //      : null;

    super.initState();
  //  isUpdateAvailable();
  }

getLoanOfficerId() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // int
  int staffId = prefs.getInt('staffId');
    setState(() {

    });
}

  // isUpdateAvailable(){
  //   return alert(
  //     context,
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text('Add Note'),
  //         InkWell(
  //             onTap: (){
  //               MyRouter.popPage(context);
  //             },
  //             child: Icon(Icons.clear))
  //       ],  ),
  //     content: Text(''),
  //     textOK: Container(
  //       width: MediaQuery.of(context).size.width * 0.3,
  //       child: RoundedButton(buttonText: 'Update',onbuttonPressed: (){
  //         InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
  //
  //       },
  //       ),
  //     ),
  //   );
  // }



  // final versionCheck = VersionCheck(
  //   packageName: Platform.isIOS
  //         ? 'com.creditdirect.sales_toolkit'
  //       : 'com.creditdirect.sales_toolkit',
  //   packageVersion: '1.0.1',
  //   showUpdateDialog: customShowUpdateDialog,
  // );
  //
  // Future checkCurrentVersion() async {
  //
  //  var satAwait =  await versionCheck.checkVersion(context);
  // // print('scatWait ${satAwait.toString()}');zxxxxx
  //   setState(() {
  //     // print('this is a test ${version}');
  //     version = versionCheck.packageVersion;
  //     packageName = versionCheck.packageName;
  //     storeVersion = versionCheck.storeVersion;
  //     storeUrl = versionCheck.storeUrl;
  //   });
  //
  // }
  //
  //
  // checkVersioning(){
  //   final Version currentVersion = new Version(1, 0, 3);
  //   final Version latestVersion = Version.parse("2.1.0");
  //
  //   if (latestVersion > currentVersion) {
  //     print("Update is available");
  //   }
  //
  //   final Version betaVersion =
  //   new Version(2, 1, 0, preRelease: <String>["beta"]);
  //   // Note: this test will return false, as pre-release versions are considered
  //   // lesser then a non-pre-release version that otherwise has the same numbers.
  //   if (betaVersion > latestVersion) {
  //     print("More recent beta available");
  //   }
  // }


  @override
  Widget build(BuildContext context) {

    forgotPin() async{

        return alert(
          context,
          title: Text('Forgot PIN ?',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
          content: Text('This will revalidate your PIN\n & force you to revalidate \n your login.\n ARE YOU SURE ?'),
          textOK: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                  child: RoundedButton(buttonText: 'Yes', onbuttonPressed: (){
                    ReforgotPin();
                  })
              ),
            SizedBox(width: 10,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.43,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  // color: Color(0xff077DBB),
                    borderRadius: BorderRadius.circular(1),
                    border: Border.all(
                        width: 1,
                        color: Colors.blue
                    )
                ),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: (){
                    MyRouter.popPage(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Color(0xff077DBB),fontFamily: 'Nunito SansRegular'),

                  ),
                ),
              ),

            ],
          )
        );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('userId');
      prefs.remove('username');
      prefs.remove('base64EncodedAuthenticationKey');
      prefs.remove('authenticated');
      prefs.remove('officeName');
      prefs.remove('staffDisplayName');
      prefs.remove('securecode');
      prefs.remove('tfa-token');

      MyRouter.pushPageReplacement(context, LoginScreen());
    }

    return Stack(
      children: [
        BackgroundImage(),
        BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 1
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    // Center(
                    //   child: buildAuthentic(context)
                    // ),
                    SizedBox(height: 50,),
                    Center(
                      child: Text('Enter your PIN',style: TextStyle(color: Colors.white,fontFamily: 'Nunito SansRegular'),),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        buildCodeNumberBox(code.length > 0 ? "•" : ""),
                        buildCodeNumberBox(code.length > 1 ? "•" : ""),
                        buildCodeNumberBox(code.length > 2 ? "•" : ""),
                        buildCodeNumberBox(code.length > 3 ? "•" : ""),

                      ],
                    ),

                    SizedBox(height: 20,),
                    Center(
                      child: InkWell(
                        onTap: () async{
                          forgotPin();
                        },
                          child: Text('I forgot my PIN',style: TextStyle(color: Colors.white,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),)),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: NumericPad(
                        onNumberSelected: (value) async{
                          print("value ${value}");
                          setState(() {
                            if(value != -1){

                              if(code.length < 4){
                                code = code + value.toString();
                              }

                            }
                            else{
                              code = code.substring(0, code.length - 1);
                            }
                            print('this is code ${code}');
                          });

                          if(code.length == 4){
                          checkPass(code);
                          }
                        },
                      ),
                    ),
                   // Container(
                   //   height: 50,
                   //     child: cancelAll()
                   // ),
                   //
                    SizedBox(height: 60,),

                    // _updateInfo == true ?
                    // Center(
                    //   child: Text('Update is available ',style: TextStyle(color: Colors.white),),
                    // ) : SizedBox(),
                    Center(
                      child: Text('Current Version: 2.49',style: TextStyle(color: Colors.white),),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget cancelAll() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          MyRouter.pushPageReplacement(context, FingerprintPage());
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(

            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text('Clear All',style: TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }


  updateDialog(){
    return alert(
      context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('New version available',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
                  Text('Delivering a better and smoother\n experience for you..',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w300),),
            ],
          ),
        ],),
      content: Text(''),
      textOK: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.6,
        child: RoundedButton(buttonText: 'Update Now', onbuttonPressed:

        // _updateInfo?.updateAvailability ==
        //     UpdateAvailability.updateAvailable
        //     ? () {
        //   InAppUpdate.performImmediateUpdate()
        //       .catchError((e) => print(e.toString()));
        // }
        //     :
        null,

        ),
      ),
    );
  }

  Widget buildAuthentic(BuildContext context){
    return IconButton(onPressed: () async{
      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => MainScreen()),
        // );
     //   MyRouter.pushPage(context, MainScreen());


        // if(  _updateInfo?.availableVersionCode != null && _updateInfo.flexibleUpdateAllowed == true  ){
        //   updateDialog();
        // }
        // else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // int
          int staffId = prefs.getInt('staffId');

          MyRouter.pushPage(context, MainScreen(passedLoanOfficerId: staffId,));
        // }


        // MyRouter.pushPage(context, BottomSheetDemo());
      }
      else {
        print('err<<');
      }
    }, icon: Icon(Icons.fingerprint,color: Colors.white,size: 50,));
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:3),
      child: SizedBox(
        width: 26,
        height: 26,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.05)
              )
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Montserrat Medium',
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkPass(String code) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
      var secureCode = prefs.getString('securecode');
        prefs.remove('clientId');
        prefs.remove('leadId');
        prefs.remove('employerResourceId');
        prefs.remove('tempEmployerInt');
        prefs.remove('tempNextOfKinInt');
        prefs.remove('tempResidentialInt');
        prefs.remove('tempBankInfoInt');
    print(secureCode);
      if(secureCode != code){
        print('code checker ${code}');
        setState(() {

        });
        print('code checker ${code}');
            MyRouter.pushPageReplacement(context, FingerprintPage());
      return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Failed!",
          message: 'PIN Incorrect',
          duration: Duration(seconds: 3),
        ).show(context);
      }
      else {
     //   MyRouter.pushPage(context, MainScreen());
     //      if(  _updateInfo?.availableVersionCode != null && _updateInfo.flexibleUpdateAllowed == true  ){
     //        updateDialog();
     //      }
         // else {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            // int
            int staffId = prefs.getInt('staffId');

            MyRouter.pushPage(context, MainScreen(passedLoanOfficerId: staffId,));
         //  }

      //

      }

  }



  void ReforgotPin() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('securecode');
    prefs.remove('tfa-token');
    prefs.remove('base64EncodedAuthenticationKey');

    MyRouter.pushPageReplacement(context, LoginScreen());
  }


}


