class CustomerModel {
  CustomerModel(
      {required this.lng,
      required this.lat,
      required this.address,
      required this.customerId,
      required this.customerLoginTime,
      required this.customerName,
      required this.customerPlan,
      required this.customerRatings,
      required this.customerReferral,
      required this.customerStatus,
      required this.emailId,
      required this.howToReach,
      required this.phoneNumber,
      required this.pinCode,
      required this.fbiid,
      required this.uniqueCustomerId,
      this.opStats = false,
      required this.lastName});

  String address;

  String emailId;

  String howToReach; //more like item reference

  String lat;

  String lng;

  String phoneNumber;

  String pinCode;

  String customerId;

  dynamic customerLoginTime;

  String customerName;

  String customerPlan;

  String customerRatings;

  String customerReferral;

  String customerStatus;

  dynamic uniqueCustomerId;

  dynamic fbiid;
  dynamic lastName;

  bool opStats;

  factory CustomerModel.fromJson(Map json) {
    final addresses = json['addresses'] as List;
    return CustomerModel(
        address: addresses.first['flat'].toString(),
        emailId: json['email'].toString(),
        lat: addresses.first['lat'].toString(),
        lng: addresses.first['lng'].toString(),
        pinCode: addresses.first['pincode'].toString(),
        phoneNumber: json['firebase_id'].toString(),
        customerId: json['phoneNumber'].toString(),
        customerName: json['first_name'].toString(),
        uniqueCustomerId: json['id'].toString(),
        fbiid: json['fbiid'],
        customerRatings: json['custRatings'].toString(),
        customerReferral: json['custReferal'].toString(),
        customerStatus: json['custStatus'].toString(),
        customerPlan: json['custPlan'].toString(),
        customerLoginTime: json['custLoginTime'],
        howToReach: json['howToReach'].toString(),
        opStats: json['opStats'].toString().contains('true') ? true : false,
        lastName: json['last_name'].toString());
  }
}
