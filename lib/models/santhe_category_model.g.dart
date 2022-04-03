// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 4;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      catId: fields[0] as int,
      catImageId: fields[1] as String,
      catImageTn: fields[2] as String,
      catName: fields[3] as String,
      catNotes: fields[4] as String,
      status: fields[5] as String,
      userCreate: fields[6] as int,
      userUpdate: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.catId)
      ..writeByte(1)
      ..write(obj.catImageId)
      ..writeByte(2)
      ..write(obj.catImageTn)
      ..writeByte(3)
      ..write(obj.catName)
      ..writeByte(4)
      ..write(obj.catNotes)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.userCreate)
      ..writeByte(7)
      ..write(obj.userUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
