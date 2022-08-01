class OfferItem {
  final String brandType;
  final String catName;
  final String itemId;
  final String itemImageId;
  final String itemName;
  final String itemNotes;
  final int itemSeqNum;
  final bool merchAvailability;
  final String merchNotes;
  final double merchPrice;
  final double quantity;
  final String unit;

  OfferItem({
    required this.brandType,
    required this.catName,
    required this.itemId,
    required this.itemImageId,
    required this.itemName,
    required this.itemNotes,
    required this.itemSeqNum,
    required this.merchAvailability,
    required this.merchNotes,
    required this.merchPrice,
    required this.quantity,
    required this.unit,
  });

  factory OfferItem.fromFirebaseRestApi(jsonData) {
    var data = jsonData['mapValue']['fields'];
    return OfferItem(
        brandType: data['brandType']['stringValue'],
        catName: data['catName']['stringValue'],
        itemId: data['itemId']['referenceValue'],
        itemImageId: data['itemImageId']['stringValue'],
        itemName: data['itemName']['stringValue'],
        itemNotes: data['itemNotes']['stringValue'],
        itemSeqNum: int.parse(data['itemSeqNum']['integerValue']),
        merchAvailability: data['merchAvailability']['booleanValue'],
        merchNotes: data['merchNotes']['stringValue'],
        merchPrice: double.parse(data['merchPrice']['stringValue']),
        quantity: double.parse(data['quantity']['stringValue']),
        unit: data['unit']['stringValue']);
  }
}
