import 'package:santhe/models/offer/santhe_offer_item_model.dart';

class Offer {
  final bool chatEnabled;
  final bool contactEnabled;
  final double custDistance;
  final String custId;
  final String custDeal;
  final String custOfferStatus;
  final DateTime custUpdateTime;
  final String custStatus;
  final DateTime eventExpiryTime;
  final List<OfferItem> offerItems;
  final String listEventId;
  final String listId;
  final String merchId;
  final bool merchDelivery;
  final bool merchFulfillment;
  final String merchListStatus;
  final int merchOfferQuantity;
  final String merchResponseStatus;
  final double merchTotalPrice;
  final DateTime merchUpdateTime;

  Offer({
    required this.chatEnabled,
    required this.contactEnabled,
    required this.custDistance,
    required this.custId,
    required this.custDeal,
    required this.custOfferStatus,
    required this.custUpdateTime,
    required this.custStatus,
    required this.eventExpiryTime,
    required this.offerItems,
    required this.listEventId,
    required this.listId,
    required this.merchId,
    required this.merchDelivery,
    required this.merchFulfillment,
    required this.merchListStatus,
    required this.merchOfferQuantity,
    required this.merchResponseStatus,
    required this.merchTotalPrice,
    required this.merchUpdateTime,
  });

  factory Offer.fromFirebaseRestApi(data) {
    List<OfferItem> offerItems = [];
if(data['items']['arrayValue']['values']!=null){
  for(int i = 0; i<data['items']['arrayValue']['values'].length;i++){
    offerItems.add(OfferItem.fromFirebaseRestApi(data['items']['arrayValue']['values'][i]));
  }
}
    return Offer(
        chatEnabled: data['chatEnabled']['booleanValue'],
        contactEnabled: data['contactEnabled']['booleanValue'],
        custDistance: data['custDistance']['doubleValue'] ??
            double.parse(data['custDistance']['integerValue']) ??
            0.0,
        custId: data['custId']['referenceValue'],
        custDeal: data['custOfferResponse']['mapValue']['fields']['custDeal']['stringValue'],
        custOfferStatus: data['custOfferResponse']['mapValue']['fields']['custOfferStatus']['stringValue'],
        custUpdateTime: DateTime.parse(data['custOfferResponse']['mapValue']['fields']['custUpdateTime']['timestampValue']),
        custStatus: data['custStatus']['stringValue'],
        eventExpiryTime: DateTime.parse(data['eventExpiryTime']['timestampValue']),
        offerItems: offerItems,
        listEventId: data['listEventId']['stringValue'],
        listId: data['listId']['referenceValue'],
        merchId: data['merchId']['referenceValue'],
        merchDelivery: data['merchResponse']['mapValue']['fields']
            ['merchDelivery']['booleanValue'],
        merchFulfillment: data['merchResponse']['mapValue']['fields']
            ['merchFulfillmentResponse']['booleanValue'],
        merchListStatus: data['merchResponse']['mapValue']['fields']
        ['merchListStatus']['stringValue'],
        merchOfferQuantity: int.parse(data['merchResponse']['mapValue']['fields']
        ['merchOfferQuantity']['integerValue']),
        merchResponseStatus: data['merchResponse']['mapValue']['fields']
        ['merchResponseStatus']['stringValue'],
        merchTotalPrice:double.parse(data['merchResponse']['mapValue']['fields']
        ['merchTotalPrice']['stringValue']),
        merchUpdateTime: DateTime.parse(data['merchResponse']['mapValue']
            ['fields']['merchUpdateTime']['timestampValue']));
  }
}
