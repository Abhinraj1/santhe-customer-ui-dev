import 'dart:convert';

MerchantOfferResponse merchantOfferResponseFromJson(String str) => MerchantOfferResponse.fromJson(json.decode(str));

String merchantOfferResponseToJson(List<MerchantOfferResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MerchantOfferResponse {
  MerchantOfferResponse({
    required this.custDistance,
    required this.eventExpiryTime,
    required this.merchId,
    required this.items,
    required this.custId,
    required this.requestForDay,
    required this.listEventId,
    required this.contactEnabled,
    required this.custOfferResponse,
    required this.chatEnabled,
    required this.custStatus,
    required this.merchResponse,
    required this.listId,
  });

  EventExpiryTime eventExpiryTime;
  List<CustOfferItem> items;
  String custId;
  int custDistance;
  bool contactEnabled;
  bool chatEnabled;
  String listEventId;
  MerchResponse merchResponse;
  String custStatus;
  CustOfferResponse custOfferResponse;
  int requestForDay;
  String listId;
  String merchId;

  factory MerchantOfferResponse.fromJson(Map<String, dynamic> json) => MerchantOfferResponse(
    eventExpiryTime: EventExpiryTime.fromJson(json["eventExpiryTime"]),
    items: List<CustOfferItem>.from(json["items"].map((x) => CustOfferItem.fromJson(x))),
    custId: json["custId"],
    custDistance: json["custDistance"],
    contactEnabled: json["contactEnabled"],
    chatEnabled: json["chatEnabled"],
    listEventId: json["listEventId"],
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
    custStatus: json["custStatus"],
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    requestForDay: json["requestForDay"],
    listId: json["listId"],
    merchId: json["merchId"],
  );

  Map<String, dynamic> toJson() => {
    "eventExpiryTime": eventExpiryTime.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "custId": custId,
    "custDistance": custDistance,
    "contactEnabled": contactEnabled,
    "chatEnabled": chatEnabled,
    "listEventId": listEventId,
    "merchResponse": merchResponse.toJson(),
    "custStatus": custStatus,
    "custOfferResponse": custOfferResponse.toJson(),
    "requestForDay": requestForDay,
    "listId": listId,
    "merchId": merchId,
  };
}

class Converter {
  Converter();

  factory Converter.fromJson(Map<String, dynamic> json) => Converter();

  Map<String, dynamic> toJson() => {};
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

class CustOfferResponse {
  CustOfferResponse({
    required this.custDeal,
    required this.custOfferStatus,
    required this.custUpdateTime,
  });

  String custDeal;
  String custOfferStatus;
  DateTime custUpdateTime;

  factory CustOfferResponse.fromJson(Map<String, dynamic> json) => CustOfferResponse(
    custDeal: json["custDeal"],
    custOfferStatus: json["custOfferStatus"],
    custUpdateTime: DateTime.parse(json["custUpdateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "custDeal": custDeal,
    "custOfferStatus": custOfferStatus,
    "custUpdateTime": custUpdateTime.toIso8601String(),
  };
}

class EventExpiryTime {
  EventExpiryTime({
    required this.seconds,
    required this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  factory EventExpiryTime.fromJson(Map<String, dynamic> json) => EventExpiryTime(
    seconds: json["_seconds"],
    nanoseconds: json["_nanoseconds"],
  );

  Map<String, dynamic> toJson() => {
    "_seconds": seconds,
    "_nanoseconds": nanoseconds,
  };
}

class CustOfferItem {
  CustOfferItem({
    required this.itemImageId,
    required this.itemName,
    required this.merchAvailability,
    required this.itemNotes,
    required this.brandType,
    required this.itemId,
    required this.merchNotes,
    required this.catName,
    required this.unit,
    required this.quantity,
    required this.merchPrice,
    required this.itemSeqNum,
  });

  String itemName;
  String itemImageId;
  String unit;
  String quantity;
  String merchNotes;
  String itemId;
  String merchPrice;
  String brandType;
  bool merchAvailability;
  String catName;
  String itemNotes;
  int itemSeqNum;

  factory CustOfferItem.fromJson(Map<String, dynamic> json) => CustOfferItem(
    itemName: json["itemName"],
    itemImageId: json["itemImageId"],
    unit: json["unit"],
    quantity: json["quantity"].toString(),
    merchNotes: json["merchNotes"],
    itemId: json["itemId"],
    merchPrice: json["merchPrice"],
    brandType: json["brandType"],
    merchAvailability: json["merchAvailability"],
    catName: json["catName"],
    itemNotes: json["itemNotes"],
    itemSeqNum: json["itemSeqNum"],
  );

  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "itemImageId": itemImageId,
    "unit": unit,
    "quantity": quantity,
    "merchNotes": merchNotes,
    "itemId": itemId,
    "merchPrice": merchPrice,
    "brandType": brandType,
    "merchAvailability": merchAvailability,
    "catName": catName,
    "itemNotes": itemNotes,
    "itemSeqNum": itemSeqNum,
  };
}

class MerchResponse {
  MerchResponse({
    required this.merchFulfillmentResponse,
    required this.merchOfferQuantity,
    required this.merchTotalPrice,
    required this.merchUpdateTime,
    required this.merchDelivery,
    required this.merchListStatus,
    required this.merchResponseStatus,
  });

  bool merchFulfillmentResponse;
  int merchOfferQuantity;
  String merchTotalPrice;
  DateTime merchUpdateTime;
  bool merchDelivery;
  String merchListStatus;
  String merchResponseStatus;

  factory MerchResponse.fromJson(Map<String, dynamic> json) => MerchResponse(
    merchFulfillmentResponse: json["merchFulfillmentResponse"],
    merchOfferQuantity: json["merchOfferQuantity"],
    merchTotalPrice: json["merchTotalPrice"],
    merchUpdateTime: DateTime.parse(json["merchUpdateTime"]),
    merchDelivery: json["merchDelivery"],
    merchListStatus: json["merchListStatus"],
    merchResponseStatus: json["merchResponseStatus"],
  );

  Map<String, dynamic> toJson() => {
    "merchFulfillmentResponse": merchFulfillmentResponse,
    "merchOfferQuantity": merchOfferQuantity,
    "merchTotalPrice": merchTotalPrice,
    "merchUpdateTime": merchUpdateTime.toIso8601String(),
    "merchDelivery": merchDelivery,
    "merchListStatus": merchListStatus,
    "merchResponseStatus": merchResponseStatus,
  };
}

