import 'dart:io';
import 'item.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'article.dart';

class DatabaseClient {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null)
    // return _database;
    // _database = await create();
    // return _database;
    {
      return _database!;
    } else {
      //Creer cette bd
      _database = await create();
      return _database!;
    }
  }

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = directory.path + 'database.db';
    var bdd = await openDatabase(database_directory, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
    CREATE TABLE item(
      id INTEGER PRIMARY key, 
      nom NOT NULL
      )
          ''');
    });
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item(
      id INTEGER PRIMARY key, 
      nom NOT NULL
      )
''');

    await db.execute('''
    CREATE TABLE article(
       id INTEGER PRIMARY KEY,
       nom TEXT NOT NULL,
       item INTEGER,
       prix TEXT,
       magasin TEXT,
       image Text
       )
      ''');
  }

  /* ECRITURE DES DONNEES */
  Future<Item> ajoutItem(Item item) async {
    Database? maDatabase = await database;
    item.id = await maDatabase?.insert('item', item.toMap());
    // if (item.id == 0) {
    return item;
    // } else {
    // return item;
    // }
  }

  //Modifier ou ajouter en fonction de ma base de donnée
  Future<int?> updateItem(Item item) async {
    Database? maDatabase = await database;
    return maDatabase!
        .update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<Item> upsertItem(Item item) async {
    Database? maDatabase = await database;
    if (item.id == null) {
      item.id = await maDatabase?.insert('item', item.toMap());
    } else {
      await maDatabase!
          .update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  Future<Article> upsertArticle(Article article) async {
    Database? maDatabase = await database;
    (article.id == null)
        ? article.id = await maDatabase?.insert('article', article.toMap())
        : await maDatabase!.update('article', article.toMap(),
            where: 'id = ?', whereArgs: [article.id]);
    return article;
  }


  //Delete
  Future<int?> delete(int id, String table) async {
    Database? myDatabase = await database;
    return await myDatabase?.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /*LECTURE DES DONNEES*/
  Future<List<Item>> allItem() async {
    Database? maDatabase = await database;
    List<Map<String, dynamic>> resultat =
        await maDatabase!.rawQuery('SELECT * FROM item');
    List<Item> items = [];
    resultat.forEach((map) {
      Item item = Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }
}
