import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import 'package:favourite_places/models/place.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/material.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY , title TEXT, image TEXT, lat REAL , lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
            address: row['address'] as String,
            latitude: row['lat'] as double,
            longitude: row['lng'] as double),
      );
    }).toList();
    state = places;
  }

  void deletePlace(String id) async {
   final db = await _getDatabase();
    // final item = await db.query(
    //   'user_places',
    //   where: "id = ?",
    //   whereArgs: [id],
    // );
    
    
    await db.delete(
      'user_places',
      where: "id = ?",
      whereArgs: [id],
    );
    state = state.where((place) => place.id != id).toList();
  }

  void insertPlace(
      String title, File copiedImage, PlaceLocation location) async {
    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();
    await db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );
    // state = state.where((place) => place.id != id).toList();
    state = [newPlace, ...state];
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();
    db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
