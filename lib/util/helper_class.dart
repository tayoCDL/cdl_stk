import 'dart:convert';
import 'dart:io';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHelper{

  Future<void> processPdfDocument(Map<String, dynamic> singleDoc) async {
    String pdf = singleDoc['location'];
    String fileName = singleDoc['name'];


    var pdfData = pdf.split(',').first;
    bool pdfExtfound = fileName.split('.').last != null && fileName.split('.').last == 'pdf' ? true : false;
  //  print('file Name ${fileName} ${pdfExtfound}');
    int chopOut = pdfData.length + 1;
    var bytes = base64Decode(pdf.substring(chopOut).replaceAll("\n", "").replaceAll("\r", ""));

    final outputDirectory = await getTemporaryDirectory();
    final filePath = pdfExtfound == true ? "${outputDirectory.path}/${fileName}" : "${outputDirectory.path}/${fileName}.pdf";

    final file = File(filePath);
    await file.writeAsBytes(bytes.buffer.asUint8List());

    print(filePath);

    await OpenFile.open(filePath);

    // setState(() {}
    // ); // Assuming `setState` is accessible or parameterized appropriately
  }


  String formatDateTime(String input) {
    print("input is $input");
    List<String> dateComponents = input.split(',');
    int iyear = int.parse(dateComponents[0]);
    int imonth = int.parse(dateComponents[1]);
    int iday = int.parse(dateComponents[2]);
    DateTime dateTime = DateTime(iyear, imonth, iday);

    final String formattedDate = DateFormat.yMMMMd().format(dateTime);
    final String removeComma = formattedDate.replaceAll(",", "");
    final List<String> wordList = removeComma.split(" ");
    final String month = wordList[0];
    final String day = wordList[1];
    final String year = wordList[2];
    final String paddedDay = day.length == 1 ? '0$day' : day;
    final String formattedResult = '$paddedDay $month $year';
    print("xxxx ${formattedResult}");
    return formattedResult;
  }


  dynamic checkAndMapClientData(
      Map<String, dynamic> data,{String passedMobileNumber,String firstName,String lastName,String emailAddress}) {
    print('>> ${passedMobileNumber}');
    print('>> ${firstName}');

    final Map<String, String> checks = {
      'familyMembers': 'Family members data is missing or empty.',
      'clientEmployers': 'Client employers data is missing or empty.',
      'clients.bvn': 'BVN data is missing or empty.',
    //  'clientEmployers[0].staffId': 'Staff ID data is missing or empty.',
      'clientBanks': 'Client banks data is missing or empty.',
      'clients.emailAddress': 'Email address data is missing or empty.',
      'clients.mobileNo': 'Phone number data is missing or empty.'
    };

    // Function to get nested values
    dynamic getNestedValue(Map<String, dynamic> map, String keyPath) {
      final keys = keyPath.split('.');
      dynamic value = map;
      for (var key in keys) {
        if (value is Map<String, dynamic> && value.containsKey(key)) {
          value = value[key];
        } else {
          return null;
        }
      }
      return value;
    }

    // Iterate over the checks map
    for (var entry in checks.entries) {
      var value = getNestedValue(data, entry.key);
      if (value == null || (value is List && value.isEmpty) || (value is String && value.isEmpty)) {
        return entry.value;
      }
    }

    // Map the required data if all checks pass
    final Map<String, dynamic> result = {
      "ippis_number": data['clientEmployers'] == null ? '' : data['clientEmployers'][0]['staffId'],
      "bvn": data['clients']['bvn'],
      "account_number": data['clientBanks'] == null ? '' : data['clientBanks'][0]['accountnumber'],
      "first_name":  data['clients']['firstname'] == null ? '' : data['clients']['firstname']  ?? '',
      "last_name":  data['clients']['lastname'] == null ? '' : data['clients']['lastname']  ?? '',
      "phone_number": passedMobileNumber == null ? data['clients']['mobileNo'] : passedMobileNumber,
      "email":  data['clients']['emailAddress'] == null ? '' : data['clients']['emailAddress']  ?? '',
      "bank": data['clientBanks'][0]['bank']['name'],
      "next_of_kin": {
        "name": data['familyMembers'] == null ? '' : data['familyMembers'][0]['firstName'] + ' ' + data['familyMembers'][0]['lastName'],
        "phone": data['familyMembers'] == null ? '' : data['familyMembers'][0]['mobileNumber'],
        "address": "N/A" // Assuming address is not provided in the example
      },
      "referee": [
        {
          "name": data['familyMembers'] == null ? '' : data['familyMembers'][0]['firstName'] + ' ' + data['familyMembers'][0]['lastName'],
          "phone": data['familyMembers'] == null ? '' : data['familyMembers'][0]['mobileNumber'],
          "address": "N/A" // Assuming address is not provided in the example
        }
      ]
    };

    print('helper result ${result}');

    return result;
  }

  String formatCurrency(String numberString) {
    // Convert the string to a double
    double number = double.parse(numberString);

    // Format as currency
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '');
    return currencyFormatter.format(number);
  }

  double pageHeight(context) => MediaQuery.of(context).size.height;

  double pageWidth(context) => MediaQuery.of(context).size.width;


  void launchURL() async {

    String totalUrl = 'https://passwordreset.microsoftonline.com/';

    try {
      await launch(
        totalUrl,
        option: CustomTabsOption(
           // toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
            animation: CustomTabsAnimation.slideIn()

        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }


  static Future<String> getToken(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

}