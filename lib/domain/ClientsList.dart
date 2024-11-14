class ClientsListData {
  int id;
  String accountNo;
  Status status;
  SubStatus subStatus;
  bool active;
  String firstname;
  String middlename;
  String lastname;
  String displayName;
  String mobileNo;
  String emailAddress;
  List<int> dateOfBirth;
  Gender gender;
  SubStatus clientType;
  Gender clientClassification;
  bool isStaff;
  int officeId;
  String officeName;
  int imageId;
  bool imagePresent;
  Timeline timeline;
  Status legalForm;
  String referralIdentity;
  String bvn;
  bool bvnValidationStatus;
  Gender referralMode;
  Gender title;
  Gender activationChannel;
  SubStatus employmentSector;
  int numberOfDependent;
  Gender educationLevel;
  Gender maritalStatus;
  ClientNonPersonDetails clientNonPersonDetails;

  ClientsListData(
      {this.id,
        this.accountNo,
        this.status,
        this.subStatus,
        this.active,
        this.firstname,
        this.middlename,
        this.lastname,
        this.displayName,
        this.mobileNo,
        this.emailAddress,
        this.dateOfBirth,
        this.gender,
        this.clientType,
        this.clientClassification,
        this.isStaff,
        this.officeId,
        this.officeName,
        this.imageId,
        this.imagePresent,
        this.timeline,
        this.legalForm,
        this.referralIdentity,
        this.bvn,
        this.bvnValidationStatus,
        this.referralMode,
        this.title,
        this.activationChannel,
        this.employmentSector,
        this.numberOfDependent,
        this.educationLevel,
        this.maritalStatus,
        this.clientNonPersonDetails});

  ClientsListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountNo = json['accountNo'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    subStatus = json['subStatus'] != null
        ? new SubStatus.fromJson(json['subStatus'])
        : null;
    active = json['active'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];
    displayName = json['displayName'];
    mobileNo = json['mobileNo'];
    emailAddress = json['emailAddress'];
    dateOfBirth = json['dateOfBirth'].cast<int>();
    gender =
    json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
    clientType = json['clientType'] != null
        ? new SubStatus.fromJson(json['clientType'])
        : null;
    clientClassification = json['clientClassification'] != null
        ? new Gender.fromJson(json['clientClassification'])
        : null;
    isStaff = json['isStaff'];
    officeId = json['officeId'];
    officeName = json['officeName'];
    imageId = json['imageId'];
    imagePresent = json['imagePresent'];
    timeline = json['timeline'] != null
        ? new Timeline.fromJson(json['timeline'])
        : null;
    legalForm = json['legalForm'] != null
        ? new Status.fromJson(json['legalForm'])
        : null;
    referralIdentity = json['referralIdentity'];
    bvn = json['bvn'];
    bvnValidationStatus = json['bvnValidationStatus'];
    referralMode = json['referralMode'] != null
        ? new Gender.fromJson(json['referralMode'])
        : null;
    title = json['title'] != null ? new Gender.fromJson(json['title']) : null;
    activationChannel = json['activationChannel'] != null
        ? new Gender.fromJson(json['activationChannel'])
        : null;
    employmentSector = json['employmentSector'] != null
        ? new SubStatus.fromJson(json['employmentSector'])
        : null;
    numberOfDependent = json['numberOfDependent'];
    educationLevel = json['educationLevel'] != null
        ? new Gender.fromJson(json['educationLevel'])
        : null;
    maritalStatus = json['maritalStatus'] != null
        ? new Gender.fromJson(json['maritalStatus'])
        : null;
    clientNonPersonDetails = json['clientNonPersonDetails'] != null
        ? new ClientNonPersonDetails.fromJson(json['clientNonPersonDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountNo'] = this.accountNo;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.subStatus != null) {
      data['subStatus'] = this.subStatus.toJson();
    }
    data['active'] = this.active;
    data['firstname'] = this.firstname;
    data['middlename'] = this.middlename;
    data['lastname'] = this.lastname;
    data['displayName'] = this.displayName;
    data['mobileNo'] = this.mobileNo;
    data['emailAddress'] = this.emailAddress;
    data['dateOfBirth'] = this.dateOfBirth;
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    if (this.clientType != null) {
      data['clientType'] = this.clientType.toJson();
    }
    if (this.clientClassification != null) {
      data['clientClassification'] = this.clientClassification.toJson();
    }
    data['isStaff'] = this.isStaff;
    data['officeId'] = this.officeId;
    data['officeName'] = this.officeName;
    data['imageId'] = this.imageId;
    data['imagePresent'] = this.imagePresent;
    if (this.timeline != null) {
      data['timeline'] = this.timeline.toJson();
    }
    if (this.legalForm != null) {
      data['legalForm'] = this.legalForm.toJson();
    }
    data['referralIdentity'] = this.referralIdentity;
    data['bvn'] = this.bvn;
    data['bvnValidationStatus'] = this.bvnValidationStatus;
    if (this.referralMode != null) {
      data['referralMode'] = this.referralMode.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.activationChannel != null) {
      data['activationChannel'] = this.activationChannel.toJson();
    }
    if (this.employmentSector != null) {
      data['employmentSector'] = this.employmentSector.toJson();
    }
    data['numberOfDependent'] = this.numberOfDependent;
    if (this.educationLevel != null) {
      data['educationLevel'] = this.educationLevel.toJson();
    }
    if (this.maritalStatus != null) {
      data['maritalStatus'] = this.maritalStatus.toJson();
    }
    if (this.clientNonPersonDetails != null) {
      data['clientNonPersonDetails'] = this.clientNonPersonDetails.toJson();
    }
    return data;
  }
}

class Status {
  int id;
  String code;
  String value;

  Status({this.id, this.code, this.value});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['value'] = this.value;
    return data;
  }
}

class SubStatus {
  bool active;
  bool mandatory;

  SubStatus({this.active, this.mandatory});

  SubStatus.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    mandatory = json['mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['mandatory'] = this.mandatory;
    return data;
  }
}

class Gender {
  int id;
  String name;
  bool active;
  bool mandatory;

  Gender({this.id, this.name, this.active, this.mandatory});

  Gender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
    mandatory = json['mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['active'] = this.active;
    data['mandatory'] = this.mandatory;
    return data;
  }
}

class Timeline {
  List<int> submittedOnDate;
  String submittedByUsername;
  String submittedByFirstname;
  String submittedByLastname;

  Timeline(
      {this.submittedOnDate,
        this.submittedByUsername,
        this.submittedByFirstname,
        this.submittedByLastname});

  Timeline.fromJson(Map<String, dynamic> json) {
    submittedOnDate = json['submittedOnDate'].cast<int>();
    submittedByUsername = json['submittedByUsername'];
    submittedByFirstname = json['submittedByFirstname'];
    submittedByLastname = json['submittedByLastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submittedOnDate'] = this.submittedOnDate;
    data['submittedByUsername'] = this.submittedByUsername;
    data['submittedByFirstname'] = this.submittedByFirstname;
    data['submittedByLastname'] = this.submittedByLastname;
    return data;
  }
}

class ClientNonPersonDetails {
  SubStatus constitution;
  SubStatus mainBusinessLine;

  ClientNonPersonDetails({this.constitution, this.mainBusinessLine});

  ClientNonPersonDetails.fromJson(Map<String, dynamic> json) {
    constitution = json['constitution'] != null
        ? new SubStatus.fromJson(json['constitution'])
        : null;
    mainBusinessLine = json['mainBusinessLine'] != null
        ? new SubStatus.fromJson(json['mainBusinessLine'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.constitution != null) {
      data['constitution'] = this.constitution.toJson();
    }
    if (this.mainBusinessLine != null) {
      data['mainBusinessLine'] = this.mainBusinessLine.toJson();
    }
    return data;
  }
}
