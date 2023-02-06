// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_if_null_operators

part of 'cart_bloc.dart';

class CartState extends Equatable with LogMixin {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class AddCartLoading extends CartState {}

class ErrorAddingItemToCartState extends CartState {
  final String message;
  const ErrorAddingItemToCartState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorGettingCartListState extends CartState {
  final String message;
  const ErrorGettingCartListState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class UpdatedQuantityState extends CartState {
  final ProductOndcModel productOndcModel;
  const UpdatedQuantityState({
    required this.productOndcModel,
  });
  @override
  List<Object> get props => [productOndcModel];
}

class ResetQuantityState extends CartState {}

class ErrorUpdatingQuantityState extends CartState {
  final String message;
  const ErrorUpdatingQuantityState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class AddedToCartList extends CartState {
  final List<ProductOndcModel> productOndcModels;
  const AddedToCartList({
    required this.productOndcModels,
  });

  AddedToCartList copyWith({
    List<ProductOndcModel>? productOndcModels,
  }) {
    return AddedToCartList(
      productOndcModels: productOndcModels ?? this.productOndcModels,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productOndcModels': productOndcModels,
    };
  }

  factory AddedToCartList.fromMap(Map<String, dynamic> map) {
    return AddedToCartList(
      productOndcModels: map['productOndcModels'] as List<ProductOndcModel>,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddedToCartList.fromJson(String source) =>
      AddedToCartList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddedToCartList(productOndcModels: $productOndcModels)';

  @override
  List<Object> get props => [productOndcModels];
}

class UpdateCartLoading extends CartState {}

class DeleteCartLoading extends CartState {}

class ErrorDeletingItemState extends CartState {
  final String message;
  const ErrorDeletingItemState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class UpdatedCartItemState extends CartState {
  final List<ProductOndcModel> productOndcModel;
  const UpdatedCartItemState({
    required this.productOndcModel,
  });
  @override
  List<Object> get props => [productOndcModel];

  UpdatedCartItemState copyWith({
    List<ProductOndcModel>? productOndcModel,
  }) {
    return UpdatedCartItemState(
      productOndcModel: productOndcModel ?? this.productOndcModel,
    );
  }

  Map<String, dynamic> toMap() {
    // infoLog('what is being stored$productOndcModel');
    return <String, dynamic>{
      'productOndcModel': productOndcModel,
    };
  }

  factory UpdatedCartItemState.fromMap(Map<String, dynamic> map) {
    // log('${map['productOndcModel']}', name: 'UpdatedCartItemStart.fromMap');
    List<dynamic> data = map['productOndcModel'];
    // log('$data', level: 3);
    List<ProductOndcModel> productOndcModels = [];
    data.forEach((mape) {
      productOndcModels.add(
        ProductOndcModel.fromNewMap(json.decode(mape)),
      );
    });
    // log('$productOndcModels', name: "Hydrated Blocfrom map");
    return UpdatedCartItemState(
      productOndcModel: productOndcModels,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatedCartItemState.fromJson(String source) =>
      UpdatedCartItemState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UpdatedCartItemState(productOndcModel: $productOndcModel)';
}

class DeleteCartItemState extends CartState {
  final List<ProductOndcModel> productOndcModel;
  const DeleteCartItemState({
    required this.productOndcModel,
  });
  @override
  List<Object> get props => [productOndcModel];
}
