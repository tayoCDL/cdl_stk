import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/entry_field.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';

import '../../palatte.dart';

class CreateNewOrder extends StatefulWidget {
  const CreateNewOrder({Key key}) : super(key: key);

  @override
  _CreateNewOrderState createState() => _CreateNewOrderState();
}

class _CreateNewOrderState extends State<CreateNewOrder> {
  TextEditingController store = TextEditingController();
  TextEditingController deviceAmount = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController downPayment = TextEditingController();

  @override
  List<String> categoryArray = [];
  List<String> collectCategory = [];
  List<dynamic> allCategory = [];

  List<String> DeviceFromcategoryArray = [];
  List<String> collectDeviceFromCategory = [];
  List<dynamic> allDeviceFrom = [];

  String deviceCategoryId = '';
  String deviceFromCategoryId = '';
  String device_Name = '';
  String phonePrice = '';

  bool _isLoading = false;
  // getAndReturnArray(apiData,allData,collectData,dataArray,iterableData,valueToIterate){
  //   setState(() {
  //     allData = apiData;
  //   });
  //   for(int i = 0; i < apiData['result'].length;i++){
  //     // print(arr1[i]['name']);
  //     collectData.add(iterableData[i][valueToIterate]);
  //   }
  //   setState(() {
  //     dataArray = collectData;
  //   });
  // }

  // getAllDevice() async{
  //   final Future<Map<String,dynamic>> respose =  RetCodes().getSentinelData(url: AppUrl.getDeviceCategory);
  //   respose.then((response) {
  //     Map<String,dynamic> newEmp = response['data'];
  //     var iterableData = newEmp['result'];
  //     var valueToIterate = 'categoryDescription';
  //     getAndReturnArray(newEmp, allDevices, collectDevice, devicesArray,iterableData,valueToIterate);
  //       print( 'all all data array ${allDevices} ${collectDevice} ${devicesArray}');
  //   }
  //   );
  // }

  getDeviceCategory() async {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().getSentinelData(url: AppUrl.getDeviceCategory);
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      List<dynamic> newEmp = response['data']['result'];
      setState(() {
        allCategory = newEmp;
        DeviceFromcategoryArray = [];
        collectDeviceFromCategory = [];
      });
      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['value']);
        collectCategory.add(newEmp[i]['categoryDescription']);
      }
      setState(() {
        categoryArray = collectCategory;
      });
    });
  }

  getDeviceFromCategory(String categoryId) async {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().getSentinelData(url: AppUrl.getDevice + categoryId);

    respose.then((response) {
      print('device response ${response}');
      setState(() {
        _isLoading = false;
      });
      List<dynamic> newEmp = response['data']['result']['deviceDetails'];
      setState(() {
        allDeviceFrom = newEmp;
        DeviceFromcategoryArray = [];
        collectDeviceFromCategory = [];
      });
      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['value']);
        collectDeviceFromCategory.add(newEmp[i]['deviceName']);
      }
      setState(() {
        DeviceFromcategoryArray = collectDeviceFromCategory;
      });
    });
  }

  int random(min, max) {
    return min + Random.secure().nextInt(max - min);
  }

  void initState() {
    // TODO: implement initState
    store.text = 'Sentinel';
    getDeviceCategory();
    // getDeviceFromCategory();
    super.initState();
  }

  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;

    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff077DBB),
            ),
            onPressed: () {
              MyRouter.popPage(context);
            },
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: mediaSize.width * 0.05,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Create new order',
                        textAlign: TextAlign.start,
                        style: kHeading_black,
                      ),
                      Text('')
                    ],
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Product Details below',
                        textAlign: TextAlign.start,
                        style: kHeading2_black,
                      ),
                      Text('')
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  EntryField(
                    editController: store,
                    labelText: 'Store Name',
                    hintText: 'Store Name',
                    suffixWidget: SizedBox(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropDownComponent(
                      items: categoryArray,
                      onChange: (String item) async {
                        setState(() {
                          List<dynamic> selectID = allCategory
                              .where((element) =>
                                  element['categoryDescription'] == item)
                              .toList();
                          print('this is select ID');
                          print(selectID[0]['categoryId']);
                          deviceCategoryId = selectID[0]['categoryId'];
                          getDeviceFromCategory(deviceCategoryId);
                          //  frequencyInt = selectID[0]['id'];
                          print('end this is select ID');
                        });
                      },
                      label: "Device Category *",
                      selectedItem: '',
                      validator: (String item) {
                        // if(item.length == 0){
                        //   return "Loan product is mandatory";
                        // }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownComponent(
                      items: DeviceFromcategoryArray,
                      onChange: (String item) async {
                        setState(() {
                          List<dynamic> selectID = allDeviceFrom
                              .where((element) => element['deviceName'] == item)
                              .toList();
                          print('select ID is ${selectID}');

                          deviceAmount.text = selectID[0]['devicePrice'];
                          device_Name = selectID[0]['deviceName'];
                        });
                      },
                      label: "Get Device *",
                      selectedItem: '',
                      validator: (String item) {
                        // if(item.length == 0){
                        //   return "Loan product is mandatory";
                        // }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  EntryField(
                    editController: deviceAmount,
                    labelText: 'Device Amount',
                    hintText: 'Device Amount',
                    keyBoard: TextInputType.number,
                    suffixWidget: SizedBox(),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  EntryField(
                    editController: downPayment,
                    labelText: 'Down Payment',
                    hintText: 'Down Payment',
                    suffixWidget: SizedBox(),
                    keyBoard: TextInputType.number,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  EntryField(
                    editController: fullName,
                    labelText: 'Full Name',
                    hintText: 'Full Name',
                    suffixWidget: SizedBox(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Downpayment should not be less than N32,000',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
                      SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Available Loan Terms',textAlign: TextAlign.start,style: kHeading3_black,),
                  //     Text('')
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Select an option below to proceed',textAlign: TextAlign.start,style: TextStyle(color: Colors.grey)),
                  //     Text('')
                  //   ],
                  // ),
                  // SizedBox(height: 40,),
                  // Container(
                  //   padding: EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //       color: Color(0xffE3F0F7),
                  //       borderRadius: BorderRadius.all(Radius.circular(5))
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text('1 Tenor',textAlign: TextAlign.start,style: kHeading3_black,),
                  //       Text('N 28,151.69 /month',textAlign: TextAlign.start,style: kHeading3_black,),
                  //     ],
                  //   ),
                  // )

                  RoundedButton(
                      buttonText: 'Place Order',
                      onbuttonPressed: () {
                        _launchURL(context);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    var TransactionReference = random(1111111, 9999999);
    var MerchantId = 292535;
    var ProductId = 34;
    var CustomerName = fullName.text;
    var deviceName = device_Name;
    var deviceModel = device_Name;
    var AssetAmount = deviceAmount.text;
    var CustomerEquity = downPayment.text;
    var redirectUrl =
        'RedirectUrl=https%3A%2F%2Fdevfinapi.sentinelock.com%2Fv1%2Fdev%2Fpost%2Fcdl%2F';

    String totalUrl =
        'https://paystaging.creditdirect.ng/?TransactionReference=${TransactionReference}&MerchantId=${MerchantId}&ProductId=${ProductId}&CustomerName=${CustomerName}s&DeviceName=${deviceName}&DeviceModel=${deviceModel}&AssetAmount=${AssetAmount}&${redirectUrl}&CustomerEquity=${CustomerEquity}&CdlFinance=&submit=';

    // String testUrl  = 'https://pay.creditdirect.ng/?TransactionReference=4373031&MerchantId=1427779&ProductId=53&CustomerName=Habisb+Lanss&DeviceName=Tecno+Camon+18i+4GB%2F128GB&DeviceModel=Tecno+Camon+18i+4GB%2F128GB&AssetAmount=104684&RedirectUrl=https%3A%2F%2Fdevfinapi.sentinelock.com%2Fv1%2Fdev%2Fpost%2Fcdl%2F&CustomerEquity=31405.2&CdlFinance=&submit=';

    String cleanTotalUrl = totalUrl.replaceAll(" ", "+");

    print('total Link ${cleanTotalUrl}');
    try {
      await launch(
        cleanTotalUrl,
        option: CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
            animation: CustomTabsAnimation.slideIn()
            // or user defined animation.
            //   animation: const CustomTabsAnimation(
            //   startEnter: 'slide_up',
            //   startExit: 'android:anim/fade_out',
            //   endEnter: 'android:anim/fade_in',
            //   endExit: 'slide_down',
            // ),
            // extraCustomTabs: const <String>[
            //   // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            //   'org.mozilla.firefox',
            //   // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            //   'com.microsoft.emmx',
            // ],
            ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
