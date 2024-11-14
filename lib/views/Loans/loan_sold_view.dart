import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/NewLoan.dart';
import 'package:sales_toolkit/views/Loans/SingleLoanView.dart';
import 'package:sales_toolkit/widgets/ProfileShimmer.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanSoldView extends StatefulWidget {
  // const LoanView({Key key}) : super(key: key);
  //
  // @override
  // _LoanViewState createState() => _LoanViewState();

  final int clientID,loanOfficerId,parentEmployerSector;
  const LoanSoldView({Key key,this.clientID,this.loanOfficerId,this.parentEmployerSector}) : super(key: key);
  @override
  _LoanSoldViewState createState() => _LoanSoldViewState(
      clientID: this.clientID,
      loanOfficerId: this.loanOfficerId,
      parentEmployerSector: this.parentEmployerSector
  );
}



class _LoanSoldViewState extends State<LoanSoldView> {
  int clientID,loanOfficerId,parentEmployerSector;
  List<dynamic> CustomerLists,filteredLoans = [];
  int employerID,sectorId,parentClient;
  bool _isLoading = false;

  _LoanSoldViewState({this.clientID,this.loanOfficerId,this.parentEmployerSector});

  @override
  Widget build(BuildContext context) {
    return NoLoanScaffold();
  }

  @override
  void initState() {
    // TODO: implement initState

    getaloansList();

   // getEmploymentProfile();
    super.initState();
  }

  getaloansList({int loanStatus}){
    setState(() {
      _isLoading = true;
    });

    print('loanStat ${loanStatus} ${loanOfficerId}');
    int passedStatus = loanStatus ?? 50;
    final Future<Map<String,dynamic>> respose =   RetCodes().loanSold(loanOfficerId,passedStatus);

    respose.then((response) async {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);

      if(response['status'] == false){

      } else {

        setState(() {
          CustomerLists = response['data']['pageItems'];
        });

      }

      print('loan templatest ${CustomerLists}');

    }
    );

  }




  getEmploymentProfile() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    setState(() {
      _isLoading = true;
    });

    Response responsevv = await get(
      AppUrl.getSingleClient + clientID.toString() + '/employers',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    // print(responsevv.body);
    setState(() {
      _isLoading = false;
    });
    final List<dynamic> responseData2 = json.decode(responsevv.body);
    print('responseData2 ${responseData2}');

    setState(() {
      employerID = responseData2[0]['employer']['id'];
      sectorId = responseData2[0]['employer']['sector']['id'];
      parentClient = responseData2[0]['employer']['parent']['clientType']['id'];
    });

    print('employer ID ${employerID} ${sectorId}');

  }



  filterLoanView(value){



    if(value == 'team_lead_approval'){
      getaloansList(loanStatus: 50);
    }
    else if(value == 'l1_underwriter'){
      getaloansList(loanStatus: 100);
    }
    else if(value == 'l2_underwriter'){
      getaloansList(loanStatus: 200);
    }
    else if(value == 'active'){
      getaloansList(loanStatus: 300);
    }
    else if(value == 'draft'){
      getaloansList(loanStatus: 10);
    }
    else if(value == 'rejected'){
      getaloansList(loanStatus: 500);
    }
    else if(value == 'closed'){
      getaloansList(loanStatus: 600);
    }








  }

  Widget NoLoanScaffold(){
    return  LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: RefreshIndicator(
        onRefresh: () => getaloansList(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('My Loans',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                MyRouter.popPage(context);
              },
              icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
            ),
            actions: [

              PopupMenuButton(
                  icon:  Icon(FeatherIcons.filter,color: Colors.blue,),
                  itemBuilder: (context) {
                    return [

                      PopupMenuItem(
                        value: 'l1_underwriter',
                        child: Text('L1 Underwriters'),
                      ),
                      PopupMenuItem(
                        value: 'l2_underwriter',
                        child: Text('L2 Underwriters'),
                      ),
                      PopupMenuItem(
                        value: 'team_lead_approval',
                        child: Text('Team lead Approval',),
                      ),
                      PopupMenuItem(
                        value: 'active',
                        child: Text('Active'),
                      ),
                      PopupMenuItem(
                        value: 'draft',
                        child: Text('Loan In Draft'),
                      ),
                      PopupMenuItem(
                        value: 'rejected',
                        child: Text('Rejected'),
                      ),
                      PopupMenuItem(
                        value: 'closed',
                        child: Text('Closed'),
                      ),


                    ];
                  },
                  onSelected: (String value) {

                    filterLoanView(value);
                    // getaloansList();
                  }
              )
            ],
          ),
          body: LoanView(),
//           floatingActionButton: FloatingActionButton(
//               onPressed: (){
//                 if(employerID == null){
//                   return   Flushbar(
//                 flushbarPosition: FlushbarPosition.TOP,
//                 flushbarStyle: FlushbarStyle.GROUNDED,
//                     backgroundColor: Colors.blueAccent,
//                     title: 'Hold ✊',
//                     message: 'Please hold, loan configuration still loading ',
//                     duration: Duration(seconds: 3),
//                   ).show(context);
//                 }
//                 else {
//                   MyRouter.pushPage(context,NewLoan(clientID: clientID,employerId: employerID,sectorID:sectorId,parentClientType:parentClient ,));
//                 }
//
//
// //              MyRouter.pushPage(context,NewLoan(clientID: clientID,employerId: employerID,sectorID:sectorId));
//               },
//               child:     SvgPicture.asset("assets/images/new_plus.svg",
//                 height: 70.0,
//                 width: 70.0,)
//           ),

        ),
      ),
    );
  }

  Widget NoloanView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Loan Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('Use the filter to check other status.',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
         
          ],
        ),
      ),
    );
  }

  Widget LoanView(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),

            // CustomerLists == null || CustomerLists.isEmpty ? Container(
            //       height: 550,
            //     child: ProfileShimmerLoading()):
            //     LoanListTile(),

            CustomerLists == null ? NoloanView() :CustomerLists.isEmpty ? NoloanView() : LoanListTile()

          ],
        ),
      ),
    );
  }

  Widget LoanListTile(){


    return
      ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: CustomerLists == null || CustomerLists.isEmpty ? 0 : CustomerLists.length,
          itemBuilder: (index,position){
            var loanPosition = CustomerLists[position];
            print('${CustomerLists}');
            return  InkWell(
              onTap: (){
                MyRouter.pushPage(context, SingleLoanView(loanID: loanPosition['id'],clientID: clientID));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.16,
                padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
                child: Card(
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // clientStatus('${loanPosition['status']['value']}' == 'Loan in draft' ?  Color(0xff707070) :
                          // '${loanPosition['status']['value']}' == 'Active' || '${loanPosition['status']['value']}' == 'Approved' ? Color(0xff56C596):
                          // Color(0xffDE914A)
                          //     ,chopPending(loanPosition['status']['value']) == 'Loan in draft' ?
                          //     'Loan In Draft' :
                          //     '${loanPosition['status']['value']}' == 'Active'  ? 'Active' : '${loanPosition['status']['value']}' == 'Approved' ? 'Approved':
                          //     'Pending'
                          //
                          // ),



                        ],
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text('${thirtyMax(loanPosition['loanProductName']) ?? ''} ',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Black',fontSize: 11,color: Color(0xff707070)),),
                                  Text('(${loanPosition['isTopup'] == false ? ' New Loan' : 'Top Up'}) - ' ,style: TextStyle(fontSize: 10.5),),
                                  Text(' ${getLoanStatus(loanPosition['status']['id'])}' ,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: ColorUtils.PRIMARY_COLOR),),

                                ],
                              ),
                              SizedBox(width: 10,),
                              // Text('#${CustomerLists[position]['id']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Black',fontSize: 10,color: Color(0xff707070)),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${loanPosition['clientName']} - ${loanPosition['clientId']}',style: TextStyle(fontSize: 11),),
                             // Text('ID : ',style: TextStyle(fontSize: 11),),
                              Text('Loan Amount: ${loanPosition['principal']}',style: TextStyle(fontSize: 11),),
                             // Text('Loan Type: ${loanPosition['isTopup'] == false ? 'New Loan' : 'Top Up'}' ,style: TextStyle(fontSize: 11),),
                              Text('${'${loanPosition['timeline']['submittedOnDate'][0]} / ${loanPosition['timeline']['submittedOnDate'][1]}  / ${loanPosition['timeline']['submittedOnDate'][2]} '}',style: TextStyle(fontSize: 11),),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ],
                      ),
                      // subtitle:

                    ),
                  ),
                ),
              ),
            );
          }) ;

  }



  Widget clientStatus(Color statusColor,String status) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.width * 0.06,
      padding: EdgeInsets.symmetric(horizontal: 2,vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(child: Text(status,style: TextStyle(color: Colors.white,fontSize: 11),)),
    );
  }

  String chopPending(String pends){
    if(pends.contains('Pending')){
      return "Team Lead Review";
    }
    else {
      return pends;
    }
  }

  String chopPendingApproval(String pends){
    if(pends.contains('Pending')){
      return "Team Lead Review";
    }
    else {
      return pends;
    }
  }

String getLoanStatus(int loanStatus){
  String loanstats =   loanStatus == 50 ? 'Team Lead Approval' : loanStatus == 100 ? 'L1 Underwriters' : loanStatus == 200 ? 'L2 Underwriters' : loanStatus == 300 ? 'Active' : loanStatus == 500 ? 'Rejected': loanStatus == 600 ? 'Closed' : loanStatus == 700 ? 'Overpaid': 'Draft';
    return loanstats;
  }
String thirtyMax(String txt){
   return txt.length > 20 ? txt.substring(0,20) + '...' : txt;
}

}
