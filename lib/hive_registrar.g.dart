// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_registrar.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as String,
      sessionId: fields[1] as String,
      content: fields[2] as String?,
      voicePath: fields[3] as String?,
      voiceDurationMs: (fields[4] as num?)?.toInt(),
      tags: fields[5] == null ? const [] : (fields[5] as List).cast<String>(),
      isSent: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sessionId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.voicePath)
      ..writeByte(4)
      ..write(obj.voiceDurationMs)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.isSent)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final typeId = 1;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      id: fields[0] as String,
      notebookId: fields[1] as String,
      title: fields[2] == null ? 'New Session' : fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      messageCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.notebookId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.messageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final typeId = 2;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      id: fields[0] as String,
      label: fields[1] as String,
      colorArgb: (fields[2] as num).toInt(),
      messageCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.colorArgb)
      ..writeByte(3)
      ..write(obj.messageCount)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotebookAdapter extends TypeAdapter<Notebook> {
  @override
  final typeId = 3;

  @override
  Notebook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notebook(
      id: fields[0] as String,
      title: fields[1] as String,
      colorArgb: (fields[2] as num).toInt(),
      createdAt: fields[3] as DateTime,
      sessionCount: fields[4] == null ? 0 : (fields[4] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Notebook obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.colorArgb)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.sessionCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotebookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final typeId = 4;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      activePresetId: fields[0] == null ? 'default' : fields[0] as String,
      themeMode: fields[1] == null ? 'system' : fields[1] as String,
      fontFamily: fields[2] == null ? 'Rubik' : fields[2] as String,
      fontSize: fields[3] == null ? 'medium' : fields[3] as String,
      primaryColorArgb: (fields[4] as num?)?.toInt(),
      accentColorArgb: (fields[5] as num?)?.toInt(),
      bubbleRadius: fields[6] == null ? 1.0 : (fields[6] as num).toDouble(),
      wallpaperType: fields[7] == null ? 'none' : fields[7] as String,
      wallpaperValue: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.activePresetId)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.fontFamily)
      ..writeByte(3)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.primaryColorArgb)
      ..writeByte(5)
      ..write(obj.accentColorArgb)
      ..writeByte(6)
      ..write(obj.bubbleRadius)
      ..writeByte(7)
      ..write(obj.wallpaperType)
      ..writeByte(8)
      ..write(obj.wallpaperValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPresetAdapter extends TypeAdapter<UserPreset> {
  @override
  final typeId = 5;

  @override
  UserPreset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreset(
      id: fields[0] as String,
      name: fields[1] as String,
      createdAt: fields[2] as DateTime,
      basePresetId: fields[3] as String,
      fontFamily: fields[4] as String,
      fontSize: fields[5] as String,
      primaryColorArgb: (fields[6] as num).toInt(),
      accentColorArgb: (fields[7] as num).toInt(),
      bubbleRadius: (fields[8] as num).toDouble(),
      wallpaperType: fields[9] == null ? 'none' : fields[9] as String,
      wallpaperValue: fields[10] as String?,
      thumbnailData: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreset obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.basePresetId)
      ..writeByte(4)
      ..write(obj.fontFamily)
      ..writeByte(5)
      ..write(obj.fontSize)
      ..writeByte(6)
      ..write(obj.primaryColorArgb)
      ..writeByte(7)
      ..write(obj.accentColorArgb)
      ..writeByte(8)
      ..write(obj.bubbleRadius)
      ..writeByte(9)
      ..write(obj.wallpaperType)
      ..writeByte(10)
      ..write(obj.wallpaperValue)
      ..writeByte(11)
      ..write(obj.thumbnailData);
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
