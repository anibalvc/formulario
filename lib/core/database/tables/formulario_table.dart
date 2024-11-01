import 'package:binance_api_test/core/database/database_service.dart';
import 'package:binance_api_test/core/database/tables/tarea_table.dart';
import 'package:binance_api_test/core/models/formularios_response.dart';
import 'package:binance_api_test/core/models/usuarios_response.dart';
import 'package:binance_api_test/widgets/app_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class FormularioDB {
  final tableName = 'formulario';

  Future<void> crearTabla(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER NOT NULL,
    "nombre" TEXT NOT NULL,
    PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> insert({required String nombre}) async {
    final database = await DatabaseService().database;
    return await database
        .rawInsert("""INSERT INTO $tableName (nombre) VALUES (?)""", [
      nombre,
    ]);
  }

  Future<FormulariosResponse> selectAll() async {
    final database = await DatabaseService().database;
    final formularios =
        await database.rawQuery(""" SELECT * from $tableName""");
    return FormulariosResponse.fromList(formularios);
  }

  Future<int> update({
    required int id,
    String? nombre,
  }) async {
    final database = await DatabaseService().database;
    Map<String, dynamic> formularioCambios = {
      if (nombre != null) "nombre": nombre,
    };
    return await database.update(tableName, formularioCambios,
        where: "id=?",
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<void> deleteAllInfo() async {
    final database = await DatabaseService().database;
    await database.rawDelete("""DELETE FROM $tableName""");
  }

  Future<void> deleteTable() async {
    final database = await DatabaseService().database;
    await database.rawDelete("""DROP TABLE $tableName""");
  }

  Future<int> deleteById(int id) async {
    final database = await DatabaseService().database;

    // Borrar el formulario
    return await database
        .rawDelete("""DELETE FROM $tableName WHERE id = ?""", [id]);
  }
}
