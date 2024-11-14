import '../../view_models/CodesAndLogic.dart';

getGlobalStaffID() async{
  final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData();
  respose.then(
          (response) {

        print('this is referal ${response['data']}');
          Map<String,dynamic> staffData = {
              "referalCount": response['referralCount'],
              "supervisor": response['data']['organisationalRoleParentStaff']['displayName'] == null ? 'N/A': response['data']['organisationalRoleParentStaff']['displayName'],
            "agentCode" : response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'],
            };

          return staffData;

      }
  );

}
