import 'package:mygym/models/exercise.dart';
import 'package:mygym/models/gymCard.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyGymDB {
  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'mygym.db'),
      version: 1,
    );
  }

  static Future<void> createDB() async {
    final db = await getDB();
    await db.execute(
        "CREATE TABLE IF NOT EXISTS scheda (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, note TEXT)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS esercizio (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, serie INTEGER, ripetizioni TEXT, pausa TEXT, giorno INTEGER, n_ordine INTEGER, note TEXT, schedaId INTEGER, FOREIGN KEY (schedaId) REFERENCES scheda (id) ON DELETE CASCADE)");
  }

  static Future<int> insertCard(GymCard card) async {
    final db = await getDB();
    final id = await db.insert('scheda', card.toMap());
    return id;
  }

  static Future<void> insertExercise(Exercise exercise) async {
    final db = await getDB();
    final id = await db.insert('esercizio', exercise.toMap());
  }

  static Future<List<GymCard>> getAllCards() async {
    final db = await MyGymDB.getDB();
    final List<Map<String, dynamic>> maps = await db.query('scheda');

    return List.generate(maps.length, (i) {
      return GymCard(
        maps[i]['id'],
        maps[i]['nome'],
        maps[i]['note'],
      );
    });
  }

  static Future<void> deleteCard(int id) async {
    final db = await MyGymDB.getDB();
    await db.delete('scheda', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteExercise(int id) async {
    final db = await MyGymDB.getDB();
    await db.delete('esercizio', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateCard(GymCard card) async {
    final db = await MyGymDB.getDB();
    await db
        .update('scheda', card.toMap(), where: 'id = ?', whereArgs: [card.id]);
  }

  static Future<void> updateExercise(Exercise exercise) async {
    final db = await MyGymDB.getDB();
    await db.update('esercizio', exercise.toMap(),
        where: 'id = ?', whereArgs: [exercise.id]);
  }

  static Future<List<Exercise>> getAllExercise(int id, int day) async {
    final db = await MyGymDB.getDB();
    final List<Map<String, dynamic>> maps = await db.query('esercizio',
        where: 'schedaId = ? AND giorno = ?',
        whereArgs: [id, day],
        orderBy: "n_ordine ASC");

    return List.generate(maps.length, (i) {
      return Exercise(
          maps[i]['id'],
          maps[i]['nome'],
          maps[i]['serie'],
          maps[i]['ripetizioni'],
          maps[i]['pausa'],
          maps[i]['giorno'],
          maps[i]['n_ordine'],
          maps[i]['note'],
          maps[i]['schedaId']);
    });
  }

  static Future<List<Exercise>> getAllExerciseFromPoint(
      int id, int day, int startPoint) async {
    final db = await MyGymDB.getDB();
    final List<Map<String, dynamic>> maps = await db.query('esercizio',
        where: 'schedaId = ? AND giorno = ? AND n_ordine >= ?',
        whereArgs: [id, day, startPoint],
        orderBy: "n_ordine ASC");

    return List.generate(maps.length, (i) {
      return Exercise(
          maps[i]['id'],
          maps[i]['nome'],
          maps[i]['serie'],
          maps[i]['ripetizioni'],
          maps[i]['pausa'],
          maps[i]['giorno'],
          maps[i]['n_ordine'],
          maps[i]['note'],
          maps[i]['schedaId']);
    });
  }

  static Future<void> changePosition(pos1, pos2, idScheda) async {
    final db = await MyGymDB.getDB();
    final List<Map<String, dynamic>> list1 = await db.query('esercizio',
        where: 'schedaId=? AND n_ordine=?',
        whereArgs: [idScheda, pos1],
        limit: 1);
    final List<Map<String, dynamic>> list2 = await db.query('esercizio',
        where: 'schedaId=? AND n_ordine=?',
        whereArgs: [idScheda, pos2],
        limit: 1);
    Exercise ex1 = Exercise(
        list1[0]['id'],
        list1[0]['nome'],
        list1[0]['serie'],
        list1[0]['ripetizioni'],
        list1[0]['pausa'],
        list1[0]['giorno'],
        list2[0]['n_ordine'],
        list1[0]['note'],
        list1[0]['schedaId']);

    Exercise ex2 = Exercise(
        list2[0]['id'],
        list2[0]['nome'],
        list2[0]['serie'],
        list2[0]['ripetizioni'],
        list2[0]['pausa'],
        list2[0]['giorno'],
        list1[0]['n_ordine'],
        list2[0]['note'],
        list2[0]['schedaId']);

    await updateExercise(ex1);
    await updateExercise(ex2);
  }
}
