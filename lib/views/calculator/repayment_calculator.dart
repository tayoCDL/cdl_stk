import 'dart:async';
import 'dart:convert';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/models/loan_calculator_reponse.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/entry_field.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../palatte.dart';
import '../../widgets/LocalTypeAhead.dart';

class RepaymentCalculator extends StatefulWidget {
  const RepaymentCalculator({Key key}) : super(key: key);

  @override
  _RepaymentCalculatorState createState() => _RepaymentCalculatorState();
}

class _RepaymentCalculatorState extends State<RepaymentCalculator> {
  TextEditingController principal = TextEditingController();
  TextEditingController tenor = TextEditingController();
  TextEditingController netPay = TextEditingController();
  TextEditingController _typeAheadController = TextEditingController();
  Timer _debounce;
  String parentEmployer = '';
  bool _isLoading = false;

  List<String> employerArray = [];
  List<String> collectEmployer = [];
  List<int> collectEmployerID = [];

  List<dynamic> allProduct = [];
  List<String> filteredProduct = [];


  List<String> BranchEmployerArray = [];
  List<String> collectBranchEmployer = [];
  List<dynamic> allBranchEmployer = [];

  List<String> empCategory = [];
  List<String> collectCategory = [];
  List<dynamic> allCategory = [];

  String branchEmployer = '';
  bool isCategorySelected = false;
  List<dynamic> allEmployer = [];

  int stateInt,salaryInt,lgaInt,employerInt,clientTypeInt;
  int branchEmployerInt = 0;
  String employerDomain ='';

  List<String> empSector = [];
  List<String> collectData = [];
  List<dynamic> allEmp = [];

  List<String> productArray = [];
  List<String> collectProduct = [];
  List<String> collectProds = [];
  dynamic minPrincipal = 0.00;
  dynamic maxPrincipal = 0.00;
  dynamic minNumberOfRepayment;
  dynamic maxNumberOfRepayment;
  double _value = 1.0;
  double _currentSliderValue = 1;
  var repaymentAmount = 0.0;

  bool isRequestLoading = false;
  int catInt;
  String employerSector = '';
  String categorySector = '';
  String accountName = '';
  String realMonth = '';

  String productName = '';
  int productInt, purposeInt;

  int empInt;

  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");



  @override
  void initState() {
    // TODO: implement initState
    getCodesList();
    getCategoryList();

    super.initState();
  }

  getEmployersBranch(int parentID){
    //print('this is parent branch ${parentID}');
    final Future<Map<String,dynamic>> respose =   RetCodes().getEmployersBranch(parentID);
    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allSalary = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectSalary.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectSalary);
    //
    //   setState(() {
    //     salaryArray = collectSalary;
    //   });
    // }
    // );

    setState(() {
      _isLoading = true;
    });
    respose.then((response) async {
      setState(() {
        _isLoading = false;
      });
      //print('${response['data']}');

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsBranchEmployer'));

        if(prefs.getString('prefsBranchEmployer').isEmpty){
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
            BranchEmployerArray = [];
            allBranchEmployer = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            //print(mtBool[i]['name']);
            BranchEmployerArray.add(mtBool[i]['name']);
          }

          setState(() {
            BranchEmployerArray = collectBranchEmployer;
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

      }
      else {
        List<dynamic> newEmp = response['data'];

        //print('this is newEmps ${newEmp.toString()}');

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsBranchEmployer', jsonEncode(newEmp));

        setState(() {
          BranchEmployerArray = [];
          collectBranchEmployer = [];
        });

        setState(() {
          allBranchEmployer = newEmp;
        });


        //print('all Branch ${newEmp}');

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectBranchEmployer.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBranchEmployer);

        setState(() {
          _isLoading = false;
          BranchEmployerArray = collectBranchEmployer;
        });
      }


    }
    );

  }


  getCodesList()  {
    setState(() {
      isRequestLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('36');
    respose.then((response) async{
      setState(() {
        isRequestLoading = false;
      });
      if(response['status'] == false){

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmpSector'));


        //
        if(prefs.getString('prefsEmpSector').isEmpty){
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
            allEmp = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            //print(mtBool[i]['name']);
            collectData.add(mtBool[i]['name']);
          }

          setState(() {
            empSector = collectData;
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


      }

      else {

        setState(() {
          isRequestLoading = false;
        });

        //print(response['data']);
        List<dynamic> newEmp = response['data'];

        // final LocalStorage storage = new LocalStorage('localstorage_app');
        //
        //
        // final info = json.encode(newEmp);
        // storage.setItem('info', info);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmpSector', jsonEncode(newEmp));

        int leadToClient = prefs.getInt('leadToClientID');
        //print('lead To Client Id ${leadToClient}');

        setState(() {
          allEmp = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectData.add(newEmp[i]['name']);
        }



        setState(() {
          empSector = collectData;

          // if(comingFrom != null){
          //   List<dynamic> selectID =   allEmp.where((element) => element['name'] == employerSector).toList();
          //   empInt = selectID[0]['id'];
          //
          //   //print('gender In from Init ${empInt}');
          // }

        });


      }


    }


    );
  }


  getCategoryList()  {
    setState(() {
      isRequestLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('16');
    respose.then((response) async{
      setState(() {
        isRequestLoading = false;
      });
      if(response['status'] == false){

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmpCategory'));


        //
        if(prefs.getString('prefsEmpCategory').isEmpty){
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
            allCategory = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            //print(mtBool[i]['name']);
            collectCategory.add(mtBool[i]['name']);
          }

          setState(() {
            empCategory = collectCategory;
            //  isAllowedToProceed = true;
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


      }

      else {

        setState(() {
          isRequestLoading = false;
        });

        //print(response['data']);
        List<dynamic> newEmp = response['data'];

        // final LocalStorage storage = new LocalStorage('localstorage_app');
        //
        //
        // final info = json.encode(newEmp);
        // storage.setItem('info', info);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmpCategory', jsonEncode(newEmp));

        // int leadToClient = prefs.getInt('leadToClientID');
        // //print('lead To Client Id ${leadToClient}');

        setState(() {
          allCategory = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectCategory.add(newEmp[i]['name']);
        }



        setState(() {
          empCategory = collectCategory;
          // if(comingFrom != null){
          //   List<dynamic> selectID =   allCategory.where((element) => element['name'] == categorySector).toList();
          //   catInt = selectID[0]['id'];
          //   //print('gender In from Init ${catInt}');
          // }

        });


      }


    }


    );
  }


  getLoanProductForEmployer(int employerInt) async {
    //  print('this is clientID ${clientID} ${employerId}');
    //   int empID = employerID == null ? employerId : employerID;
//    print('empID ${empID}');
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().employerProduct(employerInt);
    respose.then((response) {
      setState(() {
        _isLoading = false;
        var employerData = response['data'][0];
        minPrincipal = employerData['minPrincipal'];
        maxPrincipal = employerData['maxPrincipal'];
        minNumberOfRepayment = employerData['minNumberOfRepayments'];
        maxNumberOfRepayment = employerData['maxNumberOfRepayments'];
      });
       print(response);


    });
  }


  loadLoanTemplates(int employerInt) async {
  //  print('this is clientID ${clientID} ${employerId}');
 //   int empID = employerID == null ? employerId : employerID;
//    print('empID ${empID}');
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().repayment_loan_products(employerInt);
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
   //   print('sector ID ${sectorID}');

      var filtered = newEmp.toList();


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



  @override
  void dispose() {
    _debounce?.cancel();
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;


    repayment_calculation() async {

        if(employerInt == null || productInt == null || principal.text.isEmpty || tenor.text.isEmpty ){
          return
            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: 'Validation Error',
              message: 'All fields are mandatory ',
              duration: Duration(seconds: 3),
            ).show(context);
        }


      Map<String,dynamic> calculateLoan =
        {
          "employerId": employerInt,
          "productId": productInt,
          "principal": principal.text,
          "tenor": tenor.text,
          "locale": "en",
          "netpay": netPay.text
        };
        setState(() {
          _isLoading = true;
        });
        final Future<Map<String,dynamic>> Apiresponse =   RetCodes().new_loanRepaymentCalculator(calculateLoan);
        Apiresponse.then((response){
          setState(() {
            _isLoading = false;
          });
          if(response['status'] == false){
            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: 'Error',
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
          else {
            print('response response ${response}');

            if(response['data']['pass'] == false && response['data']['dsrUsed'] != null ){
              alert(
                context,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Info',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    InkWell(
                        onTap: () {
                          MyRouter.popPage(context);
                        },
                        child: Icon(Icons.clear))
                  ],
                ),
                content: Row(
                  children: [
                    Text(
                      '${response['data']['decision']},\nSuggested amount is ${response['data']['suggestedAmount']} ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
                ),
                textOK: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child:
                  // IconButton(
                  //   icon:
                  //   Icon(Icons.copy),
                  //   iconSize: 25,
                  //   color: Colors.blue,
                  // )

                  RoundedButton(
                    buttonText: 'Copy Amount',
                    onbuttonPressed: () {
                      // sendNoteForLoan(methodType,noteId);
                      String cp_text = response['suggestedAmount'].toString();
                      Clipboard.setData(ClipboardData(text: cp_text));
                      MyRouter.popPage(context);
                      Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                        backgroundColor: Colors.green,
                        title: 'Success',
                        message: 'Amount copied to clipboard',
                        duration: Duration(seconds: 5),
                      ).show(context);
                    },
                  ),

                  // RoundedButton(buttonText: 'Okay',onbuttonPressed: (){
                  //   MyRouter.popPage(context);
                  // },)
                ),
              );
            }

            else {
              LoanCalculatorResponse loanCalculatorResponse = LoanCalculatorResponse.fromJson(response['data'] as Map<String,dynamic>);
              print('local response ${loanCalculatorResponse.totalFeeChargesCharged}');
              // setState(() {
              //   repaymentAmount = response['data']['repaymentAmount'];
              // });

              calculatorResultBottomSheet(loanCalculatorResponse);
            }

          }

        });

    }

    Future<List> getSuggestions(String query) async{

      if(query.length > 3){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final Future<Map<String,dynamic>> result_response =   RetCodes().employers(catInt,query);
        //
        result_response.then((response) async {
          List<dynamic> newEmp = response['data']['pageItems'];

          setState(() {
            allEmployer = newEmp;
            collectEmployer = [];
          });

          for(int i = 0; i < newEmp.length;i++){
            //print(newEmp[i]['name']);
            collectEmployer.add(newEmp[i]['name']);
          }
          //print('vis alali');
          //print(collectEmployer);

          // setState(() {
          //   employerArray = collectEmployer;
          //   List<dynamic> selectID =   allEmployer.where((element) => element['name'] == branchEmployer).toList();
          //   //print('select value ${selectID}');
          //   //  branchEmployerInt = selectID[0]['id'];
          // });


        });
        //print('employer Array ${allEmployer}');
        return allEmployer;
      }



    }

    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
          appBar: AppBar(
            // leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Color(0xff077DBB),),
            //   onPressed: (){
            //     MyRouter.popPage(context);
            //   },
            // ),
            title:  Text('Loan Calculator',textAlign: TextAlign.start,style: kHeading_black,),
            centerTitle: false,
            backgroundColor: Colors.transparent,
          ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.05,),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Loan Calculator',textAlign: TextAlign.start,style: kHeading_black,),
                  //     Text('')
                  //   ],
                  // ),

                  DropDownComponent(items: empSector,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allEmp.where((element) => element['name'] == item).toList();
                          //print('this is select ID');
                          //print(selectID[0]['id']);
                          empInt = selectID[0]['id'];
                          // catInt =null;
                          categorySector = ' ';
                          //print('end this is select ID ${categorySector}');
                          // categorySector = '';
                          // catInt = 0;
                          isCategorySelected = false;
                        });
                      },
                      label: "Select Sector",
                      selectedItem: employerSector,
                      validator: (String item){

                      }

                  ),
                  SizedBox(height: 20,),
                  DropDownComponent(items: empCategory,
                      popUpDisabled: (String s) {
                        if(empInt == 17){
                          return  s.startsWith('Federal') || s.startsWith('State') || s.startsWith('NYSC');
                        }
                        else {
                          return  s.startsWith('Private');

                        }

                      } ,
                      onChange: (String item){
                        setState(() {
                          List<dynamic> selectID =   allCategory.where((element) => element['name'] == item).toList();
                          //print('this is select ID');
                          //print(selectID[0]['id']);
                          catInt = selectID[0]['id'];
                          print('end this is select ID ${catInt}');
                          categorySector = selectID[0]['name'];
                          isCategorySelected = true;
                        });
                      },
                      label: "Select Category",
                      selectedItem: categorySector,
                      validator: (String item){

                      }

                  ),

                  SizedBox(height: 20,),

                  Visibility(
                      visible: isCategorySelected,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                              child:
                              TypeAheadField(
                                debounceDuration: const Duration(seconds: 1),
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: this._typeAheadController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: parentEmployer == '' ? 'Search Employer ' : parentEmployer
                                    )
                                ),

                                // suggestionsBoxController: parentEmployerController,
                                transitionBuilder: (context, suggestionsBox, animationController) =>
                                    FadeTransition(
                                      child: suggestionsBox,
                                      opacity: CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn
                                      ),
                                    ),
                                suggestionsCallback: (pattern) async {
                                  return await getSuggestions(pattern);
                                  //getEmployersList(realEmployerSector,value);
                                },

                                itemBuilder: (context, suggestion) {
                                  //  //print('user suggestion ${suggestion}');
                                  return ListTile(
                                    leading: Icon(Icons.work_outlined),
                                    title: Text(suggestion['name']),
                                    // subtitle: Text('${suggestion['mobileNo']}'),
                                  );
                                },
                                noItemsFoundBuilder: (context) => Container(
                                  height: 100,
                                  child: Center(
                                    child: Text('No Employer Found'),
                                  ),
                                ),
                                onSuggestionSelected: (suggestion) {
                                  //print('suggesttion ${suggestion}');
                                  this._typeAheadController.text = suggestion['name'];
                                  employerInt = suggestion['id'];

                                      getEmployersBranch(employerInt);
                                  getLoanProductForEmployer(employerInt);
                                  branchEmployerInt = 0;
                                  setState(() {

                                  });
                                },
                              )
                          ),
                          SizedBox(height: 10,),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                            child:
                            DropDownComponent(items: BranchEmployerArray,
                                onChange: (String item){
                                  setState(() {
                                    List<dynamic> selectID =   allBranchEmployer.where((element) => element['name'] == item).toList();
                                    // List<dynamic> selectExtension =   allBranchEmployer.where((element) => element['name'] == item).toList();

                                    //print('selectId ${selectID}');
                                    branchEmployerInt = selectID[0]['id'];
                                    loadLoanTemplates(branchEmployerInt);

                                    branchEmployer = selectID[0]['name'];
                                    employerDomain = selectID[0]['emailExtension'];
                                    // //print( '${employerDomain}');
                                  });
                                },
                                label: "Organization Branch * ",
                                selectedItem: branchEmployer,
                                validator: (String item){

                                  if(branchEmployerInt == 0){
                                    return 'Employer branch cannot be empty';
                                  }


                                }
                            ),
                          ),

                          SizedBox(height: 10,),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            child: DropDownComponent(
                                items: filteredProduct,
                                onChange: (String item) async {
                                  setState(() {
                                    List<dynamic> selectID = allProduct
                                        .where((element) => element['name'] == item)
                                        .toList();
                                    print('this is select ID ${selectID[0]}');
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

                          EntryField(
                            editController: principal,
                            labelText: 'Principal',
                            hintText: 'Principal',
                            keyBoard: TextInputType.number,
                            suffixWidget: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                              child: Text('NGN',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 19),),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Min Principal  ₦${formatCurrency.format(minPrincipal)} ,Max Principal  ₦${formatCurrency.format(maxPrincipal)}')),
                          SizedBox(height: 10,),
                          EntryField(
                            editController: tenor,
                            labelText: 'Tenor',
                            hintText: 'Tenor',
                            keyBoard: TextInputType.number,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Min Tenor ${minNumberOfRepayment} , Max Tenor ${maxNumberOfRepayment}')),

                          SizedBox(height: 10,),
                          EntryField(
                            editController: netPay,
                            labelText: 'Net Pay',
                            hintText: 'Net pay',
                            keyBoard: TextInputType.number,
                          ),
                          SizedBox(height: 10,),
                        ],
                      )),


                  RoundedButton(buttonText: 'Calculate Repayment',
                      onbuttonPressed: (){
                        // showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   builder: (BuildContext context) {
                        //     return draggable_bottom_sheet();
                        //   },
                        // );
                        repayment_calculation();
                  })


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  calculatorResultBottomSheet(
      LoanCalculatorResponse local_loanCalculatedResponse) {
    //  LoanCalculatedResponse loanCalculatedResponse = new LoanCalculatedResponse();
    // print('ddd>>');
    //  print(loanCalculatedResponse.totalFeeChargesCharged);

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * .86,
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * .0,
              MediaQuery.of(context).size.height * .016,
              MediaQuery.of(context).size.width * .0,
              MediaQuery.of(context).size.height * .0,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: ColorUtils.WHITE_COLOR,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22.0),
                  topLeft: Radius.circular(22.0)),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {

                          MyRouter.popPage(context);
                        },
                        //     onTap: NavigationService.goBack(),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .1,
                            maxHeight: MediaQuery.of(context).size.height * .06,
                          ),
                          width: MediaQuery.of(context).size.width * .1,
                          height: MediaQuery.of(context).size.height * .06,
                          margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * .03,
                            MediaQuery.of(context).size.height * .0,
                            MediaQuery.of(context).size.width * .0,
                            MediaQuery.of(context).size.height * .0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12.0),
                            color: ColorUtils.BLUE_WO,
                          ),
                          child: Icon(
                            Icons.close,
                            color: ColorUtils.MAIN_BLUE,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text("Repayment Information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: ColorUtils.MAIN_BLACK)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .015,
                ),

                Container(
                  child: Column(
                    children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            containerFees(title: 'Total Fees',fee: "${local_loanCalculatedResponse.totalFeeChargesCharged}",),
                            containerFees(title: 'Principal',fee:"${local_loanCalculatedResponse.totalPrincipalExpected}",),

                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          containerFees(title: 'Interest',fee:"${local_loanCalculatedResponse.totalInterestCharged}",),
                          containerFees(title:"Total Repayment",fee: "${local_loanCalculatedResponse.totalRepaymentExpected}",),

                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Repayment Schedule",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.MAIN_BLACK)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .015,
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    // height: MediaQuery.of(context).size.height * .6,
                    // constraints: BoxConstraints(
                    //   maxHeight: MediaQuery.of(context).size.height * .6,
                    // ),
                    // color: Colors.green,
                    child: ListView.builder(
                        itemCount:
                        local_loanCalculatedResponse.periods.length ?? 0,
                        itemBuilder: (context, index) {
                          var single_loan_calculated =
                          local_loanCalculatedResponse?.periods[index];
                          String d =
                          single_loan_calculated?.dueDate?.join(",");
                          String formattedDate = AppHelper().formatDateTime(d);
                          if (index == 0) {
                            return const SizedBox();
                          }
                          return Container(
                            height: MediaQuery.of(context).size.height * .36,
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * .1,
                              MediaQuery.of(context).size.height * .02,
                              MediaQuery.of(context).size.width * .1,
                              MediaQuery.of(context).size.height * .012,
                            ),
                            margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * .03,
                              MediaQuery.of(context).size.height * .0,
                              MediaQuery.of(context).size.width * .03,
                              MediaQuery.of(context).size.height * .015,
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                                // boxShadow:  [
                                //   BoxShadow(
                                //   //  color: ColorUtils.DROP_BG,
                                //     // Shadow color
                                //     offset: Offset(0, 3),
                                //     // Offset of the shadow
                                //     blurRadius: 6.0,
                                //     // Spread of the shadow
                                //     spreadRadius:
                                //     0.0, // How far the shadow should spread
                                //   )
                                // ]
                            ),
                            child: Column(

                              children: [
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text(
                                //       "Days",
                                //       style: TextStyle(
                                //           fontSize: 12.0,
                                //           fontWeight: FontWeight.w600,
                                //           color: ColorUtils.ICON_GREY,
                                //           fontFamily: 'Nunito SansRegular'),
                                //     ),
                                //     Text(
                                //       "${single_loan_calculated?.daysInPeriod ?? '--'}",
                                //       style: const TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //   ],
                                // ),

                                  // Align(
                                  //     alignment: Alignment.topRight,
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: Colors.black,
                                  //       ),
                                  //       padding: EdgeInsets.all(10), // Adjust padding as needed
                                  //       child: Center(
                                  //         child: Text(
                                  //           '$index',
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontFamily: 'Nunito SansRegular',
                                  //             fontSize: 16,
                                  //             color: Colors.white,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  // ),

                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    padding: EdgeInsets.all(10), // Adjust padding as needed
                                    child: Center(
                                      child: Text(
                                        '$index',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Nunito SansRegular',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),


                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                         Text("Date",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                                color: ColorUtils.ICON_GREY,
                                                fontFamily: 'Nunito SansRegular')),
                                      ],
                                    ),
                                    Text(formattedDate,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito SansRegular')),
                                  ],
                                ),
                                Divider(),
                                SizedBox(height: MediaQuery.of(context).size.height * .01),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // SizedBox(height: MediaQuery.of(context).size.width * .01),
                                    const Text("Principal",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: ColorUtils.ICON_GREY,
                                            fontFamily: 'Nunito SansRegular')),
                                    Text(
                                        "₦${formatCurrency.format(single_loan_calculated?.principalOriginalDue) ?? '--'}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito SansRegular')),
                                    // SizedBox(height: MediaQuery.of(context).size.width * .01),
                                  ],
                                ),
                                Divider(),
                                SizedBox(height: MediaQuery.of(context).size.height * .01),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Interest",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: ColorUtils.ICON_GREY,
                                            fontFamily: 'Nunito SansRegular')),
                                    Text(
                                        "₦${formatCurrency.format(single_loan_calculated.interestDue) ?? '--'}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito SansRegular')),
                                  ],
                                ),
                                Divider(),
                                SizedBox(height: MediaQuery.of(context).size.height * .01),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Fees",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600,
                                              color: ColorUtils.ICON_GREY,
                                              fontFamily:
                                              'Nunito SansRegular')),
                                      Text(
                                          "₦${formatCurrency.format(single_loan_calculated?.feeChargesDue) ?? '--'}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Nunito SansRegular'))
                                    ]),
                                Divider(),
                                SizedBox(height: MediaQuery.of(context).size.height * .01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Repayment",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: ColorUtils.ICON_GREY,
                                            fontFamily: 'Nunito SansRegular')),
                                    Text(
                                        "₦${formatCurrency.format(single_loan_calculated?.totalDueForPeriod) ?? '--'}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito SansRegular'))
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .009,
                ),

              ],
            ),
          );
        });
  }

  Widget containerFees({String title,String fee}){
    return Card(
      elevation: 3,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
            width: MediaQuery.of(context).size.width * 0.43,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${title}',style: TextStyle(fontSize: 13,fontFamily: 'Nunito Black',fontWeight: FontWeight.bold),),
              Text('₦${formatCurrency.format(double.tryParse(fee))}',style: TextStyle(fontSize: 16,fontFamily: 'Nunito SansRegular'),)

            ],
          ),
        ),
      ),
    );
  }


}
