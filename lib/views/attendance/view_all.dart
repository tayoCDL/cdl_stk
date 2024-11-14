import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../util/enum/color_utils.dart';
import '../../util/router.dart';

class ViewAllAttendance extends StatefulWidget {
  final List<dynamic> passedAttendance;
  final List<dynamic> passedAttendanceLog;

  const ViewAllAttendance({Key key, this.passedAttendance,this.passedAttendanceLog}) : super(key: key);

  @override
  _ViewAllAttendanceState createState() => _ViewAllAttendanceState(
        passedAttendance: this.passedAttendance,
      passedAttendanceLog: this.passedAttendanceLog
      );
}

class _ViewAllAttendanceState extends State<ViewAllAttendance> {
  final List<dynamic> passedAttendance,passedAttendanceLog;

  _ViewAllAttendanceState({this.passedAttendance,this.passedAttendanceLog});

  @override
  void initState() {
    // TODO: implement initState

    print('this is the passed state ${passedAttendanceLog}');
    super.initState();
  }

  String maxLenght30(String maxie){
    return maxie.length > 30 ? maxie.substring(0,30) + "..." : maxie;
  }

  String first11(String str){
    return str.substring(0,11);
  }
  String onlyTime(String str){
    if (str.isEmpty || str.length < 3){
      return '';
    }
    else {
      return str.substring(11,);
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        leading: IconButton(icon:
        Icon(Icons.arrow_back_ios,color:
        ColorUtils.PRIMARY_COLOR,size: 25,),
          onPressed: (){
            MyRouter.popPage(context);
          },
        ),

        title: Text('All Activities',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // SizedBox(height: 20,),
              // Text('Logs',style: TextStyle(color: Colors.black,fontSize: 18),),
              //
              Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: TabStatus()
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget TabStatus(){
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            bottom:   TabBar(
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text('Activities',style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Nunito SansRegular'),),
                ),
                Tab(
                  child: Text('Logs',style: TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'Nunito SansRegular'),),
                ),
              ],
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: MaterialIndicator(
                  height: 4,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 0,
                  bottomRightRadius: 0,
                  tabPosition: TabPosition.bottom,
                  color: Color(0xff077DBB)
              ),
            ),
          ),
          body: TabBarView(
            children: [
              AllActivities(),
              AllLogs(),
              // Statistics(PassedagentCode: agentCode)
            ],
          ),
        )


    );
  }


  Widget AllActivities(){
    return     Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
          itemCount: passedAttendance.length,
          itemBuilder: (index, position) {
            var LastMostrecent = passedAttendance[position];

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Row(
                children: [
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text(
                        '|\n|\n|\n|\n|\n|\n|',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.78,
                            height:
                            MediaQuery.of(context).size.height *
                                0.15,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('Start Work'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  onlyTime(
                                      '${LastMostrecent['inClockDate']}'),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      maxLenght30(
                                          '${LastMostrecent['address']}'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.74,
                            height:
                            MediaQuery.of(context).size.height *
                                0.15,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Work',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  LastMostrecent['outClockDate'] ==
                                      null
                                      ? 'Not Signed Out'
                                      : onlyTime(
                                      '${LastMostrecent['outClockDate']}'),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      maxLenght30(
                                          '${LastMostrecent['address']}'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),


                ],
              ),
            );
          }),
    );
  }

  Widget AllLogs(){
    return    Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
          itemCount: passedAttendanceLog.length,
          itemBuilder: (index, position) {
            var LastMostrecent = passedAttendanceLog[position];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.87,
                            height:
                            MediaQuery.of(context).size.height *
                                0.20,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('Start Work'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  onlyTime(
                                      '${LastMostrecent['liveDate']}'),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  maxLenght30(
                                      '${LastMostrecent['statusMessage']}'),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      maxLenght30(
                                          '${LastMostrecent['address']}'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            );
          }),
    );
  }
}
