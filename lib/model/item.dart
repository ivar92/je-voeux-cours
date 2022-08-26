class Item {
    int? id;
   String? nom;

  Item();

  void fromMap(Map<String, dynamic> map) {
    //  id = map.containsKey('id') ? map['id'] : 0;
    id = map['id'];
    nom = map['nom'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'nom': nom};
    if (id != null) {
      map['id'] = id;
    }
    // Verification de throw
    return map;
  }
}
