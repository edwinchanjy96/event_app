class PromoterModel {
  String id;
  String name;
  String description;

  PromoterModel(
      {required this.id, required this.name, required this.description});

  factory PromoterModel.fromJson(Map json) {
    return PromoterModel(
        id: json['id'], name: json['name'], description: json['description']);
  }

  static List<PromoterModel> retrievePromotersList(List promoters) {
    List<PromoterModel> promotersList = [];
    promoters.forEach((element) {
      promotersList.add(PromoterModel.fromJson(element));
    });
    return promotersList;
  }
}
