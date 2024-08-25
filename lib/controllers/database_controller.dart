import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Model/post_model.dart';

class DatabaseController extends GetxController {
  Database? _database;

  Future<void> openDatabse() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'posts_databse.db'),
    );
  }

  Future<void> addPostToDB(Posts post) async {
    final db = _database;
    await db?.insert(
      'posts',
      post.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removePostFromDB(num postId) async {
      final db = _database;
      await db?.delete(
        'posts',
        where: 'id = ?',
        whereArgs: [postId],
      );
    }
  
    Future<void> removeAllPosts() async {
      final db = _database;
      await db?.delete('posts');
    }
  

  Future<List<Posts>> getPostsFromDB() async {
    final db = _database;
    final List<Map<String, dynamic>> maps = await db?.query('posts') ?? [];
    
    return List.generate(maps.length, (i) {
      return Posts.fromJson(maps[i]);
    });
  }

  Future<void> favoritePost(num postId, bool isFavorite) async {
    final db = _database;
    await db?.update(
      'posts',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [postId],
    );
  }
}
