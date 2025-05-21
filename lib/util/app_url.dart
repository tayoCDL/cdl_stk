import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {
  static const String attendanceBaseUrl = 'http://192.168.88.64:9182/api/v1/';

// static const String  baseUrl = 'https://nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/';
// static const String  LoanbaseUrl = 'nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/';
// static const String  paymentLinkUrl = 'https://nx360dev.creditdirect.ng/_/credit-direct-pay/';
// //static const String  productInfoUrl = 'https://40.113.169.208:9001/api/v1/';
// static const String  productInfoUrl = 'https://3.252.162.214:9001/api/v1/';
// static const String  sequestbaseUrl = 'https://testsequestapi.creditdirect.ng/api/';
// static const String  referralLinkUrl = 'https://api360.creditdirect.ng:8443/';
// static const String  validationBaseUrl = 'https://devwrapper.creditdirect.ng/api/v1/';
// static const String  NxWrapperBaseUrl = 'https://devwrapper.creditdirect.ng/api/';
//
// static const String  APP_CLOAK_URL = 'https://3.252.162.214:9010/';
// static const String  BASE_APP_ENC = 'https://3.252.162.214:9010/fineract-provider/api/v1/';
// static const String  NEW_BASE_APP_ENC = 'https://3.252.162.214:9010/api/v1/';
// static const String  USSD_BASE_URL = 'https://ussdstaging.creditdirect.ng/api/v1/';

  // 'https://ussdstaging.creditdirect.ng/api/v1/Ussd/getoffers?clientId=2178642
  // stkapi360
  // stkapi360

  // https://stkapi360.creditdirect.ng
  // 3.252.162.214

  static const String baseUrl =
      'https://stkapi360.creditdirect.ng:8443/fineract-provider/api/v1/';
  static const String repaymentBaseUrl =
      'https://stkapi360.creditdirect.ng:8443/';
  static const String LoanbaseUrl =
      'https://api360.creditdirect.ng:8443/fineract-provider/api/v1/';
  static const String paymentLinkUrl =
      'https://app-staging.creditdirect.ng/_/credit-direct-pay/';
  static const String referralLinkUrl = 'https://app-staging.creditdirect.ng/';
  static const String sequestbaseUrl = 'https://sequest.creditdirect.ng/api/';
  static const String validationBaseUrl =
      'https://nxwrapper.creditdirect.ng/api/v1/';
  static const String NxWrapperBaseUrl =
      'https://nxwrapper.creditdirect.ng/api/';
  static const String productInfoUrl =
      'https://api360.creditdirect.ng:9002/api/v1/';
  static const String APP_CLOAK_URL = 'https://ndwrapper.creditdirect.ng:9010/';
  static const String BASE_APP_ENC =
      'https://ndwrapper.creditdirect.ng:9010/fineract-provider/api/v1/';
  static const String NEW_BASE_APP_ENC =
      'https://ndwrapper.creditdirect.ng:9010/api/v1/';
  static const String USSD_BASE_URL =
      'https://ussdservices.creditdirect.ng/api/v1/';

  // static final Uri loginLdap = Uri.parse('${baseUrl}authentication/ldap');

  // static const Uri login_ldap = baseUrl + 'authentication/ldap';
  static final String loginLdap = '${baseUrl}authentication/ldap';
  static final String loginCloak = '${APP_CLOAK_URL}authenticate';
  static final String encLogin = '${BASE_APP_ENC}authenticate-user';
  static final String encTwoFactor =
      '${BASE_APP_ENC}sales-tool-kit/delivery/twofactor?deliveryMethod=email&extendedToken=false';
  static final String encValdateTwoFactor =
      '${BASE_APP_ENC}sales-tool-kit/twofactor/validate?token=';
  static final Uri encClientsLists = Uri.parse(
      '${BASE_APP_ENC}sales-tool-kit/users/nx360?offset=0&limit=20&searchBy');

  static final String login = '${baseUrl}authentication';
  static final String twofactor =
     '${baseUrl}twofactor?deliveryMethod=';
  static final String validateTwofactor =
     '${baseUrl}twofactor/validate?token=';
  static final Uri forgotPassword = Uri.parse('\${baseUrl}/forgot_password');
  static final Uri clientsList = Uri.parse('\${baseUrl}clients');
  static final String clients_List = '${baseUrl}clients';
  static final String clientAccount = '${baseUrl}clients/accounts/';

// http://40.113.169.208:9000/_/credit-direct-pay/177277t
  static final Uri getStaffCredential = Uri.parse('\${baseUrl}staff/');
  static final Uri clientSearch =
      Uri.parse('\${baseUrl}search?exactMatch=false');
  static final Uri leadsList = Uri.parse('\${baseUrl}leads');
  static final String addClient = '${baseUrl}clients/cdl';
  static final Uri addLead = Uri.parse('\${baseUrl}leads');
  static final Uri loanMetrics = Uri.parse('\${baseUrl}loans/metrics');
  static final Uri newSendLafOtp = Uri.parse('\${baseUrl}laf/send-otp/');
  static final Uri getApprovals =
      Uri.parse('\${baseUrl}loan-action/approvals/');
  static final Uri sendForReApprove =
      Uri.parse('\${baseUrl}loan-action/approve/');
  static final Uri lafDocument = Uri.parse('\${baseUrl}laf/document/');
  // laf/send-otp/{loanId}?channelId={channelId}
  static final Uri newVerifyOtp = Uri.parse('\${baseUrl}laf/validate-otp/');
  // /laf/validate-otp/{loanId}/{otp}?channelId={channelId}
  static final Uri checkDsr = Uri.parse('\${baseUrl}loans/cdl/dsr');
  static final Uri loanSchedule =
      Uri.parse('\${baseUrl}loans?command=calculateLoanSchedule');
  static final Uri loanRepaymentCalculator =
      Uri.parse('\${baseUrl}external/loan/calculator');
  static final Uri newLoanRepaymentCalculator =
      Uri.parse('\${baseUrl}loans/calculator');
  static final Uri createLoan = Uri.parse('\${baseUrl}loans/cdl');
  static final String getLoanDetails = '${baseUrl}loans/';
  static final Uri newSendLoanForApproval =
      Uri.parse('\${baseUrl}loan-action/sales-approve/');
  static final Uri getLendersLists =
      Uri.parse('\${baseUrl}lender?status=active');
  static final Uri getProductInformation =
      Uri.parse('\${productInfoUrl}product/information');
  static final Uri getProductCycle =
      Uri.parse('\${productInfoUrl}sales-cycle?page=0&size=12&sort=id,desc');
  static final Uri getProductMetrics =
      Uri.parse('\${productInfoUrl}sales-cycle/agent?loanOfficerId=');

  static final Uri externalApprove = Uri.parse('${baseUrl}external/loan/');
  static final Uri getLoanPaymentLinkMethod =
      Uri.parse('${baseUrl}loans/credit-direct/');
  static final Uri calclulateRepayment =
      Uri.parse('${baseUrl}loans?command=calculateLoanSchedule');
  static final String bulkBase64 = '${baseUrl}';
  static final Uri getCode = Uri.parse('${baseUrl}codes');
  static final Uri getBanks = Uri.parse('${baseUrl}banks');
  static final String getCodeValue = '${baseUrl}codes/';
  static final Uri productSummary = Uri.parse('${baseUrl}summary/products');

  static final Uri documentConfig =
      Uri.parse('${baseUrl}cdl/configuration/1/codes');
  static final Uri singleLoanDocumentConfig =
      Uri.parse('${baseUrl}cdl/configuration/');

  static final Uri getSubCodeValue = Uri.parse('${baseUrl}codes/');
  static final Uri loanGet = Uri.parse('${baseUrl}loans?');

  static final String getSingleClient = '${baseUrl}clients/';
  static final Uri loanLists =
      Uri.parse('${baseUrl}loans/stk-dashboard?limit=20&clientId=');
  static final Uri getClientChannel = Uri.parse('${baseUrl}channels/');

  static final Uri getSingleLead = Uri.parse('${baseUrl}leads/');

  static final Uri getSingleClientForLoanReview =
      Uri.parse('${baseUrl}clients/cdl/');
  static final String getResidentialClient ='${baseUrl}client/';

  static final Uri getSingleClientPersonalInfo =
      Uri.parse('${baseUrl}clients/');
  static final Uri getSingleClientBankInfo = Uri.parse('${baseUrl}clients/');

  static final Uri loanCollection = Uri.parse('${baseUrl}loans/collections');

  static final Uri oldProductEngine =
      Uri.parse('${baseUrl}loans/template?activeOnly=true&clientId=');
  static final Uri productEngine =
      Uri.parse('${baseUrl}loans/stk-template?activeOnly=true&clientId=');
  static final Uri repaymentProductEngine =
      Uri.parse('${baseUrl}loans/stk-template?activeOnly=true');

  static final Uri newProductEngine =
      Uri.parse('${baseUrl}loans/template?activeOnly=true&clientId=');

  static final Uri lafDownload = Uri.parse('${LoanbaseUrl}laf/');
  static final String allEmployers =
      '${baseUrl}employers?active=true&selectOnlyParentEmployer=true';
  static final String employerProduct = '${baseUrl}employers/';
  static final Uri thirdpartyEmployerProduct =
      Uri.parse('${baseUrl}employers/thirdparty?employerId=');

  static final Uri searchClient =
      Uri.parse('${baseUrl}search?exactMatch=false&resource=clients&query=');
  static final String newSeachClient =
      '${baseUrl}clients/nx360?offset=0&limit=100&';

// https://40.113.169.208:8443/fineract-provider/api/v1/clients/nx360?offset=0&limit=100&bvn=2231744

  //static const Uri allEmployers = baseUrl + 'employers?&selectOnlyParentEmployer=true';
  static final Uri allEmployersBranch =
      Uri.parse('${baseUrl}employers/parent/');

  //sequest API 293796
  static final Uri getRecentRequest =
      Uri.parse('\${sequestbaseUrl}RequestLog/getrecentRequest');
  static final Uri sequestLogin = Uri.parse('\${sequestbaseUrl}Auth/login/');
  static final Uri affectedUsers =
      Uri.parse('\${sequestbaseUrl}RequestType/getaffectedtypes');
  static final Uri deparmentUnit = Uri.parse('\${sequestbaseUrl}Unit/getunits');
  static final Uri ticketType =
      Uri.parse('\${sequestbaseUrl}RequestType/getrequesttypes/');
  static final Uri categoryApi =
      Uri.parse('\${sequestbaseUrl}Category/getCategoriesByTypes/');
  static final Uri categoryApiForOpportunity =
      Uri.parse('\${sequestbaseUrl}Category/getCategoryBySequestType/');
  static final Uri createOpportunity =
      Uri.parse('\${sequestbaseUrl}RequestLog/CreateOpportunity');
  static final Uri getCategoryByUnitId =
      Uri.parse('\${sequestbaseUrl}Category/getCategoryByUnitId/');

  static final Uri getSubcategoryApi =
      Uri.parse('\${sequestbaseUrl}Category/getSubCategoryByCategory/');
  static final Uri raiseTicket =
      Uri.parse('\${sequestbaseUrl}RequestLog/raiseticket');
  static final Uri getRecentTicketByCLientId =
      Uri.parse('\${sequestbaseUrl}RequestLog/getRequestByClientId/');
  static final Uri getInteractionLoggedByMe =
      Uri.parse('\${sequestbaseUrl}RequestLog/getOutgoingRequest/');
  static final Uri getOpportunityLoggedByMe =
      Uri.parse('\${sequestbaseUrl}RequestLog/getOutgoingSequestType/8/');
  static final Uri getFullDiscussWithTicketID =
      Uri.parse('\${sequestbaseUrl}RequestLog/getRequest/');
  static final Uri replyTicket =
      Uri.parse('\${sequestbaseUrl}RequestLog/replyticket');
  static final Uri getAvailableStatusByTicket =
      Uri.parse('\${sequestbaseUrl}RequestLog/getAvailableStatusByTicketId/');
  static final String getSequestTypePendingOnMe =
     '${sequestbaseUrl}RequestLog/getSequestTypePendingOnMe/8/';
  static final Uri getSequestTypeForClient =
      Uri.parse('\${sequestbaseUrl}RequestLog/getSequestTypeForClient/8/');
  static final Uri getRequestPendingOnUnit =
      Uri.parse('\${sequestbaseUrl}RequestLog/getRequestPendingOnUnit/2761');

  // /api/RequestLog/getSequestTypePendingOnMe/{sequestId}/{staffId}

  // ValidationApi
  static final Uri fetchBVN = Uri.parse(
      '\${validationBaseUrl}Validation/ValidateBankVerificationNumber/');

  //NxWrapper

  static final Uri validateBVN =
      Uri.parse('\${NxWrapperBaseUrl}Verification/ValidateBvn/');
  static final Uri getKyc = Uri.parse('\${NxWrapperBaseUrl}Verification/kyc');
  static final Uri remittaReference =
      Uri.parse('\${NxWrapperBaseUrl}Channels/Remita/Referencing');
  static final Uri verifyClientOTP =
      Uri.parse('\${NxWrapperBaseUrl}Verification/VerifyOtp/');
  static final Uri verifyAccountNumber =
      Uri.parse('\${NxWrapperBaseUrl}Verification/NameEnquiry');
  static final Uri getMBSBank =
      Uri.parse('\${NxWrapperBaseUrl}Channels/MbsBanks');
  static final Uri validateBankInfo =
      Uri.parse('\${NxWrapperBaseUrl}Verification/NameEnquiry');
  static final Uri interestChannel = Uri.parse('\${NxWrapperBaseUrl}Channels');
  static final Uri checkAvailability =
      Uri.parse('\${NxWrapperBaseUrl}verification/');
  static final Uri fetchBankStatement =
      Uri.parse('\${NxWrapperBaseUrl}Channels/GetBankStatement');
  static final Uri retryFetchbankStatement =
      Uri.parse('\${NxWrapperBaseUrl}Channels/GetBankStatement?retry=yes');
  static final Uri getRisksDetails =
      Uri.parse('\${NxWrapperBaseUrl}Channels/RiskProfile/Details');

  // Sentinel Store
  static final Uri getDeviceCategory =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getDeviceCategories');
  static final Uri getDevice =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getDevice/');
  static final Uri getDeviceFilter =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getDeviceFiter');
  static final Uri getAllDevice =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getDeviceAllDevices');
  static final Uri getStoreLocation =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getStoreLocations');
  static final Uri getStoreState =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getStoreStates');
  static final Uri getStoreInStates =
      Uri.parse('\${NxWrapperBaseUrl}Sentinel/getStoreInStates/');

//Attendance
  static final Uri attendancesignIn = Uri.parse('\${attendanceBaseUrl}sign');
  static final Uri attendanceLiveCheck =
      Uri.parse('\${attendanceBaseUrl}live/id?SignID=');
  static final Uri attendanceSignOut =
      Uri.parse('\${attendanceBaseUrl}sign/out');
  static final Uri attendanceLive = Uri.parse('\${attendanceBaseUrl}live');
  static final Uri attendanceStatistics =
      Uri.parse('\${attendanceBaseUrl}sign/statistics');

  //thirdparty
  //static const String  thirdPartyStaffInfo = BASE_APP_ENC + 'thirdpartylender/:channelId/staffinfo/62677?companyUuid=4567ujhg-ffc2-49b0-9953-41b79a5784e9';

  String appThirdParty(int? channelId, var staffId, companyUUId) {
    return NEW_BASE_APP_ENC +
        'thirdpartylender/${channelId}/staffinfo/${staffId}?companyUuid=${companyUUId}';
  }

  String book_thirdparty_loan(int? channelId, int? tp_customerId) {
    return NEW_BASE_APP_ENC +
        'thirdpartylender/${channelId}/bookloan/${tp_customerId}';
  }

  String fetch_wacs_info(int? channelId, String staffId) {
    return NEW_BASE_APP_ENC +
        'thirdpartylender/${channelId}/staffinfo/${staffId}';
  }

  String loan_permission(int? staffId, int? clientId) {
    return baseUrl! + 'staff/${staffId}/loan-permission?clientId=${clientId}';
  }

  String getLoanOfferForClient(int? clientId) {
    return USSD_BASE_URL! + 'Ussd/getoffers?clientId=${clientId}';
  }

  String getOrPostEmailValidationStatus(int? clientId, bool isGeneric) {
    return baseUrl! +
        'datatables/m_client_kyc_validation_status/${clientId}?genericResultSet=${isGeneric}';
  }
}
