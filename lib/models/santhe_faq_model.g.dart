// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_faq_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FAQAdapter extends TypeAdapter<FAQ> {
  @override
  final int typeId = 6;

  @override
  FAQ read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FAQ(
      quest: fields[0] as String,
      answ: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FAQ obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quest)
      ..writeByte(1)
      ..write(obj.answ);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FAQAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
