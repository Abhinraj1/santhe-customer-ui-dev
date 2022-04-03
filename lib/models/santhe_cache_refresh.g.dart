// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_cache_refresh.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheRefreshAdapter extends TypeAdapter<CacheRefresh> {
  @override
  final int typeId = 5;

  @override
  CacheRefresh read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheRefresh(
      catUpdate: fields[0] as DateTime,
      dbStructure: fields[1] as DateTime,
      itemUpdate: fields[2] as DateTime,
      aboutUsUpdate: fields[3] as DateTime,
      termsUpdate: fields[5] as DateTime,
      custFaqUpdate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CacheRefresh obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.catUpdate)
      ..writeByte(1)
      ..write(obj.dbStructure)
      ..writeByte(2)
      ..write(obj.itemUpdate)
      ..writeByte(3)
      ..write(obj.aboutUsUpdate)
      ..writeByte(4)
      ..write(obj.custFaqUpdate)
      ..writeByte(5)
      ..write(obj.termsUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheRefreshAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
