class LoginModel {
  int? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? firstName;
  String? lastName;
  String? emailId;
  bool? isLoggedOut;
  int? iV;
  Null? otp;
  Null? otpExpires;
  String? accessToken;

  Data(
      {this.sId,
        this.firstName,
        this.lastName,
        this.emailId,
        this.isLoggedOut,
        this.iV,
        this.otp,
        this.otpExpires,
        this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailId = json['email_id'];
    isLoggedOut = json['isLoggedOut'];
    iV = json['__v'];
    otp = json['otp'];
    otpExpires = json['otp_expires'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_id'] = this.emailId;
    data['isLoggedOut'] = this.isLoggedOut;
    data['__v'] = this.iV;
    data['otp'] = this.otp;
    data['otp_expires'] = this.otpExpires;
    data['access_token'] = this.accessToken;
    return data;
  }
}