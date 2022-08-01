

import 'package:intl/intl.dart';

import 'item_model.dart';

class AnswerList {
  final bool chatEnabled;
  final bool contactEnabled;
  final String custDistance;
  final String custId;
  final List<ItemModel> items;
  final String listId;
  final String merchId;
  final String listEventId;
  final String custStatus;
  final String custOfferStatus;
  final String date;
  final DateTime custUpdateTime;
  final DateTime merchUpdateTime;
  final String requestForDay;

  AnswerList({
    required this.date,
    required this.custOfferStatus,
    required this.custId,
    required this.items,
    required this.listId,
    required this.custStatus,
    required this.merchId,
    required this.custDistance,
    required this.contactEnabled,
    required this.chatEnabled,
    required this.listEventId,
    required this.custUpdateTime,
    required this.requestForDay,
    required this.merchUpdateTime
  });

  factory AnswerList.fromJson(data) {
    List<ItemModel> listItems = [];
    if (data['items']['arrayValue']['values'] != null) {
      for (var map in data['items']['arrayValue']['values']) {
        listItems.add(ItemModel.fromJson(map['mapValue']['fields']));
      }
    }

    return AnswerList(
      date: DateFormat('yyyy-MM-dd').format(DateTime.parse(data['custOfferResponse']['mapValue']['fields']['custUpdateTime']['timestampValue']).toLocal()),
      custOfferStatus: data['custOfferResponse']['mapValue']['fields']['custOfferStatus']['stringValue'],
      chatEnabled: data['chatEnabled']['booleanValue'],
      contactEnabled: data['contactEnabled']['booleanValue'],
      items: listItems,
      listId: data['listId']['referenceValue'],
      custDistance:data['custDistance']['integerValue']??data['custDistance']['doubleValue'],
      merchId:data['merchId']['referenceValue'],
      custId:data['custId']['referenceValue'],
      listEventId:data['listEventId']['stringValue'],
      custStatus: data['custStatus']['stringValue']??"SS",
      custUpdateTime: DateTime.parse(data['custOfferResponse']['mapValue']['fields']['custUpdateTime']['timestampValue']),
      requestForDay: data['requestForDay']?['integerValue'] ?? 'NA',
      merchUpdateTime: DateTime.parse(data['merchResponse']['mapValue']['fields']['merchUpdateTime']['timestampValue']),
    );
  }
}