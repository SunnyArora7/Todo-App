import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import '../model/home_model.dart';

class HomeController extends GetxController {
  TextEditingController taskController = TextEditingController();
  RxList<Task> task = <Task>[].obs;

  void addTask() {
    task.add(Task(title: taskController.text));
  }

  void completeTask(int index) {
    task[index].completed = !task[index].completed;
    task.refresh();
  }
}
