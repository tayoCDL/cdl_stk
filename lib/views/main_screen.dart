import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:sales_toolkit/util/dialogs.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/Sales_type.dart';
import 'package:sales_toolkit/views/attendance/Attendance_Index.dart';
import 'package:sales_toolkit/views/calculator/repayment_calculator.dart';
import 'package:sales_toolkit/views/clients/client_lists.dart';
import 'package:sales_toolkit/views/draft/DraftOverview.dart';
import 'package:sales_toolkit/views/home/device_financing.dart';

import 'package:sales_toolkit/views/home/home.dart';
import 'package:sales_toolkit/views/leads/LeadsList.dart';
import 'package:sales_toolkit/views/menu/menu_index.dart';
import 'package:sales_toolkit/views/orders/orderHistory.dart';
import 'package:sales_toolkit/views/referrals/referralIndex.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_toolkit/views/trops/trops_issues_lists.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/rounded-button.dart';
import 'orders/createOrder.dart';


class MainScreen extends StatefulWidget {
  final int passedLoanOfficerId;
  const MainScreen({Key key, this.passedLoanOfficerId}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState(passedLoanOfficerId: this.passedLoanOfficerId);
}

class _MainScreenState extends State<MainScreen> {
  int passedLoanOfficerId;

  _MainScreenState({this.passedLoanOfficerId});

  PageController _pageController;
  // AppUpdateInfo _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();


  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       _updateInfo = info;
  //     });
  //   }).catchError((e) => _showError(e));
  // }

  void _showError(dynamic exception) {
   // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.toString())));

  }

  int _page = 0;
  String login_type='Loan Management';
  // final GlobalKey<AnimatedFloatingActionButtonState> fabKey = GlobalKey();

  updateDialog(){
    return alert(
      context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('A new Update is available',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
         //     Text('Please update to V${_updateInfo.availableVersionCode} for a better experience',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w300),),
            ],
          ),
          InkWell(
              onTap: () {
                MyRouter.popPage(context);
              },
              child: Icon(Icons.clear))
        ],),
      content: Text(''),
      textOK: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        child: RoundedButton(buttonText: 'Proceed', onbuttonPressed: () {
          //  MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));

        },
        ),
      ),
    );
  }

  void navigationTapped(int page) {
   // updateDialog();
 //   _updateInfo.availableVersionCode != null &&  _updateInfo.updateAvailable == true  ? updateDialog() :  _pageController.jumpToPage(page);
    _pageController.jumpToPage(page);
  }

  checkUserType() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('login_type');
    int staffId = prefs.getInt('staffId');
    setState(() {
      login_type = prefs.getString('login_type');
    });
  }

  @override
  void initState() {
    checkUserType();

    super.initState();
    _pageController = PageController(initialPage: 0);
    print('this is passed loan >> ${passedLoanOfficerId}');
    print(passedLoanOfficerId);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {



var bottomItemA =   <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(
      FeatherIcons.home,
    ),
    label: 'Dashboard',

  ),
  BottomNavigationBarItem(
      icon: Icon(
        Feather.user,
      ),
      label:'Clients'

  ),
  BottomNavigationBarItem(
      icon: Icon(
        Feather.list,
      ),
      label: 'Feex'

  ),
  BottomNavigationBarItem(
      icon: Icon(
        Icons.calculate_outlined,
        size: 27,
      ),
      label: 'Calculator'

  ),
  BottomNavigationBarItem(
      icon: Icon(
        Feather.menu,
      ),
      label: 'Menu'

  ),
];

var bottomItemB =   <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(
      FeatherIcons.home,
      size: 27,
    ),
    label: 'Dashboard',


  ),
  BottomNavigationBarItem(
      icon: Icon(
        Icons.local_offer_outlined,
        size: 27,
      ),
      label:'Orders'

  ),
  BottomNavigationBarItem(
      icon: Icon(
        Icons.calculate_outlined,
        size: 27,
      ),
      label: 'Calculator'

  ),
  BottomNavigationBarItem(
    icon: Icon(
      FeatherIcons.menu,
      size: 27,
    ),
    label: 'More',

  ),

];


var routeWidgetsA = <Widget>[

  HomeContent(passLoanOfficer: passedLoanOfficerId,),

  ClientList(),
 // LeadList(),
  TropIssuesLists(),
  RepaymentCalculator(),
  MenuIndex()
];

var routeWidgetsB = <Widget>[
  DeviceHome(),
  OrderHistory(),
  RepaymentCalculator(),
  MenuIndex(),
];

Widget noLoginType(){
  //MyRouter.pushPage(context, SalesType());
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
    ),
    body: Container(
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            Text('Loading Dashboard',style: TextStyle(color: Colors.black,fontSize: 14),)
          ],
        ),
      ),
    ),
  );
}

    return WillPopScope(
      onWillPop: () => Dialogs().showExitDialog(context),
      child:  Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: routeWidgetsA,
        ),

        // floatingActionButton: AnimatedFloatingActionButton(
        //     key: fabKey,
        //     fabButtons: <Widget>[
        //       add(),
        //       image(),
        //       inbox(),
        //     ],
        //     colorStartAnimation: Colors.blue,
        //     colorEndAnimation: Colors.red,
        //     animatedIconData: AnimatedIcons.menu_close //To principal button
        // ),

      //    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          // bottomNavigationBar: Container(
          //     height: 65,
          //     decoration: BoxDecoration(
          //
          //       borderRadius: BorderRadius.only(
          //           topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          //       boxShadow: [
          //         BoxShadow(color: Colors.transparent, spreadRadius: 0, blurRadius: 3),
          //       ],
          //     ),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(1.0),
          //         topRight: Radius.circular(1.0),
          //       ),
          //       child:    Container(
          //         color: Theme.of(context).backgroundColor,
          //         height: 65,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 MaterialButton(
          //                   minWidth: 60,
          //                   onPressed: () {
          //
          //                   },
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: <Widget>[
          //
          //                       SvgPicture.asset("assets/images/Collage.svg",
          //                         height: 22.0,
          //                         width: 22.0,
          //
          //                       ),
          //                       Text(
          //                         'Dashboard',
          //                         style: TextStyle(
          //                             color: Colors.black,
          //                             fontFamily: 'Nunito SansRegular',
          //                             fontSize: 12
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 MaterialButton(
          //                   minWidth: 60,
          //                   onPressed: () {
          //
          //
          //                   },
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: <Widget>[
          //                       // Icon(
          //                       //   Icons.calculate_outlined,
          //                       //   color: currentTab == 1 ? Colors.blue : Colors.grey,
          //                       // ),
          //                     Icon(FeatherIcons.user,size: 22,color: Colors.blueGrey,),
          //                       Text(
          //                         'Clients',
          //                         style: TextStyle(
          //                             color:  Colors.grey,
          //                             fontFamily: 'Nunito SansRegular',
          //                             fontSize: 12
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 )
          //               ],
          //             ),
          //
          //             // Right Tab bar icons
          //
          //             Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 MaterialButton(
          //                   minWidth: 60,
          //                   onPressed: () {
          //                     MyRouter.pushPage(
          //                         context,
          //                         VerifyOtp()
          //                     );
          //                   },
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: <Widget>[
          //                       ImageIcon(
          //                         AssetImage('assets/images/client.png'),
          //                         color:  Colors.blueGrey,
          //                         size: 22,
          //                       ),
          //                       Text(
          //                         'Leads',
          //                         style: TextStyle(
          //                             color: Colors.grey,
          //                             fontFamily: 'Nunito SansRegular',
          //                             fontSize: 12
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 MaterialButton(
          //                   minWidth: 90,
          //                   onPressed: () {
          //                     MyRouter.pushPage(
          //                         context,
          //                         Profile()
          //                     );
          //                   },
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: <Widget>[
          //                       Icon(FeatherIcons.menu,size: 22,color: Colors.blueGrey,),
          //                       Text(
          //                         'More',
          //                         style: TextStyle(
          //                             color:  Colors.grey,
          //                             fontFamily: 'Nunito SansRegular',
          //                             fontSize: 12
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 )
          //               ],
          //             )
          //
          //           ],
          //         ),
          //       ),
          //     )
          // )

        bottomNavigationBar:
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),

          ),
          height: MediaQuery.of(context).size.height * 0.10,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              selectedItemColor: Color(0xff205072),
              unselectedItemColor: Colors.grey[500],

              selectedLabelStyle: TextStyle( fontSize: 13,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300,),
              elevation: 30,

              type: BottomNavigationBarType.fixed,
              items:  bottomItemA,
                      onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
        // floatingActionButton:
        // new FloatingActionButton(
        //   child: InkWell(
        //       onTap: (){
        //         MyRouter.pushPage(context, CreateOrder());
        //       },
        //       child: SvgPicture.asset('assets/images/new_fab.svg')
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }


}
