// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santhe_user_credenetials_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCredentialAdapter extends TypeAdapter<UserCredential> {
  @override
  final int typeId = 2;

  @override
  UserCredential read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCredential(
      idToken: fields[0] as String,
      refreshToken: fields[1] as String,
      expiresIn: fields[2] as int,
      localId: fields[3] as String,
      isNewUser: fields[4] as bool,
      phoneNumber: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserCredential obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idToken)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.expiresIn)
      ..writeByte(3)
      ..write(obj.localId)
      ..writeByte(4)
      ..write(obj.isNewUser)
      ..writeByte(5)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCredentialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
