// EXAMPLE use case for TextFieldSearch Widget
import 'package:flutter/material.dart';
import 'package:sales_toolkit/models/search_selection.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:textfield_search/textfield_search.dart';
import 'dart:async';
import 'package:sales_toolkit/widgets/TextSearch.dart';

class TestTextField extends StatefulWidget {
  TestTextField({Key key, this.title = 'My Home Page'}) : super(key: key);

  final String title;


  @override
  _TestTextFieldState createState() => _TestTextFieldState();
}

class _TestTextFieldState extends State<TestTextField> {
  final _testList = [
    'Test Item 1',
    'Test Item 2',
    'Test Item 3',
    'Test Item 4',
  ];

  List<dynamic> allEmployer = [];
  List<String> collectEmployer = [];
  TextEditingController myController = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
    myController2.addListener(_printLatestValue);
    myController3.addListener(_printLatestValue);
    myController4.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("text field1: ${myController.text}");
    print("text field2: ${myController2.text}");
    print("text field3: ${myController3.text}");
    print("text field4: ${myController4.text}");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    super.dispose();
  }

  // mocking a future
  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 2000));
    List _list = <dynamic>[];
    // create a list from the text input of three items
    // to mock a list of items from an http call
    // _list.add('Test' + ' Item 1');
    // _list.add('Test' + ' Item 2');
    // _list.add('Test' + ' Item 3');
   String query = myController2.text;
    final Future<Map<String,dynamic>> respose =   RetCodes().Leademployers(query);

    respose.then((response) async {
      List<dynamic> newEmp = response['data']['pageItems'];
      print('new emps ${newEmp}');
      setState(() {
        allEmployer = newEmp;
      });

      for(int i = 0; i < newEmp.length;i++){
        print(newEmp[i]['name']);
        collectEmployer.add(newEmp[i]['name']);
      }


    });

    return collectEmployer;
   // return _list;
  }

  // mocking a future that returns List of Objects
  Future<List> fetchComplexData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    List _list = <dynamic>[];
    List _jsonList = [
      {'label': 'Text' + ' Item 1', 'value': 30},
      {'label': 'Text' + ' Item 2', 'value': 31},
      {'label': 'Text' + ' Item 3', 'value': 32},
    ];
    // create a list from the text input of three items
    // to mock a list of items from an http call where
    // the label is what is seen in the textfield and something like an
    // ID is the selected value
    _list.add(new TestItem.fromJson(_jsonList[0]));
    _list.add(new TestItem.fromJson(_jsonList[1]));
    _list.add(new TestItem.fromJson(_jsonList[2]));

    return _list;
  }



  Future<List> getSuggestions() async{
        print('got here ');
        List _list = <dynamic>[];
        String query =  myController3.text;
        await Future.delayed(Duration(milliseconds: 1000));
    final Future<Map<String,dynamic>> respose =   RetCodes().Leademployers('wow');

    respose.then((response) async {
      List<dynamic> newEmp = response['data']['pageItems'];
          print('new emps ${newEmp}');
      setState(() {
        allEmployer = newEmp;

      });



        // for(int i=0;i < allEmployer.length;i++){
            _list.add(
              // SearchSelectionItem(label: parentItem.name!, value: parentItem.id)
            //    SearchSelectionItem(label: allEmployer[i]['name'],value: '')
              {'label': 'Text' + ' Item 1', 'value': 30},
            );
        // }




      // setState(() {
      //   employerArray = collectEmployer;
      //   List<dynamic> selectID =   allEmployer.where((element) => element['name'] == branchEmployer).toList();
      //   print('select value ${selectID}');
      //   //  branchEmployerInt = selectID[0]['id'];
      // });


    });
    // print('employer Array ${allEmployer}');
    // return allEmployer;
       print('lists ${_list}');
        return _list;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Form(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 16),
              LocalTextFieldSearch(
                  label: 'Simple Future List',
                  controller: myController2,
                  future: () {
                    return fetchSimpleData();
                  }),
              SizedBox(height: 16),
              LocalTextFieldSearch(
                label: 'Complex Future List',
                controller: myController3,
                future: () {
                  return fetchComplexData();
                //  return getSuggestions();
                },
                getSelectedValue: (item) {
                  print('item ${item}');
                  //      this._typeAheadController.text = suggestion['name'];
                  //       print('suggesttion ${suggestion}');
                  //       employerInt = suggestion['id'];
                  //       employerDomain = suggestion['emailExtension'];
                  //       getEmployersBranch(employerInt);
                  //       branchEmployerInt = 0;
                  //       setState(() {
                  //         employerState = '';
                  //         branchEmployer = '';
                  //         employerLga = '';
                  //         address.text = '';
                  //         employer_phone_number.text = '';
                  //         _isOTPSent = false;
                  //         employerArray = [];

                },
                minStringLength: 5,
                textStyle: TextStyle(color: Colors.red),
                decoration: InputDecoration(hintText: 'Search For Something'),
              ),
              SizedBox(height: 16),

              LocalTextFieldSearch(
                  label: 'Future List with custom scrollbar theme',
                  controller: myController4,
                        // decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //   //  hintText: parentEmployer == '' ? 'Search Employer ' : parentEmployer
                        // ),
                  // scrollbarDecoration: ScrollbarDecoration(
                  //     controller: ScrollController(),
                  //     theme: ScrollbarThemeData(
                  //         radius: Radius.circular(30.0),
                  //         thickness: MaterialStateProperty.all(20.0),
                  //         isAlwaysShown: true,
                  //         trackColor: MaterialStateProperty.all(Colors.red))
                  // ),
                  future: () {
                    return fetchSimpleData();
                  },
                getSelectedValue: (item) {
                  print('item ${item}');
                },

                  ),

              SizedBox(height: 16),
              LocalTextFieldSearch(
                  initialList: _testList,
                  label: 'Simple List',
                  controller: myController),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Mock Test Item Class
class TestItem {
  final String label;
  dynamic value;

  TestItem({@required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}