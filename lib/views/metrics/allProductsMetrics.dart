import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/metrics/metricsIndex.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';
import 'package:sales_toolkit/widgets/metricsShimmerLoading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/client_status.dart';

class AllProductsMetrics extends StatefulWidget {
  const AllProductsMetrics({Key key}) : super(key: key);

  @override
  _AllProductsMetricsState createState() => _AllProductsMetricsState();
}

class _AllProductsMetricsState extends State<AllProductsMetrics> {
  List<dynamic> metricsDataList = [];

  // String startPeriod = '01 October 2022';
  // String endPeriod = '01 March 2023';
   String startPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM yyyy");
   String endPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM yyyy");


  String vstartPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM");
  String vendPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM");


  getMetricsForSalesAgent() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int staffId = prefs.getInt('staffId');
   // int staffId = 628;
    // String startPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM yyyy");
    // String endPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM yyyy");



    var dateFormat = "dd MMMM yyyy";

    String params = '?startPeriod=${startPeriod}&endPeriod=${endPeriod}&dateFormat=${dateFormat}&groupBy=activationChannelId&loanOfficerId=${staffId}';
    //String params = '?startPeriod=${startPeriod}&endPeriod=${endPeriod}&dateFormat=${dateFormat}&groupBy=activationChannelId';
    final Future<Map<String,dynamic>> respose =   RetCodes().getLoanMetrics(params);
    respose.then((response) {
      print(response['data']);
      setState(() {
        metricsDataList = response['data'];
      });

      print('metrics Data ${metricsDataList}');
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    getMetricsForSalesAgent();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: appBack(context),
        title: Text('Sold Loans Metrics',style: TextStyle(color: Colors.black,fontFamily:'Nunito SemiBold'),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              // loanWidgetList(
              //   channelName: 'SalesToolkit',
              //   medalType: 'Metal',
              //   loanCount: 4,
              //   reward: '400,000',
              //   targetSales: '450,000',
              //   channelIcon: Icons.phone_android
              // ),
              // SizedBox(height: 10,),
              // loanWidgetList(
              //     channelName: 'Customer Portal',
              //     medalType: 'Gold',
              //     loanCount: 6,
              //     reward: '500,000',
              //     targetSales: '450,000',
              //     channelIcon: Icons.desktop_windows
              // ),


              metricsDataList.length == 0 ? NoProductSold(): SalesByActivationChannel()

            ],
          ),
        ),
      ),
    );
  }


  Widget NoProductSold(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Sold Loan Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('This user currently has no sold loan .',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }


  Widget SalesByActivationChannel(){
    return Container(
     height: MediaQuery.of(context).size.height * 0.90,
      child:    ListView.builder(
          itemCount: metricsDataList.length ?? 0,
          itemBuilder: (index,position){
              var salesData = metricsDataList[position];
            return loanWidgetList(
                channelName: salesData['activationChannel']['name'] ?? '',
                medalType: salesData['level']['code'] ?? '',
                loanCount: salesData['count'],
                reward: salesData['level']['value'],
                targetSales: '--',
                channelIcon: salesData['activationChannel']['name'],
                channelId: salesData['activationChannel']['id']
            );


          }

      ),
    );
  }

  Widget loanWidgetList({String channelName, String medalType, int loanCount,var reward,var targetSales,String channelIcon,int channelId}){
      return InkWell(
        onTap: (){
          MyRouter.pushPage(context, MetricsIndex(activationChannel: channelId,));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
          height: 190,
          child: Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(channelName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 21,fontFamily: 'Nunito Bold'),),
                       IconChooser(channelIcon)
                    ],
                  ),
                  //  subtitle: Text('Click to view your metrics',style: TextStyle(color: ColorUtils.PRIMARY_COLOR),),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),

                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Medal: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          Text('${medalType}',style: TextStyle(color: colorChoser(medalType)),),


                        ],
                      ),
                      //SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Loan Count: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          Text('${loanCount}'),


                        ],
                      ),
                      //  SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reward: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          Text('₦${reward} '),


                        ],
                      ),
                      SizedBox(height: 0,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     //    Text('Reporting Period: 1 March - 31 March '),
                      //     Text('Target Sales: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      //     Text('₦${targetSales}'),
                      //
                      //   ],
                      // ),
                      // SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //    Text('Reporting Period: 1 March - 31 March '),
                          Text('Reporting Period: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          Text('${vstartPeriod} - ${vendPeriod}'),
                        ],
                      )

                    ],
                  ),
               //   trailing: IconChooser(channelIcon),
                ),
              ],
            ),
          ),
        ),
      );
  }


  String stripOffYear(String vals){
    // return vals.split(' ').last.replaceAll('', replace);
  }
}

