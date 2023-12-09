import 'package:get/get.dart';
import 'package:todoapp/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
   RxList<Task> taskList = <Task>[].obs;
  // add Task to Db
  Future<int> addTask({required Task task}){
    return DBHelper.insert(task);
  }
  // Get Task from Db
  Future<void> getTask() async{
    final List<Map<String, Object?>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
  // delete task from Db
  void deleteTask (Task task) async {
    await DBHelper.delete(task);
    getTask();
  }
  // delete all tasks from Db
   void deleteAllTask () async {
     await DBHelper.deleteAll();
     getTask();
   }

  // Update task from Db
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }

}

