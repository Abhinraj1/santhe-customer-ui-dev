class CustomerModel{

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
      required this.pinCode
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
}