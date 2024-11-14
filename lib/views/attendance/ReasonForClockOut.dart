import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/ManageLoginState.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/attendance/Attendance_Index.dart';
import 'package:sales_toolkit/widgets/entry_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/AttendanceController.dart';
import '../../widgets/rounded-button.dart';
class ReasonForClockout extends StatefulWidget {
  final Map<String,dynamic> PassedlogoutData;
  const ReasonForClockout({Key key,this.PassedlogoutData}) : super(key: key);

  @override
  _ReasonForClockoutState createState() => _ReasonForClockoutState(
      PassedlogoutData: this.PassedlogoutData,
  );
}


class _ReasonForClockoutState extends State<ReasonForClockout> {



  AttendanceProvider attendanceProvider = AttendanceProvider();

  TextEditingController reason = TextEditingController();
  bool canShowReasonBox = false;
  bool _isLoading = false;

  final Map<String,dynamic> PassedlogoutData;
  _ReasonForClockoutState({this.PassedlogoutData});

  returnToast(String title,String message,Color color){
    // MyRouter.popPage(context);
    Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: color,
      title: title,
      message: message,
      duration: Duration(seconds: 5),
    ).show(context);
  }



  @override
  void initState() {
    // TODO: implement initState
    print('attendance Data ${PassedlogoutData}');
    super.initState();
  }


  CloseForTheDay() async{
    //print('close close');
    dynamic currentTime = DateFormat.jm().format(DateTime.now());


    Provider.of<ManageLoginState>(context,listen:false).UserNotLoggedIn();

    final SharedPreferences prefs = await SharedPreferences.getInstance();


      setState(() {
        _isLoading = true;
      });

    final Future<Map<String,dynamic>> apiResponse =  attendanceProvider.addAttendance(PassedlogoutData,AppUrl.attendanceSignOut);


    apiResponse.then((response) {

      setState(() {
        _isLoading = false;
      });


      print('this ${response}');

      if(response['status'] ==  true){

        //MyRouter.pushPage(context, AttendanceIndex());
         setState(() {
           prefs.setBool('loginState', false);
           prefs.setString('workEND', currentTime);
         });
         MyRouter.popPage(context);
        return returnToast('success','Clocked Out succesfully',Colors.green);
      }
      else {
        returnToast('error','Unable to clock-out',Colors.red);

      }

    });

  }

  otherReasons(String reason) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic currentTime = DateFormat.jm().format(DateTime.now());


    Map <String,dynamic> reasonForClockout  = {
      "AgentID": PassedlogoutData['AgentID'],
      "signId": PassedlogoutData['signId'],
      "liveDate": PassedlogoutData['outClockDate'],
      "locationLongitude": PassedlogoutData['locationLongitude'],
      "locationLatitude": PassedlogoutData['locationLatitude'],
      "statusMessage": reason,
      "Address": PassedlogoutData['Address'],
      "vendorID": PassedlogoutData['vendorID'],
      "DeviceId": PassedlogoutData['DeviceId'],
      "PlaceID": PassedlogoutData['PlaceID']
    };

    setState(() {
      _isLoading = true;
    });

    final Future<Map<String,dynamic>> apiResponse =  attendanceProvider.addAttendance(reasonForClockout,AppUrl.attendanceLive);

    apiResponse.then((response) {

      setState(() {
        _isLoading = false;
      });

      print('this ${response}');

      if(response['status'] == true){

        setState(() {
          prefs.setBool('loginState', false);
          prefs.setString('workEND', currentTime);
        });

        MyRouter.popPage(context);

        returnToast('success','Clocked Out succesfully',Colors.green);

      }
      else {
        returnToast('error','Unable to clock-out',Colors.red);

      }

      setState(() {
        // workEnd = currentTime;
        // prefs.setString('workEND', workEnd);

        // prefs.setString('workEND', currentTime);
        // workEnd = prefs.getString('workEND');

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading ,
      progressIndicator: Container(
        height: 80,
        width: 80,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:
          Icon(Icons.arrow_back_ios,color:
          ColorUtils.PRIMARY_COLOR,size: 25,),
            onPressed: (){
            MyRouter.popPage(context);
            // AttendanceIndex attendanceIndex = AttendanceIndex();
            // setState(() {
            //  attendanceIndex.
            // });
            },
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                  Text('Reason for Clock - out',style: TextStyle(color: ColorUtils.TEXT_COLOR,fontSize: 28,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),


                ],
                ),
                SizedBox(height: 30,),

                InkWell(
                  onTap: (){
                   CloseForTheDay();
                  },
                    child: clockoutBtn("End Of Day")
                ),


                SizedBox(height: 20,),
                InkWell(
                    onTap: (){
                      otherReasons("Eat Out");
                    },
                    child: clockoutBtn('Break Time',)),
                SizedBox(height: 20,),

                InkWell(
                  onTap: (){
                    setState(() {
                      canShowReasonBox =!canShowReasonBox;
                    });
                   // otherReasons(reason.text);
                  },
                    child: clockoutBtn('Other')
                ),

                SizedBox(height: 20,),
              canShowReasonBox ?  reasonBox() : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget clockoutBtn(String clockStatus, {bool canSHowOption = false,Function onTap}){
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
              border: Border.all(color: Colors.grey,width: 0.2),
            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: Column(
            children: [
              Container(
                // onPressed: (){
                //
                //   // canSHowOption ? reasonBox() : print('cannot show');
                //   if(canSHowOption){
                //     setState(() {
                //       canShowReasonBox = true;
                //     });
                //   }
                //   else{
                //     setState(() {
                //       canShowReasonBox = false;
                //
                //     });
                //   }
                //
                //   // if(canSHowOption == false){
                //   //   CloseForTheDay();
                //   // }
                // },
                child: ListTile(
                  leading: Text(clockStatus,style: TextStyle(color: ColorUtils.LOGOUT_TEXT_COLOR,fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                )
              ),
            ],
          ),
        );
  }

  Widget reasonBox(){
    return Column(
      children: [
        EntryField(editController: reason, labelText: 'State Reason', hintText: 'State Reason',keyBoard: TextInputType.multiline,minLines: 6,),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            children: [
              TextButton(onPressed: null,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.39,
                  height: MediaQuery.of(context).size.height * 0.078,
                decoration: BoxDecoration(
                    color: Color(0xffD1E6F5),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: Text('Cancel',style: TextStyle(color: Color(0xff077DBB),fontSize: 17,fontWeight: FontWeight.bold),),
                ),
              )),
              TextButton(onPressed: (){
               otherReasons(reason.text);


              },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.078,
                    decoration: BoxDecoration(
                      color: Color(0xffFF0808),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Center(
                      child: Text('Clock-out',style: TextStyle(color: Color(0xffffffff),fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }


  Widget logoutBottomSheet(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/images/clockHand.svg'),
            SizedBox(height: 20,),
            Text('You have succesfully \n Clocked Out',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Text('Your clockout time is ',style: TextStyle(color: Colors.grey,fontSize: 15),),
            SizedBox(height: 20,),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RoundedButton(buttonText: 'Close', onbuttonPressed: (){
                  MyRouter.popPage(context);
                })),

          ],
        ),
      ),
    );
  }


}
