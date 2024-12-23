import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
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

class NewLoan extends StatefulWidget {
  // const NewLoan({Key key}) : super(key: key);
  //
  // @override
  // _NewLoanState createState() => _NewLoanState();

  final int clientID, productId, loanId, employerId, sectorID, parentClientType;

  const NewLoan(
      {Key key,
      this.clientID,
      this.productId,
      this.loanId,
      this.employerId,
      this.sectorID,
      this.parentClientType})
      : super(key: key);

  @override
  _NewLoanState createState() => _NewLoanState(
      clientID: this.clientID,
      productId: this.productId,
      loanId: this.loanId,
      employerId: this.employerId,
      sectorID: this.sectorID,
      parentClientType: this.parentClientType);
}

class _NewLoanState extends State<NewLoan> {
  int clientID, productId, loanId, employerId, sectorID, parentClientType;

  _NewLoanState(
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
  bool isFedgoLoan = false;
  List<String> fundingArray = [];
  List<String> collectFunding = [];
  List<dynamic> allFunding = [];
  String productName = '';
  String PassloanPurpose = '';
  String username,clientBvn,clientNin;
  int productInt, purposeInt;
  var employmentProfile = [];
  int employerID;
  bool isRiskLoading = false;
  Map<String,dynamic> fedgoData = {};
  void initState() {
    // TODO: implement initState

    print('print parent ${parentClientType}');
    //loadPurposeTemplate();
    getUserProfile();
    fundingOptionTemplate();
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
        clientNin = responseData['nin'];

        //  interestRateForPrivate = responseData['data']['data']['categpries']['interestRate'];
    //    String nomsInterest = responseData['data']['data']['categpries']['interestRate'].toString();

      });

    });

  }

  getRiskDetailsWithBvn() async{
    setState(() {
      _isLoading= true;
      isRiskLoading = true;
    });
    final Future<Map<String,dynamic>> response =   RetCodes().getRiskDetails(bvn: clientBvn,productId: productInt.toString());
    response.then((responseData) {
      print('this>> << ${responseData}');
      setState(() {
       // clientBvn = responseData['bvn'];
      fedgoData  = {
          "interestRate": responseData['data']['data']['deciderSetupProfile']['interestRate'],
          "firstCentralPdf": responseData['data']['data']['firstCentralResponse']['base64Pdf'],
          "creditRegistryPdf": responseData['data']['data']['creditRegistry']['base64Pdf'],
      };

      });

      setState(() {
        _isLoading= false;
        isRiskLoading = false;
      });

    });

  }


  getSalesUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Vusername = prefs.getString('username');
    print('Vusername ${Vusername}');
    prefs.remove('loanCreatedId');
    prefs.remove('canBookTopUp');
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


// real_sandbox
      var filtered = newEmp
          .where((element) =>
      element['id'] == 40 || element['id'] == 43 || element['id'] == 36 || element['id'] == 28 || element['id'] == 30 || element['id'] == 52 || element['id'] == 94 || element['id'] == 95 || element['id'] == 96 || element['id'] == 49)
          .toList();

      
      // NEW PRODUCTION
      //  || element['id'] == 42

         // var filtered = newEmp
         //    .where((element) =>
         //   element['id'] == 63 || element['id'] == 40 || element['id'] == 55 || element['id'] == 64 || element['id'] == 49 || element['id'] == 52 || element['id'] == 71 || element['id'] == 72 || element['id'] == 94 || element['id'] == 95 || element['id'] == 96 || element['id'] == 97 || element['id'] == 42 || element['id'] == 100 || element['id'] == 101)
         //    .toList();


// SANDBOX
//      var filtered = newEmp.where((element) => element['id'] == 49 || element['id'] == 40).toList();

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
                    title: 'Loan Details',
                    subtitle: 'Loan Term',
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      allEmployer.length == 0 ? noEmployerDialog()  :
                    //  clientNin == null   ? noNinDialog() :
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Nunito SansRegular')),
                            SizedBox(
                              height: 8,
                            ),

                            Text(
                                'Kindly fill in all required information in the loan \n application form.',
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

                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

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

            print('purpose Int ${purposeInt} ${isFedgoLoan}');

            if (purposeInt == null) {
              return Flushbar(

                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
             //   showProgressIndicator: true,
                backgroundColor: Colors.red,
                title: 'Validation Error',
                message: 'Loan purpose is mandatory',
                duration: Duration(seconds: 3),
              ).show(context);
            }
            if (productInt == null) {
              return Flushbar(

                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                title: 'Validation Error',
                message: 'Loan product is mandatory',
                duration: Duration(seconds: 3),
              ).show(context);
            }
            if(employerID == null){
              return   Flushbar(

                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.blueAccent,
                title: 'Hold ✊',
                message: 'Please hold, we are retrieving employer\'s information',
                duration: Duration(seconds: 3),
              ).show(context);
            }

            print('fedgo data << >> ${isRiskLoading} ${fedgoData} ');

            // if(isFedgoLoan == true){
            //   getRiskDetailsWithBvn();
            // }
            // if(isRiskLoading == false){
              MyRouter.pushPage(
                  context,
                  SecondNewLoan(
                    clientID: clientID,
                    productID: productInt,
                    loanPurpose: purposeInt,
                    TheloanOfficer: loanOfficer.text,
                    loanID: loanId,
                    employerId: employerID,
                    sectorID: sectorID,
                    clientBVN: clientBvn,
                    loadfedgoData: fedgoData,
                  )
              );


            // }


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
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
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
                items: filteredProduct,
                onChange: (String item) async {
                  setState(() {
                    List<dynamic> selectID = allProduct
                        .where((element) => element['name'] == item)
                        .toList();
                    print('this is select ID');
                    print(selectID[0]['id']);
                    productInt = selectID[0]['id'];
                    loadPurposeTemplate(productInt);
                 //   if(selectID[0]['id'] == 30 && loanId == null){
                      if(selectID[0]['id'] == 30){
                      isFedgoLoan =  true;
                    }
                    else {
                      isFedgoLoan =  false;
                    }
                    print('end this is select ID ${isFedgoLoan}');
                  });
                },
                label: "Product Name *",
                selectedItem: productName,
                validator: (String item) {
                  if (item.length == 0) {
                    return "Loan product is mandatory";
                  }
                }),
          ),
          SizedBox(
            height: 6,
          ),
          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          //     child: EntryField(context, loanOfficer, 'Loan Officer *','Loan Officer',TextInputType.name,isRealOnly: true)
          // ),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropDownComponent(
                items: purposeArray,
                onChange: (String item) async {
                  setState(() {
                    List<dynamic> selectID = allPurpose
                        .where((element) => element['name'] == item)
                        .toList();
                    print('this is select ID');
                    print(selectID[0]['id']);
                    purposeInt = selectID[0]['id'];

                    print('end this is select ID');
                  });
                },
                label: "Loan Purpose   *",
                selectedItem: PassloanPurpose,
                validator: (String item) {
                  if (item.length == 0) {
                    return "Loan purpose is mandatory ";
                  }
                }),
          ),
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

 Widget noNinDialog(){
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
               'Kindly add NIN to proceed',
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
                       'Add NIN',
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
