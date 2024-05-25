class JenisKopi {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final String? region;
  final int? weight;
  final List<String>? flavorProfile;
  final List<String>? grindOption;
  final int? roastLevel;
  final String? imageUrl;
  JenisKopi({
  this.id,
  this.name,
  this.description,
  this.price,
  this.region,
  this.weight,
    this.flavorProfile,
    this.grindOption,
    this.roastLevel,
    this.imageUrl,
  });
  JenisKopi.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        description = json['description'] as String?,
        price = json['price'] as double?,
        region = json['region'] as String?,
        weight = json['weight'] as int?,
        flavorProfile = (json['flavor_profile'] as List?)?.map((dynamic e) => e as String).toList(),
        grindOption = (json['grind_option'] as List?)?.map((dynamic e) => e as String).toList(),
        roastLevel = json['roast_level'] as int?,
        imageUrl = json['image_url'] as String?;
  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'description' : description,
    'price' : price,
    'region' : region,
    'weight' : weight,
    'flavor_profile' : flavorProfile,
    'grind_option' : grindOption,
    'roast_level' : roastLevel,
    'image_url' : imageUrl
  };
}