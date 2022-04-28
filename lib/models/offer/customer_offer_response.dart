// To parse this JSON data, do
//
//     final customerOfferResponse = customerOfferResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CustomerOfferResponse> customerOfferResponseFromJson(String str) => List<CustomerOfferResponse>.from(json.decode(str).map((x) => CustomerOfferResponse.fromJson(x)));

String customerOfferResponseToJson(List<CustomerOfferResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerOfferResponse {
  CustomerOfferResponse({
    required this.chatEnabled,
    required this.contactEnabled,
    required this.custDistance,
    required this.custOfferResponse,
    required this.custStatus,
    required this.eventExpiryTime,
    required this.listEventId,
    required this.listId,
    required this.merchId,
    required this.merchResponse,
  });

  bool chatEnabled;
  bool contactEnabled;
  int custDistance;
  CustOfferResponse custOfferResponse;
  String custStatus;
  Time eventExpiryTime;
  String listEventId;
  Id listId;
  Id merchId;
  MerchResponse merchResponse;

  factory CustomerOfferResponse.fromJson(Map<String, dynamic> json) => CustomerOfferResponse(
    chatEnabled: json["chatEnabled"],
    contactEnabled: json["contactEnabled"],
    custDistance: json["custDistance"],
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    custStatus: json["custStatus"],
    eventExpiryTime: Time.fromJson(json["eventExpiryTime"]),
    listEventId: json["listEventId"],
    listId: Id.fromJson(json["listId"]),
    merchId: Id.fromJson(json["merchId"]),
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
  );

  Map<String, dynamic> toJson() => {
    "chatEnabled": chatEnabled,
    "contactEnabled": contactEnabled,
    "custDistance": custDistance,
    "custOfferResponse": custOfferResponse.toJson(),
    "custStatus": custStatus,
    "eventExpiryTime": eventExpiryTime.toJson(),
    "listEventId": listEventId,
    "listId": listId.toJson(),
    "merchId": merchId.toJson(),
    "merchResponse": merchResponse.toJson(),
  };
}

class CustOfferResponse {
  CustOfferResponse({
    required this.custUpdateTime,
    required this.custOfferStatus,
    required this.custDeal,
  });

  Time custUpdateTime;
  String custOfferStatus;
  String custDeal;

  factory CustOfferResponse.fromJson(Map<String, dynamic> json) => CustOfferResponse(
    custUpdateTime: Time.fromJson(json["custUpdateTime"]),
    custOfferStatus: json["custOfferStatus"],
    custDeal: json["custDeal"],
  );

  Map<String, dynamic> toJson() => {
    "custUpdateTime": custUpdateTime.toJson(),
    "custOfferStatus": custOfferStatus,
    "custDeal": custDeal,
  };
}

class Time {
  Time({
    required this.seconds,
    required this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    seconds: json["_seconds"],
    nanoseconds: json["_nanoseconds"],
  );

  Map<String, dynamic> toJson() => {
    "_seconds": seconds,
    "_nanoseconds": nanoseconds,
  };
}

class Id {
  Id({
    required this.firestore,
    required this.path,
    required this.converter,
  });

  Firestore firestore;
  Path path;
  Converter converter;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    firestore: Firestore.fromJson(json["_firestore"]),
    path: Path.fromJson(json["_path"]),
    converter: Converter.fromJson(json["_converter"]),
  );

  Map<String, dynamic> toJson() => {
    "_firestore": firestore.toJson(),
    "_path": path.toJson(),
    "_converter": converter.toJson(),
  };
}

class Converter {
  Converter();

  factory Converter.fromJson(Map<String, dynamic> json) => Converter(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Firestore {
  Firestore({
    required this.projectId,
  });

  String projectId;

  factory Firestore.fromJson(Map<String, dynamic> json) => Firestore(
    projectId: json["projectId"],
  );

  Map<String, dynamic> toJson() => {
    "projectId": projectId,
  };
}

class Path {
  Path({
    required this.segments,
  });

  List<String> segments;

  factory Path.fromJson(Map<String, dynamic> json) => Path(
    segments: List<String>.from(json["segments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "segments": List<dynamic>.from(segments.map((x) => x)),
  };
}

class MerchResponse {
  MerchResponse({
    required this.merchResponseStatus,
    required this.merchListStatus,
    required this.merchDelivery,
    required this.merchUpdateTime,
    required this.merchOfferQuantity,
    required this.merchFulfillmentResponse,
    required this.merchTotalPrice,
  });

  String merchResponseStatus;
  String merchListStatus;
  bool merchDelivery;
  Time merchUpdateTime;
  int merchOfferQuantity;
  bool merchFulfillmentResponse;
  String merchTotalPrice;

  factory MerchResponse.fromJson(Map<String, dynamic> json) => MerchResponse(
    merchResponseStatus: json["merchResponseStatus"],
    merchListStatus: json["merchListStatus"],
    merchDelivery: json["merchDelivery"],
    merchUpdateTime: Time.fromJson(json["merchUpdateTime"]),
    merchOfferQuantity: json["merchOfferQuantity"],
    merchFulfillmentResponse: json["merchFulfillmentResponse"],
    merchTotalPrice: json["merchTotalPrice"],
  );

  Map<String, dynamic> toJson() => {
    "merchResponseStatus": merchResponseStatus,
    "merchListStatus": merchListStatus,
    "merchDelivery": merchDelivery,
    "merchUpdateTime": merchUpdateTime.toJson(),
    "merchOfferQuantity": merchOfferQuantity,
    "merchFulfillmentResponse": merchFulfillmentResponse,
    "merchTotalPrice": merchTotalPrice,
  };
}
