

class Data {
  int? status;
  SingleOrderModel? singleOrderModel;
  String? message;
  String? type;
  List<FinalCosting>? finalCosting;

  Data({this.status, this.singleOrderModel,
    this.message, this.type, this.finalCosting});

  Data.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    singleOrderModel = json["data"] == null ? null : SingleOrderModel.fromJson(json["data"]);
    message = json["message"];
    type = json["type"];
    finalCosting = json["finalCosting"] == null ? null : (json["finalCosting"] as List).map((e) => FinalCosting.fromJson(e)).toList();
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Data.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    if(singleOrderModel != null) {
      _data["data"] = singleOrderModel?.toJson();
    }
    _data["message"] = message;
    _data["type"] = type;
    if(finalCosting != null) {
      _data["finalCosting"] = finalCosting?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}


class SingleOrderModel {
  String? id;
  String? status;
  String? transactionId;
  String? messageId;
  dynamic invoice;
  String? supportPhone;
  String? supportEmail;
  dynamic orderNumber;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? addressId;
  String? customerId;
  String? storeLocationId;
  List<Quotes>? quotes;
  StoreLocation? storeLocation;
  Address? address;
  Payment? payment;
  Support? support;

  SingleOrderModel({this.id, this.status, this.transactionId,
    this.messageId, this.invoice, this.supportPhone,
    this.supportEmail, this.orderNumber, this.createdAt,
    this.updatedAt, this.deletedAt, this.addressId, this.customerId,
    this.storeLocationId, this.quotes, this.storeLocation, this.address,
    this.payment, this.support});

  SingleOrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    status = json["status"];
    transactionId = json["transaction_id"];
    messageId = json["message_id"];
    invoice = json["invoice"];
    supportPhone = json["support_phone"];
    supportEmail = json["support_email"];
    orderNumber = json["order_number"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    addressId = json["addressId"];
    customerId = json["customerId"];
    storeLocationId = json["storeLocationId"];
    quotes = json["quotes"] == null ? null : (json["quotes"] as List).map((e) => Quotes.fromJson(e)).toList();
    storeLocation = json["storeLocation"] == null ? null : StoreLocation.fromJson(json["storeLocation"]);
    address = json["address"] == null ? null : Address.fromJson(json["address"]);
    payment = json["payment"] == null ? null : Payment.fromJson(json["payment"]);
    support = json["support"] == null ? null : Support.fromJson(json["support"]);
  }

  static List<SingleOrderModel> fromList(List<dynamic> list) {
    return list.map((map) => SingleOrderModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["status"] = status;
    _data["transaction_id"] = transactionId;
    _data["message_id"] = messageId;
    _data["invoice"] = invoice;
    _data["support_phone"] = supportPhone;
    _data["support_email"] = supportEmail;
    _data["order_number"] = orderNumber;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["addressId"] = addressId;
    _data["customerId"] = customerId;
    _data["storeLocationId"] = storeLocationId;
    if(quotes != null) {
      _data["quotes"] = quotes?.map((e) => e.toJson()).toList();
    }
    if(storeLocation != null) {
      _data["storeLocation"] = storeLocation?.toJson();
    }
    if(address != null) {
      _data["address"] = address?.toJson();
    }
    if(payment != null) {
      _data["payment"] = payment?.toJson();
    }
    if(support != null) {
      _data["support"] = support?.toJson();
    }
    return _data;
  }
}

class Payment {
  String? id;
  dynamic razorpayPaymentId;
  String? razorpayOrderId;
  bool? paymentStatus;
  String? amountInCents;
  dynamic transactionId;
  String? messageId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? orderId;

  Payment({this.id, this.razorpayPaymentId, this.razorpayOrderId, this.paymentStatus, this.amountInCents, this.transactionId, this.messageId, this.createdAt, this.updatedAt, this.deletedAt, this.orderId});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    razorpayPaymentId = json["razorpay_payment_id"];
    razorpayOrderId = json["razorpay_order_id"];
    paymentStatus = json["payment_status"];
    amountInCents = json["amountInCents"].toString();
    transactionId = json["transaction_id"];
    messageId = json["message_id"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    orderId = json["orderId"];
  }

  static List<Payment> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Payment.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["razorpay_payment_id"] = razorpayPaymentId;
    _data["razorpay_order_id"] = razorpayOrderId;
    _data["payment_status"] = paymentStatus;
    _data["amountInCents"] = amountInCents;
    _data["transaction_id"] = transactionId;
    _data["message_id"] = messageId;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["orderId"] = orderId;
    return _data;
  }
}

class Address {
  String? id;
  String? addressName;
  String? lat;
  String? lng;
  String? flat;
  String? locality;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? howToReach;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? customerId;

  Address({this.id, this.addressName, this.lat, this.lng, this.flat, this.locality, this.city, this.state, this.country, this.pincode, this.howToReach, this.createdAt, this.updatedAt, this.deletedAt, this.customerId});

  Address.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    addressName = json["address_name"];
    lat = json["lat"];
    lng = json["lng"];
    flat = json["flat"];
    locality = json["locality"];
    city = json["city"];
    state = json["state"];
    country = json["country"];
    pincode = json["pincode"];
    howToReach = json["howToReach"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    customerId = json["customerId"];
  }

  static List<Address> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Address.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["address_name"] = addressName;
    _data["lat"] = lat;
    _data["lng"] = lng;
    _data["flat"] = flat;
    _data["locality"] = locality;
    _data["city"] = city;
    _data["state"] = state;
    _data["country"] = country;
    _data["pincode"] = pincode;
    _data["howToReach"] = howToReach;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["customerId"] = customerId;
    return _data;
  }
}

class StoreLocation {
  String? id;
  String? ondcLocationId;
  String? city;
  String? pincode;
  String? address;
  String? state;
  String? days;
  dynamic frequency;
  String? storeOpenTime;
  String? storeCloseTime;
  dynamic times;
  dynamic itemCount;
  String? distance;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? storeId;
  Store? store;

  StoreLocation({this.id, this.ondcLocationId, this.city, this.pincode, this.address, this.state, this.days, this.frequency, this.storeOpenTime, this.storeCloseTime, this.times, this.itemCount, this.distance, this.createdAt, this.updatedAt, this.deletedAt, this.storeId, this.store});

  StoreLocation.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    ondcLocationId = json["ondc_location_id"];
    city = json["city"];
    pincode = json["pincode"];
    address = json["address"];
    state = json["state"];
    days = json["days"];
    frequency = json["frequency"];
    storeOpenTime = json["storeOpenTime"];
    storeCloseTime = json["storeCloseTime"];
    times = json["times"];
    itemCount = json["item_count"];
    distance = json["distance"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    storeId = json["storeId"];
    store = json["store"] == null ? null : Store.fromJson(json["store"]);
  }

  static List<StoreLocation> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => StoreLocation.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["ondc_location_id"] = ondcLocationId;
    _data["city"] = city;
    _data["pincode"] = pincode;
    _data["address"] = address;
    _data["state"] = state;
    _data["days"] = days;
    _data["frequency"] = frequency;
    _data["storeOpenTime"] = storeOpenTime;
    _data["storeCloseTime"] = storeCloseTime;
    _data["times"] = times;
    _data["item_count"] = itemCount;
    _data["distance"] = distance;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["storeId"] = storeId;
    if(store != null) {
      _data["store"] = store?.toJson();
    }
    return _data;
  }
}

class Store {
  String? id;
  String? bppId;
  String? bppUri;
  String? messageId;
  String? transactionId;
  String? ondcStoreId;
  bool? delivery;
  String? phone;
  String? email;
  String? symbol;
  String? name;
  String? shortDescription;
  String? longDescription;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Store({this.id, this.bppId, this.bppUri, this.messageId, this.transactionId, this.ondcStoreId, this.delivery, this.phone, this.email, this.symbol, this.name, this.shortDescription, this.longDescription, this.createdAt, this.updatedAt, this.deletedAt});

  Store.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    bppId = json["bpp_id"];
    bppUri = json["bpp_uri"];
    messageId = json["message_id"];
    transactionId = json["transaction_id"];
    ondcStoreId = json["ondc_store_id"];
    delivery = json["delivery"];
    phone = json["phone"];
    email = json["email"];
    symbol = json["symbol"];
    name = json["name"];
    shortDescription = json["short_description"];
    longDescription = json["long_description"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
  }

  static List<Store> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Store.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["bpp_id"] = bppId;
    _data["bpp_uri"] = bppUri;
    _data["message_id"] = messageId;
    _data["transaction_id"] = transactionId;
    _data["ondc_store_id"] = ondcStoreId;
    _data["delivery"] = delivery;
    _data["phone"] = phone;
    _data["email"] = email;
    _data["symbol"] = symbol;
    _data["name"] = name;
    _data["short_description"] = shortDescription;
    _data["long_description"] = longDescription;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    return _data;
  }
}

class Quotes {
  String? id;
  dynamic transactionId;
  String? messageId;
  String? currency;
  String? totalPrice;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? orderId;
  List<CartItemPrices>? cartItemPrices;
  List<Tracks>? tracks;

  Quotes({this.id, this.transactionId, this.messageId, this.currency, this.totalPrice, this.status, this.createdAt, this.updatedAt, this.deletedAt, this.orderId, this.cartItemPrices, this.tracks});

  Quotes.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    transactionId = json["transaction_id"];
    messageId = json["message_id"];
    currency = json["currency"];
    totalPrice = json["total_price"].toString();
    status = json["status"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    orderId = json["orderId"];
    cartItemPrices = json["cartItemPrices"] == null ? null : (json["cartItemPrices"] as List).map((e) => CartItemPrices.fromJson(e)).toList();
    tracks = json["Tracks"] == null ? null : (json["Tracks"] as List).map((e) => Tracks.fromJson(e)).toList();
  }

  static List<Quotes> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Quotes.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["transaction_id"] = transactionId;
    _data["message_id"] = messageId;
    _data["currency"] = currency;
    _data["total_price"] = totalPrice;
    _data["status"] = status;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["orderId"] = orderId;
    if(cartItemPrices != null) {
      _data["cartItemPrices"] = cartItemPrices?.map((e) => e.toJson()).toList();
    }
    if(tracks != null) {
      _data["Tracks"] = tracks?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Tracks {
  String? id;
  String? transactionId;
  String? fulfillmentId;
  String? messageId;
  String? deliveryPartner;
  String? type;
  String? startRangeEnd;
  String? startRangeStart;
  String? endRangeStart;
  String? endRangeEnd;
  String? state;
  String? deliveryCode;
  String? deliveryContactPhone;
  dynamic status;
  String? label;
  dynamic url;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? quoteId;

  Tracks({this.id, this.transactionId, this.messageId,this.fulfillmentId,
    this.deliveryPartner, this.type, this.startRangeEnd, this.startRangeStart,
    this.endRangeStart, this.endRangeEnd, this.state, this.deliveryCode,
    this.deliveryContactPhone, this.status, this.label, this.url, this.createdAt,
    this.updatedAt, this.deletedAt, this.quoteId});

  Tracks.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    transactionId = json["transaction_id"];
    fulfillmentId = json["fulfillment_id"];
    messageId = json["message_id"];
    deliveryPartner = json["delivery_partner"];
    type = json["type"];
    startRangeEnd = json["startRangeEnd"];
    startRangeStart = json["startRangeStart"];
    endRangeStart = json["endRangeStart"];
    endRangeEnd = json["endRangeEnd"];
    state = json["state"];
    deliveryCode = json["deliveryCode"];
    deliveryContactPhone = json["deliveryContactPhone"];
    status = json["status"];
    label = json["label"];
    url = json["url"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    quoteId = json["quoteId"];
  }

  static List<Tracks> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Tracks.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["transaction_id"] = transactionId;
    _data["message_id"] = messageId;
    _data["fulfillment_id"] = fulfillmentId;
    _data["delivery_partner"] = deliveryPartner;
    _data["type"] = type;
    _data["startRangeEnd"] = startRangeEnd;
    _data["startRangeStart"] = startRangeStart;
    _data["endRangeStart"] = endRangeStart;
    _data["endRangeEnd"] = endRangeEnd;
    _data["state"] = state;
    _data["deliveryCode"] = deliveryCode;
    _data["deliveryContactPhone"] = deliveryContactPhone;
    _data["status"] = status;
    _data["label"] = label;
    _data["url"] = url;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["quoteId"] = quoteId;
    return _data;
  }
}

class CartItemPrices {
  String? id;
  String? price;
  String? title;
  String? type;
  int? quantity;
  String? ondcItemId;
  dynamic status;
  dynamic cancellable;
  dynamic symbol;
  dynamic returnable;
  dynamic isCancelled;
  dynamic isReturned;
  dynamic netQuantity;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? quoteId;
  dynamic deliveryFulfillmentId;
  DeliveryFulfillment? deliveryFulfillment;

  CartItemPrices({this.id, this.price, this.title,
    this.type, this.quantity, this.ondcItemId, this.status,
    this.isCancelled,this.isReturned,
    this.cancellable, this.symbol, this.returnable, this.createdAt,
    this.netQuantity,
    this.updatedAt, this.deletedAt, this.quoteId, this.deliveryFulfillmentId,
    this.deliveryFulfillment});

  CartItemPrices.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    price = json["price"].toString();
    title = json["title"];
    type = json["type"];
    quantity = json["quantity"];
    ondcItemId = json["ondc_item_id"];
    status = json["status"];
    cancellable = json["cancellable"];
    isCancelled = json["isCancelled"];
    isReturned = json["isReturned"];
    netQuantity = json["net_quantity"];
    symbol = json["symbol"];
    returnable = json["returnable"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    quoteId = json["quoteId"];
    deliveryFulfillmentId = json["deliveryFulfillmentId"];
    deliveryFulfillment = json["deliveryFulfillment"] == null ? null : DeliveryFulfillment.fromJson(json["deliveryFulfillment"]);
  }

  static List<CartItemPrices> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => CartItemPrices.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["price"] = price;
    _data["title"] = title;
    _data["type"] = type;
    _data["quantity"] = quantity;
    _data["ondc_item_id"] = ondcItemId;
    _data["status"] = status;
    _data["cancellable"] = cancellable;
    _data["symbol"] = symbol;
    _data["returnable"] = returnable;
    _data["isReturned"] = isReturned;
    _data["isCancelled"] = isCancelled;
    _data["net_quantity"] = netQuantity;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["quoteId"] = quoteId;
    _data["deliveryFulfillmentId"] = deliveryFulfillmentId;
    if(deliveryFulfillment != null) {
      _data["deliveryFulfillment"] = deliveryFulfillment?.toJson();
    }
    return _data;
  }
}

  class DeliveryFulfillment {
    String? id;
    String? fulfillmentId;
    dynamic providerName;
    String? category;
    String? tat;
    bool? serviceable;
    String? messageId;
    String? createdAt;
    String? updatedAt;
    dynamic deletedAt;

    DeliveryFulfillment(
        {this.id, this.fulfillmentId, this.providerName, this.category, this.tat, this.serviceable, this.messageId, this.createdAt, this.updatedAt, this.deletedAt});

    DeliveryFulfillment.fromJson(Map<String, dynamic> json) {
      id = json["id"];
      fulfillmentId = json["fulfillment_id"];
      providerName = json["provider_name"];
      category = json["category"];
      tat = json["tat"];
      serviceable = json["serviceable"];
      messageId = json["message_id"];
      createdAt = json["createdAt"];
      updatedAt = json["updatedAt"];
      deletedAt = json["deletedAt"];
    }

    static List<DeliveryFulfillment> fromList(List<Map<String, dynamic>> list) {
      return list.map((map) => DeliveryFulfillment.fromJson(map)).toList();
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> _data = <String, dynamic>{};
      _data["id"] = id;
      _data["fulfillment_id"] = fulfillmentId;
      _data["provider_name"] = providerName;
      _data["category"] = category;
      _data["tat"] = tat;
      _data["serviceable"] = serviceable;
      _data["message_id"] = messageId;
      _data["createdAt"] = createdAt;
      _data["updatedAt"] = updatedAt;
      _data["deletedAt"] = deletedAt;
      return _data;
    }

  }

class Support {
  String? id;
  String? category;
  String? subCategory;
  String? shortDescription;
  String? longDescription;
  String? issueType;
  String? status;
  List<String>? itemId;
  dynamic organisationName;
  dynamic organisationPhone;
  dynamic organisationEmail;
  dynamic resolutionSupportEmail;
  dynamic resolutionSupportChatLink;
  dynamic resolutionSupportPhone;
  dynamic groPhone;
  dynamic groName;
  dynamic groEmail;
  dynamic resolution;
  dynamic resolutionRemarks;
  dynamic actionTriggered;
  dynamic refundAmount;
  dynamic resolutionAction;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? customerId;
  String? orderId;
  List<dynamic>? images;
  List<dynamic>? issueActions;

  Support({this.id, this.category, this.subCategory, this.shortDescription, this.longDescription, this.issueType, this.status, this.itemId, this.organisationName, this.organisationPhone, this.organisationEmail, this.resolutionSupportEmail, this.resolutionSupportChatLink, this.resolutionSupportPhone, this.groPhone, this.groName, this.groEmail, this.resolution, this.resolutionRemarks, this.actionTriggered, this.refundAmount, this.resolutionAction, this.createdAt, this.updatedAt, this.deletedAt, this.customerId, this.orderId, this.images, this.issueActions});

  Support.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    category = json["category"];
    subCategory = json["sub_category"];
    shortDescription = json["short_description"];
    longDescription = json["long_description"];
    issueType = json["issue_type"];
    status = json["status"];
    itemId = json["itemId"] == null ? null : List<String>.from(json["itemId"]);
    organisationName = json["organisation_name"];
    organisationPhone = json["organisation_phone"];
    organisationEmail = json["organisation_email"];
    resolutionSupportEmail = json["resolution_support_email"];
    resolutionSupportChatLink = json["resolution_support_chat_link"];
    resolutionSupportPhone = json["resolution_support_phone"];
    groPhone = json["gro_phone"];
    groName = json["gro_name"];
    groEmail = json["gro_email"];
    resolution = json["resolution"];
    resolutionRemarks = json["resolution_remarks"];
    actionTriggered = json["action_triggered"];
    refundAmount = json["refund_amount"];
    resolutionAction = json["resolution_action"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    customerId = json["customerId"];
    orderId = json["orderId"];
    images = json["images"] ?? [];
    issueActions = json["issueActions"] ?? [];
  }

  static List<Support> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Support.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["category"] = category;
    _data["sub_category"] = subCategory;
    _data["short_description"] = shortDescription;
    _data["long_description"] = longDescription;
    _data["issue_type"] = issueType;
    _data["status"] = status;
    if(itemId != null) {
      _data["itemId"] = itemId;
    }
    _data["organisation_name"] = organisationName;
    _data["organisation_phone"] = organisationPhone;
    _data["organisation_email"] = organisationEmail;
    _data["resolution_support_email"] = resolutionSupportEmail;
    _data["resolution_support_chat_link"] = resolutionSupportChatLink;
    _data["resolution_support_phone"] = resolutionSupportPhone;
    _data["gro_phone"] = groPhone;
    _data["gro_name"] = groName;
    _data["gro_email"] = groEmail;
    _data["resolution"] = resolution;
    _data["resolution_remarks"] = resolutionRemarks;
    _data["action_triggered"] = actionTriggered;
    _data["refund_amount"] = refundAmount;
    _data["resolution_action"] = resolutionAction;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["customerId"] = customerId;
    _data["orderId"] = orderId;
    if(images != null) {
      _data["images"] = images;
    }
    if(issueActions != null) {
      _data["issueActions"] = issueActions;
    }
    return _data;
  }
}

class FinalCosting {
   dynamic lable;
   dynamic value;

  FinalCosting({required this.lable, required this.value});

  FinalCosting.fromJson(Map<String, dynamic> json) {
    lable = json["lable"];
    value = json["value"];
  }

  static List<FinalCosting> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => FinalCosting.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["lable"] = lable;
    _data["value"] = value;
    return _data;
  }
}