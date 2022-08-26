class Article {
   int? id;
   String? nom;
   int? item;
  var prix;
  String? magasin;
  String? image;

  Article();

  void fromMap(Map<String, dynamic> map) {
    id = map[id];
    nom = map[nom];
    item = map[item];
    prix = map[prix];
    magasin = map[magasin];
    image = map[image];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nom': nom,
      'item': item,
      'magasin': magasin,
      'prix': prix,
      'image': image,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}

