import 'dart:convert';
import 'dart:developer';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sales_toolkit/domain/user.dart';
import 'package:sales_toolkit/shared/shared_app_card.dart';
import 'package:sales_toolkit/util/ColorReturn.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/user_provider.dart';
import 'package:sales_toolkit/views/Interactions/getInteractionLoggedByAgent.dart';
import 'package:sales_toolkit/views/Interactions/getOpportunityLoggedByAgent.dart';
import 'package:sales_toolkit/views/Loans/TestUpdate.dart';
import 'package:sales_toolkit/views/Login/login.dart';
import 'package:sales_toolkit/views/Sales_type.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/views/leads/LeadsList.dart';
import 'package:sales_toolkit/views/metrics/allProductsMetrics.dart';
import 'package:sales_toolkit/views/metrics/metricsIndex.dart';
import 'package:sales_toolkit/views/referrals/referralIndex.dart';
import 'package:sales_toolkit/views/staging_version/index_staging.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/VersionCheck.dart';
import 'package:sales_toolkit/widgets/client_status.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';

import '../Loans/loan_sold_view.dart';
import '../clients/client_lists.dart';
import 'checkAppUpdatee.dart';



class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      HomeContent()
      // ShowCaseWidget(
      //   onStart: (index, key) {
      //     log('onStart: $index, $key');
      //   },
      //   onComplete: (index, key) {
      //     log('onComplete: $index, $key');
      //     if (index == 4) {
      //       SystemChrome.setSystemUIOverlayStyle(
      //         SystemUiOverlayStyle.light.copyWith(
      //           statusBarIconBrightness: Brightness.dark,
      //           statusBarColor: Colors.white,
      //         ),
      //       );
      //     }
      //   },
      //   blurValue: 1,
      //   builder: Builder(builder: (context) => const HomeContent()),
      //   autoPlayDelay: const Duration(seconds: 3),
      // ),
    );
  }
}



class HomeContent extends StatefulWidget {
  final int passLoanOfficer;
  const HomeContent({Key key,this.passLoanOfficer}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState(passLoanOfficer: this.passLoanOfficer);
}

class _HomeContentState extends State<HomeContent> {

  int passLoanOfficer;
  _HomeContentState({this.passLoanOfficer});


  // checkTour() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ActiveTour =   prefs.getBool('VisTourActive123');
  //
  //   if(ActiveTour == null){
  //     WidgetsBinding.instance.addPostFrameCallback(
  //           (_) => ShowCaseWidget.of(context)
  //           .startShowCase([_one,_two,_three]),
  //     );
  //     prefs.setBool('isTourActive', true);
  //   }
  //
  // }

  @override


  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  String cycle = '';
  List<dynamic> metricsDataList = [];
  List<dynamic> cycleListData = [];
  int totalCommision = 0;
  bool isCycleClicked = false;
  bool isLoading = false;
  final formatCurrency = NumberFormat.currency(locale: "en_US",
      symbol: "");

  // var salesTarget = 0.0;
  // var targetArchieved = 0.0;
  // var grade = 'N/A';
  // var commissionPercent = 0;
  // var performanceEarned = 0;
  // var totalEarned = 0.0;
  // var commissionEarned = 0.0;
  // var percentageOfSales = 0;
  // var performancePayEarn = 0.0;
  //
  // var totalLoanCount = 0;
  // var totalLoanAmount = 0.0;
  // var totalUnDisbursedLoanCount = 0;
  // var totalUnDisbursedLoanAmount = 0.0;
  // var totalFailedDisbursedLoanCount = 0;
  // var totalFailedDisbursedLoanAmount = 0.0;
  // var totalDisbursedLoanCount = 0;
  // var totalDisbursedLoanAmount = 0.0;

  dynamic salesTarget = 0.0;
  dynamic targetArchieved = 0.0;
  dynamic grade = 'N/A';
  dynamic commissionPercent = 0;
  dynamic performanceEarned = 0;
  dynamic totalEarned = 0.0;
  dynamic commissionEarned = 0.0;
  String percentageOfSales = '0';
  dynamic performancePayEarn = 0.0;

  dynamic totalLoanCount = 0;
  dynamic totalLoanAmount = 0.0;
  dynamic totalUnDisbursedLoanCount = 0;
  dynamic totalUnDisbursedLoanAmount = 0.0;
  dynamic totalFailedDisbursedLoanCount = 0;
  dynamic totalFailedDisbursedLoanAmount = 0.0;
  dynamic totalDisbursedLoanCount = 0;
  dynamic totalDisbursedLoanAmount = 0.0;

  int savedCycleId;
  // var totalPay = 0.0;

  // "totalLoanCount": 0,
  // "totalLoanAmount": 0,
  // "totalUnDisbursedLoanCount": 0,
  // "totalUnDisbursedLoanAmount": 0,
  // "totalFailedDisbursedLoanCount": 0,
  // "totalFailedDisbursedLoanAmount": 0,
  // "totalDisbursedLoanCount": 0,
  // "totalDisbursedLoanAmount": 0
  


  void initState() {
    // TODO: implement initState
   // checkTour();
    getStaffID();
  //  getCLientsList();
    getSalesUsername();
    calculateCommision();
    getProductCycle();
    // _verifyVersion();
   // getCycleStatus();
    getDateTime();
  //  print('passgedd << ${passLoanOfficer}');
    identifyUser_MixPanel();
    super.initState();
  }

  identifyUser_MixPanel() async{
//    AppTracker().identifyUser(passLoanOfficer.toString());
 //   AppTracker().getPeople_Set(props: "SalesAgentID",to: passLoanOfficer.toString());
    AppTracker().trackActivity('Sales Agent On Home Screen',payLoad: {
      "timeStamp": currentDateTimey,
      "AgentCode": agentCode
    });
  }

  getDateStringAndReturnMonthInWord(String dateString){
    DateTime date = DateTime.parse(dateString);
    String monthInWord = DateFormat.MMMM().format(date);
    print(monthInWord); // Output: May
      return monthInWord;
  }




  getCycleStatus() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    cycleName = prefs.getString('cycleName');
    savedCycleId =   prefs.getInt('cycleId');
    print("Timeout");

    // Future.delayed(const Duration(seconds: 1), () {
    //
    //   print("Timeout");
    // });

    // final Stream _myStream =
    // Stream.periodic(const Duration(seconds: 1), (int count) {
    //   // Do something and return something here
    //
    // });

    // cycleName
  }


  getProductCycle(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getProductCycle();
    respose.then(
            (response) {
          print('this is product cycle ${response['data']['content']}');
          setState(() {
            cycleListData = response['data']['content'];

           int currentCycleId = cycleListData[0]['id'];
            print('cycleList Data ${currentCycleId}');

              getMetricsForCycle(currentCycleId.toString());


            setState(() {
             cycleName = '${getDateStringAndReturnMonthInWord(cycleListData[0]['endDate'])}: ${cycleListData[0]['startDate']} - ${cycleListData[0]['endDate']}';
              cycleId = cycleListData[0]['id'].toString();
            });

          });
        }
    );

  }

  calculateCommision(){

    String startPeriod =  Jiffy().startOf(Units.MONTH).format("dd MMMM yyyy");
     var ComparestartPeriod =  Jiffy().startOf(Units.MONTH).dateTime;

    String endPeriod = Jiffy().endOf(Units.MONTH).format("dd MMMM yyyy");
    Jiffy now = Jiffy();
    var todaySdate = Jiffy(now).format("dd MMMM yyyy");
    var ComparetodaySdate = Jiffy(now).dateTime;

    int daysInMonth = Jiffy(now).daysInMonth;
    var halfOfthisMonth = Jiffy().startOf(Units.MONTH).add(days: (daysInMonth ~/ 2)).format("dd MMMM yyyy");
    var ComparehalfOfthisMonth = Jiffy().startOf(Units.MONTH).add(days: (daysInMonth ~/ 2)).dateTime;

    // Jiffy halfMonth = now.add(days: (daysInMonth ~/ 2));
    //DateTime halfMonthDate = halfMonth.dateTime;

    print('half >> ${halfOfthisMonth} ${todaySdate}');
    print('halfie >> ${ComparetodaySdate} ${ComparehalfOfthisMonth}');

    var dateFormat = "dd MMMM yyyy";

    int activationChannelId = 77;

    if(ComparetodaySdate.isAfter(ComparehalfOfthisMonth)){
    //  print('today date >>');
      setState(() {
        cycle = 'Second Cycle';
        startPeriod = halfOfthisMonth;
      });
    }
    else {
    //  print('today date << ');
      setState(() {
        cycle = 'First Cycle';
        endPeriod = halfOfthisMonth;
      });

    }

   //  int staffId = 428;
    // String mstartPeriod =  '10 January 2022';
    // String mendPeriod = '10 April 2023';
    //

    String params = '?startPeriod=${startPeriod}&endPeriod=${endPeriod}&dateFormat=${dateFormat}&loanOfficerId=${staffId}&activationChannelId=${activationChannelId}';
  //  String params = '?startPeriod=${mstartPeriod}&endPeriod=${mendPeriod}&dateFormat=${dateFormat}&loanOfficerId=${staffId}';

    final Future<Map<String,dynamic>> respose =   RetCodes().getLoanMetrics(params);

    respose.then((response) {
      setState(() {
     //   _isLoading =  false;
      });
      print(response['data']);
      setState(() {
       metricsDataList = response['data'];
      });
     print('metrics Data ${metricsDataList}');
     var caluclatedCommision = 0;
     List<dynamic> accumulated_commision = [];
     for(int i=0; i < metricsDataList.length;i++){
       var singleMetric = metricsDataList[i];
    int amts =  int.tryParse(singleMetric['level']['value']);
       // print('calc commission ${caluclatedCommision}');
       accumulated_commision.add(amts);
     }
      print('accumulated commision');
      int total = accumulated_commision.fold(0, (previousValue, element) => previousValue + element);
      print('accumulated ${accumulated_commision} total ${total}');

      setState(() {
        totalCommision = total;
      });

    });


  }

  var clientsData = [];
  var   totalRefered = [];
  String _isLoading = 'not_loading';
  int referalCount  = 0;
  int loanOfficerId = 0;
  String supervisor = 'N/A';
  String agentCode = 'N/A';
  String agentFirstName = '---';

  int staffId = 0;
  int newStaffId = 0;

  String cycleId;
  String cycleName = 'Current cycle';

  // AppUpdateInfo _updateInfo;



  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       _updateInfo = info;
  //     });
  //   }).catchError((e) => _showError(e));
  // }
  //_single
  // void _showError(dynamic exception) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
  // }


  String username = '',role = '',referralCode ='';
  DateTime now  = DateTime.now();


  getDateTime() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic currentTime = DateFormat.jm().format(DateTime.now());
        print('current TIME ${retsNx360dates()} ${currentTime}');
        setState(() {
          currentDateTimey =  retsNx360dates() + ' ' + currentTime;
        });
        prefs.setString('currentDateTime', currentDateTimey);
        int staffId = prefs.getInt('staffId');
        // setState(() {
        //
        // });
        setState(() {
          currentDateTimey = prefs.getString('currentDateTime');
          newStaffId = staffId;
        });
  }

  String currentDateTimey = '';
  getSalesUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Vusername = prefs.getString('username');
    String Vrole = prefs.getString('roleName');

    prefs.setString('sequestpassword', 'Mobiluser@123');

  //  String sequestCredential = prefs.setString('password','Mobiluser@123');

   // String vDescription = prefs.getString('');
    setState(() {
      username = Vusername;
      role = Vrole;
      currentDateTimey = prefs.getString('currentDateTime');
    });

  //  String email = 'tayo.oladosu@fcmb.com';
   // await OneSignal.shared.setEmail(email: username);

    // var status = await OneSignal.shared.getDeviceState();
    // String playerId = status.userId;
    // String playerIdEmail = status.emailAddress;
    //
    // print('this is player Id ${playerId} ${playerIdEmail}');




  }

  // getCLientsList() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var token = prefs.getString('base64EncodedAuthenticationKey');
  //   var tfaToken = prefs.getString('tfa-token');
  //   int staffId = prefs.getInt('staffId');
  //   setState(() {
  //     newStaffId = staffId;
  //   });
  //   print(tfaToken);
  //   print(token);
  //   setState(() {
  //     _isLoading  = 'is_loading';
  //   });
  //   try{
  //     Response responsevv = await get(
  //       AppUrl.ClientsList+'?staffId=${staffId}',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
  //         'Authorization': 'Basic ${token}',
  //         'Fineract-Platform-TFA-Token': '${tfaToken}',
  //       },
  //     );
  //     //  print(responsevv.body);
  //     if(responsevv.statusCode == 401){
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.orangeAccent,
  //         title: 'Unauthenticated',
  //         message: 'This user is unauthenticated ',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //
  //       MyRouter.pushPageReplacement(context, LoginScreen(login_type: 'Loan Management',));
  //     }
  //
  //
  //     final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
  //     print(responseData2);
  //     var newClientData = responseData2['pageItems'];
  //     setState(() {
  //       _isLoading = 'loaded';
  //       clientsData = newClientData;
  //
  //     });
  //     print('clientsData length ${clientsData.length}');
  //
  //     dynamic currentTime = DateFormat.jm().format(DateTime.now());
  //     print('current TIME ${retsNx360dates()} ${currentTime}');
  //     setState(() {
  //       currentDateTimey =  retsNx360dates() + ' ' + currentTime;
  //     });
  //     prefs.setString('currentDateTime', currentDateTimey);
  //
  //     setState(() {
  //       currentDateTimey = prefs.getString('currentDateTime');
  //     });
  //
  //  //   print('currentkdkd ${currentDateTimey}');
  //
  //   }
  //   catch(e){
  //
  //     if (e.toString().contains('SocketException') ||
  //         e.toString().contains('HandshakeException')) {
  //
  //     }
  //   }
  //
  // }

  getStaffID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData( context: context);
    respose.then(
            (response) {
          print('this is referal ${response['data']}');
              if(response['data'] == null && response['message'] == 'Unauthenticated'){
                MyRouter.pushPageReplacement(context, LoginScreen(login_type: 'Loan Management',));
              }
            //  print('this is referal ${response['data']}');
          setState(() {
            loanOfficerId = response['data']['id'];
            agentFirstName = response['data']['firstname'];
            referalCount = response['referralCount'] ?? 0;
            supervisor = response['data']['organisationalRoleParentStaff'] == null ? 'N/A' : response['data']['organisationalRoleParentStaff']['displayName'] == null ? 'N/A': response['data']['organisationalRoleParentStaff']['displayName'];
            agentCode = response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'];

          });

          prefs.setString('loanOfficerId', loanOfficerId.toString());

        }
    );

  }

  getMetricsForCycle(String cycleId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String local_loanOfficerId =  prefs.getString('loanOfficerId');

      setState(() {
        isLoading = true;
      });



          final Future<Map<String,dynamic>> respose =   RetCodes().getProductMetrics(local_loanOfficerId == null ? passLoanOfficer.toString() : local_loanOfficerId,cycleId);
          respose.then(
                  (response) {
                setState(() {
                  isLoading = false;
                });
                print('this is metrics cycle ${response['data']}');
                var singleMetricsData = response['data'];
                setState(() {
                  salesTarget = singleMetricsData['salesTarget'];
                  targetArchieved = singleMetricsData['targetAchieved'];
                  grade = singleMetricsData['agentGrade'];
                  commissionPercent = singleMetricsData['commissionPercentage'];
                  commissionEarned = singleMetricsData['commissionEarned'];
                  performanceEarned = singleMetricsData['performancePayable'];
                  totalEarned = singleMetricsData['totalPay'];
                  percentageOfSales = singleMetricsData['percentageOfSales'];
                 // percentageOfSales = '90';
                  performancePayEarn = singleMetricsData['performancePayable'];

                  totalLoanCount = singleMetricsData['totalLoanCount'];
                  totalLoanAmount = singleMetricsData['totalLoanAmount'];

                  totalUnDisbursedLoanCount = singleMetricsData['totalUnDisbursedLoanCount'];
                  totalUnDisbursedLoanAmount = singleMetricsData['totalUnDisbursedLoanAmount'];

                  totalFailedDisbursedLoanCount = singleMetricsData['totalFailedDisbursedLoanCount'];
                  totalFailedDisbursedLoanAmount = singleMetricsData['totalFailedDisbursedLoanAmount'];

                  totalDisbursedLoanCount = singleMetricsData['totalDisbursedLoanCount'];
                  totalDisbursedLoanAmount = singleMetricsData['totalDisbursedLoanAmount'];



                  // referalCount = response['referralCount'];
                  // supervisor = response['data']['organisationalRoleParentStaff']['displayName'] == null ? 'N/A': response['data']['organisationalRoleParentStaff']['displayName'];
                  // agentCode = response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'];
                  // loanOfficerId = response['data']['id'];
                  // agentFirstName = response['data']['firstname'];
                });

              //  prefs.setString('loanOfficerId', loanOfficerId.toString());

              }
          );

        // }



  }

  returnDialog(){
    return alert(
      context,
      title: Text('Logout'),
      content: Text('Click YES to proceed, Tap Out to cancel'),
      textOK: InkWell(
        onTap: () async{
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('userId');
          prefs.remove('username');
          prefs.remove('base64EncodedAuthenticationKey');
          prefs.remove('authenticated');
          prefs.remove('officeName');
          prefs.remove('staffDisplayName');
          prefs.remove('securecode');
          prefs.remove('tfa-token');
          prefs.remove('login_type');
          prefs.remove('loanOfficerId');

          MyRouter.pushPageReplacement(context, LoginScreen(login_type: 'Loan Management',));
        },
        child: Text('YES',style:TextStyle(color: Colors.red),),
      ),

    );
  }

  // void _verifyVersion() async {
  //   await AppVersionUpdate.checkForUpdates(
  //   // appleId: '1459706595',
  //     playStoreId: 'com.creditdirect.sales_toolkit',
  //     country: 'en',
  //   ).then((result) async {
  //     if (result.canUpdate) {
  //      await AppVersionUpdate.showAlertUpdate(
  //         appVersionResult: result,
  //         context: context,
  //         backgroundColor: Colors.grey[200],
  //         title: 'A newer version is available.',
  //         titleTextStyle: const TextStyle(
  //             color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24.0),
  //         content:
  //         'Would you like to update your app to the latest version?',
  //         contentTextStyle: const TextStyle(
  //           color: Colors.black,
  //           fontWeight: FontWeight.w400,
  //         ),
  //         updateButtonText: 'Update',
  //         cancelButtonText: 'Later',
  //       );
  //
  //     }
  //   });
  //   // TODO: implement initState
  // }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: ColorUtils.BG_HOME,

      body: _buildBody(),
    );

  }

  Widget _buildBody() {
    return  _buildBodyList();

  }

  Widget _buildBodyList() {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: ListView(
        children: <Widget>[
          homeAppBar(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: cycleWidget(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: AppStats(),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              height: AppHelper().pageHeight(context) * 0.188, // Adjust height as needed
              child: PageView(
                controller: PageController(viewportFraction: 0.9),
                children: [
                  AppStats(
                    backgroundColor: const Color(0xff077DBB), // First background color
                  ),
                  SecondAppStats(
                    backgroundColor: Colors.white, // Second background color
                    textColor: Colors.black, // Change text color for white background
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text('Supervisor: '),
                        Text('${supervisor}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w100,fontFamily: 'Nunito SansRegular'),)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Agent Code: '),
                          Text('${agentCode}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w100))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Referral Code: '),
                          Text('${newStaffId}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w100,fontSize: 12))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                appCards('Group 239746.svg','Loans',totalLoanCount,totalLoanAmount,loancounts: 'Loan Count',amount: "Total Amount"),
                SizedBox(width: 15,),
                appCards('Group 14 (2).svg','Digital Loans',totalUnDisbursedLoanCount,totalUnDisbursedLoanAmount,amount: "Total Disbursed"),
              ],
            ),

          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       appCards('Group 14.svg','Failed \nDisbursements',totalFailedDisbursedLoanCount,totalFailedDisbursedLoanAmount),
          //       SizedBox(width: 15,),
          //       appCards('Group 14 (1).svg','Disbursed Loans',totalDisbursedLoanCount,totalDisbursedLoanAmount),
          //     ],
          //   ),
          //
          // ),


        AppSummaryCard(
          sections: [
            {
              "title": "Disbursed",
              "count": totalDisbursedLoanCount,
              "amount": totalDisbursedLoanAmount,
              "iconColor": Colors.green,
            },
            {
              "title": "Undisbursed",
              "count": totalUnDisbursedLoanCount,
              "amount": totalUnDisbursedLoanAmount,
              "iconColor": Colors.orange,
            },
            {
              "title": "Failed",
              "count": totalFailedDisbursedLoanCount,
              "amount": totalFailedDisbursedLoanAmount,
              "iconColor": Colors.red,
            },
          ],
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),







        ],
      ),
    );
  }

  Widget cycleWidget(){
    return InkWell(
      onTap: (){
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
            ),
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Select a Sales Cycle',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 21),)
                    ),
                  ),

                    Column(
                    children: [
                      ListTile(

                        title: Container(
                          height: MediaQuery.of(context).size.height * 0.32,
                          child: ListView.builder(
                            reverse: true,
                            itemCount: cycleListData.length == 0 ? 0 : cycleListData.length ?? 0,
                              scrollDirection: Axis.vertical,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (index,position){
                              var singleCycle = cycleListData[position];
                            return  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(
                                  child:
                                  RadioListTile(
                                    title:  Text(' ${getDateStringAndReturnMonthInWord(singleCycle['endDate'])}: ${singleCycle['startDate']} - ${singleCycle['endDate']}',style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),),

                                    value: "${singleCycle['id'] ?? cycleId}",
                                    groupValue: cycleId,
                                    onChanged: (value) async{
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();

                                      setState(() {

                                        cycleId = value.toString();
                                        print('cycleId ${cycleId}');
                                        getMetricsForCycle(cycleId);

                                        cycleName = '${getDateStringAndReturnMonthInWord(singleCycle['endDate'])}: ${singleCycle['startDate']} - ${singleCycle['endDate']}';
                                        print('cycle name ${cycleName}' );
                                        prefs.setString('cycleName', cycleName);
                                        prefs.setInt('cycleId', int.tryParse(cycleId));
                                      });
                                      MyRouter.popPage(context);
                                    },
                                  ),
                                ),

                            // savedCycleId == null || singleCycle['id'] == null  ? SizedBox() : savedCycleId == singleCycle['id'] ?   clientStatus(colorChoser('current_cycle'), 'Current Cycle',containerSIze: 80,fontSize: 10,containerHeight: 30,fontColor: Color(
                            //         0xff7f7777)
                            //     ) : SizedBox()

                              ],
                            );
                          }),
                        ),
                         // trailing:
                         // clientStatus(colorChoser('current_cycle'), 'Current Cycle',containerSIze: 80,fontSize: 10,containerHeight: 30,fontColor: Color(
                         //     0xff7f7777)
                         // )
                        )
                    ],
                    )
                   ],
                ),
              );
            });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${cycleName}',style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                SizedBox(width: 5,),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
        ),
      ),
    );
  }

  Widget AppStats({
     Color backgroundColor,
    Color textColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.only(right: 5),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Sales Target",
                  style: TextStyle(
                    color: ColorUtils.SALES_COLOR,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '₦${formatCurrency.format(salesTarget)}',
                style: TextStyle(color: ColorUtils.SALES_COLOR, fontSize: 24,fontFamily: 'Nunito SemiBold'),
              ),
            ],
          ),
          SizedBox(height: AppHelper().pageHeight(context) * 0.027),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appSingleText('Target Achieved', '₦${formatCurrency.format(targetArchieved)}',),
              Container(
                width: 30,
                child: CircularPercentIndicator(
                  radius: 44.0,
                  lineWidth: 3.0,
                  percent: int.parse(percentageOfSales.replaceAll("%", "")) >= 100
                      ? 1
                      : int.parse(percentageOfSales.replaceAll("%", "")) / 100,
                  startAngle: 310,
                  center: Text(
                    "${percentageOfSales}%",
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  progressColor: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

        ],
      ),
    );
  }


  Widget SecondAppStats({
     Color backgroundColor,
    Color textColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: appText(
                  'Commission (${commissionPercent}%)',
                  '₦${formatCurrency.format(commissionEarned)}',
                  textColor: ColorUtils.EARNING_V2,
                  subtitleColor: ColorUtils.APP_BG_EARNING,
                ),
              ),
              // SizedBox(width: 10),
              reverseappText(
                'Grade',
                '${grade}',
                fontSize: 16,
                textColor: ColorUtils.EARNING_V2,
                subtitleColor: ColorUtils.APP_BG_EARNING,
              ),
            ],
          ),
          // SizedBox(height: 10),

          // Second Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: appText(
                  'Performance Pay Earned',
                  '₦${formatCurrency.format(performancePayEarn)}',
                  textColor: ColorUtils.EARNING_V2,
                  subtitleColor: ColorUtils.APP_BG_EARNING,
                ),
              ),
              // SizedBox(width: 10),
              reverseappText(
                'Total Gross earnings',
                '₦${formatCurrency.format(totalEarned)}',
                fontSize: 16,
                textColor: ColorUtils.EARNING_V2,
                subtitleColor: ColorUtils.APP_BG_EARNING,
              ),
            ],
          ),
          // SizedBox(height: 15),

          // Info Row
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorUtils.EARNING_BG,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outlined,
                  color: ColorUtils.INFO_BG_COLOR,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All earnings are subject to Statutory Deduction',
                    style: TextStyle(
                      color: ColorUtils.APP_BG_EARNING,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Nunito SemiBold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget appText(String title,String subtitle,{String extension,Color textColor,Color subtitleColor}){
    return    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: TextStyle(color: textColor ?? Color(0xffE1E2E7),fontSize: 12,fontFamily: 'Nunito SemiBold'),),
        Text(extension ?? 'N/A',style: TextStyle(color: subtitleColor ?? Colors.orange,fontSize: 16,fontFamily: 'Nunito SemiBold'),),
        Text(subtitle,style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Nunito SemiBold'),),
      ],
    );
  }


  Widget reverseappText(String title,String subtitle,{double fontSize,Color textColor,Color subtitleColor}){
    return    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title,style: TextStyle(color: textColor ?? Color(0xffE1E2E7),fontSize: 12,fontFamily: 'Nunito SemiBold'),),
        Text(subtitle,style: TextStyle(color: subtitleColor ?? Colors.white,fontSize: fontSize ?? 16,fontFamily: 'Nunito SemiBold'),),
      ],
    );
  }



  Widget appSingleText(String title,String subtitle,{String extension}){
    return    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,style: TextStyle(color: Color(0xffE1E2E7),fontSize: 10),),
            Text(extension ?? '',style: TextStyle(color: Colors.orange,fontSize: 10),),

          ],
        ),
        Text(subtitle,style: TextStyle(color: Colors.white,fontSize: 16),),

      ],
    );
  }



  Widget appCards(String appIcon,String appName,var loanCount,var totalD,
      {String loancounts = "Count",String amount ="Amount"}){
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: MediaQuery.of(context).size.height * 0.181,
      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/images/${appIcon}',height: 26,width: 26,),
              SizedBox(width: 4,),
              Text(appName,style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Column(
         //   mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(loancounts,style: TextStyle(color: Color(0xffA3AED0),fontSize: 11,fontWeight: FontWeight.w300),),
              Text('${loanCount}',style: TextStyle(color: Color(0xff2B3674),fontSize: 16,fontWeight: FontWeight.w700),)
            ],
          ),
           SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${amount}',style: TextStyle(color: Color(0xffA3AED0),fontSize: 11,fontWeight: FontWeight.w300),),
              Text('₦${formatCurrency.format(totalD)}',style: TextStyle(color: Color(0xff2B3674),fontSize: 16,fontWeight: FontWeight.w700),),
             // Text('Naira',style: TextStyle(color: Color(0xffA3AED0),fontSize: 9,fontWeight: FontWeight.w300),),

            ],
          ),



        ],
      ),
    );
  }

  _RecentClientsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: clientsData.length < 4 ? clientsData.length : 4,
      primary: false,
      physics: ClampingScrollPhysics(),


      scrollDirection: Axis.vertical,
      itemBuilder: (context,position){
        //   return _leadsContactView(clientsData[position]['firstname'][0] == 'O' ? Colors.green : clientsData[position]['firstname'][0] == 'S' ? Colors.brown : Colors.orange, clientsData[position]['firstname'] + " " +clientsData[position]['lastname'], clientsData[position]['accountNo'],clientsData[position]['firstname'][0] + clientsData[position]['lastname'][0]);
        // return _leadsContactView(ColorReturn().retCOlor(clientsData[position]['firstname'][0]),
        //    'Client Creation',
        //     clientsData[position]['firstname'] + " " +clientsData[position]['lastname'],
        //     clientsData[position]['firstname'][0] + clientsData[position]['lastname'][0],'');

        return InkWell(
          onTap: (){
            MyRouter.pushPage(context, ViewClient(clientID: clientsData[position]['id'],));
          },
          child:    _leadsContactView(ColorReturn().retStatus(clientsData[position]['status']['value']),
              toBeginningOfSentenceCase(clientsData[position]['displayName']),
              clientsData[position]['accountNo'],clientsData[position]['displayName'][0]
                  + clientsData[position]['displayName'][1],
              '${clientsData[position]['employmentSector']['name']}')
          ,
        );



      },
    );

  }

  _buildSmallCardLists(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            children: [
            //  _singleCard('assets/images/kpi.png','N0','Unpaid Loans',(){}),
              _singleCard('assets/images/kpi.png','My Metrics ','Click to view',(){

                // MyRouter.pushPage(context, MetricsIndex());
                MyRouter.pushPage(context, AllProductsMetrics());

              },MyLoanFontsize: 11),
              _singleCard('assets/images/leads.png','₦${formatCurrency.format(totalCommision)}','Total Commission',(){
            //   MyRouter.pushPage(context, TestUpdate());
              },MyLoanFontsize: 12),
              // _singleCard('assets/images/mail.png','0','Total Open Cases',(){
              // //  MyRouter.pushPage(context, NewTestUpdate());
              // }),

              _singleCard('assets/images/customers.png',referalCount.toString(),'Referrals',(){
                MyRouter.pushPage(context, ReferralIndex());
              }),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.013,),
          // Row(
          //   children: [
          //     _singleCard('assets/images/overdue.png','0','Referrals',(){
          //       // LoanSoldView();
          //     //   MyRouter.pushPage(context, AppUpdateCheck());
          //     //  MyRouter.pushPage(context, VersionCheckScreen());
          //     }),
          //     _singleCard('assets/images/kpi.png','My Metrics ','Click to view',(){
          //
          //       // MyRouter.pushPage(context, MetricsIndex());
          //       MyRouter.pushPage(context, AllProductsMetrics());
          //
          //     },MyLoanFontsize: 11),
          //     _singleCard('assets/images/customers.png',referalCount.toString(),'Referrals',(){
          //       MyRouter.pushPage(context, ReferralIndex());
          //     }),
          //
          //
          //   ],
          // ),
          Row(
            children: [
           //   _singleCard('assets/images/overdue.png','N0','Overdue Payments',(){}),
              _singleCard('','My Interactions ','Click to view',(){
                if(loanOfficerId == 0){
                  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                    backgroundColor: Colors.blue,
                    title: "Hold",
                    message: 'Loan officer details still loading...',
                    duration: Duration(seconds: 3),
                  ).show(context);
                }else {
                  MyRouter.pushPage(context, GetInteractionLoggedByAgent(loanOfficerId: loanOfficerId,));

                }

                },
                  singleCardColor: Color(0xff98c4eb),MyLoanFontsize: 11,
                singleCardTextColor: Colors.white
              ),
              _singleCard('','My Leads','Click to view',(){
                if(loanOfficerId == 0){
                  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                    backgroundColor: Colors.blue,
                    title: "Hold",
                    message: 'Loan officer details still loading...',
                    duration: Duration(seconds: 3),
                  ).show(context);
                }else {
                  MyRouter.pushPage(context, GetOpportunityLoggedByMe(loanOfficerId: loanOfficerId,));

                }

              },
                  singleCardColor: Color(0xff58acf5),MyLoanFontsize: 11,
                  singleCardTextColor: Colors.white
              ),
              _singleCard('','My Loans','Click to track',(){
                if(loanOfficerId == 0){
                }else {
                  MyRouter.pushPage(context, LoanSoldView(loanOfficerId: loanOfficerId,));

                }

              },
                  singleCardColor: Colors.lightBlueAccent,MyLoanFontsize: 12,
                  singleCardTextColor: Colors.white

              ),


            ],
          ),
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildCardHeader(){
    User user = Provider.of<UserProvider>(context).user;
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(

              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.width * 0.42,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/userBanner.png'),
                    fit: BoxFit.contain,
                  )
              ),
              child: Text('',style: TextStyle(color: Colors.white),),
            ),
            Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.041,left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('${user.username}'),
                     SizedBox(height: 11,),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 20),
    // child:   Text('Welcome,   ${username}',style: TextStyle(color: Colors.white,fontSize: 10,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.bold),),
    //
    // ),
       SizedBox(height: 3,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Supervisor:  ${supervisor}',style: TextStyle(color: Colors.white,fontSize: 13,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w100),),

                    ),
                    //SizedBox(height: 30,),
                    SizedBox(height: 3,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Agent code:  ${agentCode}',style: TextStyle(color: Colors.white,fontSize: 13,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),

                    ),
                    //SizedBox(height: 30,),
                    SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Role:  ${role}',style: TextStyle(color: Colors.white,fontSize: 13,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),

                    ),
                    //SizedBox(height: 30,),
                    SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Referral Code: ${newStaffId}',style: TextStyle(color: Colors.white,fontSize: 13,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),
                    ),
                    SizedBox(height: 3,),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child:
                    //   Text('Last Sync: ${currentDateTimey}',style: TextStyle(color: Colors.white,fontSize: 10,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),
                    // ),
                    SizedBox(height: 3,),


                  ],
                )

            )
          ]

      ),
    );
  }

  _leadsContactView(Color colm,String title,String date,String nameLogo,String employer){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),

        height: 80,
        child: ListTile(
            leading: _LeadingUserTile(colm,nameLogo.toUpperCase()),
            title: Text(title,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 12,fontWeight: FontWeight.w600),),
            subtitle: Text(employer),
            trailing:  Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Colors.blueGrey,)
        ),
      ),
    );
  }


  _LeadingUserTile(Color cols,String nameLogo){
    return Container(
      padding: EdgeInsets.only(top: 1),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cols,
        borderRadius: BorderRadius.all(Radius.circular(60)),

      ),
      child: Center(child: Text(nameLogo,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
    );
  }



  _LeadingProfileTile(Color cols,String nameLogo){
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: EdgeInsets.only(top: 2),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: cols,
          borderRadius: BorderRadius.all(Radius.circular(23)),

        ),
        child: Center(child: Text(nameLogo,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
      ),
    );
  }



  _singleCard(String image,String numbers,String title,Function onTap,{Color singleCardColor,double MyLoanFontsize,Color singleCardTextColor}){
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0.3,
        child: Container(
          color: singleCardColor ?? Colors.white,
          width: MediaQuery.of(context).size.width * 0.28 ,
          height: MediaQuery.of(context).size.height * 0.135,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 11),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(''),

                    Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(

                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.contain,
                          )
                      ),
                    )

                    // ImageIcon(
                    //   AssetImage(image),
                    //   size: 22,
                    // ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(numbers,style: TextStyle(fontSize: MyLoanFontsize ?? 18,fontWeight: FontWeight.bold,color: singleCardTextColor ?? Colors.black),),
                    Text('')
                  ],

                ),

                SizedBox(height: 7,),
                Row(
                  children: [
                    Text(title,style: TextStyle(fontSize: 10,color: singleCardTextColor ?? Colors.black),),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  retsNx360dates(){

    DateTime now  = DateTime.now();
    String newdate = now.toString().substring(0,10);
    print(newdate);

    String formattedDate = DateFormat.yMMMMd().format(now);

    print(formattedDate);

    String removeComma = formattedDate.replaceAll(",", "");
    print('removeComma');
    print(removeComma);

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o2.length == 1 ? '0' + '' + o2 :  o2;

    print('newOO ${newOO}');

    String concatss = newOO + " " + o1 + " " + o3;

    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }

  Widget NoCliientView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Client Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('Click button below to add a client',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
            Container(
              width: 155,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff077DBB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: (){
                  MyRouter.pushPage(context,AddClient());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:   Text(
                    'Add Client',
                    style: TextStyle( fontSize: 12,
                      color: Colors.white,),
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget homeAppBar(){
    return Column(
      children: [
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4,),
                  Text('Welcome, ${agentFirstName}',style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'Nunito SemiBold',fontWeight: FontWeight.bold),),
                  Text('Last Sync: ${currentDateTimey}',style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.bold),)
                ],
              ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          //   MyRouter.pushPage(context, TestDiscovery());
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child:
                         //  Showcase(
                         //    key: _two,
                         //    title: 'View Notification',
                         //    titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                         //    description: 'Tap here to view notifications',
                         // //   shapeBorder: const CircleBorder(),
                         //    child:
                         //
                         //  ),

                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child:  SvgPicture.asset("assets/images/mdi_bell-notification-outline.svg",
                                color: Colors.black,
                                height: 28.0,
                                width: 16.0,)
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () async{
                          returnDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child:
                          // Showcase(
                          //   key: _one,
                          //   title: 'Logout',
                          //   titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                          //   description: 'Tap here to log out of your account',
                          //   //shapeBorder: const CircleBorder(),
                          //   child:
                          // ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child:  Icon(Icons.power_settings_new_outlined,color: Colors.black,size: 23,)
                          ),
                        ),
                      ),
                    ],
                  ),


            ],
          ),
        ),
      ],
    );
  }

  // Widget updateDialog(){
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(4)),
  //         color: Color(0xffDE914A).withOpacity(0.21),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(15.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Container(
  //                         decoration: BoxDecoration(
  //                           color: Colors.orangeAccent,
  //                           borderRadius: BorderRadius.all(Radius.circular(7)),
  //                         ),
  //                         child: Icon(Icons.refresh,color: Colors.white,)
  //                     ),
  //                     SizedBox(width: 6,),
  //                     Text('A new update is available',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
  //                   ],
  //                 ),
  //                 Icon(Icons.clear)
  //
  //               ],
  //               //
  //             ),
  //             SizedBox(height: 5,),
  //             Text('Please update to V${_updateInfo.availableVersionCode} for a better experience',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w300),),
  //             SizedBox(height: 5,),
  //             FlatButton(
  //                 onPressed: _updateInfo?.updateAvailable == true
  //                     ? () {
  //                   InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
  //                 }
  //                     : null,
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.black,
  //                     borderRadius: BorderRadius.all(Radius.circular(7)),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(4.0),
  //                     child: Text('Update Now',style: TextStyle(color: Colors.white),),
  //                   ),
  //                 )
  //
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
