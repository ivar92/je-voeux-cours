import 'dart:io';
import 'package:flutter/material.dart';
import 'package:je_voeux/model/article.dart';
import 'package:je_voeux/model/databaseClient.dart';

class Ajout extends StatefulWidget {
  int? id;
  Ajout(int id) {
    id = id;
  }

  @override
  _AjoutState createState() => _AjoutState();
}

class _AjoutState extends State<Ajout> {
  String image = 'images/no_image.jpeg';
  String? nom;
  String? magasin;
  String? prix;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter'),
        actions: [
          TextButton(
              onPressed: ajouter,
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Article à ajouter',
              textScaleFactor: 1.4,
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
            Card(
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (image != null)
                      ? Image.asset('images/no_image.jpeg')
                      : Image.file(File(image)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      IconButton(
                          onPressed: null, icon: Icon(Icons.camera_enhance)),
                      IconButton(
                          onPressed: null, icon: Icon(Icons.photo_library)),
                    ],
                  ),
                  textField(TypeTextField.nom, 'Nom de l\'article'),
                  textField(TypeTextField.prix, 'Prix'),
                  textField(TypeTextField.magasin, 'Magasin'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textField(TypeTextField type, String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );
  }

  void ajouter() {
    if (nom != null) {
      Map<String, dynamic> map = {'nom': nom, 'item': widget.id};
      if (magasin != null) {
        map['magasin'] = magasin;
      }
      if (prix != null) {
        map['prix'] = prix;
      }
      if (image != null) {
        map['image'] = image;
      }
      Article article = Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = 'images/no_image.jpeg';
        nom;
        magasin;
        prix;
        Navigator.pop(context);
      });
    }
  }
}

enum TypeTextField { nom, prix, magasin }
