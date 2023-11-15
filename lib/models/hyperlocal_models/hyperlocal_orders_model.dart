


import 'package:santhe/models/hyperlocal_models/hyperlocal_orders_model.dart';

import 'hyperlocal_orders_model.dart';
import 'hyperlocal_orders_model.dart';
import 'hyperlocal_orders_model.dart';

class OrderInfo {
  OrderInfo({
    required this.status,
    required this.data,
    required this.message,
  });

  final int? status;
  final Data? data;
  final String? message;

  factory OrderInfo.fromJson(Map<String, dynamic> json){
    return OrderInfo(
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      message: json["message"],
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.orderId,
    required this.deliveryCharge,
    required this.tax,
    required this.convenienceFee,
    required this.subTotal,
    required this.totalAmount,
    required this.deliveryAddressId,
    required this.billingAddressId,
    required this.customerInvoice,
    required this.notify,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.customerId,
    required this.storeDescriptionId,
    required this.orderItems,
    required this.billingAddress,
    required this.deliveryAddress,
    required this.support,
    required this.payment,
    required this.customer,
    required this.storeDescription,
    required this.states,
  });

  final String? id;
  final String? orderId;
  final dynamic deliveryCharge;
  final dynamic tax;
  final dynamic convenienceFee;
  final dynamic subTotal;
  final dynamic totalAmount;
  final String? deliveryAddressId;
  final String? billingAddressId;
  final String? customerInvoice;
  final bool? notify;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? customerId;
  final String? storeDescriptionId;
  final List<OrderItem> orderItems;
  final Address? billingAddress;
  final Address? deliveryAddress;
  final OrderInfoSupport? support;
  final Payment? payment;
  final Customer? customer;
  final StoreDescription? storeDescription;
  final List<State> states;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      orderId: json["order_id"],
      deliveryCharge: json["delivery_charge"],
      tax: json["tax"],
      convenienceFee: json["convenience_fee"],
      subTotal: json["sub_total"],
      totalAmount: json["total_amount"],
      deliveryAddressId: json["deliveryAddressId"],
      billingAddressId: json["billingAddressId"],
      customerInvoice: json["customerInvoice"],
      notify: json["notify"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customerId: json["customerId"],
      storeDescriptionId: json["storeDescriptionId"],
      orderItems: json["orderItems"] == null ? [] : List<OrderItem>.from(json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
      billingAddress: json["billingAddress"] == null ? null : Address.fromJson(json["billingAddress"]),
      deliveryAddress: json["deliveryAddress"] == null ? null : Address.fromJson(json["deliveryAddress"]),
      support: json["support"] == null ? null : OrderInfoSupport.fromJson(json["support"]),
      payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      storeDescription: json["storeDescription"] == null ? null : StoreDescription.fromJson(json["storeDescription"]),
      states: json["states"] == null ? [] : List<State>.from(json["states"]!.map((x) => State.fromJson(x))),
    );
  }

}

class Address {
  Address({
    required this.id,
    required this.addressName,
    required this.lat,
    required this.lng,
    required this.flat,
    required this.locality,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.howToReach,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.customerId,
  });

  final String? id;
  final dynamic addressName;
  final String? lat;
  final String? lng;
  final String? flat;
  final String? locality;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final dynamic howToReach;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? customerId;

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      id: json["id"],
      addressName: json["address_name"],
      lat: json["lat"],
      lng: json["lng"],
      flat: json["flat"],
      locality: json["locality"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      pincode: json["pincode"],
      howToReach: json["howToReach"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customerId: json["customerId"],
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.firebaseId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.fbiid,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String? id;
  final String? firebaseId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? fbiid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"],
      firebaseId: json["firebase_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      fbiid: json["fbiid"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}

class OrderItem {
  OrderItem({
    required this.id,
    required this.units,
    required this.quantity,
    required this.deliveryTime,
    required this.returnWindow,
    required this.price,
    required this.convenienceFee,
    required this.returnable,
    required this.cancellable,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.santheOrderId,
    required this.productId,
    required this.product,
    required this.states,
  });

  final String? id;
  final int? units;
  final String? quantity;
  final dynamic deliveryTime;
  final int? returnWindow;
  final dynamic price;
  final dynamic convenienceFee;
  final bool? returnable;
  final bool? cancellable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? santheOrderId;
  final String? productId;
  final Product? product;
  final List<State> states;

  factory OrderItem.fromJson(Map<String, dynamic> json){
    return OrderItem(
      id: json["id"],
      units: json["units"],
      quantity: json["quantity"],
      deliveryTime: json["delivery_time"],
      returnWindow: json["return_window"],
      price: json["price"],
      convenienceFee: json["convenience_fee"],
      returnable: json["returnable"],
      cancellable: json["cancellable"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      santheOrderId: json["santheOrderId"],
      productId: json["productId"],
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      states: json["states"] == null ? [] : List<State>.from(json["states"]!.map((x) => State.fromJson(x))),
    );
  }

}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.inventory,
    required this.mrp,
    required this.offerPrice,
    required this.deliveryTime,
    required this.lat,
    required this.lang,
    required this.radius,
    required this.active,
    required this.displayImage,
    required this.returnable,
    required this.cancellable,
    required this.returnWindow,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.categoryId,
    required this.storeDescriptionId,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? quantity;
  final int? inventory;
  final dynamic mrp;
  final dynamic offerPrice;
  final dynamic deliveryTime;
  final String? lat;
  final String? lang;
  final dynamic radius;
  final bool? active;
  final String? displayImage;
  final bool? returnable;
  final bool? cancellable;
  final dynamic returnWindow;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? categoryId;
  final String? storeDescriptionId;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      quantity: json["quantity"],
      inventory: json["inventory"],
      mrp: json["mrp"],
      offerPrice: json["offer_price"],
      deliveryTime: json["delivery_time"],
      lat: json["lat"],
      lang: json["lang"],
      radius: json["radius"],
      active: json["active"],
      displayImage: json["display_image"],
      returnable: json["returnable"],
      cancellable: json["cancellable"],
      returnWindow: json["return_window"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      categoryId: json["categoryId"],
      storeDescriptionId: json["storeDescriptionId"],
    );
  }

}

class State {
  State({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.orderItemId,
    required this.santheOrderId,
    required this.supportId,
    required this.images,
  });

  final String? id;
  final String? title;
  final String? createdBy;
  final String? reason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? orderItemId;
  final String? santheOrderId;
  final dynamic supportId;
  final List<dynamic> images;

  factory State.fromJson(Map<String, dynamic> json){
    return State(
      id: json["id"],
      title: json["title"],
      createdBy: json["createdBy"],
      reason: json["reason"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      orderItemId: json["orderItemId"],
      santheOrderId: json["santheOrderId"],
      supportId: json["supportId"],
      images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
    );
  }

}

class Payment {
  Payment({
    required this.id,
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    required this.paymentStatus,
    required this.amountInCents,
    required this.transactionId,
    required this.type,
    required this.isCustomerSettled,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.orderId,
    required this.santheOrderId,
  });

  final String? id;
  final String? razorpayPaymentId;
  final String? razorpayOrderId;
  final bool? paymentStatus;
  final dynamic amountInCents;
  final dynamic transactionId;
  final dynamic type;
  final bool? isCustomerSettled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic orderId;
  final String? santheOrderId;

  factory Payment.fromJson(Map<String, dynamic> json){
    return Payment(
      id: json["id"],
      razorpayPaymentId: json["razorpay_payment_id"],
      razorpayOrderId: json["razorpay_order_id"],
      paymentStatus: json["payment_status"],
      amountInCents: json["amountInCents"],
      transactionId: json["transaction_id"],
      type: json["type"],
      isCustomerSettled: json["isCustomerSettled"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      orderId: json["orderId"],
      santheOrderId: json["santheOrderId"],
    );
  }

}

class StoreDescription {
  StoreDescription({
    required this.id,
    required this.name,
    required this.upiId,
    required this.bankAccountNo,
    required this.bankIfsc,
    required this.beneficiaryName,
    required this.gstin,
    required this.fulfillmentType,
    required this.description,
    required this.email,
    required this.address,
    required this.displayImage,
    required this.lat,
    required this.lang,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.customerId,
    required this.customer,
  });

  final String? id;
  final String? name;
  final String? upiId;
  final String? bankAccountNo;
  final String? bankIfsc;
  final String? beneficiaryName;
  final String? gstin;
  final String? fulfillmentType;
  final String? description;
  final String? email;
  final String? address;
  final String? displayImage;
  final String? lat;
  final String? lang;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? customerId;
  final Customer? customer;

  factory StoreDescription.fromJson(Map<String, dynamic> json){
    return StoreDescription(
      id: json["id"],
      name: json["name"],
      upiId: json["upi_id"],
      bankAccountNo: json["bank_account_no"],
      bankIfsc: json["bank_ifsc"],
      beneficiaryName: json["beneficiary_name"],
      gstin: json["gstin"],
      fulfillmentType: json["fulfillment_type"],
      description: json["description"],
      email: json["email"],
      address: json["address"],
      displayImage: json["display_image"],
      lat: json["lat"],
      lang: json["lang"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customerId: json["customerId"],
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    );
  }

}

class OrderInfoSupport {
  OrderInfoSupport({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.shortDescription,
    required this.longDescription,
    required this.issueType,
    required this.status,
    required this.itemId,
    required this.organisationName,
    required this.organisationPhone,
    required this.organisationEmail,
    required this.resolutionSupportEmail,
    required this.resolutionSupportChatLink,
    required this.resolutionSupportPhone,
    required this.groPhone,
    required this.groName,
    required this.groEmail,
    required this.resolution,
    required this.resolutionRemarks,
    required this.actionTriggered,
    required this.refundAmount,
    required this.resolutionAction,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.customerId,
    required this.orderId,
    required this.santheOrderId,
    required this.images,
    required this.supportState,
  });

  final String? id;
  final dynamic category;
  final dynamic subCategory;
  final dynamic shortDescription;
  final String? longDescription;
  final dynamic issueType;
  final dynamic status;
  final dynamic itemId;
  final dynamic organisationName;
  final dynamic organisationPhone;
  final dynamic organisationEmail;
  final dynamic resolutionSupportEmail;
  final dynamic resolutionSupportChatLink;
  final dynamic resolutionSupportPhone;
  final dynamic groPhone;
  final dynamic groName;
  final dynamic groEmail;
  final dynamic resolution;
  final dynamic resolutionRemarks;
  final dynamic actionTriggered;
  final dynamic refundAmount;
  final dynamic resolutionAction;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? customerId;
  final dynamic orderId;
  final String? santheOrderId;
  final List<dynamic> images;
  final List<SupportState> supportState;

  factory OrderInfoSupport.fromJson(Map<String, dynamic> json){
    return OrderInfoSupport(
      id: json["id"],
      category: json["category"],
      subCategory: json["sub_category"],
      shortDescription: json["short_description"],
      longDescription: json["long_description"],
      issueType: json["issue_type"],
      status: json["status"],
      itemId: json["itemId"],
      organisationName: json["organisation_name"],
      organisationPhone: json["organisation_phone"],
      organisationEmail: json["organisation_email"],
      resolutionSupportEmail: json["resolution_support_email"],
      resolutionSupportChatLink: json["resolution_support_chat_link"],
      resolutionSupportPhone: json["resolution_support_phone"],
      groPhone: json["gro_phone"],
      groName: json["gro_name"],
      groEmail: json["gro_email"],
      resolution: json["resolution"],
      resolutionRemarks: json["resolution_remarks"],
      actionTriggered: json["action_triggered"],
      refundAmount: json["refund_amount"],
      resolutionAction: json["resolution_action"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      customerId: json["customerId"],
      orderId: json["orderId"],
      santheOrderId: json["santheOrderId"],
      images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
      supportState: json["states"] == null ? [] : List<SupportState>.from(json["states"]!.map((x) => SupportState.fromJson(x))),

    );
  }
}

class SupportState {
  SupportState({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.orderItemId,
    required this.santheOrderId,
    required this.supportId,
  });

  final String? id;
  final String? title;
  final String? createdBy;
  final dynamic reason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic orderItemId;
  final dynamic santheOrderId;
  final String? supportId;

  factory SupportState.fromJson(Map<String, dynamic> json){
    return SupportState(
      id: json["id"],
      title: json["title"],
      createdBy: json["createdBy"],
      reason: json["reason"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
      orderItemId: json["orderItemId"],
      santheOrderId: json["santheOrderId"],
      supportId: json["supportId"],
    );
  }

}
