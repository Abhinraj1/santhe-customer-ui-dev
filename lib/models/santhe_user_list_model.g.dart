// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_user_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserListAdapter extends TypeAdapter<UserList> {
  @override
  final int typeId = 1;

  @override
  UserList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserList(
      createListTime: fields[0] as DateTime,
      custId: fields[1] as int,
      items: (fields[4] as List).cast<ListItem>(),
      listId: fields[5] as int,
      listName: fields[6] as String,
      custListSentTime: fields[2] as DateTime,
      custListStatus: fields[3] as String,
      listOfferCounter: fields[7] as int,
      processStatus: fields[8] as String,
      custOfferWaitTime: fields[9] as DateTime,
      updateListTime: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserList obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.createListTime)
      ..writeByte(1)
      ..write(obj.custId)
      ..writeByte(2)
      ..write(obj.custListSentTime)
      ..writeByte(3)
      ..write(obj.custListStatus)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.listId)
      ..writeByte(6)
      ..write(obj.listName)
      ..writeByte(7)
      ..write(obj.listOfferCounter)
      ..writeByte(8)
      ..write(obj.processStatus)
      ..writeByte(9)
      ..write(obj.custOfferWaitTime)
      ..writeByte(10)
      ..write(obj.updateListTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
