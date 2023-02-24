





class PastOrderRow {
  String? id;
  String? status;
  String? transactionId;
  String? messageId;
  dynamic invoice;
  dynamic supportPhone;
  dynamic supportEmail;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? addressId;
  String? customerId;
  String? storeLocationId;
  Customer? customer;
  List<Quotes>? quotes;
  Address? address;

  PastOrderRow({this.id, this.status, this.transactionId, this.messageId, this.invoice, this.supportPhone, this.supportEmail, this.createdAt, this.updatedAt, this.deletedAt, this.addressId, this.customerId, this.storeLocationId, this.customer, this.quotes, this.address});

  PastOrderRow.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    status = json["status"];
    transactionId = json["transaction_id"];
    messageId = json["message_id"];
    invoice = json["invoice"];
    supportPhone = json["support_phone"];
    supportEmail = json["support_email"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    addressId = json["addressId"];
    customerId = json["customerId"];
    storeLocationId = json["storeLocationId"];
    customer = json["customer"] == null ? null : Customer.fromJson(json["customer"]);
    quotes = json["quotes"] == null ? null : (json["quotes"] as List).map((e) => Quotes.fromJson(e)).toList();
    address = json["address"] == null ? null : Address.fromJson(json["address"]);
  }

  static List<PastOrderRow> fromList(List<dynamic> list) {
    return list.map((map) => PastOrderRow.fromJson(map)).toList();
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
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["addressId"] = addressId;
    _data["customerId"] = customerId;
    _data["storeLocationId"] = storeLocationId;
    if(customer != null) {
      _data["customer"] = customer?.toJson();
    }
    if(quotes != null) {
      _data["quotes"] = quotes?.map((e) => e.toJson()).toList();
    }
    if(address != null) {
      _data["address"] = address?.toJson();
    }
    return _data;
  }

  PastOrderRow copyWith({
    String? id,
    String? status,
    String? transactionId,
    String? messageId,
    dynamic invoice,
    dynamic supportPhone,
    dynamic supportEmail,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? addressId,
    String? customerId,
    String? storeLocationId,
    Customer? customer,
    List<Quotes>? quotes,
    Address? address,
  }) => PastOrderRow(
    id: id ?? this.id,
    status: status ?? this.status,
    transactionId: transactionId ?? this.transactionId,
    messageId: messageId ?? this.messageId,
    invoice: invoice ?? this.invoice,
    supportPhone: supportPhone ?? this.supportPhone,
    supportEmail: supportEmail ?? this.supportEmail,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    addressId: addressId ?? this.addressId,
    customerId: customerId ?? this.customerId,
    storeLocationId: storeLocationId ?? this.storeLocationId,
    customer: customer ?? this.customer,
    quotes: quotes ?? this.quotes,
    address: address ?? this.address,
  );
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

  Address copyWith({
    String? id,
    String? addressName,
    String? lat,
    String? lng,
    String? flat,
    String? locality,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? howToReach,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? customerId,
  }) => Address(
    id: id ?? this.id,
    addressName: addressName ?? this.addressName,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    flat: flat ?? this.flat,
    locality: locality ?? this.locality,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    pincode: pincode ?? this.pincode,
    howToReach: howToReach ?? this.howToReach,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    customerId: customerId ?? this.customerId,
  );
}

class Quotes {
  String? id;
  dynamic transactionId;
  String? messageId;
  String? currency;
  int? totalPrice;
  String? status;
  dynamic invoice;
  bool? serviceable;
  String? tat;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? orderId;
  List<CartItemPrices>? cartItemPrices;
  dynamic track;

  Quotes({this.id, this.transactionId, this.messageId, this.currency, this.totalPrice, this.status, this.invoice, this.serviceable, this.tat, this.createdAt, this.updatedAt, this.deletedAt, this.orderId, this.cartItemPrices, this.track});

  Quotes.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    transactionId = json["transaction_id"];
    messageId = json["message_id"];
    currency = json["currency"];
    totalPrice = json["total_price"];
    status = json["status"];
    invoice = json["invoice"];
    serviceable = json["serviceable"];
    tat = json["tat"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    orderId = json["orderId"];
    cartItemPrices = json["cartItemPrices"] == null ? null : (json["cartItemPrices"] as List).map((e) => CartItemPrices.fromJson(e)).toList();
    track = json["Track"];
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
    _data["invoice"] = invoice;
    _data["serviceable"] = serviceable;
    _data["tat"] = tat;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["orderId"] = orderId;
    if(cartItemPrices != null) {
      _data["cartItemPrices"] = cartItemPrices?.map((e) => e.toJson()).toList();
    }
    _data["Track"] = track;
    return _data;
  }

  Quotes copyWith({
    String? id,
    dynamic transactionId,
    String? messageId,
    String? currency,
    int? totalPrice,
    String? status,
    dynamic invoice,
    bool? serviceable,
    String? tat,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? orderId,
    List<CartItemPrices>? cartItemPrices,
    dynamic track,
  }) => Quotes(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    messageId: messageId ?? this.messageId,
    currency: currency ?? this.currency,
    totalPrice: totalPrice ?? this.totalPrice,
    status: status ?? this.status,
    invoice: invoice ?? this.invoice,
    serviceable: serviceable ?? this.serviceable,
    tat: tat ?? this.tat,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    orderId: orderId ?? this.orderId,
    cartItemPrices: cartItemPrices ?? this.cartItemPrices,
    track: track ?? this.track,
  );
}

class CartItemPrices {
  String? id;
  int? price;
  String? title;
  String? type;
  int? quantity;
  String? ondcItemId;
  String? status;
  dynamic cancellable;
  dynamic symbol;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? quoteId;

  CartItemPrices({this.id, this.price, this.title, this.type, this.quantity, this.ondcItemId, this.status, this.cancellable, this.symbol, this.createdAt, this.updatedAt, this.deletedAt, this.quoteId});

  CartItemPrices.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    price = json["price"];
    title = json["title"];
    type = json["type"];
    quantity = json["quantity"];
    ondcItemId = json["ondc_item_id"];
    status = json["status"];
    cancellable = json["cancellable"];
    symbol = json["symbol"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    quoteId = json["quoteId"];
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
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    _data["quoteId"] = quoteId;
    return _data;
  }

  CartItemPrices copyWith({
    String? id,
    int? price,
    String? title,
    String? type,
    int? quantity,
    String? ondcItemId,
    String? status,
    dynamic cancellable,
    dynamic symbol,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? quoteId,
  }) => CartItemPrices(
    id: id ?? this.id,
    price: price ?? this.price,
    title: title ?? this.title,
    type: type ?? this.type,
    quantity: quantity ?? this.quantity,
    ondcItemId: ondcItemId ?? this.ondcItemId,
    status: status ?? this.status,
    cancellable: cancellable ?? this.cancellable,
    symbol: symbol ?? this.symbol,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    quoteId: quoteId ?? this.quoteId,
  );
}

class Customer {
  String? id;
  String? firebaseId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Customer({this.id, this.firebaseId, this.firstName, this.lastName, this.email, this.phoneNumber, this.createdAt, this.updatedAt, this.deletedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firebaseId = json["firebase_id"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
  }

  static List<Customer> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Customer.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["firebase_id"] = firebaseId;
    _data["first_name"] = firstName;
    _data["last_name"] = lastName;
    _data["email"] = email;
    _data["phone_number"] = phoneNumber;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["deletedAt"] = deletedAt;
    return _data;
  }

  Customer copyWith({
    String? id,
    String? firebaseId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) => Customer(
    id: id ?? this.id,
    firebaseId: firebaseId ?? this.firebaseId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
  );
}