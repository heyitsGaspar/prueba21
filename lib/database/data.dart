import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final logger = Logger();
  static BuildContext? appContext;
  static Database? _database;
  static const String _databaseName = 'myg_database.db';
  static const int _databaseVersion = 1;

  // Tabla Alumno
  static const String tableAlumno = 'alumno';
  static const String columnNombre = 'nombre';

  // Tabla Asignatura
  static const String tableAsignatura = 'asignatura';
  static const String columnNombreAsignatura = 'nombre_asignatura';

  // Tabla Profesor
  static const String tableProfesor = 'profesor';
  static const String columnNombreCompleto = 'nombre_profesor';

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    final exists = await databaseExists(path);

    if (!exists) {
      print('Creando nueva base de datos...');
      await Directory(dirname(path)).create(recursive: true);
      final database = await openDatabase(path, version: _databaseVersion, onCreate: _createDatabase);
      _database = database;
      
    } else {
      print('Base de datos existente, abriendo...');
      final database = await openDatabase(path, version: _databaseVersion);
      _database = database;
      
    }


    final database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );

    _database = database;
    return database;
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Tabla Alumno
    const createAlumnoTableQuery = '''
      CREATE TABLE $tableAlumno (
        $columnNombre TEXT
      )
    ''';

    // Tabla Asignatura
    const createAsignaturaTableQuery = '''
      CREATE TABLE $tableAsignatura (
        $columnNombreAsignatura TEXT NOT NULL
      )
    ''';

    // Tabla Profesor
    const createProfesorTableQuery = '''
      CREATE TABLE $tableProfesor (
        $columnNombreCompleto TEXT NOT NULL
      )
    ''';

    // Ejecutar las consultas para crear las tablas
    await db.execute(createAlumnoTableQuery);
    await db.execute(createAsignaturaTableQuery);
    await db.execute(createProfesorTableQuery);
  }

  
  Future<Map<String, dynamic>> getAlumno() async {
    final db = await _database;

    if (db != null) {
      final result = await db.query(
        tableAlumno,
        limit: 2, // Limitar a un solo registro
      );

      if (result.isNotEmpty) {
        return result.first;
      }
    }

    return {}; // Devolver un mapa vacío si no se encontró ningún registro
  }


  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
    
      logger.i('base de datos cerrada');
    }

    else{
      logger.i('base de datos no inizializada');
    }
  }

  
}




