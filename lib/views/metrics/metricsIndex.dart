import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';

import 'package:sales_toolkit/widgets/client_status.dart';

import 'package:sales_toolkit/widgets/go_backWidget.dart';
import 'package:sales_toolkit/widgets/metricsFilter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/CodesAndLogic.dart';
import '../../widgets/metricsShimmerLoading.dart';
import '../../widgets/sizeSheet.dart';

class MetricsIndex extends StatefulWidget {
  final int activationChannel;
  const MetricsIndex({Key key,
    this.activationChannel}) : super(key: key);

  @override
  _MetricsIndexState createState() => _MetricsIndexState(
    activationChannel: this.activationChannel
  );
}

class _MetricsIndexState extends State<MetricsIndex> {

  int activationChannel;
  _MetricsIndexState({this.activationChannel});

  TextEditingController startDate  = TextEditingController();
  TextEditingController endDate  = TextEditingController();
  DateTime CupertinoSelectedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<dynamic> metricsDataList = [];
  bool _isLoading = false;

  String startPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM yyyy");
  String endPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM yyyy");


  String vstartPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM");
  String vendPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM");


  // String startPeriod = '01 October 2022';
  // String endPeriod = '07 March 2023';




  getMetricsForSalesAgent() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();



     int staffId = prefs.getInt('staffId');
    // int staffId = 628;
    // String startPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM yyyy");
    // String endPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM yyyy");
    //
    var dateFormat = "dd MMMM yyyy";
    int activationChannelId = activationChannel;
    String params = '?startPeriod=${startPeriod}&endPeriod=${endPeriod}&dateFormat=${dateFormat}&loanOfficerId=${staffId}&activationChannelId=${activationChannelId}';
      setState(() {
        _isLoading =  true;
      });
    final Future<Map<String,dynamic>> respose =   RetCodes().getLoanMetrics(params);
    setState(() {
      _isLoading =  false;
    });
    respose.then((response) {
      setState(() {
        _isLoading =  false;
      });
      print(response['data']);
      setState(() {
        metricsDataList = response['data'];
      });
      print('metrics Data ${metricsDataList}');
    });
  }


  filterMetricsWithDateAndTime(String filterStartDate,String filterEndDate) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // int staffId = prefs.getInt('staffId');
    int staffId = 1310;
    // String startPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM yyyy");
    // String endPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM yyyy");
    //
    var dateFormat = "dd MMMM yyyy";
    int activationChannelId = activationChannel;
    String params = '?startPeriod=${filterStartDate}&endPeriod=${filterEndDate}&dateFormat=${dateFormat}&loanOfficerId=${staffId}&activationChannelId=${activationChannelId}';

    setState(() {
      _isLoading =  true;
    });

    final Future<Map<String,dynamic>> respose =   RetCodes().getLoanMetrics(params);

    setState(() {
      _isLoading =  false;
    });

    respose.then((response) {
      setState(() {
        _isLoading =  false;
      });
      print(response['data']);
      setState(() {
        metricsDataList = response['data'];
      });
      print('metrics Data ${metricsDataList}');
    });
  }



  @override
  void initState() {
   getMetricsForSalesAgent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:    appBack(context),
          actions: [
            IconButton(onPressed: (){

              showSizeSheet(
                  context,
                  0,
                  0,
                  0,
                  MetricsFilterModal(
                    onChanged: (value) {},
                    controller1: startDate,
                    controller2: endDate,
                    onPress: (){
                    //  print('date1 ${startDate.text} ${endDate.text}');
                      MyRouter.popPage(context);
                    filterMetricsWithDateAndTime(startDate.text,endDate.text);
                    //  MyRouter.popPage(context);
                    //  filterResult();
                    },
                  ),
                  colors: Colors.white);
            }, icon: Icon(FeatherIcons.filter,size: 23,color: ColorUtils.PRIMARY_COLOR,))

          ],
          title: Text('My Metrics',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body:
        //ShimmerMetricsLoading()

        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [

              SizedBox(height: 5,),

          metricsDataList.length == 0 ? noMetrics() :  MetricsLists()
            ],
          ),
        ),
      ),
    );
  }


  Widget MetricsLists(){
      return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: ListView.builder(
            itemCount: metricsDataList.length ?? 0,
            itemBuilder: (index,position){
                var singleMetricsData =metricsDataList[position];
             //   print('single >> ${singleMetricsData}');
                return singleMetricsCard(
                    activationChannel: singleMetricsData['activationChannel']['name'] ?? '',
                    counts: singleMetricsData['count'],
                    medalType: singleMetricsData['level']['code'],
                    reward: singleMetricsData['level']['value']

                );
            }
            ),
      );

  }


  Widget singleMetricsCard(
      {String activationChannel, int counts, String medalType,String reward}){
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: ListTile(
          title: Text(' ${activationChannel}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Bold',fontSize: 22),),
          subtitle:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  LinearPercentIndicator(
                    width: 200.0,
                    lineHeight: 7.0,
                    percent: counts < 100 ? counts/100 : counts/1000,
                    progressColor: ColorUtils.PRIMARY_COLOR,
                  ),

                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Reward: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      Text('₦${reward} '),


                    ],
                  ),
                  SizedBox(height: 5,),
                  // Row(
                  //   children: [
                  //     //    Text('Reporting Period: 1 March - 31 March '),
                  //     Text('Target Sales: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  //  //   Text('₦800,000'),
                  //
                  //   ],
                  // ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                  //    Text('Reporting Period: 1 March - 31 March '),
                      Text('Reporting Period: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      Text('${vstartPeriod} - ${vendPeriod}'),

                    ],
                  )



                ],
              ),

            ],
          ),
          trailing:
          Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2,),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: ColorUtils.PRIMARY_COLOR),
                    color: colorChoser(medalType),
                    borderRadius: BorderRadius.all(Radius.circular(600)),
                  ),
                  child:Center(child: Text('${counts}',style: TextStyle(color: ColorUtils.LOGOUT_TEXT_COLOR),)),
                ),
                SizedBox(height: 1,),
                Text('${medalType}',style: TextStyle(fontSize: 10,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w400),)
              ],
            ),
          )


        ),
      ),
    );
  }

  Widget noMetrics(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Metrics Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('This user currently has no metrics record.',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
            // Container(
            //   width: 155,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     color: Color(0xff077DBB),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: TextButton(
            //     onPressed: (){
            //       IconButton(onPressed: (){
            //
            //         showSizeSheet(
            //             context,
            //             0,
            //             0,
            //             0,
            //             MetricsFilterModal(
            //               onChanged: (value) {},
            //               controller1: startDate,
            //               controller2: endDate,
            //               onPress: (){
            //                 //  print('date1 ${startDate.text} ${endDate.text}');
            //                 MyRouter.popPage(context);
            //                 filterMetricsWithDateAndTime(startDate.text,endDate.text);
            //                 //  MyRouter.popPage(context);
            //                 //  filterResult();
            //               },
            //             ),
            //             colors: Colors.white);
            //       }, icon: Icon(FeatherIcons.filter,size: 23,color: ColorUtils.PRIMARY_COLOR,));
            //
            //
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 0.0),
            //       child:   Text(
            //         'Filter',
            //         style: TextStyle( fontSize: 12,
            //           color: Colors.white,),
            //       ),
            //
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }



}
