// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'santhe_list_item_model.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class ListItemAdapter extends TypeAdapter<ListItem> {
//   @override
//   final int typeId = 7;
//
//   @override
//   ListItem read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return ListItem(
//       brandType: fields[0] as String,
//       itemId: fields[2] as String,
//       notes: fields[5] as String,
//       quantity: fields[6] as num,
//       itemName: fields[4] as String,
//       itemImageId: fields[3] as String,
//       unit: fields[7] as String,
//       catName: fields[1] as String,
//       catId: fields[8] as int,
//       possibleUnits: (fields[9] as List).cast<String>(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, ListItem obj) {
//     writer
//       ..writeByte(10)
//       ..writeByte(0)
//       ..write(obj.brandType)
//       ..writeByte(1)
//       ..write(obj.catName)
//       ..writeByte(2)
//       ..write(obj.itemId)
//       ..writeByte(3)
//       ..write(obj.itemImageId)
//       ..writeByte(4)
//       ..write(obj.itemName)
//       ..writeByte(5)
//       ..write(obj.notes)
//       ..writeByte(6)
//       ..write(obj.quantity)
//       ..writeByte(7)
//       ..write(obj.unit)
//       ..writeByte(8)
//       ..write(obj.catId)
//       ..writeByte(9)
//       ..write(obj.possibleUnits);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ListItemAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
