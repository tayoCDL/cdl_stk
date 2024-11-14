import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/secondNewLoan.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EmbeddedDetails.dart';

class EmbeddedNewLoan extends StatefulWidget {
  // const NewLoan({Key key}) : super(key: key);
  //
  // @override
  // _NewLoanState createState() => _NewLoanState();

  final int clientID, productId, loanId, employerId, sectorID, parentClientType;

  const EmbeddedNewLoan(
      {Key key,
        this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType})
      : super(key: key);

  @override
  _EmbeddedNewLoanState createState() => _EmbeddedNewLoanState(
      clientID: this.clientID,
      productId: this.productId,
      loanId: this.loanId,
      employerId: this.employerId,
      sectorID: this.sectorID,
      parentClientType: this.parentClientType);
}

class _EmbeddedNewLoanState extends State<EmbeddedNewLoan> {
  int clientID, productId, loanId, employerId, sectorID, parentClientType;

 // TextEditingController staffId = TextEditingController();

  _EmbeddedNewLoanState(
      {this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType});

  @override
  List<String> productArray = [];
  List<String> collectProduct = [];
  List<String> collectProds = [];

  List<dynamic> allProduct = [];
  List<String> filteredProduct = [];

  List<String> purposeArray = [];
  List<String> collectPurpose = [];
  List<dynamic> allPurpose = [];
  List<dynamic> allEmployer = ["employer"];
  bool _isLoading = false;

  int sectorId;

  List<String> fundingArray = [];
  List<String> collectFunding = [];
  List<dynamic> allFunding = [];
  String productName = '';
  String PassloanPurpose = '';
  String username,clientBvn;
  int productInt, purposeInt;
  String staff_id;
  var employmentProfile = [];
  int employerID;
  int thirdparty_channelId;
  Map<String,dynamic> thirdPartylenderResponse,wacs_result,wacs_thirdPartylenderResponse;
  String mob1 = '',mob2='';
  bool incompleteProfile = false;
  void initState() {
    // TODO: implement initState

    print('print parent ${parentClientType}');
    //loadPurposeTemplate();
    getUserProfile();
   // fundingOptionTemplate();
    if (loanId != null) {
      getLoanDetails();
    }
    getEmploymentProfile();
    getSalesUsername();
    // print('loan Id ${loanId}');
   // loadLoanTemplates();

    super.initState();
  }



  getUserProfile(){
    final Future<Map<String,dynamic>> response =   RetCodes().getClientProfile(clientID.toString());
    response.then((responseData) {
      print('this>> << ${responseData}');
      setState(() {
        clientBvn = responseData['bvn'];

        //  interestRateForPrivate = responseData['data']['data']['categpries']['interestRate'];
        //    String nomsInterest = responseData['data']['data']['categpries']['interestRate'].toString();

      });

    });

  }

  getSalesUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Vusername = prefs.getString('username');
    print('Vusername ${Vusername}');
    prefs.remove('loanCreatedId');
    setState(() {
      loanOfficer.text = Vusername;
    });
  }

  // getEmploymentProfile() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var token = prefs.getString('base64EncodedAuthenticationKey');
  //   var tfaToken = prefs.getString('tfa-token');
  //   print(tfaToken);
  //   print(token);
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Response responsevv = await get(
  //     AppUrl.getSingleClient + clientID.toString() + '/employers',
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
  //       'Authorization': 'Basic ${token}',
  //       'Fineract-Platform-TFA-Token': '${tfaToken}',
  //     },
  //   );
  //   print(responsevv.body);
  //
  //   final List<dynamic> responseData2 = json.decode(responsevv.body);
  //   print('responseData2 ${responseData2}');
  //
  //
  //   setState(() {
  //     allEmployer = responseData2;
  //
  //     employerID = responseData2[0]['employer']['parent']['id'];
  //     sectorId = responseData2[0]['employer']['sector']['id'];
  //     parentClientType =
  //     responseData2[0]['employer']['parent']['clientType']['id'];
  //     staff_id = responseData2[0]['staffId'].toString();
  //     _isLoading = false;
  //
  //     if(responseData2.length == 0){
  //       allEmployer = [];
  //     }
  //   });
  //
  //
  //   print('employer ID ${employerID}');
  //
  //
  //   //salary_range = employmentProfile[0]['salaryRange']['id'];
  // }

  Future<void> getEmploymentProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('base64EncodedAuthenticationKey');
      final String tfaToken = prefs.getString('tfa-token');

      print(tfaToken);
      print(token);

      setState(() {
        _isLoading = true;
      });

      final Response response = await get(
        Uri.parse(AppUrl.getSingleClient + clientID.toString() + '/employers'),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic $token',
          'Fineract-Platform-TFA-Token': '$tfaToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body) as List<dynamic>;
        print('responseData2 $responseData');

        setState(() {
          allEmployer = responseData.isNotEmpty ? responseData : [];

          if (responseData.isNotEmpty) {
            employerID = responseData[0]['employer']['parent']['id'];
            sectorId = responseData[0]['employer']['sector']['id'];
            parentClientType = responseData[0]['employer']['parent']['clientType']['id'];
            staff_id = responseData[0]['staffId']?.toString() ?? '';
          }

          _isLoading = false;
        });

        print('employer ID $employerID');
      } else {
        setState(() {
          allEmployer = [];
          _isLoading = false;
        });
        print('Failed to load employment profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        allEmployer = [];
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  load_dedukt_employerProduct(){
    print('employer ID ${employerID}');

    final Future<Map<String, dynamic>> respose =
    RetCodes().thirdparty_employerProduct(employerID);
    setState(() {
      _isLoading = true;
    });
    respose.then((response) {
      print('response >> employer ${response}');
      setState(() {
        _isLoading = false;
        //  thirdPartylenderId = response['lenderEmployerId'];
        thirdPartylenderResponse = response == null ? null : response['data'] == null || response['data'].length == 0 ? null :  response['data'][0];
      });
    });
  }

   _showMessageDialog(BuildContext context,{String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incomplete Profile'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  load_wacs_employerProduct({String numberChanged}) async{
    final Future<Map<String, dynamic>> respose =
    RetCodes().new_getClientProfile(clientID.toString());
    setState(() {
      _isLoading = true;
    });
    respose.then((response) {

      print('response >> client profile ${response}');
      setState(() {
        _isLoading = false;
        mob1 = response['clients']['mobileNo'];
        mob2 = response['clients']['alternateMobileNo'] ?? null;
        first_name.text = response['clients']['firstname'] ?? '';
        last_name.text = response['clients']['lastname'] ?? null;
        email_address.text = response['clients']['emailAddress'] ?? '';

      });


      print('response from check ${response['clientEmployers']}');
    //  print(AppHelper().checkAndMapClientData(response));

      if( response['clientEmployers'] == null ||  response['clientEmployers'][0]['staffId'] == null){

        _showMessageDialog(context, message: 'Staff ID data is missing or empty');
        setState(() {
          incompleteProfile = true;
        });
        return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Incomplete profile',
          message: 'Staff ID data is missing or empty',
          duration: Duration(seconds: 3),
        ).show(context);

      }

      if(AppHelper().checkAndMapClientData(response).runtimeType == String){
        _showMessageDialog(context, message: AppHelper().checkAndMapClientData(response));
        setState(() {
          incompleteProfile = true;
        });
      return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Incomplete profile',
          message: AppHelper().checkAndMapClientData(response),
          duration: Duration(seconds: 3),
        ).show(context);

      }
       else {
        setState(() {
          _isLoading = false;
          wacs_result = AppHelper().checkAndMapClientData(response,
              passedMobileNumber: numberChanged ?? null,
              firstName: first_name.text,
              lastName: last_name.text,
              emailAddress: email_address.text
          );
        });
      }



         }
            );

  }

  // create_wacs_client() async{
  //   final Future<Map<String,dynamic>> wacs_response =   RetCodes().fetch_wacs_profile(wacs_result,staffId: int.tryParse(staff_id));
  //     setState(() {
  //       _isLoading = true;
  //     });
  //   wacs_response.then((responseData) {
  //
  //     print('this encrypted 0000>> << ${responseData}');
  //     setState(() {
  //       _isLoading = false;
  //       if(responseData['statusCode'] == 200){
  //       wacs_thirdPartylenderResponse = responseData['data'];
  //      return   MyRouter.pushPage(
  //             context,
  //             EmbeddedDetails(
  //               clientID: clientID,
  //               employerId: employerID,
  //               staff_id: staff_id,
  //               sectorID: sectorID,
  //               thirdParty_response: wacs_thirdPartylenderResponse,
  //               channelId: 2,
  //             )
  //         );
  //
  //       }
  //       else if(responseData['statusCode'] == 400){
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //           backgroundColor: Colors.red,
  //           title: 'Error',
  //           message: responseData['message'],
  //           duration: Duration(seconds: 3),
  //         ).show(context);
  //       }
  //
  //     });
  //
  //   });
  //
  // }

  create_wacs_client() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('>> wacs result >> ${wacs_result} ');
      // setState(
      //     (){
      //       wacs_result = AppHelper().checkAndMapClientData(response,
      //           passedMobileNumber: numberChanged ?? null,
      //           firstName: first_name.text,
      //           lastName: last_name.text,
      //           emailAddress: email_address.text
      //       );
      //     }
      // );
      setState(() {
        wacs_result['first_name'] = first_name.text;
        wacs_result['last_name'] = last_name.text;
        wacs_result['email'] = email_address.text;
      });

      print('new wacs >> ${wacs_result}');
    //  final Future<Map<String, dynamic>> wacs_response = RetCodes().fetch_wacs_profile(wacs_result, staffId: int.tryParse(staff_id));
      final Future<Map<String, dynamic>> wacs_response = RetCodes().fetch_wacs_profile(wacs_result, staffId: staff_id);
      final responseData = await wacs_response;

      setState(() {
        _isLoading = false;
        if (responseData['statusCode'] == 200) {
          wacs_thirdPartylenderResponse = responseData['data'];
          print('wacs response >> ${wacs_thirdPartylenderResponse}');
          Map<String,dynamic> updated_wac_thirdparty_response = {
            "is_federal_wacs": thirdparty_channelId == 2 ? true : false,
            ...wacs_thirdPartylenderResponse
          };
          MyRouter.pushPage(
            context,
            EmbeddedDetails(
              clientID: clientID,
              employerId: employerID,
              staff_id: staff_id,
              sectorID: sectorID,
              thirdParty_response: updated_wac_thirdparty_response,
              channelId: 2,
            ),
          );
        } else if (responseData['statusCode'] == 400) {
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: responseData['message'],
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    } catch (error) {
      print('error >> ${error}');
      setState(() {
        _isLoading = false;
      });
      // Handle error here, maybe show a Flushbar or some other error message
      Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'Something went wrong',
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  var productData = [];

  loadLoanTemplates() async {
    print('this is clientID ${clientID} ${employerId}');
    int empID = employerID == null ? employerId : employerID;
    print('empID ${empID}');
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().getLoanProducts(clientID, empID);
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      // print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        collectProduct = [];

        allProduct = newEmp;
      });

      print('all Products ${newEmp}');

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['name']);
        collectProduct.add(newEmp[i]['name']);
      }
      // var filteredProduct = collectProduct.where((element) => element['name'] == 'FEDERAL SPEED')
      filteredProduct = collectProduct;
      print('sector ID ${sectorID}');

      //fed speed=> 28
// state => 43
      // dpl => 36

// so far federal speed, digital personal loan and state loan is part of result... display it to user then yank every other thing out

      // if(parentClientType != null && parentClientType == 67){
      //   filteredProduct =   collectProduct.where((element) => element == 'FEDERAL SPEED' || element == 'Nano Loan' || element == 'FEDERAL LOAN' || element == 'FEDERAL').toList();
      // }
      // else if (parentClientType != null && parentClientType == 68){
      //   filteredProduct =   collectProduct.where((element) => element == 'Sharp Sharp (State Business)' || element == 'State Loan Product' ).toList();
      // }
      // else if (parentClientType != null && parentClientType == 2645){
      //   filteredProduct =   collectProduct.where((element) => element == 'DEVICE FINANCING' || element == 'Digital Personal Loan' || element == 'Nano Loan' || element == 'PayFi').toList();

      // }

      //   print('real newEmp ${newEmp}');
// real_sandbox
      var filtered = newEmp
          .where((element) =>
      element['id'] == 43 || element['id'] == 36 || element['id'] == 28 || element['id'] == 30)
          .toList();



      // NEW PRODUCTION
      //  || element['id'] == 42
      // var filtered = newEmp
      //     .where((element) =>
      //    element['id'] == 63 || element['id'] == 40 || element['id'] == 55 || element['id'] == 64 || element['id'] == 49 || element['id'] == 52 || element['id'] == 71 || element['id'] == 72)
      //     .toList();


// SANDBOX
      //   var filtered = newEmp.where((element) => element['id'] == 49 || element['id'] == 40).toList();

      for (int i = 0; i < filtered.length; i++) {
        print(filtered[i]['name']);
        collectProds.add(filtered[i]['name']);
        collectProduct.add(filtered[i]['name']);
      }

      print('vis alali filtered product.. ${collectProds}');
      //print(filteredProduct);

      setState(() {
        filteredProduct = collectProds;
        productArray = collectProduct;
        _isLoading = false;
      });
    });
  }


  getLoanDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('this is ir ');

    Response responsevv = await get(
      AppUrl.getLoanDetails + loanId.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      //  loanDetail = newClientData;
      productName = newClientData['loanProductName'];
      PassloanPurpose = newClientData['loanPurposeName'];
      productInt = newClientData['loanProductId'];
      purposeInt = newClientData['loanPurposeId'];
      clientID = newClientData['clientId'];
    });
  }

  int currentStep = 0;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  TextEditingController extrernalID = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController loanOfficer = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email_address = TextEditingController();

  bool value = false;

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
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: IconButton(
        //     onPressed: (){
        //       MyRouter.popPage(context);
        //     },
        //     icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        //   ),
        //   title: Text('Loans',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
        //   centerTitle: true,
        // ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  // LoanStepper(),
                  ProgressStepper(
                    stepper: 0.2,
                    title: 'Loan Details',
                    subtitle: 'Loan Term',
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      allEmployer.length == 0 ? noEmployerDialog() : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('3rd Party Loans ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Nunito SansRegular')),
                            SizedBox(
                              height: 8,
                            ),

                            Text(
                                'Select your preferred third-party provider.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontFamily: 'Nunito SansRegular')),
                            SizedBox(
                              height: 20,
                            ),
                            ProductWidge(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20),
                            //
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       Text('Savings Linkage',style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),)
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            //
                            // savingLinkage(),
                            // SizedBox(height: 20,),

                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(
          text1: 'Previous',
          callAction1: (){
            MyRouter.popPage(context);
          },
          text2: 'Next',
          callAction2: () {
            //    MyRouter.pushPage(context, DocumentForLoan());
            //
            // print('purpose Int ${purposeInt}');
            //
            // if (purposeInt == null) {
       //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
            //     backgroundColor: Colors.red,
            //     title: 'Validation Error',
            //     message: 'Loan purpose is mandatory',
            //     duration: Duration(seconds: 3),
            //   ).show(context);
            // }
            // if (productInt == null) {
       //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
            //     backgroundColor: Colors.red,
            //     title: 'Validation Error',
            //     message: 'Loan product is mandatory',
            //     duration: Duration(seconds: 3),
            //   ).show(context);
            // }
            // if(employerID == null){
            //   return   Flushbar(
            //     flushbarPosition: FlushbarPosition.TOP,
            //     flushbarStyle: FlushbarStyle.GROUNDED,
            //     backgroundColor: Colors.blueAccent,
            //     title: 'Hold ✊',
            //     message: 'Please hold, we are retrieving employer\'s information',
            //     duration: Duration(seconds: 3),
            //   ).show(context);
            // }

            if(thirdparty_channelId == null){
              return   Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                title: 'Error',
                message: 'Select an option above',
                duration: Duration(seconds: 3),
              ).show(context);
            }
            if(thirdPartylenderResponse  == null && (thirdparty_channelId == 2 || thirdparty_channelId == 3)){
                    if(incompleteProfile == true){
                      return _showMessageDialog(context,message: 'Update missing data');
                    }
                     else {
                        return create_wacs_client();
                    }

            }
            if(thirdPartylenderResponse == null){
                return   Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.red,
                  title: 'Error',
                  message: 'Unknown Employer',
                  duration: Duration(seconds: 3),
                ).show(context);
            }
              else {
              MyRouter.pushPage(
                  context,
                  EmbeddedDetails(
                    clientID: clientID,
                    employerId: employerID,
                    staff_id: staff_id,
                    sectorID: sectorID,
                    thirdParty_response: thirdPartylenderResponse,
                    channelId: 1,
                  )
              );
            }

          },
        ),
      ),
    );
  }

  Widget LoanStepper() {
    return Material(
      elevation: 10,
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        padding: EdgeInsets.only(left: 45, right: 45),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: Color(0xff177EB9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 18,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Terms',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 18,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Document',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ProductWidge() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.53,
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropDownComponent(
                  items: ['DEDUKT','FEDERAL WACS','PARAMILITARY WACS'],
                  onChange: (String item) async {
                    setState(() {
                      if(item == 'DEDUKT'){
                        thirdparty_channelId = 1;
                        load_dedukt_employerProduct();
                      }
                      else if(item == 'FEDERAL WACS') {
                        thirdPartylenderResponse = null;
                        thirdparty_channelId = 2;
                        load_wacs_employerProduct();
                      }

                      else {
                        thirdPartylenderResponse = null;
                        thirdparty_channelId = 3;
                        load_wacs_employerProduct();
                      }
                    });
                    print('>>TP ${thirdparty_channelId}');
                  },
                  label: "Select   *",
                  selectedItem: '',
                  validator: (String item) {
                    if (item.length == 0) {
                      return "Embedded Partner is mandatory ";
                    }
                  }),
            ),
            // SizedBox(
            //   height: 2,
            // ),
            //

            if(thirdparty_channelId != null && (
               ( thirdparty_channelId == 2 ||
                thirdparty_channelId == 3)
              && (mob2 != null &&  mob2.length > 4)
            ))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: DropDownComponent(
                      items: [mob1,mob2],
                      onChange: (String item) async {
                        load_wacs_employerProduct(numberChanged: item);
                      },
                      label: "Select Mobile Number   *",
                      selectedItem: '',
                      validator: (String item) {
                        if (item.length == 0) {
                          return "Mobile Number ";
                        }
                      }),
                ),



            thirdparty_channelId != null && (
                thirdparty_channelId == 2 || thirdparty_channelId == 3
            ) ?
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                        child: EntryField(
                            context,
                            first_name,
                            'First Name *',
                            'First Name',
                            TextInputType.text,
                            )
                    ),
                    SizedBox(height: 4,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: EntryField(
                          context,
                          last_name,
                          'Last Name *',
                          'Last Name',
                          TextInputType.text,
                        )
                    ),
                    SizedBox(height: 4,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: EntryField(
                          context,
                          email_address,
                          'Email Address *',
                          'Email Address',
                          TextInputType.text,
                        )
                    ),
                    SizedBox(height: 4,)
                  ],
                )
            :
                SizedBox(),


            SizedBox(
              height: 2,
            ),
            Text("The customer KYC details will be used to process this loan"),
            SizedBox(
              height: 6,
            ),


            SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        print(selected);
        //  date = selected.toString();
        String vasCoddd = retsNx360dates(selected);
        dateController.text = vasCoddd;
      });
  }

  retsNx360dates(DateTime selected) {
    String newdate = selectedDate.toString().substring(0, 10);
    print(newdate);

    String formattedDate = DateFormat.yMMMMd().format(selected);

    String removeComma = formattedDate.replaceAll(",", "");

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String concatss = o2 + " " + o1 + " " + o3;
    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }

  Widget EntryField(
      BuildContext context,
      var editController,
      String labelText,
      String hintText,
      var keyBoard, {
        bool isPassword = false,
        isRealOnly: false,
      }) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
      height: MediaSize.height * 0.095,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
          //  color: Theme.of(context).backgroundColor,

            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: keyBoard,

            controller: editController,

            // validator: (value)=>value.isEmpty?'Please enter password':null,
            // onSaved: (value) => vals = value,
            readOnly: isRealOnly,
            decoration: InputDecoration(
                suffixIcon: isPassword == true
                    ? Icon(
                  Icons.remove_red_eye,
                  color: Colors.black38,
                )
                    : null,
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                floatingLabelStyle: TextStyle(color: Color(0xff205072)),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.black, fontFamily: 'Nunito SansRegular'),
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color)),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  Widget savingLinkage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      padding: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            DropDownComponent(
                items: [],
                onChange: (String item) {
                  setState(() {});
                },
                label: "Link Savings",
                selectedItem: "---",
                validator: (String item) {}),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: this.value,
                  onChanged: (bool value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                ),
                Text(
                  'Create standing instructions at disbursement',
                  style: TextStyle(fontSize: 11),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget noEmployerDialog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          child: Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Warning',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Icon(Icons.clear)
                ],
                //
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Loan product is not detected for client \n kindly update the client employer to view loan product',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    MyRouter.pushPage(
                        context,
                        SingleCustomerScreen(
                          clientID: clientID,
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Update client Employer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

}
