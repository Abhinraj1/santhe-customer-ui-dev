// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 7;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      dBrandType: fields[2] as String,
      dItemNotes: fields[3] as String,
      itemImageTn: fields[9] as String,
      catId: fields[0] as String,
      createUser: fields[1] as int,
      dQuantity: fields[4] as int,
      dUnit: fields[12] as String,
      itemAlias: fields[6] as String,
      itemId: fields[7] as int,
      itemImageId: fields[8] as String,
      itemName: fields[10] as String,
      status: fields[11] as String,
      unit: (fields[5] as List).cast<String>(),
      updateUser: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.catId)
      ..writeByte(1)
      ..write(obj.createUser)
      ..writeByte(2)
      ..write(obj.dBrandType)
      ..writeByte(3)
      ..write(obj.dItemNotes)
      ..writeByte(4)
      ..write(obj.dQuantity)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.itemAlias)
      ..writeByte(7)
      ..write(obj.itemId)
      ..writeByte(8)
      ..write(obj.itemImageId)
      ..writeByte(9)
      ..write(obj.itemImageTn)
      ..writeByte(10)
      ..write(obj.itemName)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.dUnit)
      ..writeByte(13)
      ..write(obj.updateUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
