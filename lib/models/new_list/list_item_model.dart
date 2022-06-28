class ListItemModel {

  ListItemModel({
    required this.brandType,
    required this.itemId,
    required this.notes,
    required this.quantity,
    required this.itemName,
    required this.itemImageId,
    required this.unit,
    required this.catName,
    required this.catId,
  });

  String brandType;

  String catName;

  String itemId; //more like item reference

  String itemImageId;

  String itemName;

  String notes;

  String quantity;

  String unit;

  String catId;
}
