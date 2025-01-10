import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {
  static const String attendanceBaseUrl = 'http://192.168.88.64:9182/api/v1/';


static const String baseUrl = 'https://nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/';
static const String LoanbaseUrl = 'nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/';
static const String paymentLinkUrl = 'https://nx360dev.creditdirect.ng/_/credit-direct-pay/';
//static const String productInfoUrl = 'https://40.113.169.208:9001/api/v1/';
static const String productInfoUrl = 'https://3.252.162.214:9001/api/v1/';
static const String sequestbaseUrl = 'https://testsequestapi.creditdirect.ng/api/';
static const String referralLinkUrl = 'https://api360.creditdirect.ng:8443/';
static const String validationBaseUrl = 'https://devwrapper.creditdirect.ng/api/v1/';
static const String NxWrapperBaseUrl = 'https://devwrapper.creditdirect.ng/api/';

static const String APP_CLOAK_URL = 'https://3.252.162.214:9010/';
static const String BASE_APP_ENC = 'https://3.252.162.214:9010/fineract-provider/api/v1/';
static const String NEW_BASE_APP_ENC = 'https://3.252.162.214:9010/api/v1/';
static const String USSD_BASE_URL = 'https://ussdstaging.creditdirect.ng/api/v1/';

 // 'https://ussdstaging.creditdirect.ng/api/v1/Ussd/getoffers?clientId=2178642
  // stkapi360
  // stkapi360

  // https://stkapi360.creditdirect.ng
  // 3.252.162.214

              //  static const String baseUrl = 'https://stkapi360.creditdirect.ng:8443/fineract-provider/api/v1/';
              //   static const String repaymentBaseUrl = 'https://stkapi360.creditdirect.ng:8443/';
              //  static const String LoanbaseUrl = 'https://api360.creditdirect.ng:8443/fineract-provider/api/v1/';
              //  static const String paymentLinkUrl = 'https://app-staging.creditdirect.ng/_/credit-direct-pay/';
              //   static const String referralLinkUrl = 'https://app-staging.creditdirect.ng/';
              //  static const String sequestbaseUrl = 'https://sequest.creditdirect.ng/api/';
              //   static const String validationBaseUrl = 'https://nxwrapper.creditdirect.ng/api/v1/';
              //  static const String NxWrapperBaseUrl = 'https://nxwrapper.creditdirect.ng/api/';
              //  static const String productInfoUrl = 'https://api360.creditdirect.ng:9002/api/v1/';
              // static const String APP_CLOAK_URL = 'https://ndwrapper.creditdirect.ng:9010/';
              // static const String BASE_APP_ENC = 'https://ndwrapper.creditdirect.ng:9010/fineract-provider/api/v1/';
              // static const String NEW_BASE_APP_ENC = 'https://ndwrapper.creditdirect.ng:9010/api/v1/';
              //    static const String USSD_BASE_URL = 'https://ussdservices.creditdirect.ng/api/v1/';







  static const String login_ldap = baseUrl + 'authentication/ldap';
  static const String login_cloak = APP_CLOAK_URL + 'authenticate';
  static const String enc_login = BASE_APP_ENC + 'authenticate-user';
  static const String enc_two_factor = BASE_APP_ENC + 'sales-tool-kit/delivery/twofactor?deliveryMethod=email&extendedToken=false';
  static const String enc_valdate_two_factor = BASE_APP_ENC + 'sales-tool-kit/twofactor/validate?token=';
  static const String enc_clients_lists = BASE_APP_ENC + 'sales-tool-kit/users/nx360?offset=0&limit=20&searchBy';

  static const String login = baseUrl + 'authentication';
  static const String twofactor = baseUrl + 'twofactor?deliveryMethod=';
  static const String validateTwofactor = baseUrl + 'twofactor/validate?token=';
  static const String forgotPassword = baseUrl + '/forgot_password';
  static const String ClientsList = baseUrl + 'clients';
  static const String clientAccount = baseUrl + 'clients/accounts/';

// http://40.113.169.208:9000/_/credit-direct-pay/177277t
  static const String getStaffCredential = baseUrl + 'staff/';
  static const String clientSearch = baseUrl + 'search?exactMatch=false';
  static const String LeadsList = baseUrl + 'leads';
  static const String addClient = baseUrl + 'clients/cdl';
  static const String addLead = baseUrl + 'leads';
  static const String loanMetrics = baseUrl + 'loans/metrics';
  static const String newSendLafOtp = baseUrl + 'laf/send-otp/';
  static const String getApprovals = baseUrl + 'loan-action/approvals/';
  static const String sendForReApprove = baseUrl + 'loan-action/approve/';
  static const String lafDocument = baseUrl + 'laf/document/';
 // laf/send-otp/{loanId}?channelId={channelId}
  static const String newVerifyOtp = baseUrl + 'laf/validate-otp/';
 // /laf/validate-otp/{loanId}/{otp}?channelId={channelId}
  static const String checkDsr = baseUrl + 'loans/cdl/dsr';
  static const String loanSchedule = baseUrl + 'loans?command=calculateLoanSchedule';
  static const String loanRepaymentCalculator = baseUrl + 'external/loan/calculator';
  static const String new_loanRepaymentCalculator = baseUrl + 'loans/calculator';
  static const String createLoan = baseUrl + 'loans/cdl';
  static const String getLoanDetails  = baseUrl + 'loans/';
  static const String newSendLoanForApproval  = baseUrl + 'loan-action/sales-approve/';
  static const String getLendersLists  = baseUrl + 'lender?status=active';
  static const String getProductInformation  = productInfoUrl + 'product/information';
  static const String getProductCycle  = productInfoUrl + 'sales-cycle?page=0&size=12&sort=id,desc';
  static const String getProductMetrics  = productInfoUrl + 'sales-cycle/agent?loanOfficerId=';




  static const String externalApprove  = baseUrl + 'external/loan/';
  static const String getLoanPaymentLinkMethod  = baseUrl + 'loans/credit-direct/';
  static const String calclulateRepayment  = baseUrl + 'loans?command=calculateLoanSchedule';
  static const String bulkBase64 = baseUrl + '';
  static const String getCode = baseUrl + 'codes';
  static const String getBanks = baseUrl + 'banks';
  static const String getCodeValue = baseUrl + 'codes/';
  static const String productSummary = baseUrl + 'summary/products';

  static const String documentConfig = baseUrl + 'cdl/configuration/1/codes';
  static const String singleLoanDocumentConfig = baseUrl + 'cdl/configuration/';

  static const String getSubCodeValue = baseUrl + 'codes/';
  static const String loanGet = baseUrl + 'loans?';

  static const String getSingleClient = baseUrl + 'clients/';
  static const String loanLists = baseUrl + 'loans/stk-dashboard?limit=20&clientId=';
  static const String getClientChannel = baseUrl + 'channels/';

  static const String getSingleLead = baseUrl + 'leads/';

  static const String getSingleClientForLoanReview = baseUrl + 'clients/cdl/';
  static const String getResidentialClient = baseUrl + 'client/';

  static const String getSingleClientPersonalInfo = baseUrl + 'clients/';
  static const String getSingleClientBankInfo = baseUrl + 'clients/';

  static const String loanCollection = baseUrl + 'loans/collections';

  static const String OldproductEngine = baseUrl + 'loans/template?activeOnly=true&clientId=';
  static const String productEngine = baseUrl + 'loans/stk-template?activeOnly=true&clientId=';
  static const String repayment_productEngine = baseUrl + 'loans/stk-template?activeOnly=true';

  static const String NewproductEngine = baseUrl + 'loans/template?activeOnly=true&clientId=';

  static const String lafDownload = LoanbaseUrl + 'laf/';
   static const String  allEmployers = baseUrl + 'employers?active=true&selectOnlyParentEmployer=true';
   static const String  employerProduct = baseUrl + 'employers/';
   static const String  thirdparty_employerProduct = baseUrl + 'employers/thirdparty?employerId=';

 static const String searchClient = baseUrl + 'search?exactMatch=false&resource=clients&query=';
 static const String newSeachClient = baseUrl + 'clients/nx360?offset=0&limit=100&';

// https://40.113.169.208:8443/fineract-provider/api/v1/clients/nx360?offset=0&limit=100&bvn=2231744

   //static const String allEmployers = baseUrl + 'employers?&selectOnlyParentEmployer=true';
  static const String allEmployersBranch = baseUrl + 'employers/parent/';


  //sequest API 293796
  static const String getRecentRequest = sequestbaseUrl + 'RequestLog/getrecentRequest';
  static const String sequestLogin = sequestbaseUrl + 'Auth/login/';
  static const String  affectedUsers = sequestbaseUrl + 'RequestType/getaffectedtypes';
  static const String deparmentUnit = sequestbaseUrl + 'Unit/getunits';
  static const String ticketType = sequestbaseUrl + 'RequestType/getrequesttypes/';
  static const String categoryApi = sequestbaseUrl + 'Category/getCategoriesByTypes/';
  static const String categoryApiForOpportunity = sequestbaseUrl + 'Category/getCategoryBySequestType/';
  static const String createOpportunity = sequestbaseUrl + 'RequestLog/CreateOpportunity';
  static const String getCategoryByUnitId = sequestbaseUrl + 'Category/getCategoryByUnitId/';

  static const String getSubcategoryApi = sequestbaseUrl + 'Category/getSubCategoryByCategory/';
  static const String raiseTicket = sequestbaseUrl + 'RequestLog/raiseticket';
  static const String getRecentTicketByCLientId = sequestbaseUrl + 'RequestLog/getRequestByClientId/';
  static const String getInteractionLoggedByMe = sequestbaseUrl + 'RequestLog/getOutgoingRequest/';
  static const String getOpportunityLoggedByMe = sequestbaseUrl + 'RequestLog/getOutgoingSequestType/8/';
  static const String getFullDiscussWithTicketID = sequestbaseUrl + 'RequestLog/getRequest/';
  static const String replyTicket = sequestbaseUrl + 'RequestLog/replyticket';
  static const String getAvailableStatusByTicket = sequestbaseUrl + 'RequestLog/getAvailableStatusByTicketId/';
  static const String getSequestTypePendingOnMe = sequestbaseUrl + 'RequestLog/getSequestTypePendingOnMe/8/';
  static const String getSequestTypeForClient = sequestbaseUrl + 'RequestLog/getSequestTypeForClient/8/';
  static const String getRequestPendingOnUnit = sequestbaseUrl + 'RequestLog/getRequestPendingOnUnit/2761';

  // /api/RequestLog/getSequestTypePendingOnMe/{sequestId}/{staffId}

  // ValidationApi
  static const String fetchBVN = validationBaseUrl + 'Validation/ValidateBankVerificationNumber/';


  //NxWrapper

  static const String validateBVN = NxWrapperBaseUrl + 'Verification/ValidateBvn/';
  static const String getKyc = NxWrapperBaseUrl + 'Verification/kyc';
  static const String remittaReference = NxWrapperBaseUrl + 'Channels/Remita/Referencing';
  static const String verifyClientOTP = NxWrapperBaseUrl + 'Verification/VerifyOtp/';
  static const String verifyAccountNumber = NxWrapperBaseUrl + 'Verification/NameEnquiry';
  static const String getMBSBank = NxWrapperBaseUrl + 'Channels/MbsBanks';
  static const String validateBankInfo = NxWrapperBaseUrl + 'Verification/NameEnquiry';
  static const String interestChannel = NxWrapperBaseUrl + 'Channels';
  static const String checkAvailability = NxWrapperBaseUrl + 'verification/';
  static const String fetchBankStatement = NxWrapperBaseUrl + 'Channels/GetBankStatement';
  static const String retryFetchbankStatement = NxWrapperBaseUrl + 'Channels/GetBankStatement?retry=yes';
  static const String getRisksDetails = NxWrapperBaseUrl + 'Channels/RiskProfile/Details';



  // Sentinel Store
 static const String getDeviceCategory = NxWrapperBaseUrl + 'Sentinel/getDeviceCategories';
 static const String getDevice = NxWrapperBaseUrl + 'Sentinel/getDevice/';
 static const String getDeviceFilter = NxWrapperBaseUrl + 'Sentinel/getDeviceFiter';
 static const String getAllDevice = NxWrapperBaseUrl + 'Sentinel/getDeviceAllDevices';
 static const String getStoreLocation = NxWrapperBaseUrl + 'Sentinel/getStoreLocations';
 static const String getStoreState = NxWrapperBaseUrl + 'Sentinel/getStoreStates';
 static const String getStoreInStates = NxWrapperBaseUrl + 'Sentinel/getStoreInStates/';


//Attendance
 static const String attendancesignIn = attendanceBaseUrl + 'sign';
 static const String attendanceLiveCheck = attendanceBaseUrl + 'live/id?SignID=';
 static const String attendanceSignOut = attendanceBaseUrl + 'sign/out';
 static const String attendanceLive = attendanceBaseUrl + 'live';
 static const String attendanceStatistics = attendanceBaseUrl + 'sign/statistics';


 //thirdparty
 //static const String thirdPartyStaffInfo = BASE_APP_ENC + 'thirdpartylender/:channelId/staffinfo/62677?companyUuid=4567ujhg-ffc2-49b0-9953-41b79a5784e9';

 String appThirdParty(int channelId,var staffId,companyUUId){
  return NEW_BASE_APP_ENC + 'thirdpartylender/${channelId}/staffinfo/${staffId}?companyUuid=${companyUUId}';
 }

 String book_thirdparty_loan(int channelId,int tp_customerId){
  return NEW_BASE_APP_ENC + 'thirdpartylender/${channelId}/bookloan/${tp_customerId}';
 }


 String fetch_wacs_info(int channelId,String staffId){
  return NEW_BASE_APP_ENC + 'thirdpartylender/${channelId}/staffinfo/${staffId}';
 }


  String loan_permission(int staffId,int clientId){
    return baseUrl + 'staff/${staffId}/loan-permission?clientId=${clientId}';
  }
  String getLoanOfferForClient(int clientId){
    return USSD_BASE_URL + 'Ussd/getoffers?clientId=${clientId}';
  }

  String getOrPostEmailValidationStatus(int clientId,bool isGeneric){
    return baseUrl + 'datatables/m_client_kyc_validation_status/${clientId}?genericResultSet=${isGeneric}';
  }



}