import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/secondNewLoan.dart';
import 'package:sales_toolkit/views/clients/BankDetails.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/retDOB.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/rounded-button.dart';

class RemittaBioData extends StatefulWidget {
  // const NewLoan({Key key}) : super(key: key);
  //
  // @override
  // _NewLoanState createState() => _NewLoanState();

  final int clientID, productId, loanId, employerId, sectorID, parentClientType;

  const RemittaBioData(
      {Key key,
        this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType})
      : super(key: key);

  @override
  _RemittaBioDataState createState() => _RemittaBioDataState(
      clientID: this.clientID,
      productId: this.productId,
      loanId: this.loanId,
      employerId: this.employerId,
      sectorID: this.sectorID,
      parentClientType: this.parentClientType);
}

class _RemittaBioDataState extends State<RemittaBioData> {
  int clientID, productId, loanId, employerId, sectorID, parentClientType;

  _RemittaBioDataState(
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
  String username;
  int productInt, purposeInt;
  var employmentProfile = [];
  int employerID;

  bool otpValidationStatus = false;
  bool bvnFecthedSuccessfully = false;
  bool isBankLoading = false;
  bool isRequestLoading = false;
  String accountName = '';
  String bankName = '';
  String bankCode,accountTypeString,TempdateOfBirth;
  int bankInt,bankClassificationInt,bankAccountTypeListInt;

  bool isAllowedToProceed = false;


  List<String> banksListArray = [];
  List<String> collectBanksList = [];
  List<dynamic> allBanksList = [];
  var bankInfo = [];



  TextEditingController accountNumber = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController bvn = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController otpController = TextEditingController();



  void initState() {
    // TODO: implement initState

    print('print parent ${parentClientType}');
    //loadPurposeTemplate();
    fundingOptionTemplate();
    if (loanId != null) {
      getLoanDetails();
    }

    getEmploymentProfile();
    getSalesUsername();

    getbanksList();
    // print('loan Id ${loanId}');
    loadLoanTemplates();

    super.initState();
  }

  getbanksList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().CustomerbanksList();


    setState(() {
      isRequestLoading = true;
    });

    respose.then((response) {
      setState(() {
        isRequestLoading = false;
      });


      //print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        allBanksList = newEmp;
      });

      for(int i = 0; i < newEmp.length;i++){
        //print(newEmp[i]['name']);
        collectBanksList.add(newEmp[i]['name']);
      }
      //print('vis alali');
      //print(collectBanksList);

      setState(() {
        banksListArray = collectBanksList ;
      });
    }
    );



    respose.then((response) async {
      //print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsBanksList'));


        //
        if(prefs.getString('prefsBanksList').isEmpty){
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);

        }
        //
        else {

          setState(() {
            allBanksList = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            //print(mtBool[i]['name']);
            collectBanksList.add(mtBool[i]['name']);
          }

          setState(() {
            banksListArray = collectBanksList;
          });

          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);

        }

      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsBanksList', jsonEncode(newEmp));


        setState(() {
          allBanksList = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectBanksList.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBanksList);

        setState(() {
          banksListArray = collectBanksList;
        });
      }

    }
    );


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

  callRemittaReferencing(){

    // if(isAllowedToProceed){

      Map<String,dynamic> mapData = {
        "firstName": firstName.text,
        "lastName": lastName.text,
        "middleName": middleName.text,
        "payerPhone": phoneNumber.text,
        "payerAccount":accountNumber.text,
        "payerBankCode": bankCode,
        "bvn": bvn.text
      };

      setState(() {
        _isLoading = true;
      });

      final Future<Map<String,dynamic>> result_response =   RetCodes().remittaChannel(mapData);

      result_response.then((response) async {

        setState(() {
          _isLoading = false;
        });

        if(response == null || response['data'] == null  || response['message'] == 'Network error') {
          //print('response Data >> ${result_response}');
          setState(() {
            _isLoading = false;
            isBankLoading = false;
          });
          return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orangeAccent,
            title: 'Network Error',
            message: 'Unable to connect to internet',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        if(response['data']['message'] == 'Customer not found'){
          setState(() {
            _isLoading = false;

          });
          return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: "Error!",
            message: 'Customer Account Not Found',
            duration: Duration(seconds: 3),
          ).show(context);
        }
       if(response['data']['message'] == 'SUCCESS'){
         String customerID = response['data']['data']['data']['customerId'];

         print('customer ID ${customerID}');
         MyRouter.pushPage(
             context,
             SecondNewLoan(
                 clientID: clientID,
                 productID: productInt,
                 loanPurpose: purposeInt,
                 TheloanOfficer: loanOfficer.text,
                 loanID: loanId,
                 employerId: employerID,
                 comingFrom: 'remitta_refs',
                 customerID: customerID,
                 sectorID: sectorID));
       }





      });



    // }



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
//       var filtered = newEmp
//           .where((element) =>
//       element['id'] == 43 || element['id'] == 36 || element['id'] == 28 || element['id'] == 30)
//           .toList();


      // NEW PRODUCTION
      var filtered = newEmp
          .where((element) =>
         element['id'] == 63 || element['id'] == 40 || element['id'] == 55 || element['id'] == 64 || element['id'] == 49 || element['id'] == 52 )
          .toList();


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
      print(collectProduct);

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


  fetchBankInfo(String accountNumber,String sortCode) {
    setState(() {
      _isLoading = true;
      accountName = '';
    });

    Map <String,dynamic> subData = {
      "accountNumber": accountNumber,
      "bankCode": sortCode
    };


    final Future<Map<String,dynamic>> respose = RetCodes().verifyAccountNumber(subData);

    // //print('account data ${accountData}');
    // final Future<Map<String,dynamic>> respose =   RetCodes().verifyAccountBumber(accountData);

    respose.then((response) {
      // //print('heelo here' + response['data']);

      if(response == null || response['data'] == null  || response['message'] == 'Network error'){
        setState(() {
          _isLoading = false;
          isBankLoading = false;
        });
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Network Error',
          message: 'Unable to connect to internet',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if(response['message'] == 'Network error'){
        setState(() {
          _isLoading = false;
          _isLoading = false;
        });
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Network Error',
          message: 'Proceed, data has been saved to draft',
          duration: Duration(seconds: 3),
        ).show(context);

        //   return MyRouter.pushPage(context, DocumentUpload());
      }


      if(response['data'] == null || response['status'] == false){
        setState(() {
          _isLoading = false;

        });
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Error!",
          message: 'Account could not be validated',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if(response['data']['status'] == true){
        setState(() {
          _isLoading = false;
        });
        //  //print('this is a test' + response['data']['email']);
        setState(() {
          // accountName = response['data']['data']['lastName'] + ' ' + response['data']['data']['firstName'] ;
          //   accountName = response['data']['data']['lastName'] == null ? '' : response['data']['data']['lastName'] + ' ' + response['data']['data']['firstName'] == null ? '' : response['data']['data']['firstName'];

          String LastName = response['data']['data']['lastName'] == null ? '' : response['data']['data']['lastName'];
          String FirstName = response['data']['data']['firstName'] == null ? '' : response['data']['data']['firstName'];

          accountName = response['data']['data']['accountName'];

          _isLoading = false;
        });

        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: "Success",
          message: 'Account Validation Successful',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      else {
        setState(() {
          _isLoading = false;
        });
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Error!",
          message: 'Account could not be validated',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    }
    );
  }


  // fetchBankInfo(String accountNumber,String sortCode) {
  //   setState(() {
  //     _isLoading = true;
  //     accountName = '';
  //   });
  //
  //   Map <String,dynamic> subData = {
  //     "accountNumber": accountNumber,
  //     "bankCode": sortCode
  //   };
  //   final Future<Map<String,dynamic>> respose = RetCodes().verifyAccountNumber(subData);
  //
  //   // //print('account data ${accountData}');
  //   // final Future<Map<String,dynamic>> respose =   RetCodes().verifyAccountBumber(accountData);
  //
  //   respose.then((response) {
  //  print('heelo here' + response['data']);
  //
  //     if(response == null || response['data'] == null  || response['message'] == 'Network error'){
  //       setState(() {
  //         _isLoading = false;
  //        // isBankLoading = false;
  //       });
  //       return Flushbar(
  //               flushbarPosition: FlushbarPosition.TOP,
  //               flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.orangeAccent,
  //         title: 'Network Error',
  //         message: 'Unable to connect to internet',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //
  //     if(response['message'] == 'Network error'){
  //       setState(() {
  //         _isLoading = false;
  //         isBankLoading = false;
  //       });
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.orangeAccent,
  //         title: 'Network Error',
  //         message: 'Proceed, data has been saved to draft',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //
  //       //   return MyRouter.pushPage(context, DocumentUpload());
  //     }
  //
  //
  //     if(response['data'] == null || response['status'] == false){
  //       setState(() {
  //         _isLoading = false;
  //         isBankLoading = false;
  //       });
  //       return Flushbar(
  //               flushbarPosition: FlushbarPosition.TOP,
  //               flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.red,
  //         title: "Error!",
  //         message: 'Account could not be validated',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //
  //     if(response['data']['status'] == true){
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       //  //print('this is a test' + response['data']['email']);
  //       setState(() {
  //         // accountName = response['data']['data']['lastName'] + ' ' + response['data']['data']['firstName'] ;
  //         //   accountName = response['data']['data']['lastName'] == null ? '' : response['data']['data']['lastName'] + ' ' + response['data']['data']['firstName'] == null ? '' : response['data']['data']['firstName'];
  //
  //         String LastName = response['data']['data']['lastName'] == null ? '' : response['data']['data']['lastName'];
  //         String FirstName = response['data']['data']['firstName'] == null ? '' : response['data']['data']['firstName'];
  //
  //         accountName = response['data']['data']['accountName'];
  //
  //         _isLoading = false;
  //       });
  //
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.green,
  //         title: "Success",
  //         message: 'Account Validation Successful',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //
  //     else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.red,
  //         title: "Error!",
  //         message: 'Account could not be validated',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //   }
  //   );
  // }


  // fetchBvn() async{
  //   //print('employer sector ${empInt.toString()} category sector ${catInt} ');
  //
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String getBVN = prefs.getString('inputBvn');
  //
  //   Map <String,dynamic> subData = {
  //     "bvn":bvn.text ,
  //     "phone": "",
  //     "accountNumber": "",
  //     "bankCode": "",
  //
  //   };
  //   final Future<Map<String,dynamic>> respose = RetCodes().verifyBVN(subData);
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   respose.then((response) {
  //     //print('heelo here ${response}'  );
  //
  //     if(response == null || response['status'] == null || response['data'] == null || response['status'] == false ){
  //
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       return  Flushbar(
  //               flushbarPosition: FlushbarPosition.TOP,
  //               flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.red,
  //         title: 'Error',
  //         message: 'Unable to validate BVN',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //     if(response['data']['status'] == true && response['data']['data']['firstName'] !=null && response['data']['data']['lastName'] !=null ){
  //       //var realBvnData  = response['data']['data'];
  //
  //       // if(realBvnData['firstName'] != null && realBvnData['lastName'] != null){
  //
  //       // }
  //
  //       // //print('this is a test' + response['data']['email']);
  //       setState(() {
  //         // isAllowedToProceed = true;
  //       //  tempEmail = response['data']['data']['personalEmail'];
  //         firstName.text = response['data']['data']['firstName'];
  //         middleName.text = response['data']['data']['middleName'];
  //         lastName.text = response['data']['data']['lastName'];
  //         phoneNumber.text= response['data']['data']['phone'];
  //
  //       });
  //
  //       setState(() {
  //         isRequestLoading = false;
  //       });
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.lightGreen,
  //         title: "Success",
  //         message: ' OTP successfully sent to client',
  //         duration: Duration(seconds: 6),
  //       ).show(context);
  //
  //
  //     }
  //     else {
  //       setState(() {
  //         isRequestLoading = false;
  //       });
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.redAccent,
  //         title: "Error!",
  //         message: 'validation failed ',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //   }
  //   );
  // }

  fetchBvn() async{
    //print('employer sector ${empInt.toString()} category sector ${catInt} ');

    final SharedPreferences prefs = await SharedPreferences.getInstance();



    //   return enterOTP();
    Map <String,dynamic> subData = {
      "bvn":bvn.text,
      "phone": "",
      "accountNumber": "",
      "bankCode": "",

    };
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose = RetCodes().verifyBVN(subData);

    setState(() {
      _isLoading = true;
    });
    respose.then((response) {
      //print('heelo here ${response}'  );


      if(response == null || response['status'] == null || response['data'] == null || response['status'] == false ){

        if(response['message'] == 'Network error'){
          setState(() {
            _isLoading = false;
          });
        }

        setState(() {
          _isLoading = false;
        });
        return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to validate BVN',
          duration: Duration(seconds: 3),
        ).show(context);

      }

      if(response['data']['status'] == true && response['data']['data']['firstName'] !=null && response['data']['data']['lastName'] !=null ){
        //var realBvnData  = response['data']['data'];

          setState(() {
          // isAllowedToProceed = true;
          //tempEmail = response['data']['data']['personalEmail'];
          firstName.text = response['data']['data']['firstName'];
          middleName.text = response['data']['data']['middleName'];
          lastName.text = response['data']['data']['lastName'];
          phoneNumber.text= response['data']['data']['phone'];
          TempdateOfBirth =  response['data']['data']['dateOfBirth'];

          bvnFecthedSuccessfully = true;
          });

        setState(() {
          _isLoading = false;
        });
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.lightGreen,
          title: "Success",
          message: ' OTP successfully sent to client',
          duration: Duration(seconds: 6),
        ).show(context);

        enterOTP();
      }
      else {
        setState(() {
          _isLoading = false;
        });
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: "Error!",
          message: 'validation failed ',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    }
    );
  }


  int currentStep = 0;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  TextEditingController extrernalID = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController loanOfficer = TextEditingController();
  final _form = GlobalKey<FormState>(); //for storing form state.

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
                    title: 'Remita BioData',
                    subtitle: 'Loan Term',
                  ),

                  SizedBox(height: 20,),

                  Form(
                      key: _form,
                      child:
                          Container(
                            height: MediaQuery.of(context).size.height * 0.68,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: DropDownComponent(items: banksListArray,
                                      onChange: (String item){
                                        setState(() {

                                          List<dynamic> selectID =   allBanksList.where((element) => element['name'] == item).toList();

                                          bankCode = selectID[0]['bankSortCode'];
                                          bankInt = selectID[0]['id'];
                                          accountName = '';
                                          //print('bankInt code ${bankCode}');
                                        });
                                      },
                                      label: "Bank * ",
                                      selectedItem: bankName,
                                      validator: (String item){

                                      }

                                  ),
                                ),



                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical:10),
                                    child: EntryField(context, accountNumber, 'Account Number *','Account Number',TextInputType.number,maxLenghtAllow: 10,helpText: accountName,showHelpText: true,onChangeVal: (value){
                                      if(value.isEmpty){
                                        setState(() {
                                          isBankLoading = false;
                                        });
                                        // //print('isLoading is ${isBVNLoading}');

                                      }
                                      else if(value.length != 10){
                                        setState(() {
                                          isBankLoading = true;
                                        });
                                        //print('isloading  ${isBankLoading}');
                                      }
                                      else{

                                        fetchBankInfo(accountNumber.text,bankCode);
                                        setState(() {
                                          isBankLoading = false;
                                        });
                                        //print('re isloading  ${isBankLoading}');
                                      }
                                    })
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                    child: EntryField(context, bvn, 'BVN *','BVN',TextInputType.text,maxLenghtAllow: 11,onChangeVal: (value){
                                      if(value.length == 11){
                                        fetchBvn();
                                      }
                                    })
                                ),

                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                    child: EntryField(context, firstName, 'First Name *','First Name',TextInputType.text,isRealOnly: true)
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                    child: EntryField(context, middleName, 'Middle Name *','Middle Name',TextInputType.text,isRealOnly: true)
                                ),

                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                    child: EntryField(context, lastName, 'Last Name *','Last Name',TextInputType.text,isRealOnly: true)
                                ),


                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                    child: EntryField(context, phoneNumber, 'Phone Number *','Phone Number',TextInputType.number,maxLenghtAllow: 11)
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                                      //    loadPurposeTemplate(productInt);
                                          print('end this is select ID');
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



                              ],
                            ),
                          )


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
            if(_form.currentState.validate()){
              print('purpose Int ${purposeInt}');


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

          callRemittaReferencing();
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
                    print('end this is select ID');
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
        var maxLenghtAllow,
        bool showHelpText = false,
        bool isDateAllowed = false,
        String helpText,Function onChangeVal,
      }) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
      height: MediaSize.height * 0.10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            //color: Theme.of(context).backgroundColor,

            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: TextFormField(

            maxLength: maxLenghtAllow,
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: keyBoard,
            controller: editController,
            // validator: (value)=>value.isEmpty?'Please enter password':null,
            // onSaved: (value) => vals = value,
            readOnly: isRealOnly,
            decoration: InputDecoration(
                suffixIcon:
                isDateAllowed == true ? IconButton(
                  onPressed: (){
                    // showDatePicker();
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1955, 3, 5),
                        maxTime: DateTime.now().subtract(Duration( days: 6575)),
                        onChanged: (date) {
                          print('change $date');
                          setState(() {
                            String retDate = retsNx360dates(date);
                            dobController.text = retDate;
                          });
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);

                  },
                  icon: Icon(Icons.date_range,color: Colors.blue,),
                ) : null,
                fillColor: ColorUtils.BG_COL,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                helperText: showHelpText == true ? helpText : '',
                helperStyle: TextStyle(color: Colors.black,fontSize: 10,fontFamily: 'Nunito SansRegular',fontWeight: FontWeight.bold),

                counter: SizedBox.shrink(),
                floatingLabelStyle: TextStyle(color: Color(0xff205072)),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.black, fontFamily: 'Nunito SansRegular'),
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color
                )

            ),
            textInputAction: TextInputAction.done,

            onChanged: (String value){
             onChangeVal(value);
            },


          ),
        ),
      ),
    );
  }


  enterOTP(){

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
       // String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Enter OTP received from the Client',style: TextStyle(fontSize: 11),),
                  InkWell(
                      onTap: () async{
                        setState(() {
                          isAllowedToProceed = false;
                        });
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: EntryField(context, otpController, 'Enter OTP', 'Enter OTP',TextInputType.number,),
              actions: <Widget>[

                Container(
                  //  width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
// YYYY-MM-DD
                        Center(child:

                        isRequestLoading == true ? loading() :

                        RoundedButton(buttonText: 'Verify OTP',onbuttonPressed: () async{

                          //print('isRequestLoading ${isRequestLoading}');
                          confirmOTP();


                        },

                        ),

                        ),
                        SizedBox(height: 10,),
                        // Center(
                        //   child: InkWell(
                        //       onTap: (){
                        //         MyRouter.popPage(context);
                        //          dobConfirmation();
                        //       },
                        //       child:
                        //       Text('Not Receiving OTP? Click Here',
                        //         style: TextStyle(fontSize: 11),)
                        //   ),
                        // ),

                      ],
                    )

                )

                // new FlatButton(
                //   child: new Text("OK ${isTestState}"),
                //   onPressed: () {
                //           setState((){
                //             isTestState = 'isTexted';
                //
                //           });
                //    // Navigator.of(context).pop();
                //   },
                // ),



              ],
            );
          },
        );
      },
    );
  }




  confirmOTP(){

    setState(() {
      isRequestLoading = true;
    });
    if(otpController.text.isEmpty || otpController.text.length < 5){
      setState(() {
        isRequestLoading = false;
      });
      return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'OTP length too short ',
        duration: Duration(seconds: 3),
      ).show(context);
    }
    else {
      MyRouter.popPage(context);
      setState(() {
        isRequestLoading = true;
      });
      final Future<Map<String,dynamic>> respose =   RetCodes().verifyOTP(phoneNumber.text,otpController.text);
      respose.then((response) {
        setState(() {
          isRequestLoading = false;
        });
        if(response['data']['status'] == true){
          setState(() {
            isAllowedToProceed = true;
            otpValidationStatus = true;
          });

          //  MyRouter.popPage(context);


          return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: response['data']['message'],
            duration: Duration(seconds: 3),
          ).show(context);



        } else {

          setState(() {
            isAllowedToProceed = false;
            //  otpController.text = '';
          });
          enterOTP();
          return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['data']['message'],
            duration: Duration(seconds: 3),
          ).show(context);
        }

        //print('response from client OTP ${response}');
      });

    }
  }

  Widget loading(){
    return Center(
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(shape: BoxShape.circle,),
              child: CircularProgressIndicator(
                color: Colors.blue,
              )),
          Text("    Please wait ...",style: TextStyle(color: Colors.blue),)

        ],
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
                validator: (String item) {
                  if(item.isEmpty || item.length < 2){
                    return "Field cannot be empty";
                  }
                }),
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

  dobConfirmation(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Enter Client\'s BVN Date Of Birth',style: TextStyle(fontSize: 11)),
                  InkWell(
                      onTap: () async{
                        setState(() {
                          isAllowedToProceed = false;
                        });
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: EntryField(context, dobController, 'BVN Date Of Birth', 'YYYY-MM-DD',TextInputType.number,isDateAllowed: true,),
              actions: <Widget>[

                Container(
                  //  width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
// YYYY-MM-DD
                        Center(child:

                        isRequestLoading == true ? loading() :

                        RoundedButton(buttonText: 'Verify',onbuttonPressed: () async{

                          //    //print('isRequestLoading ${isRequestLoading}');
                          //  confirmOTP();
                          //print('new newtemp date ${retDOBfromBVN(TempdateOfBirth)} ${dobController.text}');

                          String compA = retDOBfromBVN(TempdateOfBirth);
                          String compB = dobController.text;

                          if(compA.compareTo(compB) == 0){

                            // come here to pass screen
                        MyRouter.popPage(context);
                            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                              backgroundColor: Colors.green,
                              title: 'Success',
                              message: 'Date Of Birth Verified',
                              duration: Duration(seconds: 3),
                            ).show(context);


                          }
                          else {
                            // //print('Not correct');
                            return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                              backgroundColor: Colors.red,
                              title: 'Error',
                              message: 'Date Of Birth not Verified',
                              duration: Duration(seconds: 3),
                            ).show(context);

                          }
                        },

                        ),

                        ),
                        SizedBox(height: 10,),

                        Center(
                          child: InkWell(
                              onTap: (){
                                MyRouter.popPage(context);
                                enterOTP();
                              },
                              child:
                              Text('Use OTP Instead',
                                style: TextStyle(fontSize: 11),)
                          ),
                        ),

                      ],
                    )

                )

                // new FlatButton(
                //   child: new Text("OK ${isTestState}"),
                //   onPressed: () {
                //           setState((){
                //             isTestState = 'isTexted';
                //
                //           });
                //    // Navigator.of(context).pop();
                //   },
                // ),



              ],
            );
          },
        );
      },
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
