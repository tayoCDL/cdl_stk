import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

import 'create_wacs_loan_terms.dart';
import 'embedded_loan_terms.dart';

class EmbeddedDetails extends StatefulWidget {
  // const NewLoan({Key key}) : super(key: key);
  //
  // @override
  // _NewLoanState createState() => _NewLoanState();

  final int clientID, productId, loanId, employerId, sectorID, parentClientType,channelId;
  final Map<String,dynamic> thirdParty_response;
  final String staff_id;
  const EmbeddedDetails(
      {Key key,
        this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType,
        this.thirdParty_response,
        this.staff_id,
        this.channelId
      })
      : super(key: key);

  @override
  _EmbeddedDetailsState createState() => _EmbeddedDetailsState(
      clientID: this.clientID,
      productId: this.productId,
      loanId: this.loanId,
      employerId: this.employerId,
      sectorID: this.sectorID,
      parentClientType: this.parentClientType,
      thirdParty_response: this.thirdParty_response,
      staff_id: this.staff_id,
      channelId: channelId
  );
}

class _EmbeddedDetailsState extends State<EmbeddedDetails> {
  int clientID, productId, loanId, employerId, sectorID, parentClientType,channelId;
  Map<String,dynamic> thirdParty_response;
  String staff_id;
 // TextEditingController staffId = TextEditingController(text: 'CDL00OP');
  bool isCustomerFound = false;

  _EmbeddedDetailsState(
      {this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType,
        this.thirdParty_response,
        this.staff_id,
        this.channelId
      });

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
  bool _isDeduktLoading = false;

  int sectorId;

  List<String> fundingArray = [];
  List<String> collectFunding = [];
  List<dynamic> allFunding = [];
  String productName = '';
  String PassloanPurpose = '';
  String username,clientBvn;
  int productInt, purposeInt;
  var employmentProfile = [];
  int employerID;

  Map<String,dynamic> third_party_client_info = {};

  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");


  void initState() {
    // TODO: implement initState
  //  print('channel ID ${channelId}');
    if(channelId == 1){
      getThirdPartyLoanInfo();
    }

    print('print parent ${parentClientType} ${thirdParty_response}');
    //loadPurposeTemplate();
    getUserProfile();

    // fundingOptionTemplate();
    if (loanId != null) {
      getLoanDetails();
    }
    getEmploymentProfile();
    getSalesUsername();
    // print('loan Id ${loanId}');
    loadLoanTemplates();

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

  getThirdPartyLoanInfo(){
    setState(() {
      _isLoading = true;
      _isDeduktLoading = true;
    });
    print('>> staffid ${staff_id} ${_isDeduktLoading}');
    Map<String,dynamic> userRequest = {
        "channelId": 1,
       // "staffId": thirdParty_response['employerId'],
       // "staffId": 12223,
       // "staffId": 62677,
        "staffId": staff_id.toString(),
        "companyUUId": thirdParty_response['lenderEmployerId'],
    };
    print(' user request >> ${userRequest}');
    final Future<Map<String,dynamic>> response =   RetCodes().get_encryptAndSend(userRequest);
    response.then((responseData) {
      // setState(() {
      //   _isLoading = false;
      // });
      print('this encrypted 0000>> << ${responseData['data']}');
      setState(() {
        if(responseData['statusCode'] == 200){
          isCustomerFound =  true;
          third_party_client_info = responseData['data'];
        }
          _isLoading = false;
         _isDeduktLoading = false;
      });
      print('new isdedukt >> ${_isDeduktLoading}');
      // setState(() {
      //   clientBvn = responseData['bvn'];
      //
      //   //  interestRateForPrivate = responseData['data']['data']['categpries']['interestRate'];
      //   //    String nomsInterest = responseData['data']['data']['categpries']['interestRate'].toString();
      //
      // });

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

  getEmploymentProfile() async {
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
    print(responsevv.body);

    final List<dynamic> responseData2 = json.decode(responsevv.body);
    print('responseData2 ${responseData2}');


    setState(() {
      allEmployer = responseData2;

      employerID = responseData2[0]['employer']['parent']['id'];
      sectorId = responseData2[0]['employer']['sector']['id'];
      parentClientType =
      responseData2[0]['employer']['parent']['clientType']['id'];
      _isLoading = false;

      if(responseData2.length == 0){
        allEmployer = [];
      }
    });


    print('employer ID ${employerID}');

    //salary_range = employmentProfile[0]['salaryRange']['id'];
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

  loadPurposeTemplate(int productId) async {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().getLoanPurpose(clientID, productId);

    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        collectPurpose = [];
        allPurpose = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['name']);
        collectPurpose.add(newEmp[i]['name']);
      }
      print('vis alali purpose..');
      print(collectPurpose);

      setState(() {
        purposeArray = collectPurpose;
        _isLoading = false;
      });
    });
  }

  fundingOptionTemplate() async {
    final Future<Map<String, dynamic>> respose =
    RetCodes().getLoanPurpose(clientID, productId);
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        allPurpose = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['name']);
        collectPurpose.add(newEmp[i]['name']);
      }
      print('vis alali purpose..');
      print(collectProduct);

      setState(() {
        purposeArray = collectPurpose;
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
                    title: 'Loan  Details',
                    subtitle: 'Loan Term',
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Loan Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Nunito SansRegular')),
                            SizedBox(
                              height: 8,
                            ),

                            Text(
                                'View your loan details.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontFamily: 'Nunito SansRegular')),
                            SizedBox(
                              height: 20,
                            ),

                         channelId == 1 ?
                        (
                            _isDeduktLoading == true ?
                            Center(
                              child:
                              Container(
                                    height:50,
                                    width: 50,
                                  child:
                                  CircularProgressIndicator()),

                            )
                            :
                           ( isCustomerFound  == false ?
                        Customer_not_found() :  ProductWidge())
                        ) :
                         WacsProductWidge(),

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

            if(channelId == 1)
              {
                MyRouter.pushPage(
                    context,
                    EmbeddedLoanTerms(
                        clientID: clientID,
                        employerId: employerID,
                        sectorID: sectorID,
                        thirdPartyLoanResponse:  third_party_client_info ,
                        otherInfo:thirdParty_response
                    )

                );
              }
            else {
              MyRouter.pushPage(
                  context,
                  CreateWacsLoanTerms(
                      clientID: clientID,
                      employerId: employerID,
                      sectorID: sectorID,
                      otherInfo:thirdParty_response,
                      productId: thirdParty_response['is_federal_wacs'] == true ?  93 : 99,
                  )

              );
            }


          },
        ),
      ),
    );
  }


  Customer_not_found(){
    return Container(
      child: Center(
        child:
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Customer Found.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('Client not eligible to book this loan.',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
            Container(
              width: 155,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff077DBB),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
              TextButton(
                onPressed: (){
                  MyRouter.popPage(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:   Text(
                    'Go To Previous Screen',
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


  Widget ProductWidge() {
        Map<String,dynamic> app_customer_data = third_party_client_info['staffInfo']['data'];
    return Container(
      height: MediaQuery.of(context).size.height * 0.52,
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child:

      Column(
        children: [

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Staff ID: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
          //     Text('CDL 002',style: TextStyle(color: Colors.black,fontSize: 19,),)
          //   ],
          // ),dummyDataPass('Staff Id', 'CDL 002'),
      SizedBox(height: 5),
      dummyDataPass('First Name', '${app_customer_data['first_name']}'),
      SizedBox(height: 5),
      dummyDataPass('Last Name', '${app_customer_data['last_name']}'),
      SizedBox(height: 5),
      dummyDataPass('Retirement Date', '${app_customer_data['expected_retirement_date']}'),
      SizedBox(height: 5),
      dummyDataPass('Net Pay', '₦${formatCurrency.format(app_customer_data['net_pay'])}'),
      SizedBox(height: 5),
      dummyDataPass('Gross Pay', '₦${formatCurrency.format(app_customer_data['gross_pay'])}'),
      SizedBox(height: 5),
      dummyDataPass('Gross Deduction', '₦${formatCurrency.format(app_customer_data['gross_deduction'])}'),
      SizedBox(height: 5),
      dummyDataPass('Payment Date', '${app_customer_data['payment_date']}'),
      SizedBox(height: 5),
      dummyDataPass('Available Deduction', '₦${formatCurrency.format(app_customer_data['available_deduction'])}'),
      SizedBox(height: 5),
      dummyDataPass('Can Do Top Up', '${third_party_client_info['staffInfo']['can_do_top_up']}'),
      SizedBox(height: 5),
      dummyDataPass('Max Top Up', '${third_party_client_info['staffInfo']['max_top_up']}'),



      // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child: DropDownComponent(
          //       items: ['Employer 1','Employer 2'],
          //       onChange: (String item) async {
          //
          //       },
          //       label: "Employers   *",
          //       selectedItem: '',
          //       validator: (String item) {
          //         if (item.length == 0) {
          //           return "Employers ";
          //         }
          //       }),
          // ),
          // SizedBox(
          //   height: 6,
          // ),

          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          //     child: EntryField(context, loanOfficer, 'Loan Officer *','Loan Officer',TextInputType.name,isRealOnly: true)
          // ),

          SizedBox(
            height: 6,
          ),

          SizedBox(
            height: 6,
          ),
        ],
      ),


    );
  }

  Widget WacsProductWidge() {
  //  Map<String,dynamic> resp_info = thirdParty_response['staff_info'];
   // Map<String,dynamic> staff_info = thirdParty_response['staffInfo'];
    Map<String,dynamic> staff_info_customer = thirdParty_response['staffInfo']['customer'];
    Map<String,dynamic> staff_info_customer_user = thirdParty_response['staffInfo']['customer']['user'];
    return Container(
      height: MediaQuery.of(context).size.height * 0.49,
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child:

      Column(
        children: [

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Staff ID: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
          //     Text('CDL 002',style: TextStyle(color: Colors.black,fontSize: 19,),)
          //   ],
          // ),dummyDataPass('Staff Id', 'CDL 002'),
          SizedBox(height: 5),
          dummyDataPass('First Name', '${staff_info_customer_user['firstName']}'),
          SizedBox(height: 5),
          dummyDataPass('Last Name', '${staff_info_customer_user['lastName']}'),
          SizedBox(height: 5),
          dummyDataPass('Phone Number', '${staff_info_customer_user['phoneNumber']}'),
          SizedBox(height: 5),
          dummyDataPass('Email', '${staff_info_customer_user['email']}'),
          SizedBox(height: 5),
          dummyDataPass('Bank Name', '${staff_info_customer['bank']}'),
          SizedBox(height: 5),
          dummyDataPass('Account Number', '${staff_info_customer['accountNumber']}'),
          SizedBox(height: 5),
          dummyDataPass('MDA', '${staff_info_customer['mda']}'),
          SizedBox(height: 5),
          // dummyDataPass('PFA Name', '${staff_info_customer['pfaName']}'),
          // SizedBox(height: 5),
          //
          // dummyDataPass('Current Eligibility', '₦${staff_info['currentEligibility']}'),
          SizedBox(height: 5),
          dummyDataPass('Eligibility',thirdParty_response['eligibility'] == null ? 'N/A': '₦${AppHelper().formatCurrency(thirdParty_response['eligibility'].toString())}'),
          SizedBox(height: 5),
          dummyDataPass('Monthly Eligibility',thirdParty_response['monthlyEligibility'] == null ? 'N/A':  '₦${AppHelper().formatCurrency(thirdParty_response['monthlyEligibility'].toString())}'),

          SizedBox(
            height: 6,
          ),

          SizedBox(
            height: 6,
          ),
        ],
      ),


    );
  }


  Widget dummyDataPass(String value,String title){
   return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
     child:   Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text('$value ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
         // Text('$title',style: TextStyle(color: Colors.black,fontSize: 19,),
         //
         // )
         Flexible(
           child: Text(
             '$title',
             style: TextStyle(color: Colors.black, fontSize: 15),
            // overflow: TextOverflow.ellipsis, // Adds '...' if text is too long
             maxLines: 2, // Ensures it's limited to 1 line
             overflow: TextOverflow.clip, // Clips the overflowing text
             softWrap: true, // Prevents wrapping to the next line
           ),
         )

       ],
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
            color: Theme.of(context).backgroundColor,

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
      child:
      Padding(
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
