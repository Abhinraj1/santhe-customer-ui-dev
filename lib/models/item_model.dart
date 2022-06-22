class ItemModel {
  String brandType;
  String itemNotes;
  String itemId;
  bool merchAvailability;
  String merchNotes;
  String merchPrice;
  String quantity;
  String unit;
  String catName;
  String itemImageId;
  String itemName;
  bool isSelected;
  bool isExpanded;
  int itemSeqNum;
  ItemModel(
      {required this.itemName,
        required this.catName,
        required this.itemImageId,
        required this.itemSeqNum,
        required this.quantity,
        required this.itemId,
        required this.brandType,
        this.isSelected = false,
        this.isExpanded = false,
        required this.itemNotes,
        required this.merchAvailability,
        required this.merchNotes,
        required this.merchPrice,
        required this.unit});
  factory ItemModel.fromJson(data) {
    return ItemModel(
      brandType: _checkPlaceholder(data['brandType']['stringValue']),
      itemId: data['itemId']['referenceValue'],
      itemNotes: _checkPlaceholder(data['itemNotes']['stringValue'] ?? "sa"),
      itemName: data['itemName']['stringValue'],
      itemImageId: data['itemImageId']['stringValue'],
      unit: data['unit']['stringValue'],
      catName: data['catName']['stringValue'],
      merchPrice: data['merchPrice']['stringValue'],
      itemSeqNum: int.parse(data['itemSeqNum']['integerValue']),
      merchAvailability: data['merchAvailability']['booleanValue'],
      quantity: data['quantity']['stringValue'] ??
          data['quantity']['integerValue'].toString(),
      merchNotes: data['merchNotes']['stringValue'],
    );
  }

  // Do not change this from customer app uploading placeholder text with unique string to be identified as placeholder
  static String _checkPlaceholder(String data){
    const placeHolderIdentifier = 'H+MbQeThWmYq3t6w';
    if(data.contains(placeHolderIdentifier)){
      return data=="sa"?"sa":'';
    }else{
      return data;
    }
  }
}
