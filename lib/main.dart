import 'package:flutter/material.dart';

import 'database/data.dart';

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();

  try {
    final database = await databaseHelper.initDatabase();
    
    final alumno = {
      DatabaseHelper.columnNombre: 'John jiu',
    };
    
    await database.insert(DatabaseHelper.tableAlumno, alumno);
    
    runApp(const MyApp());
  } catch (e) {
    // Manejar cualquier excepción ocurrida durante la inicialización de la base de datos
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final databaseHelper = DatabaseHelper();

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: databaseHelper.getAlumno(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final alumno = snapshot.data!;
              final nombre = alumno[DatabaseHelper.columnNombre];

              return Center(
                child: Text(
                  'Nombre del alumno: $nombre',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al obtener los datos',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}