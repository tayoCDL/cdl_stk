import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/domain/user.dart';

import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/shared_preference.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotSent,
  Sent,
  Sending,
}

class AddClientProvider extends ChangeNotifier {
  Status _addStatus = Status.NotSent;

  Status get addStatus => _addStatus;

  set otpStatus(Status value) {
    _addStatus = value;
  }

  List<String> bGiz= [];

  notify(){
    notifyListeners();
  }

  static Future<FutureOr> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);

    // print(responseData);

    if(response.statusCode == 200){

      var userData = responseData['data'];

      // now we will create a user model
      User authUser = User.fromJson(responseData);

      // now we will create shared preferences and save data
      UserPreferences().saveUser(authUser);

      result = {
        'status':true,
        'message':'Successfully registered',
        'data':authUser
      };

    }else{
      result = {
        'status':false,
        'message':'Successfully registered',
        'data':responseData
      };
    }
    return result;
  }



  Future<Map<String, dynamic>> addPersonal(var personalData,String clientStatus) async {
    var result;

    _addStatus = Status.NotSent;
    notifyListeners();


    print(personalData);
    print('personalData');
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    int getClientID = prefs.getInt('tempClientInt');
    int PregetClientID = prefs.getInt('clientId');


    String getBVN = prefs.getString('inputBvn');
    int emptType = prefs.getInt('employment_type');
    int getEmploymentsector = prefs.getInt('emp_category');


    print('controller tempCLient ID ${PregetClientID} ${getClientID} ${personalData['id']}  ${getBVN} ${emptType} ${getEmploymentsector}');


  // print(prefs);
   int leadToClient =  prefs.getInt('leadToClientID');
    if(leadToClient != null){
      prefs.setInt('clientId', leadToClient);
    }

   //   print('new client ID ${prefs.getInt('clientId')} ${prefs.getInt('emp_category')} ');

    //   January 24, 1991

    final Map<String, dynamic> clientData = {
      "clients": {
      "doYouWantToUpdateCustomerInfo": false,
      "firstname": personalData['firstname'],
      "lastname": personalData['lastname'],
      "middlename": personalData['middlename'],
        "activationChannelId": 77,
        "mobileNo" : personalData['phoneNumber'],
        "alternateMobileNo": personalData['alt_phoneNumber'],
      "emailAddress": personalData['emailAddress'],
        "officeId": 1,
      "genderId": personalData['gender'],
      "locale": "en",
      "dateOfBirth": personalData['dateController'],
      "dateFormat": "dd MMMM yyyy",
        "staffId":prefs.getInt('staffId'),
      "titleId": personalData['title'],
     //  "bvn": prefs.getString('inputBvn'),
        "bvn": personalData['bvn'],
        // "nin": personalData['nin'],
        'employmentSectorId': personalData['employmentSectorId'],
        "clientTypeId": personalData['clientTypeId'],
        "savingsProductId":1,
        // "clientTypeId": prefs.getInt('emp_category'),

      //  "bvn":"1111222111",
      //  'employmentSectorId': prefs.getInt('employment_type'),

      "numberOfDependent": personalData['no_of_dependents'],
      "educationLevelId": personalData['educationLevel'],
      "maritalStatusId": personalData['marital_status'],
      "isComplete": false,
    }
    };

    final Map<String, dynamic> clientData2 = {
      "clients": {
         "id": personalData['id'] == null ? prefs.getInt('clientId') : personalData['id'],
        "doYouWantToUpdateCustomerInfo": true,
        "firstname": personalData['firstname'],
        "lastname": personalData['lastname'],
        "middlename": personalData['middlename'], // prefs.getInt('clientId') == null ? "activationChannelId": 57: '',
      //  prefs.getInt('clientId') != null ? null : "activationChannelId": 57,
        "mobileNo" : personalData['phoneNumber'],
        "emailAddress": personalData['emailAddress'],
        "alternateMobileNo": personalData['alt_phoneNumber'],
      //  "officeId": 1,
        // prefs.getInt('clientId') == null ? "officeId": 1 : '',
        "genderId": personalData['gender'],
        "locale": "en",
        //"dateOfBirth": "14 December 2011",
        "dateOfBirth": personalData['dateController'],
        "dateFormat": "dd MMMM yyyy",
        // "clientClassificationId": 54,
        "titleId": personalData['title'],
        "bvn": personalData['bvn'],
        // "nin": personalData['nin'],
        'employmentSectorId': personalData['employmentSectorId'],
        "clientTypeId": personalData['clientTypeId'],
        // "referralModeId": 15,
        // "bvn": prefs.getString('inputBvn'),
       // "staffId":  prefs.getInt('staffId'),
       //  'employmentSectorId': prefs.getInt('employment_type'),
       //  "clientTypeId": prefs.getInt('emp_category'),
        // "referralIdentity": "biola",
        "numberOfDependent": personalData['no_of_dependents'],
        "educationLevelId": personalData['educationLevel'],
        "maritalStatusId": personalData['marital_status'],
        "isComplete": false
      }


    };

    print('passed data ${prefs.getInt('clientId')  ==  null && personalData['id']  == null ? clientData : clientData2}');
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    var clientId = prefs.getInt('clientId');
    print(clientId);
    print(token);
    var vClientID = personalData['id'] == null ? prefs.getInt('clientId') : personalData['id'];
    String url = clientStatus == "Active" ? AppUrl.getResidentialClient + vClientID.toString() + '/kyc' :  AppUrl.addClient;
    print('dd<< ${url}');
    try{
      Response responsevv;

      // if(clientStatus == "Active"){
      //   responsevv = await put(
      //     url,
      //     body: json.encode(prefs.getInt('clientId')  ==  null && personalData['id']  == null ? clientData : clientData2),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      //       'Authorization': 'Basic ${token}',
      //       'Fineract-Platform-TFA-Token': '${tfaToken}',
      //     },
      //   );
      // }
      // else {
        responsevv = await post(
          AppUrl.addClient,
          body: json.encode(prefs.getInt('clientId')  ==  null && personalData['id']  == null ? clientData : clientData2),
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}',
            'Fineract-Platform-TFA-Token': '${tfaToken}',
          },
        );
      // }


   //   print('error>>>> ${responsevv.body}');

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

      }

      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);

        print(responseData2);

        prefs.setInt('clientId', responseData2['clientId']);
        _addStatus = Status.Sent;
        notifyListeners();


        result = {'status': true, 'message': 'Successful','data':responseData2};


      }
      else {

        _addStatus = Status.Sent;
        notifyListeners();
        _addStatus = Status.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
        };
      }

    }
    catch(e){
      print('responsevv. status code ${e.toString()}');
      prefs.setString('prefsPersonalData', jsonEncode(clientData));

      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
       return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }
      prefs.remove('leadToClientID');
    return result;

  }


  Future<Map<String, dynamic>> addEmployment(var employmentData,String clientStatus) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();

    print(employmentData);
    print('personalData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

      // print('get test employer ${prefs.getInt('employerResourceId')}');
      var newTees =   prefs.getInt('clientId');
    print('this is neeTees ${newTees}');

    final Map<String, dynamic> clientData = {
        "clients": {
          "id": prefs.getInt('clientId') == null ? employmentData['clientId'] : prefs.getInt('clientId'),
          "doYouWantToUpdateCustomerInfo" : true,
          "isComplete": false
        },
        "clientEmployers": [
          {
           //'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
           "id": employmentData['id'],
            "locale": "en",
            "dateFormat": "dd MMMM yyyy",
            "employmentDate" : employmentData['employmentDate'],
            "emailAddress": employmentData['work_email'],
            "mobileNo" : employmentData['employer_phone_number'],
            "employerId" : employmentData['organization'],
            "staffId": employmentData['staffId'],
            "countryId": 29,
             "nextMonthSalaryPaymentDate":employmentData['salary_payday'],
            "stateId": employmentData['state_ofposting'],
            "lgaId": employmentData['lga'],
            "officeAddress": employmentData['address'],
            "nearestLandMark": employmentData['nearest_landmark'],
            "jobGrade":  employmentData['job_role'],
            "employmentStatusId": 50,
            "salaryRangeId": employmentData['salary_range'],
            "active": true,
            "workEmailVerified": employmentData['workEmailVerified']
          }
        ]
    };

    final Map<String, dynamic> clientDataWithPayRollDOB = {
      "clients": {
        "id": prefs.getInt('clientId') == null ? employmentData['clientId'] : prefs.getInt('clientId'),
        "doYouWantToUpdateCustomerInfo" : true,
        "isComplete": false
      },
      "clientEmployers": [
        {
          //'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
          "id": employmentData['id'],
          "locale": "en",
          "dateFormat": "dd MMMM yyyy",
          "employmentDate" : employmentData['employmentDate'],
          "emailAddress": employmentData['work_email'],
          "mobileNo" : employmentData['employer_phone_number'],
          "employerId" : employmentData['organization'],
          "staffId": employmentData['staffId'],
          "countryId": 29,
          "nextMonthSalaryPaymentDate":employmentData['salary_payday'],
          "stateId": employmentData['state_ofposting'],
          "lgaId": employmentData['lga'],
          "officeAddress": employmentData['address'],
          "nearestLandMark": employmentData['nearest_landmark'],
          "payrollDob": employmentData['payrollDob'],
          "jobGrade":  employmentData['job_role'],
          "employmentStatusId": 50,
          "salaryRangeId": employmentData['salary_range'],
          "active": true,
          "workEmailVerified": employmentData['workEmailVerified']
        }
      ]
    };


    final Map<String, dynamic> newclientData = {
      "clients": {
        "id": prefs.getInt('clientId') == null ? employmentData['clientId'] : prefs.getInt('clientId'),
        "doYouWantToUpdateCustomerInfo" : true,
        "isComplete": false
      },
      "clientEmployers": [
        {
          //'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
         // "id": employmentData['id'],
          "locale": "en",
          "dateFormat": "dd MMMM yyyy",
          "employmentDate" : employmentData['employmentDate'],
          "emailAddress": employmentData['work_email'],
          "mobileNo" : employmentData['employer_phone_number'],
          "employerId" : employmentData['organization'],
          "staffId": employmentData['staffId'],
          "countryId": 29,
          "nextMonthSalaryPaymentDate":employmentData['salary_payday'],
          "stateId": employmentData['state_ofposting'],
          "lgaId": employmentData['lga'],
          "officeAddress": employmentData['address'],
          "nearestLandMark": employmentData['nearest_landmark'],
          "jobGrade":  employmentData['job_role'],
          "employmentStatusId": 50,
          "salaryRangeId": employmentData['salary_range'],
          "active": true,
          "workEmailVerified": employmentData['workEmailVerified']
        }
      ]
    };

    final Map<String, dynamic> newclientDataWithPayRollDOB = {
      "clients": {
        "id": prefs.getInt('clientId') == null ? employmentData['clientId'] : prefs.getInt('clientId'),
        "doYouWantToUpdateCustomerInfo" : true,
        "isComplete": false
      },
      "clientEmployers": [
        {
          //'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
         // "id": employmentData['id'],
          "locale": "en",
          "dateFormat": "dd MMMM yyyy",
          "employmentDate" : employmentData['employmentDate'],
          "emailAddress": employmentData['work_email'],
          "mobileNo" : employmentData['employer_phone_number'],
          "employerId" : employmentData['organization'],
          "staffId": employmentData['staffId'],
          "countryId": 29,
          "nextMonthSalaryPaymentDate":employmentData['salary_payday'],
          "stateId": employmentData['state_ofposting'],
          "lgaId": employmentData['lga'],
          "officeAddress": employmentData['address'],
          "nearestLandMark": employmentData['nearest_landmark'],
          "payrollDob": employmentData['payrollDob'],
          "jobGrade":  employmentData['job_role'],
          "employmentStatusId": 50,
          "salaryRangeId": employmentData['salary_range'],
          "active": true,
          "workEmailVerified": employmentData['workEmailVerified']
        }
      ]
    };



    print('clientData employer');
    print(clientData);

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    var vClientID = employmentData['clientId'] == null ? prefs.getInt('clientId') : employmentData['clientId'];


    String url = clientStatus == "Active" ? AppUrl.getResidentialClient + vClientID.toString() + '/kyc' :  AppUrl.addClient;
      print('employer URL >>> ${url} client Status ${clientStatus}');
    prefs.setString('prefsEmploymentData', jsonEncode(clientData));

    // if employment payroldob is null and the employment ID is null, pick newCLient
    // if employment payroldob is not null and the employment id is null



     var decodeEMployer =    employmentData['payrollDob'] == null  && employmentData['id'] == null ? newclientData :
        employmentData['payrollDob'] != null && employmentData['id'] == null ? newclientDataWithPayRollDOB:
        employmentData['payrollDob'] != null && employmentData['id'] != null ?  clientDataWithPayRollDOB : clientData;


      print('decode Employer Data ${employmentData['payrollDob']} ${employmentData['id']}');
      print('decode Employer ${decodeEMployer}');

  try{
    print(token);
    Response responsevv;

    // if(clientStatus == "Active"){
    //   responsevv = await put(
    //     url,
    //     body: json.encode(clientData),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
    //       'Authorization': 'Basic ${token}',
    //       'Fineract-Platform-TFA-Token': '${tfaToken}',
    //     },
    //   );
    // }
    // else {

    responsevv = await post(
        AppUrl.addClient,
       // body: json.encode( employmentData['payrollDob'] == null || employmentData['payrollDob'].isEmpty ? clientData : clientDataWithPayRollDOB),
        body: json.encode(decodeEMployer),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );
    // }



  //  print( ' status code  ${responsevv.body}');
    if(responsevv.statusCode == 200 ){
      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      _addStatus = Status.Sent;
      notifyListeners();

      result = {'status': true, 'message': 'Successful','data':responseData2};
      prefs.setInt('employerResourceId', responseData2['resourceId']);
      print('employerID ${prefs.getInt('employerResourceId')}');

    }
    else {
      _addStatus = Status.Sent;
      notifyListeners();
      _addStatus = Status.NotSent;
      notifyListeners();

      result = {
        'status': false,
        'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
      };
    }

  }
  catch(e){



    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String vlas =   prefs.getString('prefsPersonalData');
      print('vlas ${vlas}');
          Map<String,dynamic> prefPersonals = jsonDecode(vlas);

          print('prefsPersonal ${prefPersonals}');

      Map<String,dynamic> empsPrefs = {
        "clients": {
          "id": prefs.getInt('clientId'),
          "firstname": prefPersonals['clients']['firstname'],
          "lastname": prefPersonals['clients']['lastname'],
          "middlename": prefPersonals['clients']['middlename'],
          "activationChannelId": 57,
          "mobileNo" : prefPersonals['clients']['mobileNo'],
          "emailAddress": prefPersonals['clients']['emailAddress'],
          "officeId": 1,
          "genderId": prefPersonals['clients']['genderId'],
          "locale": "en",
          "dateOfBirth": prefPersonals['clients']['dateOfBirth'],
          "dateFormat": "dd MMMM yyyy",
          "staffId":prefs.getInt('staffId'),
          "titleId": prefPersonals['clients']['titleId'],
          "bvn": prefs.getString('inputBvn'),
          'employmentSectorId':  prefPersonals['clients']['employmentSectorId'],
          "numberOfDependent": prefPersonals['clients']['numberOfDependent'],
          "educationLevelId": prefPersonals['clients']['educationLevelId'],
          "maritalStatusId": prefPersonals['clients']['maritalStatusId'],
          "doYouWantToUpdateCustomerInfo" : true,
          "isComplete": false
        },
        "clientEmployers": [
          {
            'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
            "locale": "en",
            "dateFormat": "dd MMMM yyyy",
            "employmentDate" : employmentData['employmentDate'],
            "emailAddress": employmentData['work_email'],
            "mobileNo" : employmentData['employer_phone_number'],
            "employerId" : employmentData['organization'],
            "staffId": employmentData['staffId'],
            "countryId": 29,
            "stateId": employmentData['state_ofposting'],
            "lgaId": employmentData['lga'],
            "officeAddress": employmentData['address'],
            "nearestLandMark": employmentData['nearest_landmark'],
            "jobGrade":  employmentData['job_role'],
            "employmentStatusId": 50,
            "salaryRangeId": employmentData['salary_range'],
            "active": true
          }
        ]
      };

        prefs.setString('prefsEmployment', jsonEncode(empsPrefs));
        String lils =   prefs.getString('prefsEmployment');
        //  String prefsDee = jsonDecode(lils);
          print('prefsDee ${lils}');

      return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

    }

  }



    return result;

  }



  Future<Map<String, dynamic>> addResidential(var residentialData,String clientStatus) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();
      print('residential Data');
    print(residentialData);

    //January 27, 2022
    print('personalData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> clientData = {
      "clients": {
        "id": prefs.getInt('clientId') == null ? residentialData['clientId'] : prefs.getInt('clientId'),
        "doYouWantToUpdateCustomerInfo" : true,
        "isComplete": false
      },
      "addresses" : [
        {
          "addressId": residentialData['id'],
        "dateMovedIn" : residentialData['dateMovedIn'],
        "locale": "en",
        "dateFormat": "dd MMMM yyyy",
        "addressTypeId" : residentialData['address_type_id'],
         "residentStatusId": residentialData['residential_status'],
        "addressLine1" : residentialData['permanent_address'],
        "nearestLandMark" : residentialData['nearest_landmark'],
        "city" : residentialData['residential_state'],
        "lgaId" : residentialData['lga'],
        //  "ResidentStatusId": residentialData[''],
        "stateProvinceId" : residentialData['residential_state'],
        "countryId" : 29
      }]
    };


    print('residential Details ${clientData}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');


    prefs.setString('prefsResidentData', jsonEncode(clientData));
    var vClientID = residentialData['clientId'] == null ? prefs.getInt('clientId') : residentialData['clientId'];


    String url = clientStatus == "Active" ? AppUrl.getResidentialClient + vClientID.toString() + '/kyc' :  AppUrl.addClient;

    print('new Url ${url}');

    try{
      print(token);
      Response responsevv;

      // if(clientStatus == "Active"){
      //   responsevv = await put(
      //     url,
      //     body: json.encode(clientData),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      //       'Authorization': 'Basic ${token}',
      //       'Fineract-Platform-TFA-Token': '${tfaToken}',
      //     },
      //   );
      // }
      // else {
        responsevv = await post(
          AppUrl.addClient,
          body: json.encode(clientData),
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}',
            'Fineract-Platform-TFA-Token': '${tfaToken}',
          },
        );
      // }



      print(responsevv.body);
      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        print(responseData2);
        _addStatus = Status.Sent;
        notifyListeners();

        result = {'status': true, 'message': 'Successful','data':responseData2};

        prefs.setInt('residenceResourceId', responseData2['resourceId']);

        print('residence ${prefs.getInt('residenceResourceId')}');

      }
      else {

        _addStatus = Status.Sent;
        notifyListeners();
        _addStatus = Status.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
        };
      }


    }catch(e){

      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String vlas =   prefs.getString('prefsEmployment');
        print('vlas ${vlas}');
        Map<String,dynamic> prefPersonals = jsonDecode(vlas);

        print('prefsPersonal ${prefPersonals}');

        Map<String,dynamic> resPrefs = {
          "clients": {
            "id": prefs.getInt('clientId'),
            "firstname": prefPersonals['clients']['firstname'],
            "lastname": prefPersonals['clients']['lastname'],
            "middlename": prefPersonals['clients']['middlename'],
            "activationChannelId": 57,
            "mobileNo" : prefPersonals['clients']['mobileNo'],
            "emailAddress": prefPersonals['clients']['emailAddress'],
            "officeId": 1,
            "genderId": prefPersonals['clients']['genderId'],
            "locale": "en",
            "dateOfBirth": prefPersonals['clients']['dateOfBirth'],
            "dateFormat": "dd MMMM yyyy",
            "staffId":prefs.getInt('staffId'),
            "titleId": prefPersonals['clients']['titleId'],
            "bvn": prefs.getString('inputBvn'),
            'employmentSectorId':  prefPersonals['clients']['employmentSectorId'],
            "numberOfDependent": prefPersonals['clients']['numberOfDependent'],
            "educationLevelId": prefPersonals['clients']['educationLevelId'],
            "maritalStatusId": prefPersonals['clients']['maritalStatusId'],
            "doYouWantToUpdateCustomerInfo" : true,
            "isComplete": false
          },
          "clientEmployers": [
            {
              'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "employmentDate" : prefPersonals['clientEmployers'][0]['employmentDate'],
              "emailAddress": prefPersonals['clientEmployers'][0]['emailAddress'],
              "mobileNo" : prefPersonals['clientEmployers'][0]['mobileNo'],
              "employerId" : prefPersonals['clientEmployers'][0]['employerId'],
              "employerId": prefPersonals['clientEmployers'][0]['staffId'],
              "countryId": 29,
              "stateId": prefPersonals['clientEmployers'][0]['stateId'],
              "lgaId": prefPersonals['clientEmployers'][0]['lgaId'],
              "officeAddress": prefPersonals['clientEmployers'][0]['officeAddress'],
              "nearestLandMark": prefPersonals['clientEmployers'][0]['nearestLandMark'],
              "jobGrade":  prefPersonals['clientEmployers'][0]['jobGrade'],
              "employmentStatusId": 50,
              "salaryRangeId": prefPersonals['clientEmployers'][0]['salaryRangeId'],
              "active": true
            }
          ],
          "addresses" : [
            {
              "addressId":prefs.getInt('residenceResourceId') == null ? null : prefs.getInt('residenceResourceId'),
              // "addressId": 423,
              "dateMovedIn" : residentialData['dateMovedIn'],
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "addressTypeId" : 36,
              "addressLine1" : residentialData['permanent_address'],
              "addressLine2" : residentialData['nearest_landmark'],
              "city" : residentialData['residential_state'],
              "lgaId" : residentialData['lga'],
              "stateProvinceId" : residentialData['residential_state'],
              "countryId" : 29
            }]
        };

        prefs.setString('prefsResidentials', jsonEncode(resPrefs));
        String lils =   prefs.getString('prefsResidentials');
        //  String prefsDee = jsonDecode(lils);

        print('prefsDee ${lils}');

        return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

      }

    }

    //2


    return result;

  }


  Future<Map<String, dynamic>> addNextOfKin(var nextofKinData,String clientStatus) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();

    print(nextofKinData);
    print('personalData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> clientData = {
      "clients": {
        "id": nextofKinData['clientId']  == null ? prefs.getInt('clientId') : nextofKinData['clientId'],
        "doYouWantToUpdateCustomerInfo" : false,
        "isComplete": false
      },
      "familyMembers": [
        {
          "id":prefs.getInt('tempNextOfKinInt') == null ? null : prefs.getInt('tempNextOfKinInt'),
          "firstName": nextofKinData['firstname'],
          "middleName": nextofKinData['middlename'],
          "lastName": nextofKinData['lastname'],
          "qualification": nextofKinData['lastname'],
          "relationshipId": nextofKinData['relationship_with_nok'],
          "maritalStatusId": nextofKinData['maritalStatus'],
          "genderId": nextofKinData['gender'],
          "professionId": nextofKinData['profession'],
          "mobileNumber": nextofKinData['phonenumber'],
          "age": nextofKinData['age'],
          "titleId": nextofKinData['title'],
          "isDependent": true
        }
      ]
    };

    print('clientID ${clientData}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');


   // prefs.setString('prefsNextofKinData', jsonEncode(clientData));

    var vClientID = nextofKinData['clientId'] == null ? prefs.getInt('clientId') : nextofKinData['clientId'];
    String url = clientStatus == "Active" ? AppUrl.getResidentialClient + vClientID.toString() + '/kyc' :  AppUrl.addClient;
    print('dd<< ${url}');


    print(token);

    try{
      Response responsevv;

      // if(clientStatus == "Active"){
      //   responsevv = await put(
      //     url,
      //     body: json.encode(clientData),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      //       'Authorization': 'Basic ${token}',
      //       'Fineract-Platform-TFA-Token': '${tfaToken}',
      //     },
      //   );
      //
      // }
      // else {
        responsevv = await post(
            AppUrl.addClient,
          body: json.encode(clientData),
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}',
            'Fineract-Platform-TFA-Token': '${tfaToken}',
          },
        );
      // }


      print(responsevv.body);
      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        print(responseData2);
        _addStatus = Status.Sent;
        notifyListeners();

        result = {'status': true, 'message': 'Successful','data':responseData2};


        prefs.setInt('nextOfKinId', responseData2['resourceId']);
        print('nextOfKin ${prefs.getInt('nextOfKinId')}');

      }
      else {

        _addStatus = Status.Sent;
        notifyListeners();
        _addStatus = Status.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['defaultUserMessage']
        };
      }

    }
    catch(e){
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String vlas =   prefs.getString('prefsResidentials');
        print('vlas ${vlas}');
        Map<String,dynamic> prefPersonals = jsonDecode(vlas);

        print('prefsPersonal address ${prefPersonals['addresses']}');

        Map<String,dynamic> nextOfKinsPrefs = {
          "clients": {
            "id": prefs.getInt('clientId'),
            "firstname": prefPersonals['clients']['firstname'],
            "lastname": prefPersonals['clients']['lastname'],
            "middlename": prefPersonals['clients']['middlename'],
            "activationChannelId": 57,
            "mobileNo" : prefPersonals['clients']['mobileNo'],
            "emailAddress": prefPersonals['clients']['emailAddress'],
            "officeId": 1,
            "genderId": prefPersonals['clients']['genderId'],
            "locale": "en",
            "dateOfBirth": prefPersonals['clients']['dateOfBirth'],
            "dateFormat": "dd MMMM yyyy",
            "staffId":prefs.getInt('staffId'),
            "titleId": prefPersonals['clients']['titleId'],
            "bvn": prefs.getString('inputBvn'),
            'employmentSectorId':  prefPersonals['clients']['employmentSectorId'],
            "numberOfDependent": prefPersonals['clients']['numberOfDependent'],
            "educationLevelId": prefPersonals['clients']['educationLevelId'],
            "maritalStatusId": prefPersonals['clients']['maritalStatusId'],
            "doYouWantToUpdateCustomerInfo" : true,
            "isComplete": false
          },
          "clientEmployers": [
            {
              'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "employmentDate" : prefPersonals['clientEmployers'][0]['employmentDate'],
              "emailAddress": prefPersonals['clientEmployers'][0]['emailAddress'],
              "mobileNo" : prefPersonals['clientEmployers'][0]['mobileNo'],
              "employerId" : prefPersonals['clientEmployers'][0]['employerId'],
              "staffId": prefPersonals['clientEmployers'][0]['staffId'],
              "countryId": 29,
              "stateId": prefPersonals['clientEmployers'][0]['stateId'],
              "lgaId": prefPersonals['clientEmployers'][0]['lgaId'],
              "officeAddress": prefPersonals['clientEmployers'][0]['officeAddress'],
              "nearestLandMark": prefPersonals['clientEmployers'][0]['nearestLandMark'],
              "jobGrade":  prefPersonals['clientEmployers'][0]['jobGrade'],
              "employmentStatusId": 50,
              "salaryRangeId": prefPersonals['clientEmployers'][0]['salaryRangeId'],
              "active": true
            }
          ],
          "addresses" : [
            {
              "addressId":prefs.getInt('residenceResourceId') == null ? null : prefs.getInt('residenceResourceId'),
              // "addressId": 423,
              "dateMovedIn" : prefPersonals['addresses'][0]['dateMovedIn'],
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "addressTypeId" : 36,
              "addressLine1" : prefPersonals['addresses'][0]['addressLine1'],
              "addressLine2" : prefPersonals['addresses'][0]['addressLine2'],
              "city" : prefPersonals['addresses'][0]['city'],
              "lgaId" : prefPersonals['addresses'][0]['lgaId'],
              "stateProvinceId" : prefPersonals['addresses'][0]['stateProvinceId'],
              "countryId" : 29
            }],
          "familyMembers": [
            {
              "id":prefs.getInt('nextOfKinId') == null ? null : prefs.getInt('nextOfKinId'),
              "firstName": nextofKinData['firstname'],
              "middleName": nextofKinData['middlename'],
              "lastName": nextofKinData['lastname'],
              "qualification": nextofKinData['lastname'],
              "relationshipId": nextofKinData['relationship_with_nok'],
              "maritalStatusId": nextofKinData['maritalStatus'],
              "genderId": nextofKinData['gender'],
              "professionId": nextofKinData['profession'],
              "mobileNumber": nextofKinData['phonenumber'],
              "age": nextofKinData['age'],
              "isDependent": true
            }
          ]
        };

        prefs.setString('prefsNextOfKin', jsonEncode(nextOfKinsPrefs));
        String lils =   prefs.getString('prefsNextOfKin');
        //  String prefsDee = jsonDecode(lils);

        print('prefsDee ${lils}');

        return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

      }
    }



    //2


    return result;

  }


  Future<Map<String, dynamic>> addBankDetails(var bankData,String clientStatus) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();

    print(bankData);
    print('personalData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> clientData = {
      "clients": {
        "id": prefs.getInt('clientId') == null ? bankData['clientId'] : prefs.getInt('clientId'),
        "doYouWantToUpdateCustomerInfo" : true,
        "isComplete": false
      },
      "clientBanks" : [
        {
          'id': bankData['id'],
          "bankId" : bankData['bankId'],
          "accountnumber" : bankData['account_number'],
          "accountname" : bankData['accountName'],
          "bankAccountTypeId": bankData['bankAccountTypeId'],
          "active": true
        }
      ]
    };


    print('client Bank ${clientData}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');


    prefs.setString('prefsbankDetailsData', jsonEncode(clientData));

    var vClientID = bankData['clientId'] == null ? prefs.getInt('clientId') : bankData['clientId'];
    String url = clientStatus == "Active" ? AppUrl.getResidentialClient + vClientID.toString() + '/kyc' :  AppUrl.addClient;
    print('dd<< ${url}');


    print(token);

    try{
      Response responsevv;

      // if(clientStatus == "Active"){
      //
      //   responsevv = await put(
      //     url,
      //     body: json.encode(clientData),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      //       'Authorization': 'Basic ${token}',
      //       'Fineract-Platform-TFA-Token': '${tfaToken}',
      //     },
      //   );
      //
      // }
      // else {
        responsevv = await post(
          AppUrl.addClient,
          body: json.encode(clientData),
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}',
            'Fineract-Platform-TFA-Token': '${tfaToken}',
          },
        );
      // }



      print(responsevv.body);
      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        print(responseData2);
        _addStatus = Status.Sent;
        notifyListeners();

        result = {'status': true, 'message': 'Successful','data':responseData2};


      }
      else {

        _addStatus = Status.Sent;
        notifyListeners();
        _addStatus = Status.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['defaultUserMessage']
        };
      }
    }
    catch(e){
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String vlas =   prefs.getString('prefsNextOfKin');
        print('vlas ${vlas}');
        Map<String,dynamic> prefPersonals = jsonDecode(vlas);

        print('prefsPersonal family ${prefPersonals['familyMembers']}');

        Map<String,dynamic> BankAccountPrefs = {
          "clients": {
            "id": prefs.getInt('clientId'),
            "firstname": prefPersonals['clients']['firstname'],
            "lastname": prefPersonals['clients']['lastname'],
            "middlename": prefPersonals['clients']['middlename'],
            "activationChannelId": 57,
            "mobileNo" : prefPersonals['clients']['mobileNo'],
            "emailAddress": prefPersonals['clients']['emailAddress'],
            "officeId": 1,
            "genderId": prefPersonals['clients']['genderId'],
            "locale": "en",
            "dateOfBirth": prefPersonals['clients']['dateOfBirth'],
            "dateFormat": "dd MMMM yyyy",
            "staffId":prefs.getInt('staffId'),
            "titleId": prefPersonals['clients']['titleId'],
            "bvn": prefs.getString('inputBvn'),
            'employmentSectorId':  prefPersonals['clients']['employmentSectorId'],
            "numberOfDependent": prefPersonals['clients']['numberOfDependent'],
            "educationLevelId": prefPersonals['clients']['educationLevelId'],
            "maritalStatusId": prefPersonals['clients']['maritalStatusId'],
            "doYouWantToUpdateCustomerInfo" : true,
            "isComplete": false
          },
          "clientEmployers": [
            {
              'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "employmentDate" : prefPersonals['clientEmployers'][0]['employmentDate'],
              "emailAddress": prefPersonals['clientEmployers'][0]['emailAddress'],
              "mobileNo" : prefPersonals['clientEmployers'][0]['mobileNo'],
              "employerId" : prefPersonals['clientEmployers'][0]['employerId'],
              "staffId": prefPersonals['clientEmployers'][0]['staffId'],
              "countryId": 29,
              "stateId": prefPersonals['clientEmployers'][0]['stateId'],
              "lgaId": prefPersonals['clientEmployers'][0]['lgaId'],
              "officeAddress": prefPersonals['clientEmployers'][0]['officeAddress'],
              "nearestLandMark": prefPersonals['clientEmployers'][0]['nearestLandMark'],
              "jobGrade":  prefPersonals['clientEmployers'][0]['jobGrade'],
              "employmentStatusId": 50,
              "salaryRangeId": prefPersonals['clientEmployers'][0]['salaryRangeId'],
              "active": true
            }
          ],
          "addresses" : [
            {
              "addressId":prefs.getInt('residenceResourceId') == null ? null : prefs.getInt('residenceResourceId'),
              // "addressId": 423,
              "dateMovedIn" : prefPersonals['addresses'][0]['dateMovedIn'],
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "addressTypeId" : 36,
              "addressLine1" : prefPersonals['addresses'][0]['addressLine1'],
              "addressLine2" : prefPersonals['addresses'][0]['addressLine2'],
              "city" : prefPersonals['addresses'][0]['city'],
              "lgaId" : prefPersonals['addresses'][0]['lgaId'],
              "stateProvinceId" : prefPersonals['addresses'][0]['stateProvinceId'],
              "countryId" : 29
            }],
          "familyMembers": [
            {
              "id":prefs.getInt('nextOfKinId') == null ? null : prefs.getInt('nextOfKinId'),
              "firstName": prefPersonals['familyMembers'][0]['firstName'],
              "middleName": prefPersonals['familyMembers'][0]['middleName'],
              "lastName": prefPersonals['familyMembers'][0]['lastName'],
              "qualification": prefPersonals['familyMembers'][0]['qualification'],
              "relationshipId": prefPersonals['familyMembers'][0]['relationshipId'],
              "maritalStatusId": prefPersonals['familyMembers'][0]['maritalStatusId'],
              "genderId": prefPersonals['familyMembers'][0]['genderId'],
              "professionId": prefPersonals['familyMembers'][0]['professionId'],
              "mobileNumber": prefPersonals['familyMembers'][0]['mobileNumber'],
              "age": prefPersonals['familyMembers'][0]['age'],
              "isDependent": true
            }
          ],
          "clientBanks" : [
            {
              "bankId" : bankData['bankId'],
              "accountnumber" : bankData['account_number'],
              "accountname" : bankData['accountName'],
              "active": true
            }
          ]
        };

        prefs.setString('prefsBankAccountPrefs', jsonEncode(BankAccountPrefs));
        String lils =   prefs.getString('prefsBankAccountPrefs');
        //  String prefsDee = jsonDecode(lils);

        print('prefsDee plus bank ${lils}');

        return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

      }

    }


    //2


    return result;

  }


  Future<Map<String, dynamic>>  addDocumentUpload(String clientStatus,
      {var docData,
      String passportLocation,
      String passportFileType,
      int ClientInt}) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();

    print('docData ${docData}');
    print('passport Location');

    print('passport file type ${passportFileType}');

  //  print('avatar' + passportLocation);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> clientData = {
      "clients": {
        "id": prefs.getInt('clientId') == null ? ClientInt : prefs.getInt('clientId'),
      //  "id": 524,
        "doYouWantToUpdateCustomerInfo" : true,
        "isComplete": false
      },
      "avatar": passportLocation,
       "clientIdentifiers" : docData
    };

   //
   //  final Map<String, dynamic> passportData = {
   //    "clients": {
   //      "id": prefs.getInt('clientId'),
   //      //  "id": 524,
   //
   //    },
   //  //  "avatar" : "data:image/png;base64,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"
   // // "avatar":'data:image/${passportFileType};base64,' + passportLocation
   // "avatar": passportLocation
   //  };


    print('document Upload ${clientData}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');


  //  prefs.setString('prefsDocumentUploadData', jsonEncode(clientData));

    var vClientID =  prefs.getInt('clientId') == null ? ClientInt : prefs.getInt('clientId');
    String url = clientStatus == "Active" ? AppUrl.getResidentialClient + vClientID.toString() + '/kyc' :  AppUrl.addClient;
    print('dd<< ${url}');

    print(token);

    try{
      Response responsevv;
      // if(clientStatus == "Active"){
      //   responsevv = await put(
      //     url,
      //     body: json.encode(clientData),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      //       'Authorization': 'Basic ${token}',
      //       'Fineract-Platform-TFA-Token': '${tfaToken}',
      //     },
      //   );
      // }
      // else {
        responsevv = await post(
          AppUrl.addClient,
          body: json.encode(clientData),
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}',
            'Fineract-Platform-TFA-Token': '${tfaToken}',
          },
        );
      // }


        print('this is exception');
      print(responsevv.body);
      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        print(responseData2);
        _addStatus = Status.Sent;
        notifyListeners();

        result = {'status': true, 'message': 'Successful','data':responseData2};


      } else {

        _addStatus = Status.Sent;
        notifyListeners();
        _addStatus = Status.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
        };
      }
    }catch(e){
        print('this is error ${e}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String vlas =   prefs.getString('prefsBankAccountPrefs');
        print('vlas ${vlas}');
        Map<String,dynamic> prefPersonals = jsonDecode(vlas);

        print('prefsPersonal family ${prefPersonals['familyMembers']}');

        Map<String,dynamic> DocuUploadPrefs = {
          "clients": {
            "id": prefs.getInt('clientId'),
            "firstname": prefPersonals['clients']['firstname'],
            "lastname": prefPersonals['clients']['lastname'],
            "middlename": prefPersonals['clients']['middlename'],
            "activationChannelId": 57,
            "mobileNo" : prefPersonals['clients']['mobileNo'],
            "emailAddress": prefPersonals['clients']['emailAddress'],
            "officeId": 1,
            "genderId": prefPersonals['clients']['genderId'],
            "locale": "en",
            "dateOfBirth": prefPersonals['clients']['dateOfBirth'],
            "dateFormat": "dd MMMM yyyy",
            "staffId":prefs.getInt('staffId'),
            "titleId": prefPersonals['clients']['titleId'],
            "bvn": prefs.getString('inputBvn'),
            'employmentSectorId':  prefPersonals['clients']['employmentSectorId'],
            "numberOfDependent": prefPersonals['clients']['numberOfDependent'],
            "educationLevelId": prefPersonals['clients']['educationLevelId'],
            "maritalStatusId": prefPersonals['clients']['maritalStatusId'],
            "doYouWantToUpdateCustomerInfo" : true,
            "isComplete": false
          },
          "clientEmployers": [
            {
              'id':prefs.getInt('employerResourceId') == null ? null : prefs.getInt('employerResourceId'),
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "employmentDate" : prefPersonals['clientEmployers'][0]['employmentDate'],
              "emailAddress": prefPersonals['clientEmployers'][0]['emailAddress'],
              "mobileNo" : prefPersonals['clientEmployers'][0]['mobileNo'],
              "employerId" : prefPersonals['clientEmployers'][0]['employerId'],
              "staffId": prefPersonals['clientEmployers'][0]['staffId'],
              "countryId": 29,
              "stateId": prefPersonals['clientEmployers'][0]['stateId'],
              "lgaId": prefPersonals['clientEmployers'][0]['lgaId'],
              "officeAddress": prefPersonals['clientEmployers'][0]['officeAddress'],
              "nearestLandMark": prefPersonals['clientEmployers'][0]['nearestLandMark'],
              "jobGrade":  prefPersonals['clientEmployers'][0]['jobGrade'],
              "employmentStatusId": 50,
              "salaryRangeId": prefPersonals['clientEmployers'][0]['salaryRangeId'],
              "active": true
            }
          ],
          "addresses" : [
            {
              "addressId":prefs.getInt('residenceResourceId') == null ? null : prefs.getInt('residenceResourceId'),
              // "addressId": 423,
              "dateMovedIn" : prefPersonals['addresses'][0]['dateMovedIn'],
              "locale": "en",
              "dateFormat": "dd MMMM yyyy",
              "addressTypeId" : 36,
              "addressLine1" : prefPersonals['addresses'][0]['addressLine1'],
              "addressLine2" : prefPersonals['addresses'][0]['addressLine2'],
              "city" : prefPersonals['addresses'][0]['city'],
              "lgaId" : prefPersonals['addresses'][0]['lgaId'],
              "stateProvinceId" : prefPersonals['addresses'][0]['stateProvinceId'],
              "countryId" : 29
            }],
          "familyMembers": [
            {
              "id":prefs.getInt('nextOfKinId') == null ? null : prefs.getInt('nextOfKinId'),
              "firstName": prefPersonals['familyMembers'][0]['firstName'],
              "middleName": prefPersonals['familyMembers'][0]['middleName'],
              "lastName": prefPersonals['familyMembers'][0]['lastName'],
              "qualification": prefPersonals['familyMembers'][0]['qualification'],
              "relationshipId": prefPersonals['familyMembers'][0]['relationshipId'],
              "maritalStatusId": prefPersonals['familyMembers'][0]['maritalStatusId'],
              "genderId": prefPersonals['familyMembers'][0]['genderId'],
              "professionId": prefPersonals['familyMembers'][0]['professionId'],
              "mobileNumber": prefPersonals['familyMembers'][0]['mobileNumber'],
              "age": prefPersonals['familyMembers'][0]['age'],
              "isDependent": true
            }
          ],
          "clientBanks" : [
            {
              "bankId" : prefPersonals['familyMembers'][0]['bankId'],
              "accountnumber" : prefPersonals['familyMembers'][0]['accountnumber'],
              "accountname" : prefPersonals['familyMembers'][0]['accountname'],
              "active": true
            }
          ],
          "clientIdentifiers" : docData
        };

        prefs.setString('prefsDocUploadsPrefs', jsonEncode(DocuUploadPrefs));
        String lils =   prefs.getString('prefsDocUploadsPrefs');
        // Map<String,dynamic> vLils= jsonDecode(lils);
        //
        // var mVilils = vLils['clientIdentifiers'];
        //
        // //  String prefsDee = jsonDecode(lils);
        //
        // print('prefsDee plus doc Upload ${mVilils}');




         List<String> listDraft =   prefs.getStringList('ListDraftClient');

          if(listDraft ==  null){
            listDraft = [];
            listDraft.add(lils);
          }else {
            listDraft.add(lils);
          }



        var minGis =   prefs.setStringList('ListDraftClient', listDraft);
          prefs.remove('prefsDocUploadsPrefs');
        print('getLists ${minGis}');
        return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

      }


    }



    //2


    return result;

  }


  Future<Map<String, dynamic>> finalClientValidation(var docData) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();

    print(docData);

    //  print('avatar' + passportLocation);
    final SharedPreferences prefs = await SharedPreferences.getInstance();



    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');


    // prefs.setString('prefsDocumentUploadData', jsonEncode(clientData));
    //

    print(token);
    Response responsevv = await post(
      AppUrl.addClient,
      body: json.encode(docData),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print(responsevv.body);
    if(responsevv.statusCode == 200 ){
      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      _addStatus = Status.Sent;
      notifyListeners();

      result = {'status': true, 'message': 'Successful','data':responseData2};


    } else {
          print('json Code ${responsevv.body}');
      _addStatus = Status.Sent;
      notifyListeners();
      _addStatus = Status.NotSent;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
      };
    }

    //2


    return result;

  }



  static onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }



}

