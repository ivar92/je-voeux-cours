import 'package:flutter/material.dart';
import 'package:je_voeux/model/item.dart';
import 'package:je_voeux/model/article.dart';
import 'donnees_vides.dart';
import 'ajout_article.dart';

class ItemDetail extends StatefulWidget {

   late Item item;

  ItemDetail(Item item) {
    this.item = item;
  }

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
   late List<Article> articles = [];
     @override
     Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nom!),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Ajout(widget.item.id!);
                }));
              },
              child: Text(
                'ajouter',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: (articles == null || articles.length == 0)
          ? DonneesVides()
          : GridView.builder(
              itemCount: articles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, i) {
                Article article = articles[i];
                return Card(
                  child: Column(
                    children: [
                      Text(article.nom!)
                      ],
                  ),
                );
              }
              ),
     );
  }
  
}
