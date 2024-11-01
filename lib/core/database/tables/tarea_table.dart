import 'package:binance_api_test/core/database/database_service.dart';
import 'package:binance_api_test/core/models/tareas_response.dart';
import 'package:sqflite/sqflite.dart';

class TareasDB {
  final tableName = 'tareas';

  Future<void> crearTabla(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER NOT NULL,
    "idFormulario" INTEGER NOT NULL,
    "nombre" TEXT NOT NULL,
    "horaInicio" TEXT NOT NULL,
    "horaFin" TEXT NOT NULL,
    PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> insert({
    required int idFormulario,
    required String nombre,
    required String horaInicio,
    required String horaFin,
  }) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      """INSERT INTO $tableName (idFormulario, nombre, horaInicio, horaFin) VALUES (?, ?, ?, ?)""",
      [idFormulario, nombre, horaInicio, horaFin],
    );
  }

  Future<TareasResponse> selectAll() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> tareas =
        await database.rawQuery("""SELECT * FROM $tableName""");
    return TareasResponse.fromList(tareas);
  }

  Future<int> update({
    required int id,
    int? idFormulario,
    String? nombre,
    String? horaInicio,
    String? horaFin,
  }) async {
    final database = await DatabaseService().database;
    Map<String, dynamic> tareaCambios = {
      if (idFormulario != null) "idFormulario": idFormulario,
      if (nombre != null) "nombre": nombre,
      if (horaInicio != null) "horaInicio": horaInicio,
      if (horaFin != null) "horaFin": horaFin,
    };
    return await database.update(
      tableName,
      tareaCambios,
      where: "id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
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
    return await database
        .rawDelete("""DELETE FROM $tableName WHERE id = ?""", [id]);
  }

  Future<int> deleteByIdFormulario(int id) async {
    final database = await DatabaseService().database;
    return await database
        .rawDelete("""DELETE FROM $tableName WHERE idFormulario = ?""", [id]);
  }
}
