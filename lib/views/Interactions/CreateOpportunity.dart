import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addInteraction.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteraction.dart';
import 'package:sales_toolkit/views/Interactions/clientOpportunity.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';

import '../../palatte.dart';

class CreateOpportunity extends StatefulWidget {
  final int ClientID;
  final String clientName,ClientEmail;
  const CreateOpportunity({Key key,this.ClientID,this.ClientEmail,this.clientName}) : super(key: key);

  @override
  _CreateOpportunityState createState() => _CreateOpportunityState(
      ClientID:this.ClientID,
      ClientEmail:this.ClientEmail,
      clientName: this.clientName
  );
}

enum SingingCharacter { resolved,Open, Closed }


class _CreateOpportunityState extends State<CreateOpportunity> {
  int ClientID;
  String ClientEmail,clientName;

  _CreateOpportunityState({
    this.ClientID,
    this.clientName,
    this.ClientEmail
  });

  @override

  List<String> affectedUserArray = [];
  List<String> collectAffectedUser = [];
  List<dynamic> allAffected  = [];

  List<String> departmentUnitArray = []; // display to users
  List<String> collectDepartmentUnit = []; // collect department from endpoint, filter and show the names only
  List<dynamic> allDepartmentUnit  = []; // filter purpose

  List<String> TicketTypeArray = [];
  List<String> collectTicketType = [];
  List<dynamic> allTicketType  = [];

  List<String> CategoryArray = [];
  List<String> collectCategory = [];
  List<dynamic> allCategory  = [];


  List<String> SubCategoryArray = [];
  List<String> collectSubCategory = [];
  List<dynamic> allSubCategory  = [];

  File uploadimage;
  final ImagePicker _picker = ImagePicker();

  String _fileName = '...';

  String fileSize = '';

  String _path = '...';
  String baseimage = '';
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();
  File chosenImage;
  String agent_name,agent_email = '';
  int agentId = 0;

  TextEditingController passport = TextEditingController();

  void initState() {
    // TODO: implement initState
    getAffectedType();
    deparmentUnit();
    TicketType(2);
     CategoryType();
    getStaffID();
    // getSubCategory(10);
    email.text = ClientEmail;
    name.text = clientName;
    sequestClientID.text = ClientID.toString();
    super.initState();
  }

  getStaffID() async{
    final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData();
    respose.then(
            (response) {


        //  print('this is referal ${response['data']}');
          setState(() {
            agentId = response['data']['id'];
            agent_name = response['data']['displayName'];
            agent_email = response['data']['displayName'];
          });

        }
    );

  }


  getAffectedType(){
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().affectedUsers();

    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);
      //{data: {id: 3, requestTypeName: Request, affectedTypeId: 2}, message: successful, responseCode: 00}
      List<dynamic> newEmp = response['data']['data'];
      print('new emps');
      print(newEmp);
      setState(() {
        allAffected = newEmp;
        _isLoading = false;
      });

      for(int i = 0; i < newEmp.length;i++){
        //  print(newEmp[i].affectedTypeName);
        collectAffectedUser.add(newEmp[i]['affectedTypeName']);
      }
      print('vis alali');
      print(collectAffectedUser);

      setState(() {
        affectedUserArray = collectAffectedUser;
      });
    }
    );
  }

  deparmentUnit(){
    final Future<Map<String,dynamic>> respose =   RetCodes().departmentUnit();
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data']['data'];
      print('new emps');
      print(newEmp);
      setState(() {
        allDepartmentUnit = newEmp;
      });
//O(n)
      for(int i = 0; i < newEmp.length;i++){
        //  print(newEmp[i].affectedTypeName);
        collectDepartmentUnit.add(newEmp[i]['unitName']);
      }
      print('vis alali');
      print(collectDepartmentUnit);

      setState(() {
        departmentUnitArray = collectDepartmentUnit;
      });
    }
    );
  }

  TicketType(int affectedType){
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().ticketType(affectedType);


    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);
      List<dynamic> newEmp = response['data']['data'];
      print('new emps');
      print(newEmp.length);
      setState(() {
        allTicketType = newEmp;
        collectTicketType = [];
      });

      for(int i = 0; i < newEmp.length;i++){
        //  print(newEmp[i].affectedTypeName);
        collectTicketType.add(newEmp[i]['requestTypeName']);
      }
      print('vis alali');
      print(collectTicketType);

      setState(() {
        // TicketTypeArray = [];
        TicketTypeArray = collectTicketType;
      });
    }

    );
    setState(() {
      _isLoading = false;
    });
  }

  CategoryType(){
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().categoryTypeForOpportunity(8);
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);

      List<dynamic> newEmp = response['data']['data'];
      print('new emps');

      print(newEmp);
      setState(() {
        CategoryArray = [];
        allCategory = newEmp;
      });

      for(int i = 0; i < newEmp.length;i++){
        //  print(newEmp[i].affectedTypeName);
        collectCategory.add(newEmp[i]['categoryName']);
      }

      print('vis alali catgory');
      print(collectCategory);

      setState(() {
        CategoryArray = collectCategory;
      });
    }
    );
  }

  getSubCategory(int categoryID){
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().getSubCategoryType(categoryID);
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);
      List<dynamic> newEmp = response['data']['data'];
      print('new emps');
      print(newEmp);
      setState(() {
        allSubCategory = newEmp;
      });

      setState(() {
        collectSubCategory = [];
      });

      for(int i = 0; i < newEmp.length;i++){
        //  print(newEmp[i].affectedTypeName);
        collectSubCategory.add(newEmp[i]['subCategoryName']);
      }

      print('vis alali subcatgory');
      print(collectSubCategory);

      setState(() {
        SubCategoryArray = collectSubCategory;
      });
    }
    );
  }



  @override
  var _lights = true;
  String employment_type = '';
  int affectedInt,ticketInt,categoryInt,subCategoryInt;
  bool _isLoading = false;
  int departmentInt = 2764;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sequestClientID = TextEditingController();

  AddInteractionProvider addInteractionProvider = AddInteractionProvider();

  Widget build(BuildContext context) {

    var submitInteraction  = () {
      if(title.text.length < 2 || description.text.length < 2){
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Validation error",
          message: 'title or description too short',
          duration: Duration(seconds: 3),
        ).show(context);
      }
      else {
        setState(() {
          _isLoading = true;
        });

      //   {
      //     "subject": "string",
      // "description": "string",
      // "clientId": "string",
      // "requestingParty": 0,
      // "categoryId": 0,
      // "subCategoryId": 0,
      // "channelId": 0,
      // "createdBy": "string",
      // "createdById": "string",
      // "createdByEmail": "string",
      // "responsibleUnitId": 0,
      // "responsiblePersonId": "string"
      // }

        Map<String,dynamic> interactionData= {
          "subject": title.text,
          "description": description.text,
          "clientId": sequestClientID.text,
          "requestingParty": 0,
          "categoryId": categoryInt,
          "subCategoryId": subCategoryInt,
          "channelId": 77,
           "responsibleUnitId":  departmentInt.toString(),
          "createdBy": agent_name.toString(),
          "createdById": agentId.toString(),
          "createdByEmail": agent_name,
          "responsiblePersonId": agentId.toString()
        };

        String url = AppUrl.createOpportunity;
        final Future<Map<String,dynamic>> respose =  addInteractionProvider.addInteraction(interactionData,url);

        print('response from backend ${respose}');

        respose.then((response) {

          if (response['status']) {

            // Navigator.pushReplacementNamed(context, '');
            MyRouter.pushPageReplacement(context, ClientOpportunity(clientID: ClientID,));
            // MyRouter.popPage(context);
            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.green,
              title: "Success",
              message: 'New Opportunity added',
              duration: Duration(seconds: 3),
            ).show(context);
          } else {

            setState(() {
              _isLoading = false;
            });

            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: "Error",
              message: response['message']['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });

        print('start response from login');
        setState(() {
          _isLoading = true;
        });


      }

    };



    return LoadingOverlay(
      isLoading:  _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('New Opportunity',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                MyRouter.popPage(context);
              },
              icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
            ),
          ),

          body: GestureDetector(
            onTap: (){

              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: ListView(
                children: [

                  SizedBox(height: 30,),
                  EntryField(context, title, 'Short Description *','Enter Short Description here',TextInputType.name),
                  SizedBox(height: 20,),

                  TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 6,
                    controller: description,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                        ),
                        labelText: 'Comment',
                        floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                        hintText: 'Comment',
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular'),
                        labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                        counter: SizedBox.shrink()
                    ),
                  ),

               //   SizedBox(height: 20,),

                  Visibility(
                    visible: false,
                      child: EntryField(context, sequestClientID, 'Requesting Client ID *','Enter Requesting client here',TextInputType.name,isRead: true)),
                //  SizedBox(height: 20,),

                  Visibility(
                      visible: false,
                      child: EntryField(context, email, 'Requesting Client email *','Enter email here',TextInputType.emailAddress,isRead: true)),
                  // SizedBox(height: 20,),
                  Visibility(
                      visible: false,
                      child: EntryField(context, name, 'Requesting Client name *','Enter client name here',TextInputType.name,isRead: true)),
                //  SizedBox(height: 20,),



                  // DropDownComponent(items: affectedUserArray,
                  //     onChange: (String item){
                  //       setState(() {
                  //
                  //         List<dynamic> selectID =   allAffected.where((element) => element['affectedTypeName'] == item).toList();
                  //         print('this is select ID');
                  //         print(selectID[0]['id']);
                  //         affectedInt = selectID[0]['id'];
                  //         print('end this is select ID');
                  //         TicketType(affectedInt);
                  //
                  //       });
                  //     },
                  //     label: "Affected User Type: ",
                  //     selectedItem: "----",
                  //     validator: (String item){
                  //
                  //     }
                  //
                  // ),
                  // SizedBox(height: 20,),
                  // EntryField(context, bvn, 'Staff ID *','Enter Staff ID',TextInputType.name),
                  // SizedBox(height: 20,),
                  // DropDownComponent(items: TicketTypeArray,
                  //     onChange: (String item){
                  //       setState(() {
                  //
                  //         List<dynamic> selectID =   allTicketType.where((element) => element['requestTypeName'] == item).toList();
                  //         print('this is select ID');
                  //         print(selectID[0]['id']);
                  //         ticketInt = selectID[0]['id'];
                  //
                  //
                  //
                  //       });
                  //     },
                  //     label: "Ticket Type",
                  //     selectedItem: "----",
                  //     validator: (String item){
                  //
                  //     }
                  //
                  // ),
                  //
                 //  SizedBox(height: 20,),
                  Visibility(
                    visible: false,
                    child: DropDownComponent(items: departmentUnitArray,
                        onChange: (String item){
                          setState(() {

                            List<dynamic> selectID =   allDepartmentUnit.where((element) => element['unitName'] == item).toList();
                            print('this is select ID');
                            print(selectID[0]['id']);
                            departmentInt = selectID[0]['id'];
                         //   CategoryType(ticketInt,departmentInt);
                            print('end this is select ID');

                          });
                        },
                        label: "Responsible Department(Unit): ",
                        selectedItem: "----",
                        validator: (String item){

                        }

                    ),
                  ),

                  // SizedBox(height: 20,),
                  SizedBox(height: 20,),
                  DropDownComponent(items: CategoryArray,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allCategory.where((element) => element['categoryName'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          categoryInt = selectID[0]['id'];
                          var tickCOnfs =  getSubCategory(categoryInt);
                          print('end this is select ID Ticketconfs');
                          print(tickCOnfs);
                        });
                      },
                      label: "Category",
                      selectedItem: "----",
                      validator: (String item){

                      }

                  ),
                  SizedBox(height: 20,),
                  DropDownComponent(items: SubCategoryArray,
                      onChange: (String item){
                        setState(() {
                          List<dynamic> selectID =   allSubCategory.where((element) => element['subCategoryName'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          subCategoryInt = selectID[0]['id'];
                          print('end this is select ID');
                        });
                      },
                      label: "Sub Category",
                      selectedItem: "----",
                      validator: (String item){

                      }

                  ),
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
          bottomNavigationBar:
          DoubleBottomNavComponent(
            text1: 'Cancel',text2: 'Submit',callAction1: (){
            MyRouter.popPage(context);
          },
            callAction2: (){

              submitInteraction();
            },
          )
      ),
    );
  }



  Widget showTicketStatusSheet(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Select the ticket status to \n complete interaction',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.black),),
              SizedBox(height: 10,),

            ],
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),

      child: Column(
        children: <Widget>[
          Text(
            "Choose...",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
                MyRouter.popPage(context);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
                MyRouter.popPage(context);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    // final pickedFile = await _picker.getImage(
    //   source: source,
    // );
    // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);

    var choosedimage = await ImagePicker.pickImage(source: source);
    print(choosedimage);

    setState(() {
      uploadimage = choosedimage;

      final bytes = choosedimage.readAsBytesSync().lengthInBytes;

      // get file size
      final kb = bytes / 1024;
      final mb = kb / 1024;
      print('this is the MB ${mb}');
      String filesizeAsString  = mb.toString();
      fileSize = filesizeAsString;

      // end get file size
      //convert image to base64
      List<int> imageBytes = uploadimage.readAsBytesSync();
      baseimage = base64Encode(imageBytes);



      String getPath  = choosedimage.toString();
      _fileName = getPath != null ? getPath.split('/').last : '...';
      passport.text = _fileName;
    });
  }

  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,bool isRead = false,}){
    var MediaSize = MediaQuery.of(context).size;
    return
      Container(
        height: 60,
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
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular'),
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                  counter: SizedBox.shrink()
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
      );




  }




}

