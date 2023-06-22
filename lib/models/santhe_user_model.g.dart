// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      address: fields[0] as String,
      emailId: fields[1] as String,
      howToReach: fields[2] as String,
      lat: fields[3] as double,
      lng: fields[4] as double,
      phoneNumber: fields[5] as int,
      custId: fields[6] as int,
      custName: fields[8] as String,
      custRatings: fields[10] as double,
      custReferal: fields[11] as int,
      custStatus: fields[12] as String,
      custLoginTime: fields[7] as DateTime,
      custPlan: fields[9] as String,
      pincode: fields[13] as int,
      lastName: fields[14] as dynamic,
      fiiid: fields[15] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.emailId)
      ..writeByte(2)
      ..write(obj.howToReach)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lng)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.custId)
      ..writeByte(7)
      ..write(obj.custLoginTime)
      ..writeByte(8)
      ..write(obj.custName)
      ..writeByte(9)
      ..write(obj.custPlan)
      ..writeByte(10)
      ..write(obj.custRatings)
      ..writeByte(11)
      ..write(obj.custReferal)
      ..writeByte(12)
      ..write(obj.custStatus)
      ..writeByte(13)
      ..write(obj.pincode)
      ..writeByte(14)
      ..write(obj.lastName)
      ..writeByte(15)
      ..write(obj.fiiid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
