class CustomerModel {

  CustomerModel({required this.lng,
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

  DateTime customerLoginTime;

  String customerName;

  String customerPlan;

  String customerRatings;

  String customerReferral;

  String customerStatus;

  bool opStats;

  factory CustomerModel.fromJson(Map json){
    return CustomerModel(
        address: json['contact']['mapValue']['fields']['address']['stringValue'],
        emailId: json['contact']['mapValue']['fields']['emailId']['stringValue'],
        lat: json['contact']['mapValue']['fields']['location']
        ['mapValue']['fields']['lat']['doubleValue']
            .toString(),
        lng: json['contact']['mapValue']['fields']['location']
        ['mapValue']['fields']['lng']['doubleValue']
            .toString(),
        pinCode: json['contact']['mapValue']['fields']['pincode']['integerValue'],
        phoneNumber: json['contact']['mapValue']['fields']['phoneNumber']['integerValue'],
        customerId: json['custId']['integerValue'],
        customerName: json['custName']['stringValue'],
        customerRatings: json['custRatings']['integerValue'] ??
            json['custRatings']['doubleValue'].toString(),
        customerReferral: json['custReferal']['integerValue'],
        customerStatus: json['custStatus']['stringValue'],
        customerPlan: json['custPlan']['stringValue'],
        customerLoginTime: DateTime.parse(
            json['custLoginTime']['timestampValue']),
        howToReach: json['contact']['mapValue']['fields']['howToReach']
        ['stringValue'],
        opStats: json['opStats']==null?false:json['opStats']['booleanValue']
    );
  }
}