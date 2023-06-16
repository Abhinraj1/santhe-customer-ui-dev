// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_question_mark, non_constant_identifier_names, must_be_immutable
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class HyperlocalOrderDetailModel extends Equatable {
  final dynamic id;
  final dynamic order_id;
  final dynamic delivery_charge;
  final dynamic tax;
  final dynamic convenience_fee;
  final dynamic sub_total;
  final dynamic total_amount;
  final dynamic deliveryAddressId;
  final dynamic billingAddressId;
  final dynamic createdAt;
  final dynamic customerId;
  final dynamic storeDescriptionId;
  final dynamic orderItems;
  final dynamic customerFirebaseId;
  final dynamic customerNamel;
  final dynamic customerLastName;
  final dynamic customerEmail;
  final dynamic statesId;
  final dynamic statesTitle;
  final dynamic statescreatedBy;
  final dynamic statesReason;
  final dynamic statesSantheOrderId;
  final dynamic statesSupportId;
  // final dynamic deliveryAddressIdMapId;
  // final dynamic deliveryAddressIdMapAddressName;
  // final dynamic deliveryAddressIdMapLat;
  // final dynamic deliveryAddressIdMapLng;
  // final dynamic deliveryAddressIdMapFlat;
  // final dynamic deliveryAddressIdMapLocality;
  // final dynamic deliveryAddressIdMapCity;
  // final dynamic deliveryAddressIdMapState;
  // final dynamic deliveryAddressIdMapCountry;
  // final dynamic deliveryAddressIdMapPincode;
  // final dynamic deliveryAddressIdMapHowToReach;
  // final dynamic deliveryAddressIdMapCustomerId;
  // final dynamic billingAddressMapId;
  // final dynamic billingAddressMapAddressName;
  // final dynamic billingAddressMapLat;
  // final dynamic billingAddressMapLng;
  // final dynamic billingAddressMapFlat;
  // final dynamic billingAddressMapLocality;
  // final dynamic billingAddressMapCity;
  // final dynamic billingAddressMapState;
  // final dynamic billingAddressMapCountry;
  // final dynamic billingAddressMapPincode;
  // final dynamic billingAddressMap;
  dynamic formattedDate;
  HyperlocalOrderDetailModel({
    required this.id,
    required this.order_id,
    required this.delivery_charge,
    required this.tax,
    required this.convenience_fee,
    required this.sub_total,
    required this.total_amount,
    required this.deliveryAddressId,
    required this.billingAddressId,
    required this.createdAt,
    required this.customerId,
    required this.storeDescriptionId,
    required this.orderItems,
    required this.customerFirebaseId,
    required this.customerNamel,
    required this.customerLastName,
    required this.customerEmail,
    required this.statesId,
    required this.statesTitle,
    required this.statescreatedBy,
    required this.statesReason,
    required this.statesSantheOrderId,
    required this.statesSupportId,
    // required this.deliveryAddressIdMapId,
    // required this.deliveryAddressIdMapAddressName,
    // required this.deliveryAddressIdMapLat,
    // required this.deliveryAddressIdMapLng,
    // required this.deliveryAddressIdMapFlat,
    // required this.deliveryAddressIdMapLocality,
    // required this.deliveryAddressIdMapCity,
    // required this.deliveryAddressIdMapState,
    // required this.deliveryAddressIdMapCountry,
    // required this.deliveryAddressIdMapPincode,
    // required this.deliveryAddressIdMapHowToReach,
    // required this.deliveryAddressIdMapCustomerId,
    // required this.billingAddressMapId,
    // required this.billingAddressMapAddressName,
    // required this.billingAddressMapLat,
    // required this.billingAddressMapLng,
    // required this.billingAddressMapFlat,
    // required this.billingAddressMapLocality,
    // required this.billingAddressMapCity,
    // required this.billingAddressMapState,
    // required this.billingAddressMapCountry,
    // required this.billingAddressMapPincode,
    // required this.billingAddressMap,
  });

  HyperlocalOrderDetailModel copyWith({
    dynamic? id,
    dynamic? order_id,
    dynamic? delivery_charge,
    dynamic? tax,
    dynamic? convenience_fee,
    dynamic? sub_total,
    dynamic? total_amount,
    dynamic? deliveryAddressId,
    dynamic? billingAddressId,
    dynamic? createdAt,
    dynamic? customerId,
    dynamic? storeDescriptionId,
    dynamic? orderItems,
    dynamic? customerFirebaseId,
    dynamic? customerNamel,
    dynamic? customerLastName,
    dynamic? customerEmail,
    dynamic? statesId,
    dynamic? statesTitle,
    dynamic? statescreatedBy,
    dynamic? statesReason,
    dynamic? statesSantheOrderId,
    dynamic? statesSupportId,
    dynamic? deliveryAddressIdMapId,
    dynamic? deliveryAddressIdMapAddressName,
    dynamic? deliveryAddressIdMapLat,
    dynamic? deliveryAddressIdMapLng,
    dynamic? deliveryAddressIdMapFlat,
    dynamic? deliveryAddressIdMapLocality,
    dynamic? deliveryAddressIdMapCity,
    dynamic? deliveryAddressIdMapState,
    dynamic? deliveryAddressIdMapCountry,
    dynamic? deliveryAddressIdMapPincode,
    dynamic? deliveryAddressIdMapHowToReach,
    dynamic? deliveryAddressIdMapCustomerId,
    dynamic? billingAddressMapId,
    dynamic? billingAddressMapAddressName,
    dynamic? billingAddressMapLat,
    dynamic? billingAddressMapLng,
    dynamic? billingAddressMapFlat,
    dynamic? billingAddressMapLocality,
    dynamic? billingAddressMapCity,
    dynamic? billingAddressMapState,
    dynamic? billingAddressMapCountry,
    dynamic? billingAddressMapPincode,
    dynamic? billingAddressMap,
  }) {
    return HyperlocalOrderDetailModel(
      id: id ?? this.id,
      order_id: order_id ?? this.order_id,
      delivery_charge: delivery_charge ?? this.delivery_charge,
      tax: tax ?? this.tax,
      convenience_fee: convenience_fee ?? this.convenience_fee,
      sub_total: sub_total ?? this.sub_total,
      total_amount: total_amount ?? this.total_amount,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      billingAddressId: billingAddressId ?? this.billingAddressId,
      createdAt: createdAt ?? this.createdAt,
      customerId: customerId ?? this.customerId,
      storeDescriptionId: storeDescriptionId ?? this.storeDescriptionId,
      orderItems: orderItems ?? this.orderItems,
      customerFirebaseId: customerFirebaseId ?? this.customerFirebaseId,
      customerNamel: customerNamel ?? this.customerNamel,
      customerLastName: customerLastName ?? this.customerLastName,
      customerEmail: customerEmail ?? this.customerEmail,
      statesId: statesId ?? this.statesId,
      statesTitle: statesTitle ?? this.statesTitle,
      statescreatedBy: statescreatedBy ?? this.statescreatedBy,
      statesReason: statesReason ?? this.statesReason,
      statesSantheOrderId: statesSantheOrderId ?? this.statesSantheOrderId,
      statesSupportId: statesSupportId ?? this.statesSupportId,
      // deliveryAddressIdMapId:
      //     deliveryAddressIdMapId ?? this.deliveryAddressIdMapId,
      // deliveryAddressIdMapAddressName: deliveryAddressIdMapAddressName ??
      //     this.deliveryAddressIdMapAddressName,
      // deliveryAddressIdMapLat:
      //     deliveryAddressIdMapLat ?? this.deliveryAddressIdMapLat,
      // deliveryAddressIdMapLng:
      //     deliveryAddressIdMapLng ?? this.deliveryAddressIdMapLng,
      // deliveryAddressIdMapFlat:
      //     deliveryAddressIdMapFlat ?? this.deliveryAddressIdMapFlat,
      // deliveryAddressIdMapLocality:
      //     deliveryAddressIdMapLocality ?? this.deliveryAddressIdMapLocality,
      // deliveryAddressIdMapCity:
      //     deliveryAddressIdMapCity ?? this.deliveryAddressIdMapCity,
      // deliveryAddressIdMapState:
      //     deliveryAddressIdMapState ?? this.deliveryAddressIdMapState,
      // deliveryAddressIdMapCountry:
      //     deliveryAddressIdMapCountry ?? this.deliveryAddressIdMapCountry,
      // deliveryAddressIdMapPincode:
      //     deliveryAddressIdMapPincode ?? this.deliveryAddressIdMapPincode,
      // deliveryAddressIdMapHowToReach:
      //     deliveryAddressIdMapHowToReach ?? this.deliveryAddressIdMapHowToReach,
      // deliveryAddressIdMapCustomerId:
      //     deliveryAddressIdMapCustomerId ?? this.deliveryAddressIdMapCustomerId,
      // billingAddressMapId: billingAddressMapId ?? this.billingAddressMapId,
      // billingAddressMapAddressName:
      //     billingAddressMapAddressName ?? this.billingAddressMapAddressName,
      // billingAddressMapLat: billingAddressMapLat ?? this.billingAddressMapLat,
      // billingAddressMapLng: billingAddressMapLng ?? this.billingAddressMapLng,
      // billingAddressMapFlat:
      //     billingAddressMapFlat ?? this.billingAddressMapFlat,
      // billingAddressMapLocality:
      //     billingAddressMapLocality ?? this.billingAddressMapLocality,
      // billingAddressMapCity:
      //     billingAddressMapCity ?? this.billingAddressMapCity,
      // billingAddressMapState:
      //     billingAddressMapState ?? this.billingAddressMapState,
      // billingAddressMapCountry:
      //     billingAddressMapCountry ?? this.billingAddressMapCountry,
      // billingAddressMapPincode:
      //     billingAddressMapPincode ?? this.billingAddressMapPincode,
      // billingAddressMap: billingAddressMap ?? this.billingAddressMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order_id': order_id,
      'delivery_charge': delivery_charge,
      'tax': tax,
      'convenience_fee': convenience_fee,
      'sub_total': sub_total,
      'total_amount': total_amount,
      'deliveryAddressId': deliveryAddressId,
      'billingAddressId': billingAddressId,
      'createdAt': createdAt,
      'customerId': customerId,
      'storeDescriptionId': storeDescriptionId,
      'orderItems': orderItems,
      'customerFirebaseId': customerFirebaseId,
      'customerNamel': customerNamel,
      'customerLastName': customerLastName,
      'customerEmail': customerEmail,
      'statesId': statesId,
      'statesTitle': statesTitle,
      'statescreatedBy': statescreatedBy,
      'statesReason': statesReason,
      'statesSantheOrderId': statesSantheOrderId,
      'statesSupportId': statesSupportId,
      // 'deliveryAddressIdMapId': deliveryAddressIdMapId,
      // 'deliveryAddressIdMapAddressName': deliveryAddressIdMapAddressName,
      // 'deliveryAddressIdMapLat': deliveryAddressIdMapLat,
      // 'deliveryAddressIdMapLng': deliveryAddressIdMapLng,
      // 'deliveryAddressIdMapFlat': deliveryAddressIdMapFlat,
      // 'deliveryAddressIdMapLocality': deliveryAddressIdMapLocality,
      // 'deliveryAddressIdMapCity': deliveryAddressIdMapCity,
      // 'deliveryAddressIdMapState': deliveryAddressIdMapState,
      // 'deliveryAddressIdMapCountry': deliveryAddressIdMapCountry,
      // 'deliveryAddressIdMapPincode': deliveryAddressIdMapPincode,
      // 'deliveryAddressIdMapHowToReach': deliveryAddressIdMapHowToReach,
      // 'deliveryAddressIdMapCustomerId': deliveryAddressIdMapCustomerId,
      // 'billingAddressMapId': billingAddressMapId,
      // 'billingAddressMapAddressName': billingAddressMapAddressName,
      // 'billingAddressMapLat': billingAddressMapLat,
      // 'billingAddressMapLng': billingAddressMapLng,
      // 'billingAddressMapFlat': billingAddressMapFlat,
      // 'billingAddressMapLocality': billingAddressMapLocality,
      // 'billingAddressMapCity': billingAddressMapCity,
      // 'billingAddressMapState': billingAddressMapState,
      // 'billingAddressMapCountry': billingAddressMapCountry,
      // 'billingAddressMapPincode': billingAddressMapPincode,
      // 'billingAddressMap': billingAddressMap,
    };
  }

  factory HyperlocalOrderDetailModel.fromMap(Map<String, dynamic> map) {
    List state = map['states'] as List;
    // log('${map['customer']}, ${state.first}',
    //     name: 'HyperlocalOrderDetailModel.fromMap');
    return HyperlocalOrderDetailModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      order_id: map['order_id'] != null ? map['order_id'] as dynamic : null,
      delivery_charge: map['delivery_charge'] as dynamic,
      tax: map['tax'] != null ? map['tax'] as dynamic : null,
      convenience_fee: map['convenience_fee'] != null
          ? map['convenience_fee'] as dynamic
          : null,
      sub_total: map['sub_total'] != null ? map['sub_total'] as dynamic : null,
      total_amount:
          map['total_amount'] != null ? map['total_amount'] as dynamic : null,
      deliveryAddressId: map['deliveryAddressId'] != null
          ? map['deliveryAddressId'] as dynamic
          : null,
      billingAddressId: map['billingAddressId'] != null
          ? map['billingAddressId'] as dynamic
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as dynamic : null,
      customerId:
          map['customerId'] != null ? map['customerId'] as dynamic : null,
      storeDescriptionId: map['storeDescriptionId'] as dynamic,
      orderItems: map['orderItems'] as dynamic,
      customerFirebaseId: map['customer'] != null
          ? map['customer']['firebase_id'] as dynamic
          : null,
      customerNamel: map['customer'] != null
          ? map['customer']['first_name'] as dynamic
          : null,
      customerLastName: map['customer'] != null
          ? map['customer']['last_name'] as dynamic
          : null,
      customerEmail:
          map['customer'] != null ? map['customer']['email'] as dynamic : null,
      statesId: state.first['id'] != null ? state.first['id'] as dynamic : null,
      statesTitle:
          state.first['title'] != null ? state.first['title'] as dynamic : null,
      statescreatedBy: state.first['createdBy'] != null
          ? state.first['createdBy'] as dynamic
          : null,
      statesReason: state.first['reason'] != null
          ? state.first['reason'] as dynamic
          : null,
      statesSantheOrderId: state.first['santheOrderId'] != null
          ? state.first['santheOrderId'] as dynamic
          : null,
      statesSupportId: state.first['supportId'] != null
          ? state.first['supportId'] as dynamic
          : null,
      // deliveryAddressIdMapId: map['deliveryAddress'] != null
      //     ? map['deliveryAddress']['id'] as dynamic
      //     : null,
      // deliveryAddressIdMapAddressName: map['deliveryAddress'] != null
      //     ? map['deliveryAddress']['address_name'] as dynamic
      //     : null,
      // deliveryAddressIdMapLat: map['deliveryAddress'] != null
      //     ? map['deliveryAddress']['lat'] as dynamic
      //     : null,
      // deliveryAddressIdMapLng: map['deliveryAddress'] != null
      //     ? map['deliveryAddress']['lng'] as dynamic
      //     : null,
      // deliveryAddressIdMapFlat: map['deliveryAddress']
      //     ? map['deliveryAddress']['flat'] as dynamic
      //     : null,
      // deliveryAddressIdMapLocality: map['deliveryAddress']
      //     ? map['deliveryAddress']['locality'] as dynamic
      //     : null,
      // deliveryAddressIdMapCity: map['deliveryAddress']
      //     ? map['deliveryAddress']['city'] as dynamic
      //     : null,
      // deliveryAddressIdMapState: map['deliveryAddress']
      //     ? map['deliveryAddress']['state'] as dynamic
      //     : null,
      // deliveryAddressIdMapCountry: map['deliveryAddress']
      //     ? map['deliveryAddress']['lng'] as dynamic
      //     : null,
      // deliveryAddressIdMapPincode: map['deliveryAddress']
      //     ? map['deliveryAddress']['pincode'] as dynamic
      //     : null,
      // deliveryAddressIdMapHowToReach: map['deliveryAddress'] != null
      //     ? map['deliveryAddress']['howToReach'] as dynamic
      //     : null,
      // deliveryAddressIdMapCustomerId: map['deliveryAddress']
      //     ? map['deliveryAddress']['customerId'] as dynamic
      //     : null,
      // billingAddressMapId: map['billingAddress'] != null
      //     ? map['billingAddress']['id'] as dynamic
      //     : null,
      // billingAddressMapAddressName: map['billingAddress'] != null
      //     ? map['billingAddress']['address_name'] as dynamic
      //     : null,
      // billingAddressMapLat: map['billingAddress'] != null
      //     ? map['billingAddress']['lat'] as dynamic
      //     : null,
      // billingAddressMapLng: map['billingAddress'] != null
      //     ? map['billingAddress']['lng'] as dynamic
      //     : null,
      // billingAddressMapFlat: map['billingAddress'] != null
      //     ? map['billingAddress']['flat'] as dynamic
      //     : null,
      // billingAddressMapLocality: map['billingAddress'] != null
      //     ? map['billingAddress']['locality'] as dynamic
      //     : null,
      // billingAddressMapCity: map['billingAddress'] != null
      //     ? map['billingAddress']['city'] as dynamic
      //     : null,
      // billingAddressMapState: map['billingAddress'] != null
      //     ? map['billingAddress']['state'] as dynamic
      //     : null,
      // billingAddressMapCountry: map['billingAddress'] != null
      //     ? map['billingAddress']['country'] as dynamic
      //     : null,
      // billingAddressMapPincode: map['billingAddress'] != null
      //     ? map['billingAddress']['pincode'] as dynamic
      //     : null,
      // billingAddressMap: map['billingAddress'] != null
      //     ? map['billingAddress']['customerId'] as dynamic
      //     : null,
    );
  }

  getFormattedData() {
    dynamic newFormattedDate = DateTime.parse(createdAt);
    formattedDate = DateFormat.yMd().format(newFormattedDate);
    log('Formatted Date $formattedDate', name: 'hyperlocal_orderdetail.dart');
  }

  String toJson() => json.encode(toMap());

  factory HyperlocalOrderDetailModel.fromJson(String source) =>
      HyperlocalOrderDetailModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      order_id,
      delivery_charge,
      tax,
      convenience_fee,
      sub_total,
      total_amount,
      deliveryAddressId,
      billingAddressId,
      createdAt,
      customerId,
      storeDescriptionId,
      orderItems,
      customerFirebaseId,
      customerNamel,
      customerLastName,
      customerEmail,
      statesId,
      statesTitle,
      statescreatedBy,
      statesReason,
      statesSantheOrderId,
      statesSupportId,
      // deliveryAddressIdMapId,
      // deliveryAddressIdMapAddressName,
      // deliveryAddressIdMapLat,
      // deliveryAddressIdMapLng,
      // deliveryAddressIdMapFlat,
      // deliveryAddressIdMapLocality,
      // deliveryAddressIdMapCity,
      // deliveryAddressIdMapState,
      // deliveryAddressIdMapCountry,
      // deliveryAddressIdMapPincode,
      // deliveryAddressIdMapHowToReach,
      // deliveryAddressIdMapCustomerId,
      // billingAddressMapId,
      // billingAddressMapAddressName,
      // billingAddressMapLat,
      // billingAddressMapLng,
      // billingAddressMapFlat,
      // billingAddressMapLocality,
      // billingAddressMapCity,
      // billingAddressMapState,
      // billingAddressMapCountry,
      // billingAddressMapPincode,
      // billingAddressMap,
    ];
  }
}
