import 'dart:convert';
import 'dart:developer';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
//import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sales_toolkit/domain/user.dart';
import 'package:sales_toolkit/util/ColorReturn.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/user_provider.dart';
import 'package:sales_toolkit/views/Loans/TestUpdate.dart';
import 'package:sales_toolkit/views/Login/login.dart';
import 'package:sales_toolkit/views/Sales_type.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/views/referrals/referralIndex.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:sales_toolkit/widgets/shared/agentCode.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';



class DeviceHome extends StatelessWidget {
  const DeviceHome({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeviceHomeContent()
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
      //   builder: Builder(builder: (context) => const DeviceHomeContent()),
      //   autoPlayDelay: const Duration(seconds: 3),
      // ),
    );
  }
}



class DeviceHomeContent extends StatefulWidget {
  const DeviceHomeContent({Key key}) : super(key: key);

  @override
  _DeviceHomeContentState createState() => _DeviceHomeContentState();
}

class _DeviceHomeContentState extends State<DeviceHomeContent> {


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

  void initState() {
    // TODO: implement initState
  //  checkTour();
    getStaffID();
    getCLientsList();
    getSalesUsername();
    //  checkForUpdate();
    super.initState();
  }

  var clientsData = [];
  var   totalRefered = [];
  String _isLoading = 'not_loading';
  int referalCount  = 0;
  String supervisor = 'N/A';
  String agentCode = 'N/A';

  // AppUpdateInfo _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       _updateInfo = info;
  //     });
  //   }).catchError((e) => _showError(e));
  // }

  // void _showError(dynamic exception) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
  // }

  String username = '',role = '';
  DateTime now  = DateTime.now();
  String currentDateTimey = '';
  getSalesUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Vusername = prefs.getString('username');
    String Vrole = prefs.getString('roleName');
    setState(() {
      username = Vusername;
      role = Vrole;
      currentDateTimey = prefs.getString('currentDateTime');
    });


  }

  getCLientsList() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int staffId = prefs.getInt('staffId');
    print(tfaToken);
    print(token);
    setState(() {
      _isLoading  = 'is_loading';
    });
    try{
      Response responsevv = await get(
        AppUrl.ClientsList+'?staffId=${staffId}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );
      //  print(responsevv.body);
      if(responsevv.statusCode == 401){
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Unauthenticated',
          message: 'This user is unauthenticated ',
          duration: Duration(seconds: 3),
        ).show(context);

        MyRouter.pushPageReplacement(context, SalesType());
      }


      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      var newClientData = responseData2['pageItems'];
      setState(() {
        _isLoading = 'loaded';
        clientsData = newClientData;

      });
      print('clientsData length ${clientsData.length}');

      dynamic currentTime = DateFormat.jm().format(DateTime.now());
      print('current TIME ${retsNx360dates()} ${currentTime}');
      setState(() {
        currentDateTimey =  retsNx360dates() + ' ' + currentTime;
      });
      prefs.setString('currentDateTime', currentDateTimey);

      setState(() {
        currentDateTimey = prefs.getString('currentDateTime');
      });

      print('currentkdkd ${currentDateTimey}');

    }
    catch(e){

      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {

      }


    }



  }

  getStaffID() async{
    final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData();
    respose.then(
            (response) {
       // print('this is staff ID ${getGlobalStaffID()['referalCount']}');
        //  print('this is referal ${response['data']}');
          setState(() {
            referalCount = response['referralCount'];
            supervisor = response['data']['organisationalRoleParentStaff']['displayName'] == null ? 'N/A': response['data']['organisationalRoleParentStaff']['displayName'];
            agentCode = response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'];

          });

        }
    );

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



          MyRouter.pushPageReplacement(context, SalesType());
        },
        child: Text('YES',style:TextStyle(color: Colors.red),),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,

        // leading: Container(
        //   child: Builder(
        //     builder: (context) => InkWell(
        //       onTap: () => Scaffold.of(context).openDrawer(),
        //       child: Showcase(
        //         key: _three,
        //         title: 'Profile',
        //         titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
        //         description: 'Tap to view client profile',
        //         shapeBorder: const CircleBorder(),
        //         child: Container(
        //
        //           padding: EdgeInsets.symmetric(horizontal:9,vertical: 2),
        //           child:  _LeadingProfileTile(Colors.grey, username == null ? '' : '${username.substring(0,1)}'),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        actions: [
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
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child:  SvgPicture.asset("assets/images/bellIcon.svg",
                        color: Colors.black,
                        height: 25.0,
                        width: 20.0,)
                  ),
                  // Showcase(
                  //   key: _two,
                  //   title: 'View Notification',
                  //   titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                  //   description: 'Tap here to view notifications',
                  //   //shapeBorder: const CircleBorder(),
                  //   child:
                  //   Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 4),
                  //       child:  SvgPicture.asset("assets/images/bellIcon.svg",
                  //         color: Colors.black,
                  //         height: 25.0,
                  //         width: 20.0,)
                  //   ),
                  // ),
                ),
              ),
              InkWell(
                onTap: () async{
                  returnDialog();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child:
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:  Icon(Icons.power_settings_new_outlined,color: Colors.black,)
                  ),
                  // Showcase(
                  //   key: _one,
                  //   title: 'Logout',
                  //   titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                  //   description: 'Tap here to log out of your account',
                  // //  shapeBorder: const CircleBorder(),
                  //   child:
                  //
                  // ),
                ),
              ),
            ],
          ),
        ], systemOverlayStyle: SystemUiOverlayStyle.dark,


      ),
      body: _buildBody(),
    );

  }

  Widget _buildBody() {
    return  _buildBodyList();

  }

  Widget _buildBodyList() {
    return RefreshIndicator(
      onRefresh: () => getCLientsList(),
      child: ListView(
        children: <Widget>[
          _buildCardHeader(),
          SizedBox(height: 2.0),

          _buildSmallCardLists(),
          SizedBox(height: 10.0),
          salesTarget(),
          //    updateDialog(),
          //   _updateInfo.updateAvailable == true &&  _updateInfo.availableVersionCode != null ? updateDialog() : SizedBox(),


          //_updateInfo.updateAvailable == true ? isUpdateAvailable() : null;

          // _buildSectionTitle('Recently Created Clients'),

          // SizedBox(height: 20.0),
          //  _leadsContactView(Colors.blue,'Client Creation','Alex Obinna','27 May,2021'),
          //   clientsData.length == 0 ? ShimmerListLoading() : _RecentClientsList()
          //    Container(
          //        height: MediaQuery.of(context).size.height * 0.35,
          //        child:
          //  clientsData.length == 0 ? ShimmerListLoading() : _RecentClientsList()
          // clientsData.length == 0 && _isLoading == 'is_loading' ? ShimmerListLoading() : clientsData.length == 0 && _isLoading == 'loaded' ? NoCliientView() : _RecentClientsList()

          // )
          //    clientsData.length == 0 ? ShimmerListLoading() : _RecentClientsList()
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _singleCard('assets/images/customers.png',clientsData.length.toString(),'Total Customers',(){}),
              _singleCard('assets/images/leads.png','0','Total Leads',(){
                // MyRouter.pushPage(context, TestUpdate());
              }),

            ],
          ),
          Row(
            children: [
              _singleCard('assets/images/overdue.png','N0','Overdue Payments',(){}),
              _singleCard('assets/images/kpi.png','0%','Current KPI Score',(){}),



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
              height: MediaQuery.of(context).size.width * 0.39,
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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.039,left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('${user.username}'),
                    // SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Welcome,   ${username}',style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.bold),),

                    ),
                    SizedBox(height: 3,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Supervisor:  ${supervisor}',style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),

                    ),
                    //SizedBox(height: 30,),
                    SizedBox(height: 3,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Agent code:  ${agentCode}',style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),

                    ),
                    //SizedBox(height: 30,),
                    SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:   Text('Role:  ${role}',style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),

                    ),
                    //SizedBox(height: 30,),
                    SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Last Sync: ${currentDateTimey}',style: TextStyle(color: Colors.white,fontSize: 12,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.w300),),
                    ),

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



  _singleCard(String image,String numbers,String title,Function onTap){
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0.3,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.435 ,
          height: MediaQuery.of(context).size.height * 0.13,
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
                    Text(numbers,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                    Text('')
                  ],

                ),

                Row(
                  children: [
                    Text(title,style: TextStyle(fontSize: 10),),
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


  Widget updateDialog(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Color(0xffDE914A).withOpacity(0.21),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Icon(Icons.refresh,color: Colors.white,)
                      ),
                      SizedBox(width: 6,),
                      Text('A new update is available',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                    ],
                  ),
                  Icon(Icons.clear)

                ],
                //
              ),
              SizedBox(height: 5,),
              // Text('Please update to V${_updateInfo.availableVersionCode} for a better experience',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w300),),
              //
              SizedBox(height: 5,),
              // FlatButton(
              //     onPressed: _updateInfo?.updateAvailable == true
              //         ? () {
              //       InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
              //     }
              //         : null,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: Colors.black,
              //         borderRadius: BorderRadius.all(Radius.circular(7)),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: Text('Update Now',style: TextStyle(color: Colors.white),),
              //       ),
              //     )
              //
              // )
            ],
          ),
        ),
      ),
    );
  }



  Widget salesTarget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(13))
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sales Target'),
                SizedBox(height: 6,),
                Text('N700,000.00',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24)),
                SizedBox(height: 15,),
                Text('Total Sales: N250,000',style: TextStyle(color: Colors.black,fontSize: 17),)
              ],
            ),
            Container(

              margin: EdgeInsets.only(top: 1),
              child:  CircularPercentIndicator(
                radius: 90.0,
                lineWidth: 8.0,
                percent: 0.76,
                center: new Text("76%",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                progressColor: Color(0xff147AD6),
              )
            )
          ],
        ),
      ),
    );
  }
}
