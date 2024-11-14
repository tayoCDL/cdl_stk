class LoanCalculatorResponse {
  Currency currency;
  dynamic loanTermInDays;
  dynamic totalPrincipalDisbursed;
  dynamic totalPrincipalExpected;
  dynamic totalPrincipalPaid;
  dynamic totalInterestCharged;
  dynamic totalFeeChargesCharged;
  dynamic totalPenaltyChargesCharged;
  dynamic totalRepaymentExpected;
  dynamic totalOutstanding;
  List<Periods> periods;

  LoanCalculatorResponse(
      {this.currency,
        this.loanTermInDays,
        this.totalPrincipalDisbursed,
        this.totalPrincipalExpected,
        this.totalPrincipalPaid,
        this.totalInterestCharged,
        this.totalFeeChargesCharged,
        this.totalPenaltyChargesCharged,
        this.totalRepaymentExpected,
        this.totalOutstanding,
        this.periods});

  LoanCalculatorResponse.fromJson(Map<String, dynamic> json) {
    // currency = json['currency'] != null
    //      new Currency.fromJson(json['currency'])
    //     : null;
    loanTermInDays = json['loanTermInDays'];
    totalPrincipalDisbursed = json['totalPrincipalDisbursed'];
    totalPrincipalExpected = json['totalPrincipalExpected'];
    totalPrincipalPaid = json['totalPrincipalPaid'];
    totalInterestCharged = json['totalInterestCharged'];
    totalFeeChargesCharged = json['totalFeeChargesCharged'];
    totalPenaltyChargesCharged = json['totalPenaltyChargesCharged'];
    totalRepaymentExpected = json['totalRepaymentExpected'];
    totalOutstanding = json['totalOutstanding'];
    if (json['periods'] != null) {
      periods = <Periods>[];
      json['periods'].forEach((v) {
        periods.add(new Periods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currency != null) {
      data['currency'] = this.currency.toJson();
    }
    data['loanTermInDays'] = this.loanTermInDays;
    data['totalPrincipalDisbursed'] = this.totalPrincipalDisbursed;
    data['totalPrincipalExpected'] = this.totalPrincipalExpected;
    data['totalPrincipalPaid'] = this.totalPrincipalPaid;
    data['totalInterestCharged'] = this.totalInterestCharged;
    data['totalFeeChargesCharged'] = this.totalFeeChargesCharged;
    data['totalPenaltyChargesCharged'] = this.totalPenaltyChargesCharged;
    data['totalRepaymentExpected'] = this.totalRepaymentExpected;
    data['totalOutstanding'] = this.totalOutstanding;
    if (this.periods != null) {
      data['periods'] = this.periods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Currency {
  String code;
  String name;
  dynamic decimalPlaces;
  dynamic inMultiplesOf;
  String displaySymbol;
  String nameCode;
  String displayLabel;

  Currency(
      {this.code,
        this.name,
        this.decimalPlaces,
        this.inMultiplesOf,
        this.displaySymbol,
        this.nameCode,
        this.displayLabel});

  Currency.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    decimalPlaces = json['decimalPlaces'];
    inMultiplesOf = json['inMultiplesOf'];
    displaySymbol = json['displaySymbol'];
    nameCode = json['nameCode'];
    displayLabel = json['displayLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['decimalPlaces'] = this.decimalPlaces;
    data['inMultiplesOf'] = this.inMultiplesOf;
    data['displaySymbol'] = this.displaySymbol;
    data['nameCode'] = this.nameCode;
    data['displayLabel'] = this.displayLabel;
    return data;
  }
}

class Periods {
  List<dynamic> dueDate;
  dynamic principalDisbursed;
  dynamic principalLoanBalanceOutstanding;
  dynamic feeChargesDue;
  dynamic feeChargesOutstanding;
  dynamic totalOriginalDueForPeriod;
  dynamic totalDueForPeriod;
  dynamic totalOutstandingForPeriod;
  dynamic totalActualCostOfLoanForPeriod;
  dynamic period;
  List<dynamic> fromDate;
  dynamic daysInPeriod;
  dynamic principalOriginalDue;
  dynamic principalDue;
  dynamic principalOutstanding;
  dynamic interestOriginalDue;
  dynamic interestDue;
  dynamic interestOutstanding;
  dynamic penaltyChargesDue;
  dynamic totalPaidForPeriod;
  dynamic totalInstallmentAmountForPeriod;

  Periods(
      {this.dueDate,
        this.principalDisbursed,
        this.principalLoanBalanceOutstanding,
        this.feeChargesDue,
        this.feeChargesOutstanding,
        this.totalOriginalDueForPeriod,
        this.totalDueForPeriod,
        this.totalOutstandingForPeriod,
        this.totalActualCostOfLoanForPeriod,
        this.period,
        this.fromDate,
        this.daysInPeriod,
        this.principalOriginalDue,
        this.principalDue,
        this.principalOutstanding,
        this.interestOriginalDue,
        this.interestDue,
        this.interestOutstanding,
        this.penaltyChargesDue,
        this.totalPaidForPeriod,
        this.totalInstallmentAmountForPeriod});

  Periods.fromJson(Map<String, dynamic> json) {
    dueDate = json['dueDate'].cast<dynamic>();
    principalDisbursed = json['principalDisbursed'];
    principalLoanBalanceOutstanding = json['principalLoanBalanceOutstanding'];
    feeChargesDue = json['feeChargesDue'];
    feeChargesOutstanding = json['feeChargesOutstanding'];
    totalOriginalDueForPeriod = json['totalOriginalDueForPeriod'];
    totalDueForPeriod = json['totalDueForPeriod'];
    totalOutstandingForPeriod = json['totalOutstandingForPeriod'];
    totalActualCostOfLoanForPeriod = json['totalActualCostOfLoanForPeriod'];
    period = json['period'];
  //  fromDate = json['fromDate'].cast<dynamic>();
    daysInPeriod = json['daysInPeriod'];
    principalOriginalDue = json['principalOriginalDue'];
    principalDue = json['principalDue'];
    principalOutstanding = json['principalOutstanding'];
    interestOriginalDue = json['interestOriginalDue'];
    interestDue = json['interestDue'];
    interestOutstanding = json['interestOutstanding'];
    penaltyChargesDue = json['penaltyChargesDue'];
    totalPaidForPeriod = json['totalPaidForPeriod'];
    totalInstallmentAmountForPeriod = json['totalInstallmentAmountForPeriod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dueDate'] = this.dueDate;
    data['principalDisbursed'] = this.principalDisbursed;
    data['principalLoanBalanceOutstanding'] =
        this.principalLoanBalanceOutstanding;
    data['feeChargesDue'] = this.feeChargesDue;
    data['feeChargesOutstanding'] = this.feeChargesOutstanding;
    data['totalOriginalDueForPeriod'] = this.totalOriginalDueForPeriod;
    data['totalDueForPeriod'] = this.totalDueForPeriod;
    data['totalOutstandingForPeriod'] = this.totalOutstandingForPeriod;
    data['totalActualCostOfLoanForPeriod'] =
        this.totalActualCostOfLoanForPeriod;
    data['period'] = this.period;
    data['fromDate'] = this.fromDate;
    data['daysInPeriod'] = this.daysInPeriod;
    data['principalOriginalDue'] = this.principalOriginalDue;
    data['principalDue'] = this.principalDue;
    data['principalOutstanding'] = this.principalOutstanding;
    data['interestOriginalDue'] = this.interestOriginalDue;
    data['interestDue'] = this.interestDue;
    data['interestOutstanding'] = this.interestOutstanding;
    data['penaltyChargesDue'] = this.penaltyChargesDue;
    data['totalPaidForPeriod'] = this.totalPaidForPeriod;
    data['totalInstallmentAmountForPeriod'] =
        this.totalInstallmentAmountForPeriod;
    return data;
  }
}
