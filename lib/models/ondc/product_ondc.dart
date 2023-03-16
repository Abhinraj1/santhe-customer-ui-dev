// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark, must_be_immutable, prefer_if_null_operators
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:santhe/core/loggers.dart';

class ProductOndcModel extends Equatable with LogMixin {
  final dynamic id;
  final dynamic transaction_id;
  final dynamic generic_name;
  final dynamic ondc_item_id;
  final dynamic cancellable;
  final dynamic ondc_location_id;
  final dynamic name;
  final dynamic short_description;
  final dynamic long_description;
  final dynamic returnable;
  final dynamic isVeg;
  final dynamic time_to_ship;
  final dynamic rating;
  final dynamic storeId;
  final dynamic customer_care;
  final dynamic return_window;
  final dynamic seller_pickup_return;
  final dynamic symbol;
  final dynamic available;
  final dynamic maximum;
  final dynamic itemPriceId;
  final dynamic itemPriceCurrency;
  final dynamic estimated_value;
  final dynamic computed_value;
  final dynamic listed_value;
  final dynamic offered_value;
  final dynamic minimum_value;
  final dynamic maximum_value;
  final dynamic net_quantity;
  final dynamic storeLocationId;
  final dynamic importer_FSSAI_license_no;
  final dynamic other_FSSAI_license_no;
  final dynamic additives_info;
  final dynamic brand_owner_FSSAI_license_no;
  final dynamic nutritional_info;
  final dynamic fulfillment_id;
  final dynamic fulfillmentId;
  final dynamic ondc_fullfilment_type;
  final dynamic packer_name;
  final dynamic packer_address;
  final dynamic value;
  final dynamic back_image_url;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic itemId;
  final dynamic categoryId;
  final dynamic category;
  final dynamic manufacture_date;
  bool? isAddedToCart = false;
  dynamic quantity = 1;
  dynamic total;
  final List<dynamic>? images;
  ProductOndcModel({
    required this.id,
    required this.transaction_id,
    required this.generic_name,
    required this.ondc_item_id,
    required this.cancellable,
    required this.ondc_location_id,
    required this.name,
    required this.short_description,
    required this.long_description,
    required this.returnable,
    required this.isVeg,
    required this.time_to_ship,
    required this.rating,
    required this.storeId,
    required this.customer_care,
    required this.return_window,
    required this.seller_pickup_return,
    required this.symbol,
    required this.available,
    required this.maximum,
    required this.itemPriceId,
    required this.itemPriceCurrency,
    required this.estimated_value,
    required this.computed_value,
    required this.listed_value,
    required this.offered_value,
    required this.minimum_value,
    required this.maximum_value,
    required this.net_quantity,
    required this.storeLocationId,
    required this.importer_FSSAI_license_no,
    required this.other_FSSAI_license_no,
    required this.additives_info,
    required this.brand_owner_FSSAI_license_no,
    required this.nutritional_info,
    required this.fulfillment_id,
    required this.fulfillmentId,
    required this.ondc_fullfilment_type,
    required this.packer_name,
    required this.packer_address,
    required this.value,
    required this.back_image_url,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.itemId,
    required this.categoryId,
    required this.category,
    required this.manufacture_date,
    this.isAddedToCart,
    this.quantity,
    this.total,
    required this.images,
  });

  ProductOndcModel copyWith({
    dynamic? id,
    dynamic? transaction_id,
    dynamic? generic_name,
    dynamic? ondc_item_id,
    dynamic? cancellable,
    dynamic? ondc_location_id,
    dynamic? name,
    dynamic? short_description,
    dynamic? long_description,
    dynamic? returnable,
    dynamic? isVeg,
    dynamic? time_to_ship,
    dynamic? rating,
    dynamic? storeId,
    dynamic? customer_care,
    dynamic? return_window,
    dynamic? seller_pickup_return,
    dynamic? symbol,
    dynamic? available,
    dynamic? maximum,
    dynamic? itemPriceId,
    dynamic? itemPriceCurrency,
    dynamic? estimated_value,
    dynamic? computed_value,
    dynamic? listed_value,
    dynamic? offered_value,
    dynamic? minimum_value,
    dynamic? maximum_value,
    dynamic? net_quantity,
    dynamic? storeLocationId,
    dynamic? importer_FSSAI_license_no,
    dynamic? other_FSSAI_license_no,
    dynamic? additives_info,
    dynamic? brand_owner_FSSAI_license_no,
    dynamic? nutritional_info,
    dynamic? fulfillment_id,
    dynamic? fulfillmentId,
    dynamic? ondc_fullfilment_type,
    dynamic? packer_name,
    dynamic? packer_address,
    dynamic? value,
    dynamic? back_image_url,
    dynamic? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
    dynamic? itemId,
    dynamic? categoryId,
    dynamic? category,
    dynamic? manufacture_date,
    bool? isAddedToCart,
    dynamic? quantity,
    dynamic? total,
    List<dynamic>? images,
  }) {
    return ProductOndcModel(
      id: id ?? this.id,
      transaction_id: transaction_id ?? this.transaction_id,
      generic_name: generic_name ?? this.generic_name,
      ondc_item_id: ondc_item_id ?? this.ondc_item_id,
      cancellable: cancellable ?? this.cancellable,
      ondc_location_id: ondc_location_id ?? this.ondc_location_id,
      name: name ?? this.name,
      short_description: short_description ?? this.short_description,
      long_description: long_description ?? this.long_description,
      returnable: returnable ?? this.returnable,
      isVeg: isVeg ?? this.isVeg,
      time_to_ship: time_to_ship ?? this.time_to_ship,
      rating: rating ?? this.rating,
      storeId: storeId ?? this.storeId,
      customer_care: customer_care ?? this.customer_care,
      return_window: return_window ?? this.return_window,
      seller_pickup_return: seller_pickup_return ?? this.seller_pickup_return,
      symbol: symbol ?? this.symbol,
      available: available ?? this.available,
      maximum: maximum ?? this.maximum,
      itemPriceId: itemPriceId ?? this.itemPriceId,
      itemPriceCurrency: itemPriceCurrency ?? this.itemPriceCurrency,
      estimated_value: estimated_value ?? this.estimated_value,
      computed_value: computed_value ?? this.computed_value,
      listed_value: listed_value ?? this.listed_value,
      offered_value: offered_value ?? this.offered_value,
      minimum_value: minimum_value ?? this.minimum_value,
      maximum_value: maximum_value ?? this.maximum_value,
      net_quantity: net_quantity ?? this.net_quantity,
      storeLocationId: storeLocationId ?? this.storeLocationId,
      importer_FSSAI_license_no:
          importer_FSSAI_license_no ?? this.importer_FSSAI_license_no,
      other_FSSAI_license_no:
          other_FSSAI_license_no ?? this.other_FSSAI_license_no,
      additives_info: additives_info ?? this.additives_info,
      brand_owner_FSSAI_license_no:
          brand_owner_FSSAI_license_no ?? this.brand_owner_FSSAI_license_no,
      nutritional_info: nutritional_info ?? this.nutritional_info,
      fulfillment_id: fulfillment_id ?? this.fulfillment_id,
      fulfillmentId: fulfillmentId ?? this.fulfillmentId,
      ondc_fullfilment_type:
          ondc_fullfilment_type ?? this.ondc_fullfilment_type,
      packer_name: packer_name ?? this.packer_name,
      packer_address: packer_address ?? this.packer_address,
      value: value ?? this.value,
      back_image_url: back_image_url ?? this.back_image_url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      manufacture_date: manufacture_date ?? this.manufacture_date,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transaction_id': transaction_id,
      'ondc_item_id': ondc_item_id,
      'name': name,
      'short_description': short_description,
      'long_description': long_description,
      'returnable': returnable,
      'isVeg': isVeg,
      'time_to_ship': time_to_ship,
      'rating': rating,
      'storeId': storeId,
      'customer_care': customer_care,
      'return_window': return_window,
      'seller_pickup_return': seller_pickup_return,
      'symbol': symbol,
      'available': available,
      'maximum': maximum,
      'itemPriceId': itemPriceId,
      'itemPriceCurrency': itemPriceCurrency,
      'estimated_value': estimated_value,
      'computed_value': computed_value,
      'ondc_location_id': ondc_location_id,
      'listed_value': listed_value,
      'offered_value': offered_value,
      'minimum_value': minimum_value,
      'maximum_value': maximum_value,
      'value': value,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'itemId': itemId,
      'images': images,
      'quantity': quantity,
      'isAddedToCart': isAddedToCart,
      'category_id': categoryId,
      'net_quantity': net_quantity,
      'packer_name': packer_name,
      'packer_address': packer_address,
      'nutritional_info': nutritional_info,
      'importer_FSSAI_license_no': importer_FSSAI_license_no,
      'other_FSSAI_license_no': other_FSSAI_license_no,
      'back_image_url': back_image_url,
      'additives_info': additives_info,
      'brand_owner_FSSAI_license_no': brand_owner_FSSAI_license_no,
      'fulfillment_id': fulfillment_id,
      'fulfillmentId': fulfillmentId,
      'total': total,
      'generic_name': generic_name,
      'cancellable': cancellable
    };
  }

  factory ProductOndcModel.fromNewMap(Map<String, dynamic> map) {
    return ProductOndcModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      cancellable:
          map['cancellable'] != null ? map['cancellable'] as dynamic : null,
      manufacture_date:
          map['manufacture_date'] != null ? map['manufacture_date'] : null,
      generic_name:
          map['generic_name'] != null ? map['generic_name'] as dynamic : null,
      storeLocationId: map['storeLocationId'] != null
          ? map['storeLocationId'] as dynamic
          : null,
      ondc_fullfilment_type: map['fulfillment'] != null
          ? map['fulfillment']['ondc_fullfilment_type'] != null
              ? map['fulfillment']['ondc_fullfilment_type'] as dynamic
              : null
          : null,
      fulfillmentId:
          map['fulfillmentId'] != null ? map['fulfillmentId'] as dynamic : null,
      back_image_url: map['back_image_url'] != null
          ? map['back_image_url'] as dynamic
          : null,
      fulfillment_id: map['fulfillment_id'] != null
          ? map['fulfillment_id'] as dynamic
          : null,
      quantity: map['quantity'] != null ? map['quantity'] as dynamic : 0,
      other_FSSAI_license_no: map['other_FSSAI_license_no'] != null
          ? map['other_FSSAI_license_no'] as dynamic
          : null,
      importer_FSSAI_license_no: map['importer_FSSAI_license_no'] != null
          ? map['importer_FSSAI_license_no'] as dynamic
          : null,
      nutritional_info:
          map['nutritional_info'] != null ? map['nutritional_info'] : null,
      packer_name:
          map['packer_name'] != null ? map['packer_name'] as dynamic : null,
      packer_address: map['packer_address'] != null
          ? map['packer_address'] as dynamic
          : null,
      additives_info:
          map['additives_info'] != null ? map['additives_info'] : null,
      brand_owner_FSSAI_license_no: map['brand_owner_FSSAI_license_no'] != null
          ? map['brand_owner_FSSAI_license_no'] as dynamic
          : null,
      net_quantity:
          map['net_quantity'] != null ? map['net_quantity'] as dynamic : 0,
      category: map['category'] != null ? map['category'] as dynamic : null,
      isAddedToCart:
          map['isAddedToCart'] != null ? map['isAddedToCart'] as bool : false,
      transaction_id: map['transaction_id'] != null
          ? map['transaction_id'] as dynamic
          : null,
      ondc_item_id:
          map['ondc_item_id'] != null ? map['ondc_item_id'] as dynamic : null,
      name: map['name'] != null ? map['name'] as dynamic : null,
      short_description: map['short_description'] != null
          ? map['short_description'] as dynamic
          : null,
      long_description: map['long_description'] != null
          ? map['long_description'] as dynamic
          : null,
      returnable:
          map['returnable'] != null ? map['returnable'] as dynamic : null,
      isVeg: map['isVeg'] != null ? map['isVeg'] as dynamic : null,
      time_to_ship:
          map['time_to_ship'] != null ? map['time_to_ship'] as dynamic : null,
      rating: map['rating'] != null ? map['rating'] as dynamic : null,
      storeId: map['storeId'] != null ? map['storeId'] as dynamic : null,
      customer_care:
          map['customer_care'] != null ? map['customer_care'] as dynamic : null,
      return_window:
          map['return_window'] != null ? map['return_window'] as dynamic : null,
      seller_pickup_return: map['seller_pickup_return'] != null
          ? map['seller_pickup_return'] as dynamic
          : null,
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      available: map['available'] != null ? map['available'] as dynamic : null,
      maximum: map['maximum'] != null ? map['maximum'] as dynamic : null,
      itemPriceId: map['itemPriceId'] != null ? map['itemPriceId'] : null,
      itemPriceCurrency:
          map['itemPriceCurrency'] != null ? map['itemPriceCurrency'] : null,
      estimated_value:
          map['estimated_value'] != null ? map['estimated_value'] : null,
      computed_value:
          map['computed_value'] != null ? map['computed_value'] : null,
      listed_value: map['listed_value'] != null ? map['listed_value'] : null,
      offered_value: map['offered_value'] != null ? map['offered_value'] : null,
      minimum_value:
          map['minimum_value'] != null ? map['minimum_value'] != null : null,
      ondc_location_id: map['ondc_location_id'] != null
          ? map['ondc_location_id'] as dynamic
          : null,
      maximum_value: map['maximum_value'] != null ? map['maximum_value'] : null,
      value: map['value'] != null ? map['value'] : null,
      categoryId: map['category_id'] != null ? map['category_id'] : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] : null,
      itemId: map['itemId'] != null ? map['itemId'] : null,
      images: map['images'] != null ? map['images'] as List<dynamic> : null,
      total: map['total'] != null ? map['total'] as dynamic : null,
    );
  }

  add() {
    if (quantity < available) {
      quantity = quantity + 1;
      getTotal();
    }
  }

  bool addToCart() {
    if (available > 0) {
      isAddedToCart = true;
      getTotal();
      return true;
    }
    return false;
  }

  minus() {
    if (quantity != 1) {
      quantity = quantity - 1;
      getTotal();
    }
  }

  removeFromCart() {
    isAddedToCart = false;
    quantity = 0;
  }

  getTotal() {
    total = quantity * value;
    warningLog('$total');
  }

  String toJson() => json.encode(toMap());

  factory ProductOndcModel.fromJson(String source) =>
      ProductOndcModel.fromNewMap(
        json.decode(source),
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      transaction_id,
      generic_name,
      ondc_item_id,
      cancellable,
      ondc_location_id,
      name,
      short_description,
      long_description,
      returnable,
      isVeg,
      time_to_ship,
      rating,
      storeId,
      customer_care,
      return_window,
      seller_pickup_return,
      symbol,
      available,
      maximum,
      itemPriceId,
      itemPriceCurrency,
      estimated_value,
      computed_value,
      listed_value,
      offered_value,
      minimum_value,
      maximum_value,
      net_quantity,
      storeLocationId,
      importer_FSSAI_license_no,
      other_FSSAI_license_no,
      additives_info,
      brand_owner_FSSAI_license_no,
      nutritional_info,
      fulfillment_id,
      fulfillmentId,
      ondc_fullfilment_type,
      packer_name,
      packer_address,
      value,
      back_image_url,
      createdAt,
      updatedAt,
      deletedAt,
      itemId,
      categoryId,
      category,
      manufacture_date,
      isAddedToCart,
      quantity,
      total,
      images,
    ];
  }
}
