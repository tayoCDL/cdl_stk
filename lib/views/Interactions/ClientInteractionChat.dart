import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/app_theme.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addInteraction.dart';
import 'package:sales_toolkit/views/Interactions/interactionPreview.dart';
import 'package:sales_toolkit/views/clients/DocumentPreview.dart';
import 'package:sales_toolkit/widgets/client_status.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../util/enum/color_utils.dart';

class ClientInteractionChat extends StatefulWidget {
  final String ticketID;
  const ClientInteractionChat({Key key, @required this.ticketID})
      : super(key: key);

  @override
  _ClientInteractionChatState createState() =>
      _ClientInteractionChatState(ticketID: this.ticketID);
// final User user;
}

class _ClientInteractionChatState extends State<ClientInteractionChat> {
  @override
  var discussData = [];
  var fullRequestData = {};

  File uploadimage;
  final ImagePicker _picker = ImagePicker();

  String _fileName = '...';
  bool _isLoading = false;
  String fileSize = '';
  String baseimage = '';
  int replyStatus = 0;
  File chosenImage;
  String agent_name, agent_email = '';
  int agentId = 0;
  String selectedStatus = '';
  List<dynamic> loggerStatus = [];
  List<dynamic> resolverStatus = [];
  List<dynamic> showTicketStatus = List.empty(growable: true);
  AddInteractionProvider _addInteractionProvider = AddInteractionProvider();
  TextEditingController chatSendController = TextEditingController();
  String selectedFile = '';
  String dummyAvatar =
      "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a\r\nHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy\r\nMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCACWAJYDASIA\r\nAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA\r\nAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3\r\nODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm\r\np6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA\r\nAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx\r\nBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK\r\nU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3\r\nuLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD2Siii\r\ngAooooAKKWjFABRS4qvdX9pZDNxOiH+7nJ/Ic0AT0YrAn8WW6HEFvJJ7sQo/rVf/AIS5/wDnzX/v\r\n5/8AWoA6eisK28VWshC3ELw/7QO4f4/pW5FJHPEskTq6N0ZTkGgBcUlOxSUAJRRiigAooooAKKKK\r\nACiiigApaKUCgAApwFKBWfrtybTR53U4dhsU/X/62aAMLWfEMjyNbWT7I1OGlU8t9D2Fc6SWJJJJ\r\nPUmkooAKKKKACrllql3p+Rby7VY5KkAg1TooA7jQ9Z/tRXjlVUnTnC9GHqK1iK4PQJ/I1q2OTh22\r\nEDvngfriu/IoAixRTiKSgBtFLSUAFFFFABS0lKKAFAp4FIBT1FACgVg+MONJh/67j/0Fq6JRWJ4u\r\nhL6IHH/LOVWP6j+tAHB0UUUAFFFFABRRRQBd0hS2sWYAz++U/rXpBWuA8MqG8Q2gIzyx/wDHTXob\r\nLQBXIphFTMKjIoAjpKcRSUAJRRRQAtKKSnigByipFFNUVKooAcorJ8UzRw6BMr/elKog9TnP9DWy\r\nornPG6/8Sm3b0nA/8dP+FAHC0UUUAFFFFABRRRQBf0W8Sw1i2uZBlFYhvYEEZ/DOa9NIzXkdesWW\r\n46dbF/veUufrgUADComFWGFQsKAISKYakYUw0ANopaKAFFPWmCpFoAeoqZRUa1MtAD1FZXim0N1o\r\nE+0ZaLEoH06/pmtdaeKAPG6K6vxho9pYJb3FpAIhI7CQKTgnqMDoO/SuUoAKKKKACiiigCeztXvb\r\n2G2jBLSOF+nvXrW0KoUDAAwKy9B0W20yzikEQN06AySHk5PUD0FaxoAhYVCwqdqiagCBhUZqVqjN\r\nADKKKKAHCnrTBUi0ASrUy1CtTLQBItPFNFOFAHOeN42fQ42UEhJ1LewwR/MivPq9b1GWzh0+Vr8q\r\nLYja+4E5zx0HNeUXAiFzKIGZoQ58st1K54z+FAEdFFFABUkEElzcRwRLueRgqj3NR10XhS90zT7m\r\nae+k2S4CxEoWwO/Qden60AehKoVQo6AYpDTgQRkHIPQ000ARtULVM1RNQBC1RGpWqJqAGGig0UAK\r\nKkWoxUi0ATLUq1CtLLcw20fmTypGg/idsCgC0tPFcnfeNLaIFLGIzN2d/lX8up/Sucu/EmrXZIa7\r\neNSSQsXyAe2RyfxNAGr4z1YXNymnwtmOE5kI6F/T8Ofz9q5WjrRQAUUUUAFFFFAHofhLVhe6cLSR\r\nv9Itxjn+JOx/Dp+XrXQGvH4ppYJBJDI8bjoyNgj8a2rPxZqlqVEkouIwMbZRz+Y5z9c0AehNULVj\r\n2PizT7zCzE20h7Sfd/76/wAcVrFgyhlIIPIIPWgCNqjNSNURoAaaKKKAFFU7rWbGyyJZ1Lj+BPmP\r\n6dPxrmta1uW4ne3t3KQKSpKnl/8A61YdAHS3vi6ZwUsohEP778t+XQfrXP3FzPdSeZPK8j+rHNRU\r\nUAFFFFABRRRQAUUUUAFFFFABRRRQAVbs9SvLA5tp2Qd16qfwPFVKKAOstPFyPhbyAof78fI/I8/z\r\nrat761vFzbzpJ3wDyPqOtec0qsyMGRirDkEHBFAHpdFc9omu+cjQXrgOgysh/iHofeigDlnOZGPu\r\nabQTkk0UAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBNbttkJzjiiolbac0UAJRRRQA\r\nUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB/9k=";
  String passportFileName,
      passportFileSize,
      passportFiletype,
      passportFileLocation,
      newFileLocation;
  String appendBase64 = '';

  String _path = '...';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  List<dynamic> interactionStatus = [];
  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );

  int _crossAxisCount = 2;

  double _aspectRatio = 1.5;

  retRealFile(String img) {
    var Velo = img.split(',').first;
    int chopOut = Velo.length + 1;
    String realfile =
        img.substring(chopOut).replaceAll("\n", "").replaceAll("\r", "");
    return realfile;
  }

  // List<ImageData> itemList = getImageDataList();

  void initState() {
    // getStaffID();
    // getTicketStatus(ticketID);

    Future.microtask(() => {
          if (mounted) {getDiscourseLists()}
        });

    // getDiscourseLists();
    super.initState();
  }

  getStaffID() async {
    final Future<Map<String, dynamic>> respose =
        RetCodes().getReferalsAndStaffData();
    respose.then((response) {
      setState(() {
        agentId = response['data']['id'];
        agent_name = response['data']['displayName'];
        agent_email = response['data']['displayName'];
      });
    });
  }

  getTicketStatus(String ticketId) async {
    final Future<Map<String, dynamic>> respose =
        RetCodes().getTicketStatus(ticketId);
    respose.then((response) {
      print('>> response >> ${response['data']}');
      setState(() {
        //  resolverStatuses
        // loggerStatuses
        loggerStatus = response['data']['loggerStatuses'];
        resolverStatus = response['data']['resolverStatuses'];
      });
    });
  }

  List<dynamic> getTickStatus() {
    Timer(Duration(seconds: 10), () {
      print("Yeah, this line is printed after 4 seconds");
    });
    String createdBy = fullRequestData == null || fullRequestData.isEmpty
        ? ''
        : fullRequestData['ticketDetails']['createdBy'];

    createdBy == agent_name ? print('truthy') : print('falsy');

    if (createdBy == agent_name) {
      setState(() {
        showTicketStatus = loggerStatus;
      });
      print('yeah yeah');
    } else {
      setState(() {
        showTicketStatus = resolverStatus;
      });
      print('no no');
    }
    print(
        'showTicket Stat ${resolverStatus} ${loggerStatus}  ${createdBy} ${agent_name}');
    print('final ticketStatus ${showTicketStatus}');
    if (resolverStatus == null) {
      setState(() {
        showTicketStatus = loggerStatus;
      });
    }

    setState(() {
      interactionStatus = showTicketStatus;
    });
    print('interactionStatus >>:: ${interactionStatus}');
    return showTicketStatus;
  }

  String ticketID;
  _ClientInteractionChatState({this.ticketID});

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
    print('discussData ${discussData}');
    getStaffID();
    getTicketStatus(ticketID);
  }

  actionPopUpItemSelected(String value) {
    if (value == "closed") {
      setState(() {
        replyStatus = 4;
      });
    }
    if (value == "pending_feedback") {
      setState(() {
        replyStatus = 3;
      });
    }
    if (value == "resolved") {
      setState(() {
        replyStatus = 2;
      });
    }
    if (value == "feedback_provided") {
      setState(() {
        replyStatus = 5;
      });
    }
  }

  Widget build(BuildContext context) {
    changeStatusForTicket() {
      return alert(context,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Change Ticket Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Select a new status below ',
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
                    MyRouter.popPage(context);
                  },
                  child: Icon(Icons.clear))
            ],
          ),
          content: Text(''),
          textOK: SizedBox());
    }

    var replyTicket = () async {
      if (showTicketStatus[0]['description'].contains('Re-open') &&
          showTicketStatus.length == 1) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Error',
          message: 'Ticket already closed',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (replyStatus == 0) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Validation error',
          message: 'Please select Ticket status',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> interactionData = {
        "ticketId": ticketID,
        "messageBody": chatSendController.text,
        "unitId": 0,
        "fileSize": "",
        "createdBy": agent_name,
        "createdById": agentId.toString(),
        "requestStatus": replyStatus,
        "fileName": selectedFile,
        "attachment": newFileLocation,
      };

      print('interaction >> ${interactionData}');
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
                context, ClientInteractionChat(ticketID: ticketID));
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fullRequestData == null || fullRequestData.isEmpty
                    ? '--'
                    : '${fullRequestData['ticketDetails']['title']} ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              //Text(fullRequestData == null || fullRequestData.isEmpty ? '--' : '${fullRequestData['ticketDetails']['status']}',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              clientStatus(
                  colorChoser(fullRequestData == null || fullRequestData.isEmpty
                      ? '--'
                      : '${fullRequestData['ticketDetails']['status']}'),
                  fullRequestData == null || fullRequestData.isEmpty
                      ? '--'
                      : '${fullRequestData['ticketDetails']['status']}',
                  fontSize: 11)
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              MyRouter.popPage(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
          ),
        ),
        body: TabStatus(),
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

  stripHtmlIfNeed(var html) {
    String newParsed = Bidi.stripHtmlIfNeeded(html);
    return newParsed;
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
                // takePhoto(ImageSource.gallery);
                _openFileExplorer();
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  // void takePhoto(ImageSource source) async {
  //   // final pickedFile = await _picker.getImage(
  //   //   source: source,
  //   // );
  //   // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
  //   MyRouter.popPage(context);
  //   var choosedimage = await ImagePicker.pickImage(source: source);
  //   print(choosedimage);
  //
  //   setState(() {
  //     uploadimage = choosedimage;
  //
  //     final bytes = choosedimage.readAsBytesSync().lengthInBytes;
  //
  //     // get file size
  //     final kb = bytes / 1024;
  //     final mb = kb / 1024;
  //     print('this is the MB ${mb}');
  //     String filesizeAsString  = mb.toString();
  //     fileSize = filesizeAsString;
  //
  //     // end get file size
  //     //convert image to base64
  //     List<int> imageBytes = uploadimage.readAsBytesSync();
  //     baseimage = base64Encode(imageBytes);
  //
  //
  //
  //     String getPath  = choosedimage.toString();
  //     _fileName = getPath != null ? getPath.split('/').last.replaceAll("'", '') : '...';
  //      selectedFile = _fileName;
  //      print('real file Name ${selectedFile}');
  //   });
  // }

  void takePhoto(ImageSource source) async {
    MyRouter.popPage(context);
    var choosedimage = await ImagePicker.pickImage(source: source);
    //  print('this ${choosedimage.toString()}');
    File imagefile = choosedimage; //convert Path to File

    var result = await FlutterImageCompress.compressWithFile(
      imagefile.absolute.path,
      minWidth: 330,
      minHeight: 250,
      quality: 100,
      // rotate: 90,
    );

    print('this is file sixe');
    print(imagefile.lengthSync());
    print(result);
    //return result;

    // image compressor

    print('image File ${imagefile}');
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(result); //convert bytes to base64 string
    print('base64string ${base64string}');

    String _finalPath = choosedimage.toString();
    // final bytes = Io.File(_finalPath).readAsBytesSync();
    //   final byeInLength = Io.File(_finalPath).readAsBytesSync().lengthInBytes;
    // String img64 = base64Encode(bytes);

    // print(img64);

    setState(() {
      uploadimage = choosedimage;
      String getPath = choosedimage.toString();
      _fileName = getPath != null ? getPath.split('/').last : '...';
      // _openFileExplorer(getPath);

      File file = choosedimage;
      _fileName = file.path.split('/').last;
      print('filename ${_fileName}');
      selectedFile = _fileName;
    });

    // final kb = byeInLength / 1024;
    // final mb = kb / 1024;
    // print('this is the MB ${mb}');
    // String filesizeAsString  = mb.toString();
    // print('this is file sizelenght ${filesizeAsString}');
    //  print('image base64 ${img64}');

    setState(() {
      passportFileLocation = base64string;
      passportFileSize = '';
      passportFiletype = _fileName.split('.').last;
    });

    print('passport file location ${passportFiletype} ');

    setState(() {
      if (passportFiletype == 'png') {
        appendBase64 = 'data:image/png;base64,';
      } else if (passportFiletype == 'jpg') {
        appendBase64 = 'data:image/jpeg;base64,';
      } else if (passportFiletype == 'jpeg') {
        appendBase64 = 'data:image/jpeg;base64,';
      }
    });

    newFileLocation = appendBase64 + passportFileLocation;

    if (!mounted) return;

    setState(() {
      // _fileName = _path != null ? _path.split('/').last : '...';
      selectedFile = _fileName;
      passportFileName = _fileName;
    });
  }

  void _openFileExplorer() async {
    MyRouter.popPage(context);

    String result;
    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeTypes: ["image/png", "image/jpeg", "image/jpg"],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);

      final file = File(result);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        setState(() {
          //    passport.text = '';
          passportFileLocation = '';
          _path = '-';
          // isPassportAdded = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('File Size Exceeded'),
              content: Text('Please select a file with a maximum size of 2MB.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      // setState(() {
      //   _pickFileInProgress = false;
      // });
    }

    setState(() {
      _path = result;
    });

    try {
      //  var newPath  = await FilePicker.getFile(type: _pickingType,fileExtension: _extension);
      //  print('this is new Path ${newPath}');
      // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);

      // print('this is Path ${_path}');

      print('file extension ${_path.split('.').last}');

      String filePath = _path.split('.').last;

      var result;

      bool extensionChecker =
          filePath == 'png' || filePath == 'jpg' || filePath == 'jpeg'
              ? true
              : false;

      if (extensionChecker) {
        result = await FlutterImageCompress.compressWithFile(
          _path,
          minWidth: 330,
          minHeight: 250,
          quality: 90,
          //  rotate: 180,
        );
        //    print('this is file sixe');

      }

      final bytes = Io.File(_path).readAsBytesSync();
      final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
      String img64 = base64Encode(extensionChecker ? result : bytes);

      // get file size
      final kb = byeInLength / 1024;
      final mb = kb / 1024;
      print('this is the MB ${mb}');
      String filesizeAsString = mb.toString();
      print('this is file sizelenght ${filesizeAsString}');
      print('image base64 ${img64}');

      setState(() {
        passportFileLocation = img64;
        passportFileSize = filesizeAsString;
        passportFiletype = _path.split('.').last;
      });

      print('passport file location ${passportFiletype} ');

      setState(() {
        if (passportFiletype == 'png') {
          appendBase64 = 'data:image/png;base64,';
        } else if (passportFiletype == 'jpg') {
          appendBase64 = 'data:image/jpeg;base64,';
        } else if (passportFiletype == 'jpeg') {
          appendBase64 = 'data:image/jpeg;base64,';
        }
      });

      newFileLocation = appendBase64 + passportFileLocation;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
      selectedFile = _fileName;
      passportFileName = _fileName;
      //  isPassportAdded = true;
    });

    // }
  }

  Widget TabStatus() {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 1,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text(
                    'Discourse',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff177EB9),
                        fontFamily: 'Nunito SemiBold'),
                  ),
                ),
                Tab(
                  child: Text(
                    'Files',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff177EB9),
                        fontFamily: 'Nunito SemiBold'),
                  ),
                ),
              ],
              labelColor: Color(0xff177EB9),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: MaterialIndicator(
                  height: 2,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 0,
                  bottomRightRadius: 0,
                  tabPosition: TabPosition.bottom,
                  color: Colors.blue),
            ),
          ),
          body: TabBarView(
            children: [DiscourseScreen(), FileTabScreen()],
          ),
        ));
  }

  Widget DiscourseScreen() {
    var replyTicket = () async {
      if (showTicketStatus[0]['description'].contains('Re-open') &&
          showTicketStatus.length == 1) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Error',
          message: 'Ticket already closed',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (replyStatus == 0) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Validation error',
          message: 'Please select Ticket status',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> interactionData = {
        "ticketId": ticketID,
        "messageBody": chatSendController.text,
        "unitId": 0,
        "fileSize": "",
        "createdBy": agent_name,
        "createdById": agentId.toString(),
        "requestStatus": replyStatus,
        "fileName": selectedFile,
        "attachment": newFileLocation,
      };

      print('interaction >> ${interactionData}');
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
                context, ClientInteractionChat(ticketID: ticketID));
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

    return GestureDetector(
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
                                            bottomLeft:
                                                Radius.circular(isMe ? 6 : 0),
                                            bottomRight:
                                                Radius.circular(isMe ? 0 : 6),
                                          ),
                                          color: Colors.white60),
                                      child: Text(
                                        'L',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Nunito SansRegular',
                                            fontSize: 25),
                                      ),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
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
                                      '${stripHtmlIfNeed(message['message'])}',
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
                                    Column(
                                      children: [
                                        Text(
                                          retsNx360dates(
                                              message['dateTimeCreated']),
                                          style: MyTheme.bodyTextTime,
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${message['createdBy']}',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Action: ${message['action']}',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        )

                                        //    clientStatus(colorChoser('${message['action']}'), '${message['action']}',fontSize: 8,containerSIze: 30)
                                      ],
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
          ConstrainedBox(
              constraints: BoxConstraints(minHeight: 140),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    // height: 140,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: 350, minHeight: 50),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  // height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      // IconButton(onPressed: (){
                                      //   changeStatusForTicket();
                                      // }, icon: Icon(Icons.more_vert_outlined, color: Colors.grey[500])),
                                      //

                                      // PopupMenuButton(
                                      //   icon: Icon(Icons.more_vert,color: Colors.blue,),
                                      //   itemBuilder: (context) {
                                      //     return [
                                      //       PopupMenuItem(
                                      //         value: 'closed',
                                      //         child: Text('Closed',),
                                      //       ),
                                      //       PopupMenuItem(
                                      //         value: 'pending_feedback',
                                      //         child: Text('Pending Feedback'),
                                      //       ),
                                      //       PopupMenuItem(
                                      //         value: 'resolved',
                                      //         child: Text('Resolved'),
                                      //       ),
                                      //       PopupMenuItem(
                                      //         value: 'feedback_provided',
                                      //         child: Text('Feedback Provided'),
                                      //       ),
                                      //
                                      //     ];
                                      //   },
                                      //   onSelected: (String value) => actionPopUpItemSelected(value),
                                      // ),

                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 5,
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          controller: chatSendController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Type your message ...',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) =>
                                                bottomSheet()),
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
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            InkWell(
                              onTap: () {
                                replyTicket();
                                //      Future.delayed(Duration.zero,(){
                                //        //your code goes here
                                //        openTicketModal();
                                //      });

                                // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                //   openTicketModal();
                                // });
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
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 24,
                          child: ListView.builder(
                              itemCount: getTickStatus() == null
                                  ? 0
                                  : getTickStatus().length ?? 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (index, position) {
                                // if(position == 0){
                                //   clientStatus(colorChoser('open'), 'open');
                                // }
                                //  print('ticket Status ${getTickStatus()}');
                                return clientStatus(
                                    colorChoser(
                                        '${showTicketStatus[position]['description']}'),
                                    '${showTicketStatus[position]['description']}',
                                    fontSize: 11,
                                    containerSIze: 140, ontaPP: () {
                                  print(
                                      'this tapp ${showTicketStatus[position]['status']}');
                                  setState(() {
                                    selectedStatus = showTicketStatus[position]
                                        ['description'];
                                    replyStatus =
                                        showTicketStatus[position]['status'];
                                  });
                                });
                              }),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'you selected: ${selectedStatus}',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Selected file: ${selectedFile}',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  // openTicketModal(){
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
  //     ),
  //     context: context,
  //     builder: ((builder) => showBottomSheetForTicket()),
  //   );
  //
  // }

  // Widget showBottomSheetForTicket(){
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.267,
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 20,
  //       vertical: 20,
  //     ),
  //     child: Column(
  //       // mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         Align(
  //           alignment: Alignment.topLeft,
  //           child: Text(
  //             "Select an option to proceed",
  //             style: TextStyle(
  //                 fontSize: 22.0,
  //                 fontFamily: 'Nunito SansRegular',
  //                 fontWeight: FontWeight.w700,
  //                 color: ColorUtils.SELECT_OPTION
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //
  //       Container(
  //         height: MediaQuery.of(context).size.height * 0.2,
  //         child: ListView.builder(
  //             itemCount: interactionStatus.length 0= 0 ?? ( getTickStatus() == null || getTickStatus().length == 0) ? 0 :  getTickStatus().length,
  //             itemBuilder: (index,position){
  //               return
  //                 ListTile(
  //                 title: Text('${showTicketStatus[position]['description']}'),
  //                 leading: Radio(
  //                   value: showTicketStatus[position]['status'],
  //                   onChanged: (value) {
  //                     setState(() {
  //                      replyStatus  = value;
  //                     });
  //                   },
  //                 ),
  //               );
  //             }),
  //       )
  //
  //
  //       ],
  //     ),
  //   );
  // }

  Widget FileTabScreen() {
    return Scaffold(
        body: fullRequestData['images'] == null ||
                fullRequestData['images'].length != 0
            ? Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: FileAvailable())
            : Center(child: Text('No File')));
  }

  Widget FileAvailable() {
    return ListView.builder(
        itemCount: fullRequestData['images'] == null ||
                fullRequestData['images'].length == 0
            ? 0
            : fullRequestData['images'].length,
        itemBuilder: (index, position) {
          var singleFile = fullRequestData['images'][position];
          var singleImageFile = singleFile['attachment'];

          print('single Image ${singleImageFile}');

          final UriData data = Uri.parse(singleImageFile).data;

// You can check if data is normal base64 - should return true
          print('isBase64');
          print(data.isBase64);

// Will returns your image as Uint8List
          Uint8List myImage = data.contentAsBytes();

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Image.memory(
                  (myImage),
                  width: 100,
                  height: 100,
                ),
                title: Text(
                  '${singleFile['fileName']}',
                  style: TextStyle(fontSize: 12, fontFamily: 'Nunito SemiBold'),
                ),
                trailing: InkWell(
                    onTap: () {
                      MyRouter.pushPage(
                          context,
                          InteractionImagePreview(
                            passedDocument: myImage,
                            passedFileName: singleFile['fileName'],
                          ));
                    },
                    child: Icon(Icons.remove_red_eye)),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
              )
            ],
          );
        });
  }

  // void handleKeyPress(event) {
  //   if (event is RawKeyUpEvent && event.data is RawKeyEventDataWeb) {
  //     var data = event.data as RawKeyEventDataWeb;
  //     if (data.code == "Enter" && !event.isShiftPressed) {
  //       final val = chatSendController.value;
  //       final messageWithoutNewLine =
  //           chatSendController.text.substring(0, val.selection.start - 1) +
  //               chatSendController.text.substring(val.selection.start);
  //       chatSendController.value = TextEditingValue(
  //         text: messageWithoutNewLine,
  //         selection: TextSelection.fromPosition(
  //           TextPosition(offset: messageWithoutNewLine.length),
  //         ),
  //       );
  //     //  _onSend();
  //     }
  //   }
  // }

  final _focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          //  _sendMessage();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  GridTile getGridItem(var imageData) {
    return GridTile(
        child: Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageData['attachment'],
              )),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                imageData['fileName'],
                style: const TextStyle(fontSize: 20),
              ),
              // Text(
              //   imageData['dateAdded'],
              //   style: const TextStyle(fontSize: 15),
              // ),
            ],
          )
        ],
      ),
    )

        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Expanded(
        //         child: ClipRRect(
        //             borderRadius: BorderRadius.circular(10),
        //             child: Image.network(
        //               imageData.path,
        //             ))),
        //     Text(
        //       imageData.title,
        //       style: const TextStyle(fontSize: 15),
        //     ),
        //     const SizedBox(
        //       height: 5,
        //     )
        //   ],
        // ),
        );
  }
}
