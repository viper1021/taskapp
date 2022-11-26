import 'dart:io';

import 'package:flutter_codigo_taskdb/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? myDatabase;

//singleton
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();
//

  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase(); //CREAR BASE DE DATOS
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database dbx, int version) async {
      //crear tabla correspondiente
      await dbx.execute(
          "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status TEXT)");
    });
  }

  insertRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, descripcion, status) VALUES ('Ir de compras','tenemos a tottus','false')");
    print(res);
  }

  insertTask() async {
    Database? db = await checkDatabase();
    int res = await db!.insert("TASK", {
      "title": "comprar el nuevo disco",
      "description": "Nuevo disco de Epica",
      "status": "false",
    });
    print(res);
  }

  getRawTasks() async {
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks[0]);
  }

  Future<List<TaskModel>> getTasks() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    List<TaskModel> taskModelList =
        tasks.map((e) => TaskModel.deMapAModel(e)).toList();

    //  tasks.forEach((element) {
    //    TaskModel task = TaskModel.deMapAModel(element);
    //    taskModelList.add(task);
    //  });

    return taskModelList;
  }

  updateRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate(
        "UPDATE TASK SET title ='Ir de compras',description ='Comprar comida', status = 'true'  WHERE id = 2");
    print(res);
  }

  updateTask() async {
    Database? db = await checkDatabase();
    int res = await db!.update(
        "TASK",
        {
          "title": "Ir al cine",
          "descripcion": "Es el viernes en la tarde",
          "status": "false",
        },
        where: "id = 2");
  }

  deleteRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.delete("DELETE FROM TASK WHERE id= 2");
    print(res);
  }

  deleteTask() async {
    Database? db = await checkDatabase();
    int res = await db!.delete("TASK", where: "id=3");
    print(res);
  }
}
