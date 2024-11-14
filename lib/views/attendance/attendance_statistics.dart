import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/attendance/view_all.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';

import '../../util/app_url.dart';
import '../../view_models/AttendanceController.dart';
import '../../widgets/Calendar/clean_calendar_event.dart';
import '../../widgets/Calendar/local_flutter_clean_calendar.dart';



class Statistics extends StatefulWidget {
  final String PassedagentCode;

  const Statistics({Key key,this.PassedagentCode}):super(key:key);

  @override
  _StatisticsState createState() => _StatisticsState(
      PassedagentCode: this.PassedagentCode
  );
}

class _StatisticsState extends State<Statistics> {

  String PassedagentCode;
  _StatisticsState({this.PassedagentCode});



  DateTime selectedDay;
  List <CleanCalendarEvent> selectedEvent;
  AttendanceProvider attendanceProvider = AttendanceProvider();
  String agentCode = '';
  List<dynamic> signinIDs = [];
  List<dynamic> allLogs = [];
  var singleSignin = [];
  var specialEvents;
  int leave=0,attended=0,absent=0,shouldAttend = 0;
  DateTime CupertinoSelectedDate = DateTime.now();
  bool _isLoading = false;

  String startTime ='';
  String endTime = '';
  var mostRecent = [];

  String onlyTime(String str){
   return str.substring(11,);
  }

  //  convertToDash(String datedash){
  //   String choppedDate =   datedash.substring(0,4);
  //   return int.parse(choppedDate);
  // }

  String first11(String str){
    return str.substring(0,11);
  }
  getYear(String date){
    String choppedDate =   date.substring(0,4);
    print('choppeddate ${choppedDate}');
    return int.parse(choppedDate);
  }
  getMonth(String date){
    String choppedDate =   date.substring(5,7);
    print('choppedmonth ${choppedDate}');
    return int.parse(choppedDate);
  }
  getDay(String date){
    String choppedDate =   date.substring(8,10);
    print('getDay ${choppedDate}');
    return int.parse(choppedDate);
  }




  Map<DateTime,List<CleanCalendarEvent>> newEvent1,newEvent2,newEvent3,collectEvents= {};

  Map<DateTime,List<CleanCalendarEvent>> events = {
    // for(var i=0;i < 10;i++){}
    // DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day):
    // [
    //   CleanCalendarEvent('Event A',
    //       startTime: DateTime(
    //           DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
    //
    //       endTime:  DateTime(
    //           DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
    //
    //       description: 'A special event',
    //       color: Colors.blue[700]),
    // ],
    // DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day + 3):
    // [
    //   CleanCalendarEvent('Event A',
    //       startTime: DateTime(
    //           DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
    //
    //       endTime:  DateTime(
    //           DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
    //
    //       description: 'A special event',
    //       color: Colors.blue[700]),
    // ],

  };

    getLiveLog(var ids){

      for(int i=0;i < ids.length;i++){

        final Future<Map<String,dynamic>> apiResponse =  attendanceProvider.addAttendancGet(AppUrl.attendanceLiveCheck,ids[i].toString());

        apiResponse.then((response) {
        //  print('this is ${response}');
          if(response["status"] == true){
            var responseData = response['data'];

            // for(int i=0;i < responseData.length;i++){
            //   signinIDs.add(responseData[i]['id']);
            // }
            print('all logs logs ${responseData['logs']}');

            var salesLocationLog = responseData['logs'];

            for(int i = 0; i < salesLocationLog.length;i++){
              allLogs.add(salesLocationLog[i]);
            }



            print('this is all logs ${allLogs}');
          }
        });
      }

    }

  convertToEvents(var convertEvents){
        //  String clockIn = convertEvents[0]['inClockDate'];
          // setState(() {
          // events = {
          //   DateTime(getYear(clockIn),getMonth(clockIn),getDay(clockIn)):
          //   [
          //     CleanCalendarEvent(convertEvents[0]['inClockDate'],
          //         startTime: DateTime(
          //             DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
          //
          //         endTime:  DateTime(
          //             DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
          //
          //         description: convertEvents[0]['address'],
          //         color: Colors.blue[700],
          //         clockIn: onlyTime(convertEvents[0]['inClockDate']),
          //         clockOut: onlyTime(convertEvents[0]['outClockDate']),
          //         location: convertEvents[0]['address'],
          //         isDevice: false
          //     ),
          //
          //   ],
          // };
          // });

  }

  callDateStatistics(DateTime date){
      String filteredDate = date.toString().substring(0,10);
      String params = '?agentID=${PassedagentCode}&InClockDate=${filteredDate}';

      setState(() {
        _isLoading = true;
      });

    final Future<Map<String,dynamic>> apiResponse =  attendanceProvider.addAttendancGet(AppUrl.attendancesignIn,params);



    apiResponse.then((response) {
      print('this is ${response}');
      if(response["status"] == true){
        setState(() {
          _isLoading = false;
        });
        var responseData = response['data']['data'];

        print('this is response ...> ${responseData}');

        setState(() {
          mostRecent  = responseData;
        });

        print('most recent Log Activity ${mostRecent}');
        convertToEvents(responseData);

        for(int i=0;i < responseData.length;i++){
          signinIDs.add(responseData[i]['id']);
        }
        print('all IDs ${signinIDs}');
        getLiveLog(signinIDs);

      }
    });

  }


  void _handleData(date){
    // print('date is ${date} ${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}');
    // setState(() {
    //   selectedDay = date;
    //   selectedEvent = events[selectedDay] ?? [];
    //   print('date selected >>> ');
    //   // Navigator.pushReplacement(context, Statistics());
    //  // MyRouter.pushPageReplacement(context, Statistics());
    //  //  setState(() {
    //  //    events = {
    //  //      // for(var i=0;i < 10;i++){}
    //  //      DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day):
    //  //      [
    //  //        CleanCalendarEvent('Event A',
    //  //            startTime: DateTime(
    //  //                DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
    //  //
    //  //            endTime:  DateTime(
    //  //                DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
    //  //
    //  //            description: 'A special event',
    //  //            color: Colors.blue[700]),
    //  //      ],
    //  //
    //  //    };
    //  //  });
    //
    //   //
    //   // setState(() {
    //   //   events = {
    //   //     // for(var i=0;i < 10;i++){}
    //   //     DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day):
    //   //     [
    //   //       CleanCalendarEvent('Event A',
    //   //           startTime: DateTime(
    //   //               DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
    //   //
    //   //           endTime:  DateTime(
    //   //               DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
    //   //
    //   //           description: 'A special event',
    //   //           color: Colors.blue[700]),
    //   //     ],
    //   //
    //   //   };
    //   // });
    //
    //  // setState(() {});
    //
    //  // _handleData(date);
    //     // if(events.length == 1){
    //     //   // print('isLoading');
    //     //   // setState(() {
    //     //   //   events = {
    //     //   //     // for(var i=0;i < 10;i++){}
    //     //   //     DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day):
    //     //   //     [
    //     //   //       CleanCalendarEvent('Event A',
    //     //   //           startTime: DateTime(
    //     //   //               DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
    //     //   //
    //     //   //           endTime:  DateTime(
    //     //   //               DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
    //     //   //
    //     //   //           description: 'A special event',
    //     //   //           color: Colors.blue[700]),
    //     //   //     ],
    //     //   //
    //     //   //   };
    //     //   // });
    //     // }
    //   print('date selected <<< ${events}');
    //
    // });

   // callDateStatistics(date);
   // print('selectedDay ${selectedDay}');
  }

  getStaffID() async{
    final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData();
    respose.then(
            (response) {
          print('this is referal statistics ${response['data']}');
          setState(() {
            agentCode = response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'];

          });


          print('agentCode ${agentCode}');

        }
    );



  }

  dateStatistics() async{
      var date_substring = CupertinoSelectedDate.toString().substring(0,7).replaceAll('-', '/');
     // print('this is date substring ${date_substring}');
    String params = '?agentID=A123J7&OutClockDate=${date_substring}';
    final Future<Map<String,dynamic>> apiResponse =  attendanceProvider.addAttendancGet(AppUrl.attendanceStatistics,params);


    apiResponse.then((response) {
        if(response['status'] == true){
            print('stats response ${response['data']}');
            var leaveResponse = response['data'];
            setState(() {
              attended = leaveResponse['attended'];
              absent = leaveResponse['absent'];
              shouldAttend = leaveResponse['shouldAttend'];
            });
        }

    });

  }

  dateFilter(){
   return showDatePicker();
  }

  void actionPopUpItemSelected(String value) {
      if(value == 'by_clockIn'){
        return dateFilter();
      }
  }



 String maxLenght30(String maxie){
     return maxie.length > 30 ? maxie.substring(0,30) + "..." : maxie;
 }


  @override
  void initState() {
    // TODO: implement initState
    // selectedEvent = events[selectedDay] ?? [];
    print('cupertino date ${CupertinoSelectedDate}');
    callDateStatistics(CupertinoSelectedDate);
    // loadEvents();
    getStaffID();
   // loadMoreEvents();
    dateStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 80,
        width: 80,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
            backgroundColor: Color(0xffEDF2F6),
        body:  Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
         // height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Center(
                child: Row(
                  children: [
                    _singleCard('assets/images/customers.png',shouldAttend,"Should Attend",),
                    _singleCard('assets/images/customers.png',attended,"Attended"),
                    _singleCard('assets/images/customers.png',absent,"Absent"),
                    _singleCard('assets/images/customers.png',leave,"Leave"),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' Activity On: ${first11(CupertinoSelectedDate.toString())}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 23),),
                  // InkWell(
                  //     onTap: null,
                  //     child: Icon(FeatherIcons.filter,color: ColorUtils.PRIMARY_COLOR,)
                  // )
                  PopupMenuButton(
                    icon: Icon(FeatherIcons.filter,color: Colors.blue,),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'by_clockIn',
                          child: Text('By Clock-In Date'),
                        ),

                      ];
                    },
                    onSelected: (String value) => actionPopUpItemSelected(value),
                  )
                ],
              ),
              SizedBox(height: 10,),


              Container(
                height: MediaQuery.of(context).size.height * 0.34,
                child: mostRecent == null || mostRecent.isEmpty ? ShimmerListLoading() :

                ListView.builder(
                  itemCount: 1,
                    itemBuilder: (index,position){
                    int mostLength  =   mostRecent.isEmpty  || mostRecent == null ? 2 : mostRecent.length;
                    var LastMostrecent = mostRecent == null ? [] : mostRecent [mostLength -1];
                    print('this is most recent ${LastMostrecent['address']} ${mostLength}');
                  return mostRecent.isEmpty || mostRecent == null  || LastMostrecent == null || LastMostrecent.isEmpty ? ShimmerListLoading() :
                      Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Icon(Icons.check_circle,color: Colors.green,),
                            Text('|\n|\n|\n|\n|\n|\n|',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                            Icon(Icons.check_circle,color: Colors.red,),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.74,
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Start Work'),
                                      SizedBox(height: 5,),
                                      Text(onlyTime('${LastMostrecent['inClockDate']}'),style: TextStyle(color: Colors.grey,fontSize: 14),),
                                      SizedBox(height: 15,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.place,color: Colors.grey,),
                                          Text(maxLenght30('${LastMostrecent['address']}'),style: TextStyle(color: Colors.black,fontSize: 14),),


                                        ],
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 20,),
                            Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.74,
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('End Work',style: TextStyle(fontSize: 12),),
                                      SizedBox(height: 5,),
                                      Text(LastMostrecent['outClockDate'] == null ? 'Not Signed Out' : onlyTime('${LastMostrecent['outClockDate']}'),style: TextStyle(color: Colors.grey,fontSize: 14),),
                                      SizedBox(height: 15,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.place,color: Colors.grey,),
                                         Text(maxLenght30('${LastMostrecent['address']}'),style: TextStyle(color: Colors.black,fontSize: 14),),


                      ],
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),


                      ],
                    ),
                  );
                }),
              ),





              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  MyRouter.pushPage(context, ViewAllAttendance(passedAttendance: mostRecent,passedAttendanceLog: allLogs,));
                },
                child: Center(
                  child: Text('View All',style: TextStyle(color: Colors.black,fontSize: 20),),
                ),
              )

            ],
          )

        ),
      ),
    );
  }

  _singleCard(String image,int numbers,String title){
    return Card(
      elevation: 0.3,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.22 ,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 11),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(

                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.contain,
                        )
                    ),
                  ),
                  Text(''),

                  // ImageIcon(
                  //   AssetImage(image),
                  //   size: 22,
                  // ),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(numbers.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                  Text('')
                ],

              ),

              Row(
                children: [
                  Text(title,style: TextStyle(fontSize: 11),),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }


  showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height*0.40,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      if (value != null && value != CupertinoSelectedDate)
                        setState(() {
                           CupertinoSelectedDate = value;
                          // print(CupertinoSelectedDate);
                          // String retDate = retsNx360dates(CupertinoSelectedDate);
                          // print('ret Date ${retDate}');
                          // repaymentDate.text = retDate;
                        });



                    },
                    initialDateTime: DateTime.now().add(Duration(hours: 2)),
                    // minimumYear: 2022,
                    // maximumYear: 2022,
                    maximumDate: DateTime.now().add(Duration(days: 365, hours: 0)),
                    minimumDate: DateTime.now().subtract(Duration(days: 365, hours: 0)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  //  onPressed: () => Navigator.of(context).pop(),
                  onPressed: (){
                    callDateStatistics(CupertinoSelectedDate);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        }
    );
  }

}