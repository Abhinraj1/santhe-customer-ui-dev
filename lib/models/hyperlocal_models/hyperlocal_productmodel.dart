// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark, must_be_immutable
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:santhe/core/loggers.dart';

class HyperLocalProductModel extends Equatable with LogMixin {
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic quantityValue;
  final dynamic quantityUnit;
  final dynamic inventory;
  final dynamic mrp;
  final dynamic offer_price;
  // final dynamic home_delivery;
  // final dynamic self_pickup;
  // final dynamic santhe_delivery;
  // final dynamic self_delivery;
  final dynamic delivery_time;
  final dynamic lat;
  final dynamic lang;
  final dynamic radius;
  final dynamic active;
  final dynamic display_image;
  final dynamic returnable;
  final dynamic window;
  final dynamic cancellable;
  final dynamic return_pickup;
  final dynamic categoryId;
  final dynamic storeDescriptionId;
  final dynamic images;
  bool? isAddedToCart = false;
  dynamic quantity = 1;
  dynamic total;
  dynamic discountpercent;
  HyperLocalProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantityValue,
    required this.quantityUnit,
    required this.inventory,
    required this.mrp,
    required this.offer_price,
    // required this.home_delivery,
    // required this.self_pickup,
    // required this.santhe_delivery,
    // required this.self_delivery,
    required this.delivery_time,
    required this.lat,
    required this.lang,
    required this.radius,
    required this.active,
    required this.display_image,
    required this.returnable,
    required this.window,
    required this.cancellable,
    required this.return_pickup,
    required this.categoryId,
    required this.storeDescriptionId,
    required this.images,
    this.isAddedToCart,
    required this.quantity,
    required this.total,
  });

  HyperLocalProductModel copyWith({
    dynamic? id,
    dynamic? name,
    dynamic? description,
    dynamic? quantityValue,
    dynamic? quantityUnit,
    dynamic? inventory,
    dynamic? mrp,
    dynamic? offer_price,
    // dynamic? home_delivery,
    dynamic? self_pickup,
    dynamic? santhe_delivery,
    dynamic? self_delivery,
    dynamic? delivery_time,
    dynamic? lat,
    dynamic? lang,
    dynamic? radius,
    dynamic? active,
    dynamic? display_image,
    dynamic? returnable,
    dynamic? window,
    dynamic? cancellable,
    dynamic? return_pickup,
    dynamic? categoryId,
    dynamic? storeDescriptionId,
    dynamic? images,
    bool? isAddedToCart,
    dynamic? quantity,
    dynamic? total,
  }) {
    return HyperLocalProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      inventory: inventory ?? this.inventory,
      mrp: mrp ?? this.mrp,
      offer_price: offer_price ?? this.offer_price,
      // home_delivery: home_delivery ?? this.home_delivery,
      // self_pickup: self_pickup ?? this.self_pickup,
      // santhe_delivery: santhe_delivery ?? this.santhe_delivery,
      // self_delivery: self_delivery ?? this.self_delivery,
      delivery_time: delivery_time ?? this.delivery_time,
      lat: lat ?? this.lat,
      lang: lang ?? this.lang,
      radius: radius ?? this.radius,
      active: active ?? this.active,
      display_image: display_image ?? this.display_image,
      returnable: returnable ?? this.returnable,
      window: window ?? this.window,
      cancellable: cancellable ?? this.cancellable,
      return_pickup: return_pickup ?? this.return_pickup,
      categoryId: categoryId ?? this.categoryId,
      storeDescriptionId: storeDescriptionId ?? this.storeDescriptionId,
      images: images ?? this.images,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toNewMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'quantityValue': quantityValue,
      'quantityUnit': quantityUnit,
      'inventory': inventory,
      'mrp': mrp,
      'offer_price': offer_price,
      // 'home_delivery': home_delivery,
      // 'self_pickup': self_pickup,
      // 'santhe_delivery': santhe_delivery,
      // 'self_delivery': self_delivery,
       'delivery_time': delivery_time,
      'lat': lat,
      'lang': lang,
      'radius': radius,
      'active': active,
      'display_image': display_image,
      'returnable': returnable,
      'window': window,
      'cancellable': cancellable,
      'return_pickup': return_pickup,
      'categoryId': categoryId,
      'storeDescriptionId': storeDescriptionId,
      'images': images,
    };
  }

  factory HyperLocalProductModel.fromNewMap(Map<String, dynamic> map) {
    log('$map', name: 'HyperLocalProductModel.fromMap');
    return HyperLocalProductModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      name: map['name'] != null ? map['name'] as dynamic : null,
      description:
          map['description'] != null ? map['description'] as dynamic : null,
      quantityValue: map['quantity'] != null
          ? map['quantity']['value'] != null
              ? map['quantity']['value'] as dynamic
              : null
          : null,
      quantityUnit: map['quantity'] != null
          ? map['quantity']['unit'] != null
              ? map['quantity']['unit'] as dynamic
              : null
          : null,
      inventory: map['inventory'] != null ? map['inventory'] as dynamic : null,
      mrp: map['mrp'] != null ? map['mrp'] as dynamic : null,
      offer_price: map['offer_price'] ? map['offer_price'] as dynamic : null,
      // home_delivery: map['fulfillment_type'] != null
      //     ? map['fulfillment_type']['home_delivery'] != null
      //         ? map['fulfillment_type']['home_delivery'] as dynamic
      //         : null
      //     : null,
      // self_pickup: map['fulfillment_type'] != null
      //     ? map['fulfillment_type']['self_pickup'] != null
      //         ? map['fulfillment_type']['self_pickup'] as dynamic
      //         : null
      //     : null,
      // santhe_delivery: map['fulfillment_type'] != null
      //     ? map['fulfillment_type']['home_delivery_type'] != null
      //         ? map['fulfillment_type']['home_delivery_type']
      //                     ['santhe_delivery'] !=
      //                 null
      //             ? map['fulfillment_type']['home_delivery_type']
      //                 ['santhe_delivery'] as dynamic
      //             : null
      //         : null
      //     : null,
      // self_delivery: map['fulfillment_type'] != null
      //     ? map['fulfillment_type']['home_delivery_type'] != null
      //         ? map['fulfillment_type']['home_delivery_type']
      //                     ['self_delivery'] !=
      //                 null
      //             ? map['fulfillment_type']['home_delivery_type']
      //                 ['self_delivery'] as dynamic
      //             : null
      //         : null
      //     : null,
      delivery_time: map['delivery_time'] as dynamic,
      lat: map['lat'] != null ? map['lat'] as dynamic : null,
      lang: map['lang'] != null ? map['lang'] as dynamic : null,
      radius: map['radius'] != null ? map['radius'] as dynamic : null,
      active: map['active'] != null ? map['active'] as dynamic : null,
      display_image:
          map['display_image'] ? map['display_image'] as dynamic : null,
      returnable: map['returnable'] != null
          ? map['returnable']['returnable'] != null
              ? map['returnable']['returnable'] as dynamic
              : null
          : null,
      window: map['returnable'] != null
          ? map['returnable']['window'] != null
              ? map['returnable']['window'] as dynamic
              : null
          : null,
      cancellable:
          map['cancellable'] != null ? map['cancellable'] as dynamic : null,
      return_pickup:
          map['return_pickup'] != null ? map['return_pickup'] as dynamic : null,
      categoryId:
          map['categoryId'] != null ? map['categoryId'] as dynamic : null,
      storeDescriptionId: map['storeDescriptionId'] != null
          ? map['storeDescriptionId'] as dynamic
          : null,
      images: map['images'] != null ? map['images'] as dynamic : null,
      quantity: map['quantity'] != null ? map['quantity'] as dynamic : null,
      total: map['total'] != null ? map['total'] as dynamic : null,
      isAddedToCart: false,
    );
  }

  add() {
    if (quantity < inventory) {
      quantity = quantity + 1;
      getTotal();
    }
  }

  bool addToCart() {
    if (inventory > 0) {
      isAddedToCart = true;
      getTotal();
      return true;
    }
    return false;
  }

  minus() {
    if (inventory != 1) {
      quantity = quantity - 1;
      getTotal();
    }
  }

  removeFromCart() {
    isAddedToCart = false;
    // quantity = 0;
  }

  getTotal() {
    total = quantity * offer_price;
    warningLog('$total');
  }

  String toJson() => json.encode(toMap());

  factory HyperLocalProductModel.fromJson(String source) =>
      HyperLocalProductModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      quantityValue,
      quantityUnit,
      inventory,
      mrp,
      offer_price,
      // home_delivery,
      // self_pickup,
      // santhe_delivery,
      // self_delivery,
      delivery_time,
      lat,
      lang,
      radius,
      active,
      display_image,
      returnable,
      window,
      cancellable,
      return_pickup,
      categoryId,
      storeDescriptionId,
      images,
      isAddedToCart,
      quantity,
      total,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'quantityValue': quantityValue,
      'quantityUnit': quantityUnit,
      'inventory': inventory,
      'mrp': mrp,
      'offer_price': offer_price,
      // 'home_delivery': home_delivery,
      // 'self_pickup': self_pickup,
      // 'santhe_delivery': santhe_delivery,
      // 'self_delivery': self_delivery,
      'delivery_time': delivery_time,
      'lat': lat,
      'lang': lang,
      'radius': radius,
      'active': active,
      'display_image': display_image,
      'returnable': returnable,
      'window': window,
      'cancellable': cancellable,
      'return_pickup': return_pickup,
      'categoryId': categoryId,
      'storeDescriptionId': storeDescriptionId,
      'images': images,
    };
  }

  factory HyperLocalProductModel.fromMap(Map<String, dynamic> map) {
    return HyperLocalProductModel(
      id: map['id'] as dynamic,
      name: map['name'] as dynamic,
      description: map['description'] as dynamic,
      quantityValue: map['quantity']['value'] as dynamic,
      quantityUnit: map['quantity']['unit'] as dynamic,
      inventory: map['inventory'] as dynamic,
      mrp: map['mrp'] as dynamic,
      offer_price: map['offer_price'] as dynamic,
      // home_delivery: map['fulfillment_type']['home_delivery'] as dynamic,
      // self_pickup: map['fulfillment_type']['self_pickup'] as dynamic,
      // santhe_delivery: map['fulfillment_type'] != null
      //     ? map['fulfillment_type']['home_delivery_type'] != null
      //         ? map['fulfillment_type']['home_delivery_type']
      //                     ['santhe_delivery'] !=
      //                 null
      //             ? map['fulfillment_type']['home_delivery_type']
      //                 ['santhe_delivery'] as dynamic
      //             : null
      //         : null
      //     : null,
      // self_delivery: map['fulfillment_type'] != null
      //     ? map['fulfillment_type']['home_delivery_type'] != null
      //         ? map['fulfillment_type']['home_delivery_type']
      //                     ['self_delivery'] !=
      //                 null
      //             ? map['fulfillment_type']['home_delivery_type']
      //                 ['self_delivery'] as dynamic
      //             : null
      //         : null
      //     : null,
      delivery_time: map['delivery_time'] as dynamic ,
      lat: map['lat'] as dynamic,
      lang: map['lang'] as dynamic,
      radius: map['radius'] as dynamic,
      active: map['active'] as dynamic,
      display_image: map['display_image'] as dynamic,
      returnable:
          map['returnable'] != null ? map['returnable'] as dynamic : null,
      window:
          map['return_window'] != null ? map['return_window'] as dynamic : null,
      cancellable: map['cancellable'] as dynamic,
      return_pickup: map['return_pickup'] as dynamic,
      categoryId: map['categoryId'] as dynamic,
      storeDescriptionId: map['storeDescriptionId'] as dynamic,
      images: map['images'] as dynamic,
      quantity: map['quantity'] != null ? map['quantity'] as dynamic : null,
      total: map['total'] != null ? map['total'] as dynamic : null,
      isAddedToCart: false,
    );
  }
}
