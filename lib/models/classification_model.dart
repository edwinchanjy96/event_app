class ClassificationModel {
  final bool isPrimary;
  final bool hasFamily;
  final SegmentModel? segment;
  final GenreModel? genre;
  final SubGenreModel? subGenre;
  final TypeModel? type;
  final SubTypeModel? subType;

  ClassificationModel(
      {required this.isPrimary,
      required this.hasFamily,
      this.segment,
      this.genre,
      this.subGenre,
      this.type,
      this.subType});

  factory ClassificationModel.fromJson(Map json) {
    return ClassificationModel(
      isPrimary: json['primary'],
      hasFamily: json['family'],
      segment: json['segment'] == null ? null : SegmentModel.fromJson(json['segment']),
      genre: json['genre'] == null ? null : GenreModel.fromJson(json['genre']),
      subGenre: json['subGenre'] == null ? null : SubGenreModel.fromJson(json['subGenre']),
      type: json['type'] == null ? null : TypeModel.fromJson(json['type']),
      subType: json['subType'] == null ? null : SubTypeModel.fromJson(json['subType'])
    );
  }



}

class SegmentModel {
  final String id;
  final String name;

  SegmentModel({required this.id, required this.name});

  factory SegmentModel.fromJson(Map json) {
    return SegmentModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class GenreModel {
  final String id;
  final String name;

  GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map json) {
    return GenreModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SubGenreModel {
  final String id;
  final String name;

  SubGenreModel({required this.id, required this.name});

  factory SubGenreModel.fromJson(Map json) {
    return SubGenreModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class TypeModel {
  final String id;
  final String name;

  TypeModel({required this.id, required this.name});

  factory TypeModel.fromJson(Map json) {
    return TypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SubTypeModel {
  final String id;
  final String name;

  SubTypeModel({required this.id, required this.name});

  factory SubTypeModel.fromJson(Map json) {
    return SubTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
