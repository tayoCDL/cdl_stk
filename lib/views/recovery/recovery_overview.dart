import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';

class RecoveryOverview extends StatefulWidget {
 final int collectionID;
  const RecoveryOverview({Key key,this.collectionID}) : super(key: key);

  @override
  _RecoveryOverviewState createState() => _RecoveryOverviewState(
      collectionID:this.collectionID
  );
}



class _RecoveryOverviewState extends State<RecoveryOverview> {
  int collectionID;
  String realMonth='';
  Map<String,dynamic> recoveryLists = {};

  _RecoveryOverviewState({this.collectionID});

  @override
  void initState() {
    // TODO: implement initState
    singleRecovery();
    super.initState();
  }



  singleRecovery(){
    final Future<Map<String,dynamic>> respose =   RetCodes().recoveryOverview(collectionID);

    respose.then((response) async {
      print('received  ${response['data']}');

      if(response['data'] == null){
        print('no recovery available');
      }
      else {
        if(response['status'] == true){
          setState(() {
            recoveryLists = response['data'];
          });
        }
      }
    }
    );

  }

  final formatCurrency = NumberFormat.currency(locale: "en_US",
      symbol: "");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Text('#${recoveryLists['id']}'),
                ),
                Text('')
              ],
            ),

            Divider(color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Align(
                  child: Column(
                    children: [
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text('Customer Name'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                            child: Text('${recoveryLists['loan'] == null ? '--' : recoveryLists['loan']['clientName']}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                          Text('')
                        ],
                      ),

                      SizedBox(height: 20,),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text('Loan Product'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                            child: Text('${recoveryLists['loan'] == null ? '--' : recoveryLists['loan']['loanProductName']}',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                          Text('')
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text('Activation Date'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [
                          recoveryLists['clientData'] == null ? Text('') :
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                            child: Text('${recoveryLists['clientData'] == null  || recoveryLists['clientData'].isEmpty? '--' :

    recoveryLists['clientData']['activationDate'][0]}-${recoveryLists['clientData']['activationDate'][1]}-${recoveryLists['clientData']['activationDate'][2]}'

                              ,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),

                          Text('')
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text('Amount Paid'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                            child: Text('NGN ${recoveryLists['loan'] == null ? '--' : recoveryLists['loan']['summary']['principalPaid']}',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                          Text('')
                        ],
                      ),

                      SizedBox(height: 20,),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text('Current Outstanding'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                            child: Text('NGN ${recoveryLists['loan'] == null ? '--' : formatCurrency.format(recoveryLists['loan']['summary']['principalOutstanding'])}',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                          Text('')
                        ],
                      ),

                      SizedBox(height: 20,),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text('Total Outstanding'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                            child:
                            Text('',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),

                          ),
                          Text('NGN ${recoveryLists['loan'] == null ? '--' : formatCurrency.format(recoveryLists['loan']['summary']['totalOutstanding'])}',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold))
                        ],
                      ),

                      SizedBox(height: 20,),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                            child: Text('Total Overdue'),
                          ),
                          Text('')
                        ],
                      ),
                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                            child:  Text('NGN ${recoveryLists['loan'] == null ? '--' : formatCurrency.format(recoveryLists['loan']['summary']['totalOverdue'])}',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold))
                          ),
                          Text('')
                        ],
                      ),

                    ],
                  ),
                alignment: Alignment.bottomLeft,
              ),
            ),


          ],
        ),
      ),
    );
  }

  retDOBfromBVN(String getDate){
    print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);



    if(wordList[1] == '1'){
      setState(() {
        realMonth = 'January';
      });
    }
    if(wordList[1] == '2'){
      setState(() {
        realMonth = 'February';
      });
    }
    if(wordList[1] == '3'){
      setState(() {
        realMonth = 'March';
      });
    }
    if(wordList[1] == '4'){
      setState(() {
        realMonth = 'April';
      });
    }
    if(wordList[1] == '5'){
      setState(() {
        realMonth = 'May';
      });
    }  if(wordList[1] == '6'){
      setState(() {
        realMonth = 'June';
      });
    }  if(wordList[1] == '7'){
      setState(() {
        realMonth = 'July';
      });
    }  if(wordList[1] == '8'){
      setState(() {
        realMonth = 'August';
      });
    }  if(wordList[1] == '9'){
      setState(() {
        realMonth = 'September';
      });
    }  if(wordList[1] == '10'){
      setState(() {
        realMonth = 'October';
      });
    }
    if(wordList[1] == '11'){
      setState(() {
        realMonth = 'November';
      });
    }
    if(wordList[1] == '12'){
      setState(() {
        realMonth = 'December';
      });
    }


    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o3.length == 1 ? '0' + '' + o3 :  o3;

    print('newOO ${newOO}');

    String concatss =  newOO + " " + realMonth + " " + o1   ;

    print("concatss new Date from edit ${concatss}");

    return concatss;


  }

}
