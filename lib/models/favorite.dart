import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 1)
class Favorite extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String email;

  @HiveField(2)
  List<Kopi> kopiList;

  Favorite({
    required this.email,
    required this.kopiList,
  });
}

@HiveType(typeId: 2)
class Kopi extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String region;

  @HiveField(5)
  final int weight;

  @HiveField(6)
  final List<String> flavorProfile;

  @HiveField(7)
  final List<String> grindOption;

  @HiveField(8)
  final int roastLevel;

  @HiveField(9)
  final String imageUrl;

  Kopi({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.region,
    required this.weight,
    required this.flavorProfile,
    required this.grindOption,
    required this.roastLevel,
    required this.imageUrl,
  });
}
