import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:async';
import 'package:je_voeux/model/item.dart';
import 'package:je_voeux/widgets/donnees_vides.dart';
import 'package:je_voeux/model/databaseClient.dart';
import 'package:je_voeux/widgets/item_detail.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  late String nouvelleList;
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    recupere();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: (() => ajouter(Item())),
              child: Text(
                "Ajouter",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: (items == null || items.length == 0)
          ? DonneesVides()
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: ((context, i) {
                Item item = items[i];
                return ListTile(
                  title: Text(item.nom!),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        DatabaseClient().delete(item.id!, 'item').then((int) {
                          print("L'Int recuperer est : $int");
                          recupere();
                        });
                      }),
                  leading: IconButton(
                      icon: Icon(Icons.edit), onPressed: (() => ajouter(item))),
                  onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext buildContext) {
                          return ItemDetail(item);
                        }));
                      },
                );
              })),
    );
  }

  Future<Null> ajouter(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text("Ajouter une liste de souhaits"),
            content: TextField(
              decoration: InputDecoration(
                  labelText: "Liste:",
                  hintText: (item == null)
                      ? "ex: mes prochains jeux vidéos"
                      : item.nom),
              onChanged: (String str) {
                nouvelleList = str;
              },
            ),
            actions: [
              TextButton(
                onPressed: (() => Navigator.pop(buildContext)),
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () {
                  // Ajouter le code pour pouvoir ajouter à la bd
                  if (nouvelleList != null) {
                    if (item == null) {
                      item = Item();
                      Map<String, dynamic> map = {'nom': nouvelleList};
                      // Item item = Item();
                      item.fromMap(map);
                      // DatabaseClient().ajoutItem(item).then((i) => recupere());
                      // nouvelleList;
                    } else {
                      item.nom = nouvelleList;
                    }
                    //  DatabaseClient().ajoutItem(item).then((i) => recupere());
                    DatabaseClient().upsertItem(item).then((i) => recupere());
                    nouvelleList;
                  }
                  Navigator.pop(buildContext);
                },
                child: const Text(
                  "Valider",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }

  void recupere() {
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
