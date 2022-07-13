class ListItemModel {
  ListItemModel(
      {required this.brandType,
      required this.itemId,
      required this.notes,
      required this.quantity,
      required this.itemName,
      required this.itemImageId,
      required this.unit,
      required this.catName,
      required this.catId,
      required this.possibleUnits});

  String brandType;

  String catName;

  String itemId; //more like item reference

  String itemImageId;

  String itemName;

  String notes;

  String quantity;

  String unit;

  String catId;

  List<String> possibleUnits;

  bool compareTo(ListItemModel cmp) {
    return (brandType == cmp.brandType &&
        catName == cmp.catName &&
        itemId == cmp.itemId &&
        itemImageId == cmp.itemImageId &&
        itemName == cmp.itemName &&
        notes == cmp.notes &&
        unit == cmp.unit &&
        catId == cmp.catId);
  }
}
