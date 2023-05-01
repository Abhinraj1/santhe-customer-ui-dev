



import '../../../models/ondc/support_contact_models.dart';

abstract class CustomerContactState {}

class CustomerContactInitialState extends CustomerContactState{}

class CustomerContactLoadingState extends CustomerContactState{}

class CustomerContactLoadedState extends CustomerContactState{
  final List<CategoryModel> category;
  final List<CategoryModel> subCategory;

  CustomerContactLoadedState({required this.category,required this.subCategory});
}

class CustomerContactSentSuccessfulState extends CustomerContactState{}

class CustomerContactShowShopDetailsState extends CustomerContactState{}


class CustomerContactErrorState extends CustomerContactState{

  final String message;

  CustomerContactErrorState({required this.message});
}