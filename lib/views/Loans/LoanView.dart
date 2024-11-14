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
import 'package:sales_toolkit/views/Loans/remitta_referencing.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/widgets/ProfileShimmer.dart';
import 'package:sales_toolkit/widgets/client_status.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/noEmployer.dart';
import '../clients/SingleCustomerScreen.dart';

class LoanView extends StatefulWidget {
  // const LoanView({Key key}) : super(key: key);
  //
  // @override
  // _LoanViewState createState() => _LoanViewState();

  final int clientID,parentEmployerId,parentEmployerSector;
  const LoanView({Key key,this.clientID,this.parentEmployerId,this.parentEmployerSector}) : super(key: key);
  @override
  _LoanViewState createState() => _LoanViewState(
      clientID: this.clientID,
      parentEmployerId: this.parentEmployerId,
      parentEmployerSector: this.parentEmployerSector
  );
}



class _LoanViewState extends State<LoanView> {
  int clientID,parentEmployerId,parentEmployerSector;
  List<dynamic> CustomerLists,filteredLoans = [];
  int employerID,sectorId,parentClient;
  bool _isLoading = false;
  bool employerLoaded = false;
  String realMonth = '';
  _LoanViewState({this.clientID,this.parentEmployerId,this.parentEmployerSector});

  @override
  Widget build(BuildContext context) {
    return NoLoanScaffold();
  }

  @override
  void initState() {
    // TODO: implement initState
    print('parent employer ${parentEmployerId}');
    getaloansList();
    getEmploymentProfile();
    super.initState();
  }

  getaloansList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().loanLists(clientID.toString());

    respose.then((response) async {
    //  print(response['data']);

      if(response['status'] == false){

      } else {

        setState(() {
        //  CustomerLists = response['data']['loanAccounts'];
          CustomerLists = response['data']['pageItems'];
       });
        // }
        setState(() {
        List<dynamic>  newCustomerLists =     CustomerLists.where((element) => element['status']['id'] != 0).toList();
        CustomerLists = newCustomerLists;
        });

        print('customer Product ${CustomerLists}');
      }


    }
    );

  }


  checkisStaffQualifiedAndBvnAvailable() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String passed_staff_id =   prefs.getString('loanOfficerId');
    print('>> a staff Id >> ${passed_staff_id}');
    setState(() {
      _isLoading = true;
    });
    RetCodes rtCocdes = RetCodes();
    rtCocdes.loanPermission(int.tryParse(passed_staff_id), clientID).then((value) {
      setState(() {
        _isLoading = false;
      });

    //  print('>> is bool ${value['data']['loanBookingPermission']['canBookOtherLoans']}');

      bool canBookNewLoan = value['data'] == null ? false :  value['data']['loanBookingPermission']['canBookNewLoan'] ?? false;
      bool canBookOtherLoans = value['data'] == null ? false : value['data']['loanBookingPermission']['canBookOtherLoans'] ?? false;


      if(canBookNewLoan == false){
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: "You are not eligible to book this loan,kindly contact people's management",
          duration: Duration(seconds: 6),
        ).show(context);
      }

     else if(canBookNewLoan == true  || canBookOtherLoans)
    //    if(true)
      {
        setState(() {
          _isLoading = true;
        });
        rtCocdes.isBvnAvailable(clientID).then(
                (value) {
              setState(() {
                _isLoading = false;
              });

              if(value ==  false){
                Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.redAccent,
                  title: 'Error ',
                  message: 'Kindly update client\'s BVN in KYC ',
                  duration: Duration(seconds: 3),
                ).show(context);
              }
              else {
                if(employerID == null){
                  return   Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                    backgroundColor: Colors.blueAccent,
                    title: 'Hold ✊',
                    message: 'Please hold, loan configuration still loading ',
                    duration: Duration(seconds: 3),
                  ).show(context);
                }
                else {
                  //    showModalForLoanOptions();
                  MyRouter.pushPage(context,NewLoan(clientID: clientID,employerId: employerID,sectorID:sectorId,parentClientType:parentClient ,));
                }
              }

            }
        );
      }

    });
  }

  click_filterloansList(int statusId){
    final Future<Map<String,dynamic>> respose =   RetCodes().filterLoanWithStatusId(clientID.toString(),statusId);

    respose.then((response) async {
      //  print(response['data']);
      if(response['status'] == false){

      } else {

        setState(() {
          //  CustomerLists = response['data']['loanAccounts'];
          CustomerLists = response['data']['pageItems'];
        });
        // }
        setState(() {
          List<dynamic>  newCustomerLists =     CustomerLists.where((element) => element['status']['id'] != 0).toList();
          CustomerLists = newCustomerLists;

        });

        print('customer Product ${CustomerLists}');
      }


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
      employerLoaded = false;
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
      employerLoaded = true;
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

  v_goBack(BuildContext context,String value,{Function newFn}){
    if(value == 'go_back'){
      // MyRouter.popPage(context);
      MyRouter.pushPageReplacement(context, ViewClient(clientID: clientID,));
    }else if(value == 'go_home'){
      MyRouter.pushPageReplacement(context, MainScreen());
    }
  }

  filterLoanWithStatusId(int loanStatusId){

  }




  filterLoanView(value){

    getaloansList();

    if(value == 'loan_in_draft'){
      var newFiltered = CustomerLists.where((element) => element['status']['value'] == 'Loan in draft').toList();
      print('filtered');
      setState(() {
        filteredLoans = newFiltered;
      });

    }

    else if(value == 'active'){
      var newFiltered = CustomerLists.where((element) => element['status']['value'] == 'Active').toList();
      print('filtered');
      setState(() {
        filteredLoans = newFiltered;
      });
    }

    else if(value == 'approved'){
      var newFiltered = CustomerLists.where((element) => element['status']['value'] == 'Approved').toList();
      print('filtered');
      setState(() {
        filteredLoans = newFiltered;
      });
    }


    else if(value == 'all_loans'){
  //  var newFiltered = CustomerLists.where((element) => element['status']['value'] == 'Approved').toList();
    print('filtered');
    setState(() {
  //  filteredLoans = newFiltered;
    //  filteredLoans = new;
    });
    }
    else if(value == 'rejected'){

      var newFiltered = CustomerLists.where((element) => element['status']['value'] == 'Rejected').toList();
      print('filtered');
      setState(() {
        filteredLoans = newFiltered;
      });
    }
    else if(value == 'pending'){

      var newFiltered = CustomerLists.where((element) => element['status']['value'].contains('pending')).toList();
      print('filtered');
      setState(() {
        filteredLoans = newFiltered;
      });
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
            title: Text('Loans',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            centerTitle: true,
            leading:
            // IconButton(
            //   onPressed: (){
            //     MyRouter.popPage(context);
            //   },
            //   icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
            // ),
            // appBack(context),
            PopupMenuButton(
              icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.blue,),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'go_back',
                    child: Row(
                      children: [
                        //  Icon(Icons.arrow_back_ios,color: ColorUtils.PRIMARY_COLOR,),
                        SizedBox(width: 5,),
                        Text('Previous Screen',),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'go_home',
                    child: Row(
                      children: [
                        //  Icon(FeatherIcons.home,color: ColorUtils.PRIMARY_COLOR,),
                        SizedBox(width: 5,),
                        Text('Go To Dashboard'),
                      ],
                    ),
                  ),


                ];
              },
              onSelected: (String value) => v_goBack(context,value,
              ),
            ),
            actions: [
              // IconButton(
              //   onPressed: (){
              //     // MyRouter.popPage(context);
              //     // showSearch(context: context, delegate: InteractionSearch());
              //   },
              //   icon: Icon(FeatherIcons.filter,color: Colors.blue,),
              // ),

              // PopupMenuButton(
              //     icon:  Icon(FeatherIcons.filter,color: Colors.blue,),
              //     itemBuilder: (context) {
              //       return [
              //         PopupMenuItem(
              //           value: 'loan_in_draft',
              //           child: Text('Loan In Draft',),
              //         ),
              //         PopupMenuItem(
              //           value: 'pending',
              //           child: Text('Pending Loans'),
              //         ),
              //         PopupMenuItem(
              //           value: 'active',
              //           child: Text('Active Loans'),
              //         ),
              //         PopupMenuItem(
              //           value: 'approved',
              //           child: Text('Approved Loans'),
              //         ),
              //         PopupMenuItem(
              //           value: 'all_loans',
              //           child: Text('All Loans'),
              //         ),
              //
              //       ];
              //     },
              //     onSelected: (String value) {
              //
              //       filterLoanView(value);
              //       // getaloansList();
              //     }
              // )
              PopupMenuButton(
                icon: Icon(Icons.filter_list, color: Colors.blue),
                itemBuilder: (context) {
                  return [
                    for (var entry in colorUtilsMap.entries)
                      PopupMenuItem(
                        value: entry.key,
                        child: Text(getHumanReadable(entry.key)),
                      ),
                  ];
                },
                onSelected: (String value) {
                    int loan_status_val = m_filterLoanView(value);
                  click_filterloansList(loan_status_val);
               //   filterLoanView(value);
                  // getaloansList();
                },
              ),

            ],
          ),
          body: LoanView(),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                checkisStaffQualifiedAndBvnAvailable();

           },
              child:     SvgPicture.asset("assets/images/new_plus.svg",
                height: 70.0,
                width: 70.0,
              )
          ),

        ),
      ),
    );
  }

  Widget NoloanView(){
    return Container(
      child: Center(
        child:
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Loan Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('This user currently has no loan record.',style: TextStyle(color: Colors.black,fontSize: 14,),),
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
                  checkisStaffQualifiedAndBvnAvailable();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:   Text(
                    'Book New Loan',
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

            CustomerLists == null ? NoloanView() :
            CustomerLists.isEmpty ?
            NoloanView()
            // Container(
            //   height: 550,
            //   child: ProfileShimmerLoading(),
            // )
                : Column(
              children: [
                employerID == null && employerLoaded == true ? noEmployerDialog(onTap: (){
                  MyRouter.pushPage(
                      context,
                      SingleCustomerScreen(
                        clientID: clientID,
                      )
                  );
                }): SizedBox(),
                LoanListTile(),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget LoanListTile(){

    return filteredLoans.isEmpty ?
      ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: CustomerLists == null || CustomerLists.isEmpty ? 0 : CustomerLists.length,
          itemBuilder: (index,position){
            var loanPosition = CustomerLists[position];
            print('customers Lists>> ${CustomerLists.where((element) => element['status']['id'] != 0)}');
       //     print('clientID: ${loanPosition}');
            return  InkWell(
              onTap: (){

                MyRouter.pushPage(context, SingleLoanView(loanID: loanPosition['id'],clientID: clientID,));
              //  MyRouter.pushPage(context, SingleLoanView(loanID: 14562974,clientID: 2178641,));
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
                          Text('LoanId: ${loanPosition['id']}',style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w200),),
                          SizedBox(height: 12,),
                          // clientStatus('${loanPosition['status']['value']}' == 'Loan in draft' ?  Color(0xff707070) :
                          // '${loanPosition['status']['value']}' == 'Active' || '${loanPosition['status']['value']}' == 'Approved' ? Color(0xff56C596):
                          // Color(0xffDE914A)
                          //     ,
                          //     chopPending(loanPosition['status']['value']) == 'Loan in draft' ?
                          //     'Loan In Draft' :
                          //     '${loanPosition['status']['value']}' == 'Active'  ? 'Active' : '${loanPosition['status']['value']}' == 'Approved' ? 'Approved':
                          //     'Pending'
                          // ),

                             clientStatus(colorChoser(loanPosition['status']['id']), '${chopPending(loanPosition['status']['value'])}')


                        ],
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Row(
                            // loanProductName
                            //productName
                            children: [
                              Text('${loanPosition['loanProductName']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Black',fontSize: 12,color: Color(0xff707070)),),
                              SizedBox(width: 10,),
                              // Text('#${CustomerLists[position]['id']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Black',fontSize: 10,color: Color(0xff707070)),),

                            ],
                          ),
                          SizedBox(height: 10,),
                           Text('${'${loanPosition['timeline']['submittedOnDate'][0]} / ${loanPosition['timeline']['submittedOnDate'][1]}  / ${loanPosition['timeline']['submittedOnDate'][2]} '}'),






                          // Text(
                          //   loanPosition['timeline'] == null
                          //       ? '---'
                          //       : retDOBfromBVN(
                          //           '2024-09-10'
                          //   ),
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       fontFamily: 'Nunito SansRegular',
                          //       fontSize: 16),
                          // ),

                        ],
                      ),
                      // subtitle:

                    ),
                  ),
                ),
              ),
            );
          }) :
      ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: filteredLoans == null || filteredLoans.isEmpty ? 0 : filteredLoans.length,
          itemBuilder: (index,position){
            var loanPosition = filteredLoans[position];
            print('${CustomerLists}');
            return  InkWell(
              onTap: (){
             //   MyRouter.pushPage(context, SingleLoanView(loanID: 14562974,clientID: 2178641,));
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
                          Text('${loanPosition['accountNo']}',style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w200),),
                          SizedBox(height: 12,),
                          clientStatus('${loanPosition['status']['value']}' == 'Loan in draft' ?  Color(0xff707070) :
                          '${loanPosition['status']['value']}' == 'Active' || '${loanPosition['status']['value']}' == 'Approved' ? Color(0xff56C596):
                          Color(0xffDE914A)
                              ,chopPending(loanPosition['status']['value']) == 'Loan in draft' ?
                              'Loan In Draft' :
                              '${loanPosition['status']['value']}' == 'Active'  ? 'Active' : '${loanPosition['status']['value']}' == 'Approved' ? 'Approved':
                              'Pending'
                          ),
                       //   clientStatus(colorChoser(loanPosition['status']['id']), '${loanPosition['status']['value']}')
                        ],
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Text('${loanPosition['loanProductName']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Black',fontSize: 12,color: Color(
                                  0xff707070)),),
                              SizedBox(width: 10,),
                              // Text('#${CustomerLists[position]['id']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito Black',fontSize: 10,color: Color(0xff707070)),),

                            ],
                          ),
                          SizedBox(height: 10,),


                           Text('${'${loanPosition['timeline']['submittedOnDate'][0]} / ${loanPosition['timeline']['submittedOnDate'][1]}  / ${loanPosition['timeline']['submittedOnDate'][2]} '}'),


                        ],
                      ),
                      // subtitle:

                    ),
                  ),
                ),
              ),
            );
          })
    ;

  }



  Widget clientStatus(Color statusColor,String status) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.33,
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
    if(pends.contains('Pending') || pends.contains('pending')){
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


  showModalForLoanOptions(){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
      ),
      context: context,
      builder: ((builder) => bottomSheet()),
    );

  }


  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Select an option to proceed",
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Nunito SansRegular',
                fontWeight: FontWeight.w700,
                color: ColorUtils.SELECT_OPTION
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: (){
              MyRouter.pushPage(context,RemittaBioData(clientID: clientID,employerId: employerID,sectorID:sectorId,parentClientType:parentClient ,));

            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Use Remita Referencing',style: TextStyle(fontSize: 17),),
                  Icon(Icons.arrow_forward_ios,color: ColorUtils.SELECT_OPTION,size: 20,)

            ]
            ),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: (){
                 MyRouter.pushPage(context,NewLoan(clientID: clientID,employerId: employerID,sectorID:sectorId,parentClientType:parentClient ,));

            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Use CDL Referencing',style: TextStyle(fontSize: 17),),
                  Icon(Icons.arrow_forward_ios,color: ColorUtils.SELECT_OPTION,size: 20,)

                ]
            ),
          ),



        ],
      ),
    );
  }


  retDOBfromBVN(String getDate) {
    print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);

    if (wordList[1] == '1') {
      setState(() {
        realMonth = 'January';
      });
    }
    if (wordList[1] == '2') {
      setState(() {
        realMonth = 'February';
      });
    }
    if (wordList[1] == '3') {
      setState(() {
        realMonth = 'March';
      });
    }
    if (wordList[1] == '4') {
      setState(() {
        realMonth = 'April';
      });
    }
    if (wordList[1] == '5') {
      setState(() {
        realMonth = 'May';
      });
    }
    if (wordList[1] == '6') {
      setState(() {
        realMonth = 'June';
      });
    }
    if (wordList[1] == '7') {
      setState(() {
        realMonth = 'July';
      });
    }
    if (wordList[1] == '8') {
      setState(() {
        realMonth = 'August';
      });
    }
    if (wordList[1] == '9') {
      setState(() {
        realMonth = 'September';
      });
    }
    if (wordList[1] == '10') {
      setState(() {
        realMonth = 'October';
      });
    }
    if (wordList[1] == '11') {
      setState(() {
        realMonth = 'November';
      });
    }
    if (wordList[1] == '12') {
      setState(() {
        realMonth = 'December';
      });
    }

    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o3.length == 1 ? '0' + '' + o3 : o3;

    print('newOO ${newOO}');

    String concatss = newOO + " " + realMonth + " " + o1;

    print("concatss new Date from edit ${concatss}");

    return concatss;
  }


}
