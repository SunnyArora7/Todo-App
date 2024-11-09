import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/home/controller/home_controller.dart';

import '../model/home_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: Obx(
        () => Column(
          children: [
            // Task input widget
            const TaskInputWidget(),

            // Task list (wrapped with Obx to observe changes)
            homeController.task.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: homeController.task.length,
                      itemBuilder: (BuildContext context, index) {
                        return TaskListTile(
                          task: homeController.task[index],
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              homeController.completeTask(index);
                            }
                          },
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 300.0),
                      child: Text(
                        "No Task Added",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TaskInputWidget extends StatelessWidget {
  const TaskInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: homeController.taskController,
              decoration: const InputDecoration(
                hintText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              if (homeController.taskController.text.isNotEmpty) {
                homeController.addTask();
                homeController.taskController.clear();
              }
            },
            child: const Text(
              "Add Task",
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskListTile({
    required this.task,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
      ),
      subtitle: task.completed == true
          ? const Text(
              "Task Completed",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
            )
          : const Text(
              "Task Pending",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w800, fontSize: 16),
            ),
      trailing: Checkbox(
        value: task.completed,
        onChanged: onChanged,
      ),
    );
  }
}
