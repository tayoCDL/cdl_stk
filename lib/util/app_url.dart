import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {
  static const String attendanceBaseUrl = 'http://192.168.88.64:9182/api/v1/';

static const String  baseUrl = 'https://nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/';
static const String  LoanbaseUrl = 'nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/';
static const String  paymentLinkUrl = 'https://nx360dev.creditdirect.ng/_/credit-direct-pay/';
//static const String  productInfoUrl = 'https://40.113.169.208:9001/api/v1/';
static const String  productInfoUrl = 'https://3.252.162.214:9001/api/v1/';
static const String  sequestbaseUrl = 'https://testsequestapi.creditdirect.ng/api/';
static const String  referralLinkUrl = 'https://api360.creditdirect.ng:8443/';
static const String  validationBaseUrl = 'https://devwrapper.creditdirect.ng/api/v1/';
static const String  NxWrapperBaseUrl = 'https://devwrapper.creditdirect.ng/api/';

static const String  APP_CLOAK_URL = 'https://3.252.162.214:9010/';
static const String  BASE_APP_ENC = 'https://3.252.162.214:9010/fineract-provider/api/v1/';
static const String  NEW_BASE_APP_ENC = 'https://3.252.162.214:9010/api/v1/';
static const String  USSD_BASE_URL = 'https://ussdstaging.creditdirect.ng/api/v1/';

  // 'https://ussdstaging.creditdirect.ng/api/v1/Ussd/getoffers?clientId=2178642
  // stkapi360
  // stkapi360

  // https://stkapi360.creditdirect.ng
  // 3.252.162.214

  // static const String baseUrl =
  //     'https://stkapi360.creditdirect.ng:8443/fineract-provider/api/v1/';
  // static const String repaymentBaseUrl =
  //     'https://stkapi360.creditdirect.ng:8443/';
  // static const String LoanbaseUrl =
  //     'https://api360.creditdirect.ng:8443/fineract-provider/api/v1/';
  // static const String paymentLinkUrl =
  //     'https://app-staging.creditdirect.ng/_/credit-direct-pay/';
  // static const String referralLinkUrl = 'https://app-staging.creditdirect.ng/';
  // static const String sequestbaseUrl = 'https://sequest.creditdirect.ng/api/';
  // static const String validationBaseUrl =
  //     'https://nxwrapper.creditdirect.ng/api/v1/';
  // static const String NxWrapperBaseUrl =
  //     'https://nxwrapper.creditdirect.ng/api/';
  // static const String productInfoUrl =
  //     'https://api360.creditdirect.ng:9002/api/v1/';
  // static const String APP_CLOAK_URL = 'https://ndwrapper.creditdirect.ng:9010/';
  // static const String BASE_APP_ENC =
  //     'https://ndwrapper.creditdirect.ng:9010/fineract-provider/api/v1/';
  // static const String NEW_BASE_APP_ENC =
  //     'https://ndwrapper.creditdirect.ng:9010/api/v1/';
  // static const String USSD_BASE_URL =
  //     'https://ussdservices.creditdirect.ng/api/v1/';

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
  static final String clientsList = '${baseUrl}clients';
  static final String clients_List = '${baseUrl}clients';
  static final String clientAccount = '${baseUrl}clients/accounts/';

// http://40.113.169.208:9000/_/credit-direct-pay/177277t
  static final String getStaffCredential ='${baseUrl}staff/';
  static final Uri clientSearch =
      Uri.parse('${baseUrl}search?exactMatch=false');
  static final Uri leadsList = Uri.parse('${baseUrl}leads');
  static final String addClient = '${baseUrl}clients/cdl';
  static final Uri addLead = Uri.parse('${baseUrl}leads');
  static final String loanMetrics = '${baseUrl}loans/metrics';
  static final String newSendLafOtp = '${baseUrl}laf/send-otp/';
  static final String getApprovals =
      '${baseUrl}loan-action/approvals/';
  static final String sendForReApprove =
     '${baseUrl}loan-action/approve/';
  static final String lafDocument = '${baseUrl}laf/document/';
  // laf/send-otp/{loanId}?channelId={channelId}
  static final String newVerifyOtp ='${baseUrl}laf/validate-otp/';
  // /laf/validate-otp/{loanId}/{otp}?channelId={channelId}
  static final String checkDsr = '${baseUrl}loans/cdl/dsr';
  static final Uri loanSchedule =
      Uri.parse('${baseUrl}loans?command=calculateLoanSchedule');
  static final Uri loanRepaymentCalculator =
      Uri.parse('${baseUrl}external/loan/calculator');
  static final Uri newLoanRepaymentCalculator =
      Uri.parse('${baseUrl}loans/calculator');
  static final Uri createLoan = Uri.parse('${baseUrl}loans/cdl');
  static final String getLoanDetails = '${baseUrl}loans/';
  static final String newSendLoanForApproval =
      '${baseUrl}loan-action/sales-approve/';

  static final String getLendersLists =
      '${baseUrl}lender?status=active';

  static final Uri getProductInformation =
      Uri.parse('${productInfoUrl}product/information');
  static final Uri getProductCycle =
      Uri.parse('${productInfoUrl}sales-cycle?page=0&size=12&sort=id,desc');
  static final String getProductMetrics =
     '${productInfoUrl}sales-cycle/agent?loanOfficerId=';

  static final Uri externalApprove = Uri.parse('${baseUrl}external/loan/');
  static final String getLoanPaymentLinkMethod =
     '${baseUrl}loans/credit-direct/';
  static final Uri calclulateRepayment =
      Uri.parse('${baseUrl}loans?command=calculateLoanSchedule');
  static final String bulkBase64 = '${baseUrl}';
  static final Uri getCode = Uri.parse('${baseUrl}codes');
  static final Uri getBanks = Uri.parse('${baseUrl}banks');
  static final String getCodeValue = '${baseUrl}codes/';
  static final Uri productSummary = Uri.parse('${baseUrl}summary/products');

  static final Uri documentConfig =
      Uri.parse('${baseUrl}cdl/configuration/1/codes');
  static final String singleLoanDocumentConfig =
    '${baseUrl}cdl/configuration/';

  static final Uri getSubCodeValue = Uri.parse('${baseUrl}codes/');
  static final String loanGet = '${baseUrl}loans?';

  static final String getSingleClient = '${baseUrl}clients/';
  static final String loanLists =
      '${baseUrl}loans/stk-dashboard?limit=20&clientId=';
  static final Uri getClientChannel = Uri.parse('${baseUrl}channels/');

  static final Uri getSingleLead = Uri.parse('${baseUrl}leads/');

  static final String getSingleClientForLoanReview =
      '${baseUrl}clients/cdl/';
  static final String getResidentialClient ='${baseUrl}client/';

  static final String getSingleClientPersonalInfo =
      '${baseUrl}clients/';
  static final Uri getSingleClientBankInfo = Uri.parse('${baseUrl}clients/');

  static final String loanCollection = '${baseUrl}loans/collections';

  static final Uri oldProductEngine =
      Uri.parse('${baseUrl}loans/template?activeOnly=true&clientId=');
  static final String productEngine =
      '${baseUrl}loans/stk-template?activeOnly=true&clientId=';
  static final String repaymentProductEngine =
      '${baseUrl}loans/stk-template?activeOnly=true';

  static final Uri newProductEngine =
      Uri.parse('${baseUrl}loans/template?activeOnly=true&clientId=');

  static final String lafDownload = '${LoanbaseUrl}laf/';
  static final String allEmployers =
      '${baseUrl}employers?active=true&selectOnlyParentEmployer=true';
  static final String employerProduct = '${baseUrl}employers/';
  static final String thirdpartyEmployerProduct =
      '${baseUrl}employers/thirdparty?employerId=';

  static final Uri searchClient =
      Uri.parse('${baseUrl}search?exactMatch=false&resource=clients&query=');
  static final String newSeachClient =
      '${baseUrl}clients/nx360?offset=0&limit=100&';

// https://40.113.169.208:8443/fineract-provider/api/v1/clients/nx360?offset=0&limit=100&bvn=2231744

  //static const Uri allEmployers = baseUrl + 'employers?&selectOnlyParentEmployer=true';
  static final String allEmployersBranch =
     '${baseUrl}employers/parent/';

  //sequest API 293796
  static final Uri getRecentRequest =
      Uri.parse('${sequestbaseUrl}RequestLog/getrecentRequest');
  // static final Uri sequestLogin = Uri.parse('\${sequestbaseUrl}Auth/login/');
  static final Uri sequestLogin = Uri.parse('${sequestbaseUrl}Auth/login/');

  static final String sequest_Login = '${sequestbaseUrl}Auth/login/';
  static final Uri affectedUsers =
      Uri.parse('${sequestbaseUrl}RequestType/getaffectedtypes');
  static final String deparmentUnit = '${sequestbaseUrl}Unit/getunits';
  static final String ticketType = '${sequestbaseUrl}RequestType/getrequesttypes/';
  static final String categoryApi =
      '${sequestbaseUrl}Category/getCategoriesByTypes/';
  static final String categoryApiForOpportunity =
      '${sequestbaseUrl}Category/getCategoryBySequestType/';
  static final Uri createOpportunity =
      Uri.parse('${sequestbaseUrl}RequestLog/CreateOpportunity');
  static final String getCategoryByUnitId =
      '${sequestbaseUrl}Category/getCategoryByUnitId/';

  static final String getSubcategoryApi =
      '${sequestbaseUrl}Category/getSubCategoryByCategory/';
  static final String raiseTicket =
     '${sequestbaseUrl}RequestLog/raiseticket';
  static final String getRecentTicketByCLientId =
      '${sequestbaseUrl}RequestLog/getRequestByClientId/';
  static final String getInteractionLoggedByMe =
    '${sequestbaseUrl}RequestLog/getOutgoingRequest/';
  static final Uri getOpportunityLoggedByMe =
      Uri.parse('${sequestbaseUrl}RequestLog/getOutgoingSequestType/8/');
  static final String getFullDiscussWithTicketID =
      '${sequestbaseUrl}RequestLog/getRequest/';
  static final Uri replyTicket =
      Uri.parse('${sequestbaseUrl}RequestLog/replyticket');
  static final String getAvailableStatusByTicket =
      '${sequestbaseUrl}RequestLog/getAvailableStatusByTicketId/';
  static final String getSequestTypePendingOnMe =
     '${sequestbaseUrl}RequestLog/getSequestTypePendingOnMe/8/';
  static final Uri getSequestTypeForClient =
      Uri.parse('${sequestbaseUrl}RequestLog/getSequestTypeForClient/8/');
  static final Uri getRequestPendingOnUnit =
      Uri.parse('${sequestbaseUrl}RequestLog/getRequestPendingOnUnit/2761');

  // /api/RequestLog/getSequestTypePendingOnMe/{sequestId}/{staffId}

  // ValidationApi
  static final Uri fetchBVN = Uri.parse(
      '${validationBaseUrl}Validation/ValidateBankVerificationNumber/');

  //NxWrapper

  static final Uri validateBVN =
      Uri.parse('${NxWrapperBaseUrl}Verification/ValidateBvn/');
  static final Uri getKyc = Uri.parse('${NxWrapperBaseUrl}Verification/kyc');
  static final Uri remittaReference =
      Uri.parse('${NxWrapperBaseUrl}Channels/Remita/Referencing');
  static final String verifyClientOTP =
      '${NxWrapperBaseUrl}Verification/VerifyOtp/';
  static final Uri verifyAccountNumber =
      Uri.parse('${NxWrapperBaseUrl}Verification/NameEnquiry');
  static final Uri getMBSBank =
      Uri.parse('${NxWrapperBaseUrl}Channels/MbsBanks');
  static final Uri validateBankInfo =
      Uri.parse('${NxWrapperBaseUrl}Verification/NameEnquiry');
  static final Uri interestChannel = Uri.parse('${NxWrapperBaseUrl}Channels');
  static final String checkAvailability =
      '${NxWrapperBaseUrl}verification/';
  static final Uri fetchBankStatement =
      Uri.parse('${NxWrapperBaseUrl}Channels/GetBankStatement');
  static final Uri retryFetchbankStatement =
      Uri.parse('${NxWrapperBaseUrl}Channels/GetBankStatement?retry=yes');
  static final String getRisksDetails =
      '${NxWrapperBaseUrl}Channels/RiskProfile/Details';

  // Sentinel Store
  static final Uri getDeviceCategory =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getDeviceCategories');
  static final Uri getDevice =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getDevice/');
  static final Uri getDeviceFilter =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getDeviceFiter');
  static final Uri getAllDevice =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getDeviceAllDevices');
  static final Uri getStoreLocation =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getStoreLocations');
  static final Uri getStoreState =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getStoreStates');
  static final Uri getStoreInStates =
      Uri.parse('${NxWrapperBaseUrl}Sentinel/getStoreInStates/');

//Attendance
  static final Uri attendancesignIn = Uri.parse('${attendanceBaseUrl}sign');
  static final Uri attendanceLiveCheck =
      Uri.parse('${attendanceBaseUrl}live/id?SignID=');
  static final Uri attendanceSignOut =
      Uri.parse('${attendanceBaseUrl}sign/out');
  static final Uri attendanceLive = Uri.parse('${attendanceBaseUrl}live');
  static final Uri attendanceStatistics =
      Uri.parse('${attendanceBaseUrl}sign/statistics');

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

  String getSavingsAccount(int? clientId) {
    return baseUrl! + 'clients/${clientId}/accounts?fields=savingsAccounts';
  }
 String getSavingsAccountDetails(int? savingsAccountId) {
    return baseUrl! + 'savingsaccounts/${savingsAccountId}?associations=all';
  }
}
