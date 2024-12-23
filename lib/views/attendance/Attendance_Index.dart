// import 'dart:async';
//
// import 'package:another_flushbar/flushbar.dart';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_toolkit/util/enum/ManageLoginState.dart';
// import 'package:sales_toolkit/util/router.dart';
// import 'package:sales_toolkit/views/attendance/ReasonForClockOut.dart';
// import 'package:sales_toolkit/views/attendance/attendance_statistics.dart';
// import 'package:sales_toolkit/widgets/rounded-button.dart';
// import 'package:sales_toolkit/widgets/shared/agentCode.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tab_indicator_styler/tab_indicator_styler.dart';
// import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
//
// import '../../util/app_url.dart';
// import '../../view_models/AttendanceController.dart';
// import '../../view_models/CodesAndLogic.dart';
// import '../../view_models/apiHandler.dart';
//
// class AttendanceIndex extends StatefulWidget {
//   const AttendanceIndex({Key key}) : super(key: key);
//
//   @override
//   _AttendanceIndexState createState() => _AttendanceIndexState();
// }
//
// class _AttendanceIndexState extends State<AttendanceIndex> {
//  // List<Marker> myMarker = [];
//   bool isLoggedIn  = false;
//   double draggedLatitude;
//   double draggedLongitude;
//
//
//   Completer<GoogleMapController> _controllerGogleMap = Completer();
//   GoogleMapController newGoogleController;
//
//   AttendanceProvider attendanceProvider = AttendanceProvider();
//
//   var uuid = Uuid();
//
//   Position currentPosition;
//   Position newPosition;
//   LatLng draggedLocation;
//   var geoLocatior = Geolocator();
//   String placedAddress ='';
//
//   Timer _timerForInter;
//
//   String realAddress = '';
//   var Dlatitude;
//   var Dlongitude;
//   String agentCode = 'N/A';
//   var startTime = '';
//   var workEnd = '';
//   bool _isLoading = false;
//
//
//
//   void locatePosition() async{
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
//     currentPosition = position;
//     print('this is position ${position}');
//     LatLng latLngPosition = LatLng((position.latitude), position.longitude);
//
//     setState(() {
//       Dlatitude = position.latitude;
//       Dlongitude = position.longitude;
//     });
//
//     print('this is DLongs ${Dlatitude} and ${Dlongitude}');
//
//     CameraPosition cameraPosition = new CameraPosition(target: latLngPosition,zoom: 14.0);
//     newGoogleController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//
//     String address = await AssistantMethods.searchCordinateaddress(position);
//    // print('location longitude and latiude ${position.longitude} ${position.latitude}');
//
//     setState(() {
//       realAddress = address;
//     });
//     print('This is your address :: ' + address);
//
//   }
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//
//
//   Widget loginSuccessfulSheet(){
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
//       child: Center(
//         child: Column(
//           children: [
//             SvgPicture.asset('assets/images/clockHand.svg'),
//             SizedBox(height: 20,),
//                 Text('You have succesfully \n Clocked In',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),textAlign: TextAlign.center,),
//               SizedBox(height: 20,),
//             Text('Your arrival time is ${startTime}',style: TextStyle(color: Colors.grey,fontSize: 15),),
//             SizedBox(height: 20,),
//             Container(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 child: RoundedButton(buttonText: 'Close', onbuttonPressed: (){
//                   MyRouter.popPage(context);
//                 })),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget showreasonSheet(){
//     return Container(
//
//       padding: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
//       child: Center(
//         child: Column(
//           children: [
//             SvgPicture.asset('assets/images/clockHand.svg'),
//             SizedBox(height: 20,),
//             Text('You have succesfully \n Clocked In',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),textAlign: TextAlign.center,),
//             SizedBox(height: 20,),
//             Text('Your arrival time is ${startTime}',style: TextStyle(color: Colors.grey,fontSize: 15),),
//             SizedBox(height: 20,),
//             Container(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 child: RoundedButton(buttonText: 'Close', onbuttonPressed: (){
//                   MyRouter.popPage(context);
//                 })),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   signinUser() async{
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//
//     DateTime myDatetime = DateTime.parse(DateTime.now().toString());
//     String isoDate = myDatetime.toIso8601String();
//
//     dynamic currentTime = DateFormat.jm().format(DateTime.now());
//
//     Map<String,dynamic> attendanceData = {
//       "AgentID": agentCode,
//       "inClockDate": isoDate,
//       "locationLongitude": Dlongitude,
//       "locationLatitude": Dlatitude,
//       "type": "in",
//       "Address": realAddress,
//       "vendorID": 292472,
//       "DeviceId": uuid.v4(),
//       "PlaceID": "2345678901202928383838383"
//     };
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final Future<Map<String,dynamic>> apiResponse =  attendanceProvider.addAttendance(attendanceData,AppUrl.attendancesignIn);
//
//     apiResponse.then((response) async{
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       print('this ${response}');
//       if(response['status'] == true){
//
//         var attendance = response['data']['signId'];
//
//         String deviceID = attendance['deviceId'];
//         String clockInDate = attendance['inClockDate'];
//         int signinId = attendance['id'];
//         prefs.setString('deviceID', deviceID);
//         prefs.setInt('SignInID', signinId);
//         prefs.setString('clockInDate',clockInDate);
//         prefs.setBool('loginState', true);
//
//         setState(() {
//          // startTime = currentTime;
//           print('this is start time ${startTime}');
//           prefs.setString('workStart', currentTime);
//
//           startTime = prefs.getString('workStart');
//           workEnd = '';
//         });
//
//         showModalBottomSheet(
//           context: context,
//
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//           ),
//           builder: ((builder) => loginSuccessfulSheet()),
//         );
//
//       } else{
//         return     Flushbar(
//                 flushbarPosition: FlushbarPosition.TOP,
//                 flushbarStyle: FlushbarStyle.GROUNDED,
//           backgroundColor: Colors.red,
//           title: 'Error',
//           message: 'Unknown error,try again',
//           duration: Duration(seconds: 6),
//         ).show(context);
//       }
//
//     });
//
//   }
//
//   logoutUser() async{
//     print('logout');
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//       String passedDeviceID = prefs.getString('deviceID');
//       int signedIn = prefs.getInt('SignInID');
//
//     dynamic currentTime = DateFormat.jm().format(DateTime.now());
//
//
//     DateTime myDatetime = DateTime.parse(DateTime.now().toString());
//     String isoDate = myDatetime.toIso8601String();
//
//
//     Map<String,dynamic> attendanceData = {
//       "AgentID": agentCode,
//       "signId": signedIn,
//       "outClockDate": isoDate,
//       "locationLongitude": Dlongitude,
//       "locationLatitude": Dlatitude,
//       "type": "out",
//       "Address": realAddress,
//       "vendorID": 292472,
//       "DeviceId": passedDeviceID,
//       "PlaceID": "2345678901202928383838383"
//     };
//
//
//     MyRouter.pushPage(context, ReasonForClockout(
//       PassedlogoutData: attendanceData,
//     ));
//
//
//
//   }
//
//
//
//
//   toggleAttendance() async{
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//    // bool userLogin = Provider.of<ManageLoginState>(context).LogInStatus;
//
//
//     Provider.of<ManageLoginState>(context,listen:false).UserLoggedIn();
//     //
//     // setState(() {
//     //   isLoggedIn = !isLoggedIn;
//     // });
//     //
//     // prefs.setBool('loginState', isLoggedIn);
//     //
//     //
//     // if(isLoggedIn == true){
//     //  logoutUser();
//     // }
//     // else {
//       signinUser();
//
//
//
//
//     // }
//
//   }
//
//
//   getStaffID() async{
//     final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData();
//     respose.then(
//             (response) {
//            print('this is referal ${response['data']}');
//           setState(() {
//             agentCode = response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'];
//
//           });
//
//         }
//     );
//
//   }
//
//
//   getAttendanceInfo() async{
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//    // String Vusername = prefs.getString('username');
//
//  //   bool userLogin = Provider.of<ManageLoginState>(context).LogInStatus;
//
//     setState(() {
//       startTime = prefs.getString('workStart');
//       workEnd = prefs.getString('workEND');
//       //
//       if(isLoggedIn == null){
//         isLoggedIn = false;
//       }
//
//       isLoggedIn =   prefs.get('loginState');
//      // isLoggedIn = prefs.setBool('loginState', userLogin) as bool;
//
//
//     });
//
//     print('current Login State ${isLoggedIn}');
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     print('Agent code');
//     getStaffID();
//
//     _timerForInter = Timer.periodic(Duration(seconds: 2), (result) {
//       getAttendanceInfo();
//     });
//
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _timerForInter?.cancel();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     bool userLogin = Provider.of<ManageLoginState>(context).isLoggedIn;
//
//     return LoadingOverlay(
//       isLoading: _isLoading ,
//       progressIndicator: Container(
//         height: 80,
//         width: 80,
//         child:  Lottie.asset('assets/images/newLoader.json'),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Color(0xff077DBB),),
//             onPressed: (){
//               MyRouter.popPage(context);
//             },
//           ),
//           title: Text('Attendance',style: TextStyle(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
//           backgroundColor: Colors.white,
//         ),
//         body: SingleChildScrollView(
//               child: Container(
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     Container(
//                         height: MediaQuery.of(context).size.height * 0.9,
//                         child: TabStatus()
//                     )
//                   ],
//                 ),
//               ),
//         ),
//       ),
//     );
//   }
//
//
//
//   Widget TabStatus(){
//     return DefaultTabController(
//         length: 2,
//         initialIndex: 0,
//         child: Scaffold(
//           appBar: AppBar(
//             toolbarHeight: 10,
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.white,
//             bottom:   TabBar(
//               indicatorColor: Colors.red,
//               tabs: [
//                 Tab(
//                   child: Text('Clock In',style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Nunito SansRegular'),),
//                 ),
//                 Tab(
//                   child: Text('Statistics',style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Nunito SansRegular'),),
//                 ),
//               ],
//               labelColor: Colors.black,
//               indicatorSize: TabBarIndicatorSize.tab,
//               indicator: MaterialIndicator(
//                   height: 4,
//                   topLeftRadius: 0,
//                   topRightRadius: 0,
//                   bottomLeftRadius: 0,
//                   bottomRightRadius: 0,
//                   tabPosition: TabPosition.bottom,
//                   color: Color(0xff077DBB)
//               ),
//             ),
//           ),
//           body: TabBarView(
//             children: [
//             ClockIn(),
//               Statistics(PassedagentCode: agentCode)
//             ],
//           ),
//         )
//
//
//     );
//   }
//
//
//
//   Widget ClockIn(){
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
//       child: Column(
//         children: [
//           CurrentDateAndLocation(),
//           SizedBox(height: 20,),
//           WorkCounter()
//         ],
//       ),
//     );
//
//   }
//
//
//
//   Widget CurrentDateAndLocation(){
//       return  Container(
//         padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(20))
//
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Current Date:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                 Text('08 Aug, 2022')
//               ],
//             ),
//             SizedBox(height: 15,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Store Location',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//              //   Text('Approved',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
//               ],
//             ),
//             SizedBox(height: 10,),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//
//                 Container(
//                   height:0.5,
//
//                   width: 1.0,
//                   child:     GoogleMap(
//                     mapType: MapType.normal,
//                     myLocationButtonEnabled: true,
//                     initialCameraPosition: _kGooglePlex,
//                     myLocationEnabled: true,
//                     zoomGesturesEnabled: true,
//                     zoomControlsEnabled: true,
//                  //   markers: Set.from(myMarker),
//
//                     onMapCreated: (GoogleMapController controller){
//                       _controllerGogleMap.complete(controller);
//                       newGoogleController = controller;
//
//                       locatePosition();
//                     },
//                   ),
//                 ),
//
//                 Row(
//                   children: [
//                     Icon(Icons.place,color: Colors.grey,),
//                    // Text(realAddress,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w200),),
//                     CheckTextLenght(realAddress)
//                   ],
//                 ),
//                 InkWell(
//                     onTap: null,
//                     child: Row(
//                       children: [
//                         Text('On-Site',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),),
//                         SizedBox(width: 10,),
//                         Icon(Icons.radio_button_checked_outlined,color: Color(0xff1CB164),size: 12,)
//                       ],
//                     )
//                 )
//               ],
//             ),
//           ],
//         ),
//       );
//   }
//
//   Widget CheckTextLenght(String text){
//       int textLenght = text.length;
//     String newText =   textLenght > 40 ? text.substring(0,30) + " ..." : text;
//     return Text(newText);
//   }
//
//   Widget WorkStart(){
//
//    // bool userLoginStatus = Provider.of<ManageLoginState>(context).isLoggedIn;
//
//   return
//     GestureDetector(
//       onTap: (){
//
//         toggleAttendance();
//
//       },
//       child: AvatarGlow(
//         glowColor: isLoggedIn ==  true ? Color(0xffFF0808) : Color(0xff1CB164),
//         endRadius: 90.0,
//         duration: Duration(milliseconds: 1000),
//         repeat: true,
//         animate: true,
//         showTwoGlows: true,
//         repeatPauseDuration: Duration(milliseconds: 10),
//         child: Material(     // Replace this child with your own
//           elevation: 14.0,
//
//           shape: CircleBorder(),
//           child: CircleAvatar(
//             backgroundColor:isLoggedIn == true ? Color(0xffFF0808) : Color(0xff1CB164),
//             child: Container(
//               child: Center(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 30,),
//                     Text('Tap here to',style: TextStyle(color: Colors.white,fontSize: 13),),
//                     SizedBox(height: 7,),
//                     Text( isLoggedIn == true ? 'End Work' : 'Start Work',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
//                     SizedBox(height: 7,),
//                     Text('07:58:23',style: TextStyle(color: Colors.white,fontSize: 13),)
//                   ],
//                 ),
//               ),
//             ),
//             radius: 64.0,
//           ),
//         ),
//       ),
//     );
//
//
//   }
//
//   Widget WorkEnd(){
//
//   //  bool userLoginStatus = Provider.of<ManageLoginState>(context).isLoggedIn;
//
//     return
//       GestureDetector(
//         onTap: (){
//
//           logoutUser();
//
//         },
//         child: AvatarGlow(
//           glowColor: isLoggedIn ==  true ? Color(0xffFF0808) : Color(0xff1CB164),
//           endRadius: 90.0,
//           duration: Duration(milliseconds: 1000),
//           repeat: true,
//           animate: true,
//           showTwoGlows: true,
//           repeatPauseDuration: Duration(milliseconds: 10),
//           child: Material(     // Replace this child with your own
//             elevation: 14.0,
//
//             shape: CircleBorder(),
//             child: CircleAvatar(
//               backgroundColor:isLoggedIn == true ? Color(0xffFF0808) : Color(0xff1CB164),
//               child: Container(
//                 child: Center(
//                   child: Column(
//                     children: [
//                       SizedBox(height: 30,),
//                       Text('Tap here to',style: TextStyle(color: Colors.white,fontSize: 13),),
//                       SizedBox(height: 7,),
//                       Text( isLoggedIn == true ? 'End Work' : 'Start Work',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
//                       SizedBox(height: 7,),
//                       Text('07:58:23',style: TextStyle(color: Colors.white,fontSize: 13),)
//                     ],
//                   ),
//                 ),
//               ),
//               radius: 64.0,
//             ),
//           ),
//         ),
//       );
//
//
//   }
//
//
//   Widget workCard({String work_type = '', String work_hr = ''}){
//     return Container(
//       //color: Color(0xffEEF1F6),
//       width: MediaQuery.of(context).size.width * 0.36,
//       padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//         color: Color(0xffEEF1F6),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(work_type == null ? '' : work_type,style: TextStyle(color: Colors.grey,fontSize: 15),),
//           SizedBox(height: 5,),
//           Text(work_hr == null ? '' : work_hr,style: TextStyle(color: Color(0xff707070),fontWeight: FontWeight.bold,fontSize: 17),)
//         ],
//       ),
//     );
//   }
//
//
//   Widget WorkCounter(){
//   //  bool userLogin = Provider.of<ManageLoginState>(context).LogInStatus;
//
//
//     return Container(
//       //height: MediaQuery.of(context).size.height * 0,
//       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//         color: Colors.white
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//              workCard(work_type: "Work Starts",work_hr: startTime),
//                workCard(work_type: "Work Ends",work_hr: workEnd),
//             ],
//           ),
//           SizedBox(height: 20,),
//           isLoggedIn == true ? WorkEnd() : WorkStart(),
//           SizedBox(height: 10,),
//           Text('Note: You will not be able to perform this action \nwhile you are off-site',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.center,)
//         ],
//       ),
//     );
//   }
//
// }
