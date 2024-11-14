import 'dart:convert';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/DocumentExtraScreen.dart';
import 'package:sales_toolkit/views/Loans/SingleLoanView.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoanBankStatement extends StatefulWidget {

  final int clientId,loanId;
  final String passedMoreDocument;
  const LoanBankStatement({Key key,this.clientId,this.passedMoreDocument,this.loanId}) : super(key: key);

  @override
  _LoanBankStatementState createState() => _LoanBankStatementState(
    clientId:this.clientId,
    passedMoreDocument:this.passedMoreDocument,
    loanId:this.loanId,
  );
}

class _LoanBankStatementState extends State<LoanBankStatement> {

  int clientId,loanId;
  String passedMoreDocument;
  _LoanBankStatementState({this.clientId,this.passedMoreDocument,this.loanId});
  @override

  List<String> titleArray = [];
  List<String> collectTitle = [];
  List<dynamic> allTitle = [];
  bool value = false;
  List<String> relationshipArray = [];
  List<String> collectRelationship= [];
  List<dynamic> allRelationship = [];

  List<String> maritalArray = [];
  List<String> collectMarital= [];
  List<dynamic> allMarital = [];

  List<String> genderArray = [];
  List<String> collectGender = [];
  List<dynamic> allGender = [];

  List<String> professionArray = [];
  List<String> collectProfession = [];
  List<dynamic> allProfession = [];
  var nextOfKin = [];

  Map<String,dynamic> loanDetail = {};

  var bankResult = [];
  String bankSortCode = '';
  bool showTicketAndPassword = false;
  int mbsSortCode = 0;

  void initState() {
    // TODO: implement initState
    print('clientID ${clientId} moreDocument ${passedMoreDocument}');
    getBankMbsSync();
    getBankInfoInformation();
    getPersonalInformation();
    getLoanDetails();
    super.initState();
  }

  getBankInfoInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int localclientID =  clientId;

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString() + '/banks',
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
    var newClientData = responseData2;
    setState(() {
      bankSortCode = newClientData[0]['bank']['bankSortCode'];
    });
    // print('bankInfo ${bankInfo}');
    accountName.text = newClientData[0]['accountname'];
    accountNumber.text = newClientData[0]['accountnumber'];
    bankname.text = newClientData[0]['bank']['name'];

  }

  getPersonalInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    int localclientID =  clientId;
    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    ///clients/{clientId}/familymembers
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);

    final Map<String,dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {

      phonenumber.text = newClientData['mobileNo'];

    });


  }

  getBankMbsSync()
  {
    final Future<Map<String,dynamic>> respose =   RetCodes().getMBSBank();
    respose.then((response){
      if(response['status'] == true){
        print('bank ${response['data']['data']['result']}');

        setState(() {
          bankResult = response['data']['data']['result'];
        });

        List<dynamic> selectSortCode =  bankResult.where((element) => element['sortCode'] == bankSortCode).toList();

        mbsSortCode = selectSortCode[0]['id'];
        print('this is Clientx code ${selectSortCode}');
        if(selectSortCode[0]['sortCode'] == '057' || selectSortCode[0]['sortCode'] == '058')
        {
          setState(() {
            showTicketAndPassword = true;
          });
        }
        else {
          setState(() {
            showTicketAndPassword = false;
          });
        }


      }
      else {

      }
    });
  }

  submitLoanBankStatement() async {


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int tempLoanID =  prefs.getInt('loanCreatedId');
    print('MBS SortCode ${mbsSortCode}');



    Map<String,dynamic> bankAnalyser = {
      "externalBankId": mbsSortCode,
      "amountRequested": loanDetail['principal'],
      "productId": loanDetail['loanProductId'],
      "tenure": loanDetail['numberOfRepayments'],
      "phone": phonenumber.text,
      "loanId":loanDetail['id'],
    };
    Map<String,dynamic> bankAnalyserWithTicket = {
      "externalBankId": mbsSortCode,
      "amountRequested": loanDetail['principal'],
      "productId": loanDetail['loanProductId'],
      "tenure": loanDetail['numberOfRepayments'],
      "ticketNo": ticketID.text,
      "password": password.text,
      "phone": phonenumber.text,
      "loanId":loanDetail['id'],

    };

    setState(() {
      _isLoading = true;
    });

    final Future<Map<String,dynamic>> respose =   RetCodes().bankStatementAnalyser( showTicketAndPassword ? bankAnalyserWithTicket : bankAnalyser,tempLoanID,clientId);
    respose.then((response) async {

      setState(() {
        _isLoading = false;
      });

      print('response from APi ${response}');
      if(response['status'] == false){
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to analyse statement',
          duration: Duration(seconds: 3),
        ).show(context);
      }
      else {
        if(response['data']['status'] == 'FAIL'){
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Success',
            message: 'Auto analysis failed, please try the manual route',
            duration: Duration(seconds: 6),
          ).show(context);
        }
        else if(response['data']['status'] == 'COUNTER_OFFER'){
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orangeAccent,
            title: 'Success',
            message: response['data']['reason'],
            duration: Duration(seconds: 6),
          ).show(context);
        }
        else {
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: 'Statement analysis successful',
            duration: Duration(seconds: 6),
          ).show(context);
        }


        //    MyRouter.pushPageReplacement(context, ViewClient(clientID: clientId,));
        int tempLoanID =  prefs.getInt('loanCreatedId');
        bool isAutoDisbursed = prefs.getBool('isAutoDisburse');

        // if(isAutoDisbursed == false){
        //
        //
        // }
        // else {
        //   submitLoanBankStatement();
        // }
      }
      //
      // bool isAutoDisbursed = prefs.getBool('isAutoDisburse');
      // if(!isAutoDisbursed){
      //
      // }
      // else {
      //   MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));
      // }


    });
  }

  getLoanDetails() async{
    print('loanID ${loanId}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('this is ir ');

    Response responsevv = await get(
      AppUrl.getLoanDetails + loanId.toString() + '?associations=all&exclude=guarantors,futureSchedule',
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
      loanDetail = newClientData;

      // if(loanDetail['configs'] != null){
      //   int docConfigData = loanDetail['configs'][0]['id'];
      //   if(docConfigData != null){
      //     geSingleLoanConfig(docConfigData);
      //   }
      // }



    });
    print('Loan detail ${loanDetail}');

  }




  @override
  TextEditingController bankname = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController accountName = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController ticketID = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController note = TextEditingController();


  bool _isLoading = false;

  final _form = GlobalKey<FormState>(); //for storing form state.

  int titleInt,relationshipInt,maritalInt,genderInt,professionInt;

  Widget build(BuildContext context) {

    var sendLoanForApproval = () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (note.text.isEmpty || note.text.length < 5) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'note length too short ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      int tempLoanID =  prefs.getInt('loanCreatedId');

      Map<String, dynamic> noteData = {
        'note': note.text,
      };

      MyRouter.popPage(context);
      setState(() {
        _isLoading = true;
      });


      final Future<Map<String, dynamic>> respose = RetCodes()
          .SendLoanForApproval(noteData, tempLoanID,'manual_review');

      setState(() {
        _isLoading = false;
      });


      respose.then((response) {
        print('response got here for approval ${response}');
        if (response['status'] == true) {
          note.text = '';
          MyRouter.popPage(context);
          prefs.remove('sendForManualReview');


          MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',clientID: clientId,));

          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: 'Loan successfully sent for approval',
            duration: Duration(seconds: 5),
          ).show(context);
        }

        else {
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.redAccent,
            title: 'Failed',
            message: response['message'],
            duration: Duration(seconds: 5),
          ).show(context);
        }
      });
    };


    sendForAppro() {
      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Comment'),
            InkWell(
                onTap: () {
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],),
        content: EntryField(
          context, note, 'Add Comment', 'Enter Comment', TextInputType.name,),
        textOK: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          child: RoundedButton(buttonText: 'Send For Approval', onbuttonPressed: () {
            sendLoanForApproval();
          },
          ),
        ),
      );
    }

    needToComplete() {
      bool isAllowedToSend = (loanDetail['paymentMethod'] != null && loanDetail['paymentMethod']['id'] > 1);
      print('is allowed to send ? ${isAllowedToSend}');
      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Requirements not met',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
            InkWell(
                onTap: () {
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('::: Please confirm If :::'),
              SizedBox(height: 10,),
              Text( loanDetail['isDocumentComplete'] ? '' : 'Necessary Loan Document Not Uploaded',style: TextStyle(fontSize: 13),),

              SizedBox(height: 10,),
              Text( isAllowedToSend ? '' : ' Repayment Method Not set',style: TextStyle(fontSize: 13)),
              SizedBox(height: 10,),
              Text( loanDetail['isLafSigned'] ? '' : ' LAF Has Not Been Accepted By Customer',style: TextStyle(fontSize: 13))
            ],
          ),
        ),
        textOK: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: Column(

              children: [
                // RoundedButton(buttonText: 'OKAY', onbuttonPressed: () {
                //   //  sendLoanForApproval();
                //   MyRouter.popPage(context);
                // },
                // ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OutlinedButton(
                    onPressed: (){
                      //  sendOTPLaf();
                      MyRouter.pushPageReplacement(context, SingleLoanView(loanID: loanDetail['id'],comingFrom: 'loanBankStatement',clientID: clientId,));
                    },
                    child: Text(
                      'Proceed, send later',
                      style: TextStyle(color: Color(0xff077DBB),fontFamily: 'Nunito SansRegular'),

                    ),
                  ),
                ),

                SizedBox(height: 10,),
                RoundedButton(buttonText: 'OKAY', onbuttonPressed: () {
                  //  sendLoanForApproval();
                  MyRouter.popPage(context);
                },
                ),
              ],
            )



        ),
      );
    }


    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(

        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProgressStepper(stepper: 0.85,title: 'Loan Bank Statement',subtitle: 'Complete',),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        child: Text('',style: TextStyle(fontSize: 11),),
                      ),


                      Form(
                          key: _form,
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, bankname, 'Bank Name *','Enter bank name',TextInputType.name,isRead: true)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, accountNumber, 'Account Number *','Enter account number',TextInputType.name,isRead: true)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, accountName, 'Account Name *','Enter account name ',TextInputType.name,isRead: true)
                              ),

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, phonenumber, 'Mobile Number Attached To Bank Account*','Enter mobile number ',TextInputType.name,isRead: false)
                              ),
                              showTicketAndPassword ?  Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      child: EntryField(context, ticketID, 'Ticket ID *','Enter ticket ID',TextInputType.name,isRead: false)
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      child: EntryField(context, password, 'Password *','Enter password ',TextInputType.name,isRead: false)
                                  ),
                                ],
                              ) : SizedBox(height: 0,),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Row(
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
                                    Text('I HAVE CONFIRMED FROM CLIENT THAT THIS IS THE \n'
                                        ' MOBILE NUMBER ATTACHED TO HIS BANK ACCOUNT \n'
                                        'AND CLIENT HAD GIVEN THE GO AHEAD TO PULL \n'
                                        ' HIS STATEMENT',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ),

                              showTicketAndPassword ?  Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.circle,color: Colors.redAccent
                                      ,size: 25,)
                                    ,
                                    Text('PLEASE ADVICE CLIENT TO GENERATE TICKET ID \nAND PASSWORD FROM THEIR MOBILE APPLICATION OR \nINTERNET BANKING \n'
                                      ,style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.redAccent),)
                                  ],
                                ),
                              ) : SizedBox()

                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              //   child: DropDownComponent(items: professionArray,
                              //       onChange: (String item) async{
                              //         setState(() {
                              //
                              //           List<dynamic> selectID =   allProfession.where((element) => element['name'] == item).toList();
                              //           print('this is select ID');
                              //           print(selectID[0]['id']);
                              //           professionInt = selectID[0]['id'];
                              //           print('end this is select ID');
                              //
                              //         });
                              //       },
                              //       label: "Profession",
                              //       selectedItem: "--",
                              //       validator: (String item){
                              //
                              //       }
                              //   ),
                              // ),
                            ],
                          )),


                      SizedBox(height: 50,),
                    ],
                  ),
                )





              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',
          callAction2: () async{
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            bool isAutoDisbursed = prefs.getBool('isAutoDisburse');
            if(isAutoDisbursed == false){

              bool isAllowedToSend =  loanDetail['isLafSigned'] &&  loanDetail['isDocumentComplete'] && (loanDetail['paymentMethod'] != null && loanDetail['paymentMethod']['id'] > 0);

              isAllowedToSend? submitLoanBankStatement() : null;


              isAllowedToSend   ? sendForAppro() : needToComplete();
            }
            else {
              submitLoanBankStatement();
              MyRouter.pushPageReplacement(context, SingleLoanView(loanID: loanDetail['id'],comingFrom: 'loanBankStatement',clientID: loanDetail['clientId']));

            }



          },callAction1: (){
            MyRouter.popPage(context);
          },),
      ),
    );
  }

  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,bool isRead = false}){
    var MediaSize = MediaQuery.of(context).size;
    return
      Container(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,

              // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // set rounded corner radius
            ),
            child:
            TextFormField(
              readOnly: isRead,
              maxLength: maxLenghtAllow,
              style: TextStyle(fontFamily: 'Nunito SansRegular'),
              keyboardType: keyBoard,

              controller: editController,

              validator: (value) {

                if(value.isEmpty){
                  return 'Field cannot be empty';

                }



              },


              // onSaved: (value) => vals = value,

              decoration: InputDecoration(
                  suffixIcon: isPassword == true ? Icon(Icons.remove_red_eye,color: Colors.black38
                    ,) : null,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                  ),
                  border: OutlineInputBorder(

                  ),
                  labelText: labelText,
                  floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular'),
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                  counter: SizedBox.shrink()
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      );




  }

}

