// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPresetAdapter extends TypeAdapter<UserPreset> {
  @override
  final typeId = 5;

  @override
  UserPreset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreset();
  }

  @override
  void write(BinaryWriter writer, UserPreset obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPresetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
