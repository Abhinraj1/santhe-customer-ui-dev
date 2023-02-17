class CustomerModel {
  CustomerModel({
    required this.lng,
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
    this.opStats = false,
  });

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

  bool opStats;

  factory CustomerModel.fromJson(Map json) {
    return CustomerModel(
      address: json['contact']['address'].toString(),
      emailId: json['contact']['emailId'].toString(),
      lat: json['contact']['location']['lat'].toString(),
      lng: json['contact']['location']['lng'].toString(),
      pinCode: json['contact']['pincode'].toString(),
      phoneNumber: json['contact']['phoneNumber'].toString(),
      customerId: json['contact']['phoneNumber'].toString(),
      customerName: json['custName'].toString(),
      customerRatings: json['custRatings'].toString(),
      customerReferral: json['custReferal'].toString(),
      customerStatus: json['custStatus'].toString(),
      customerPlan: json['custPlan'].toString(),
      customerLoginTime: json['custLoginTime'] as Map,
      howToReach: json['contact']['howToReach'].toString(),
      opStats: json['opStats'].toString().contains('true') ? true : false,
    );
  }
}
