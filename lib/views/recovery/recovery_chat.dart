import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/app_theme.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/addInteraction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecoveryChat extends StatefulWidget {
  final String ticketID;
  const RecoveryChat({Key key, @required this.ticketID}) : super(key: key);

  @override
  _RecoveryChatState createState() =>
      _RecoveryChatState(ticketID: this.ticketID);
// final User user;
}

class _RecoveryChatState extends State<RecoveryChat> {
  @override
  var discussData = [];
  var fullRequestData = {};

  File uploadimage;
  final ImagePicker _picker = ImagePicker();

  String _fileName = '...';
  bool _isLoading = false;
  String fileSize = '';
  String baseimage = '';

  File chosenImage;

  AddInteractionProvider _addInteractionProvider = AddInteractionProvider();
  TextEditingController chatSendController = TextEditingController();

  void initState() {
    getDiscourseLists();
    super.initState();
  }

  String ticketID;
  _RecoveryChatState({this.ticketID});

  getDiscourseLists() async {
    print('ticketID ${ticketID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var sequesttoken = prefs.getString('sequestToken');
    print('sequest Token ${sequesttoken}');
    Response responsevv = await get(
      AppUrl.getFullDiscussWithTicketID + ticketID,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );
    print('this is ir ${responsevv.body}');

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      discussData = newClientData['data']['discourseList'];
      fullRequestData = newClientData['data'];
    });
    print(discussData);
  }

  Widget build(BuildContext context) {
    var replyTicket = () async {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> interactionData = {
        "ticketId": ticketID,
        "messageBody": chatSendController.text,
        "unitId": 0,
        "fileName": "",
        "attachment": "",
        "fileSize": "",
        "createdBy": "",
        "createdById": "",
        "requestStatus": "001"
      };

      final Future<Map<String, dynamic>> respose =
          _addInteractionProvider.replyTicket(interactionData);

      respose.then((response) {
        if (response['status'] == false) {
          setState(() {
            _isLoading = false;
          });
          print('response returned ${response['message']}');
          if (response['message'] == 'Network_error') {
            //       Flushbar(
            //              flushbarPosition: FlushbarPosition.TOP,
            //              flushbarStyle: FlushbarStyle.GROUNDED,
            //   backgroundColor: Colors.orangeAccent,
            //   title: 'Network Error',
            //   message: 'Proceed, data has been saved to draft',
            //   duration: Duration(seconds: 3),
            // ).show(context);

            return MyRouter.pushPageReplacement(
                context, RecoveryChat(ticketID: ticketID));
          }

          /*   Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: 'Error',
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);*/

        } else {
          setState(() {
            _isLoading = false;
          });
          print('response returned ${response['message']}');
          // if(comingFrom == 'CustomerPreview'){
          //   return  MyRouter.pushPage(context, CustomerPreview());
          // }
          // if(comingFrom == 'SingleCustomerScreen'){
          //   return  MyRouter.pushPage(context, SingleCustomerScreen(clientID: ClientInt,));
          // }
          //
          // MyRouter.pushPage(context, BankDetails());
          //       Flushbar(
          //              flushbarPosition: FlushbarPosition.TOP,
          //              flushbarStyle: FlushbarStyle.GROUNDED,
          //   backgroundColor: Colors.green,
          //   title: "Success",
          //   message: 'Client updated successfully',
          //   duration: Duration(seconds: 3),
          // ).show(context);

          setState(() {
            getDiscourseLists();
            chatSendController.text = '';
          });
        }
      });
    };

    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            fullRequestData == null || fullRequestData.isEmpty
                ? '--'
                : '${fullRequestData['ticketDetails']['title']}',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // leading: IconButton(
          //   onPressed: (){
          //     MyRouter.popPage(context);
          //   },
          //   icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
          // ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      child: ListView.builder(
                          reverse: true,
                          itemCount: discussData == null || discussData.isEmpty
                              ? 0
                              : discussData.length,
                          itemBuilder: (context, int index) {
                            print(discussData);

                            final message = discussData[index];
                            //  bool isMe = message.sender.id == currentUser.id;
                            bool isMe = message['messageBy'] == "resolver";
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (!isMe)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                                topRight: Radius.circular(6),
                                                bottomLeft: Radius.circular(
                                                    isMe ? 6 : 0),
                                                bottomRight: Radius.circular(
                                                    isMe ? 0 : 6),
                                              ),
                                              color: Colors.white60),
                                          child: Text(
                                            'L',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    'Nunito SansRegular',
                                                fontSize: 25),
                                          ),
                                        ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6),
                                        decoration: BoxDecoration(
                                            color: isMe
                                                ? Colors.white60
                                                : Color(0xff077DBB),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                              bottomLeft:
                                                  Radius.circular(isMe ? 6 : 0),
                                              bottomRight:
                                                  Radius.circular(isMe ? 0 : 6),
                                            )),
                                        child: Text(
                                          '${message['message']}',
                                          style: MyTheme.bodyTextTime.copyWith(
                                              color: isMe
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment: isMe
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        if (!isMe)
                                          SizedBox(
                                            width: 40,
                                          ),
                                        Icon(
                                          Icons.done_all,
                                          size: 20,
                                          color: MyTheme.bodyTextTime.color,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          retsNx360dates(
                                              message['dateTimeCreated']),
                                          style: MyTheme.bodyTextTime,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          })),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.more_vert_outlined,
                              color: Colors.grey[500],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: chatSendController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type your message ...',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              },
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        replyTicket();
                      },
                      child: CircleAvatar(
                        backgroundColor: MyTheme.kAccentColor,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  retsNx360dates(String chatDate) {
    print('2022-03-11T10:03:18.7029365');

    // String newdate = selectedDate.toString().substring(0,10);
    // print(newdate);

    DateTime inputDate = DateTime.parse(chatDate);
    String formattedDate = DateFormat.yMMMMd().format(inputDate);

    print(formattedDate);

    String removeComma = formattedDate.replaceAll(",", "");
    print('removeComma');
    print(removeComma);

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o2.length == 1 ? '0' + '' + o2 : o2;

    print('newOO ${newOO}');

    String concatss = newOO + " " + o1 + " " + o3;

    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }

  // Widget ChatComposer() {
  //   return
  //     Container(
  //       padding: EdgeInsets.symmetric(horizontal: 20),
  //       color: Colors.white,
  //       height: 100,
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 14),
  //               height: 60,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[200],
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.emoji_emotions_outlined,
  //                     color: Colors.grey[500],
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Expanded(
  //                     child: TextField(
  //                       decoration: InputDecoration(
  //                         border: InputBorder.none,
  //                         hintText: 'Type your message ...',
  //                         hintStyle: TextStyle(color: Colors.grey[500]),
  //                       ),
  //                     ),
  //                   ),
  //                   Icon(
  //                     Icons.attach_file,
  //                     color: Colors.grey[500],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 16,
  //           ),
  //           InkWell(
  //             onTap: (){
  //              replyTicket();
  //             },
  //             child: CircleAvatar(
  //               backgroundColor: MyTheme.kAccentColor,
  //               child: Icon(
  //                 Icons.send,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  // }

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
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
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
      String filesizeAsString = mb.toString();
      fileSize = filesizeAsString;

      // end get file size
      //convert image to base64
      List<int> imageBytes = uploadimage.readAsBytesSync();
      baseimage = base64Encode(imageBytes);

      String getPath = choosedimage.toString();
      _fileName = getPath != null ? getPath.split('/').last : '...';
      // passport.text = _fileName;
    });
  }
}
