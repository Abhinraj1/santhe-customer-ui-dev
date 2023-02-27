



abstract class CustomerContactState {}

class CustomerContactInitialState extends CustomerContactState{}

class CustomerContactLoadingState extends CustomerContactState{}

class CustomerContactSentSuccessfulState extends CustomerContactState{}

class CustomerContactShowShopDetailsState extends CustomerContactState{}


class CustomerContactErrorState extends CustomerContactState{

  final String message;

  CustomerContactErrorState({required this.message});
}