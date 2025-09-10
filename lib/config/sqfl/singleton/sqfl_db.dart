import 'dart:developer';

import 'package:image_enhancer_app/config/sqfl/model/db_model.dart';
import 'package:image_enhancer_app/utils/enum/table_name.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:sqflite/sqflite.dart';

class SqflDB {

  SqflDB._();

  static final SqflDB instance = SqflDB._();

  static Database? _database;


  Future<Database?> get database async => _database ??= await _initDatabase();

  Future<Database?> _initDatabase() async {

    try {

      final dir = await pp.getApplicationDocumentsDirectory();

      return await openDatabase(
            join(dir.path, 'img_enhancer.db'),
            version: 1,
            onCreate: (db, version) {
              return db.execute(
                TableName.none.option().header
              );
            }
          );
    } catch (e) {
      log("initialize database exception:\n${e.toString()}");
      return null;
    }
  }

  Future<bool> insertData({required TableName tableName, required DbModel dbModel}) async {
    try {
      final db = await database;

      if (!await tableExists(tableName: tableName)) await db!.execute(tableName.option().header);

      dbModel.toJson().printResponse(title: "saving history in local db");

      return await db!.insert(
            tableName.option().name,
            dbModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace
          ) > 0;
    } catch (e) {
      log("insert data exception:\n${e.toString()}");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getTableData({
    required TableName tableName,
    int? limit,
    int? offset
  }) async {
    try {
      if(!await tableExists(tableName: tableName)) {
        return [];
      } else {
        final db = await database;
        return await db!.query(
          tableName.option().name,
          limit: limit,
          offset: offset,
          orderBy: "id DESC",
        );
      }
    } catch (e) {
      log("get table data exception:\n${e.toString()}");
      return [];
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null; // Ensure the database is set to null after closing
    }
  }
  
  Future<bool> tableExists({required TableName tableName}) async {
    try {
      final db = await database;
      final result = await db!.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='${tableName.option().name}'");
      return result.isNotEmpty;
    } catch (e) {
      log("table exist exception:\n${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteData({
    required TableName tableName,
    required int id,
  }) async {
    try {
      final db = await database;
      return await db!.delete(
            tableName.option().name,
            where: "id = ?",
            whereArgs: [id],
          ) > 0;
    } catch (e) {
      log("delete data exception:\n${e.toString()}");
      return false;
    }
  }


  Future<bool> updateData({
    required TableName tableName,
    required int id,
    required String val,
  }) async {
    try {
      final db = await database;
      return await db!.update(
            tableName.option().name,
            {"val": val, "created_at": DateTime.now().toIso8601String()},
            where: "id = ?",
            whereArgs: [id],
          ) > 0;
    } catch (e) {
      log("update data exception:\n${e.toString()}");
      return false;
    }
  }

  Future<void> deleteTable({required TableName tableName}) async {
    try {
      final db = await database;
      if (await tableExists(tableName: tableName)) {
        await db!
              .execute('DROP TABLE IF EXISTS ${tableName.option().name}');
      }
    } catch (e) {
      log("delete table exception:\n${e.toString()}");
    }
  }
}