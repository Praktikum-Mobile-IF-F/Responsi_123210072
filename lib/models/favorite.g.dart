// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 1;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      email: fields[1] as String,
      kopiList: (fields[2] as List).cast<Kopi>(),
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.kopiList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KopiAdapter extends TypeAdapter<Kopi> {
  @override
  final int typeId = 2;

  @override
  Kopi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Kopi(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      region: fields[4] as String,
      weight: fields[5] as int,
      flavorProfile: (fields[6] as List).cast<String>(),
      grindOption: (fields[7] as List).cast<String>(),
      roastLevel: fields[8] as int,
      imageUrl: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Kopi obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.region)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.flavorProfile)
      ..writeByte(7)
      ..write(obj.grindOption)
      ..writeByte(8)
      ..write(obj.roastLevel)
      ..writeByte(9)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KopiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
