import 'dart:convert';

List<MerchantOfferResponse> merchantOfferResponseFromJson(String str) => List<MerchantOfferResponse>.from(json.decode(str).map((x) => MerchantOfferResponse.fromJson(x)));

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

  int custDistance;
  EventExpiryTime eventExpiryTime;
  Id merchId;
  List<CustOfferItem> items;
  Id custId;
  int requestForDay;
  String listEventId;
  bool contactEnabled;
  CustOfferResponse custOfferResponse;
  bool chatEnabled;
  String custStatus;
  MerchResponse merchResponse;
  Id listId;

  factory MerchantOfferResponse.fromJson(Map<String, dynamic> json) => MerchantOfferResponse(
    custDistance: json["custDistance"],
    eventExpiryTime: EventExpiryTime.fromJson(json["eventExpiryTime"]),
    merchId: Id.fromJson(json["merchId"]),
    items: List<CustOfferItem>.from(json["items"].map((x) => CustOfferItem.fromJson(x))),
    custId: Id.fromJson(json["custId"]),
    requestForDay: json["requestForDay"],
    listEventId: json["listEventId"],
    contactEnabled: json["contactEnabled"],
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    chatEnabled: json["chatEnabled"],
    custStatus: json["custStatus"],
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
    listId: Id.fromJson(json["listId"]),
  );

  Map<String, dynamic> toJson() => {
    "custDistance": custDistance,
    "eventExpiryTime": eventExpiryTime.toJson(),
    "merchId": merchId.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "custId": custId.toJson(),
    "requestForDay": requestForDay,
    "listEventId": listEventId,
    "contactEnabled": contactEnabled,
    "custOfferResponse": custOfferResponse.toJson(),
    "chatEnabled": chatEnabled,
    "custStatus": custStatus,
    "merchResponse": merchResponse.toJson(),
    "listId": listId.toJson(),
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

  String itemImageId;
  String itemName;
  bool merchAvailability;
  String itemNotes;
  String brandType;
  Id itemId;
  String merchNotes;
  String catName;
  String unit;
  String quantity;
  String merchPrice;
  int itemSeqNum;

  factory CustOfferItem.fromJson(Map<String, dynamic> json) => CustOfferItem(
    itemImageId: json["itemImageId"],
    itemName: json["itemName"],
    merchAvailability: json["merchAvailability"],
    itemNotes: json["itemNotes"],
    brandType: json["brandType"],
    itemId: Id.fromJson(json["itemId"]),
    merchNotes: json["merchNotes"],
    catName: json["catName"],
    unit: json["unit"],
    quantity: json["quantity"].toString(),
    merchPrice: json["merchPrice"],
    itemSeqNum: json["itemSeqNum"],
  );

  Map<String, dynamic> toJson() => {
    "itemImageId": itemImageId,
    "itemName": itemName,
    "merchAvailability": merchAvailability,
    "itemNotes": itemNotes,
    "brandType": brandType,
    "itemId": itemId.toJson(),
    "merchNotes": merchNotes,
    "catName": catName,
    "unit": unit,
    "quantity": quantity,
    "merchPrice": merchPrice,
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

