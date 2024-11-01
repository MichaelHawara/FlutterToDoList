import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ToDo List App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<TaskList> currLists = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    currLists.add(TaskList(name: 'All Tasks'));
    currLists.add(TaskList(name: 'Completed Tasks'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List App',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.blueGrey,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (var list in currLists)
                NavigationRailDestination(
                  icon: const Icon(Icons.list),
                  label: Text(
                    list.name,
                    style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
            ],
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddListDialog,
            ),
          ),
          Expanded(
            child: TaskListWidget(taskList: currLists[selectedIndex]),
          ),
        ],
      ),
    );
  }

  void _showAddListDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newListName = '';

        return AlertDialog(
          title: const Text('Add New List'),
          content: TextField(
            onChanged: (value) {
              newListName = value;
            },
            decoration: const InputDecoration(hintText: "List Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newListName.isNotEmpty) {
                  setState(() {
                    currLists.add(TaskList(name: newListName));
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  final String label;
  final Color color;
  bool isCompleted;

  Task({
    required this.label,
    this.color = const Color.fromARGB(255, 72, 70, 70),
    this.isCompleted = false,
  });
}

class TaskList {
  final String name;
  final List<Task> tasks;

  TaskList({required this.name}) : tasks = [];

  void addTask(Task task) {
    tasks.add(task);
  }

  void removeTask(Task task) {
    tasks.remove(task);
  }

  List<Task> getAllTasks() {
    return tasks;
  }
}

class TaskListWidget extends StatefulWidget {
  final TaskList taskList;

  const TaskListWidget({Key? key, required this.taskList}) : super(key: key);

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          color: Colors.blueGrey[100],
          child: Text(
            widget.taskList.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.blueGrey[100],
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.taskList.getAllTasks().length,
                    itemBuilder: (context, index) {
                      final task = widget.taskList.getAllTasks()[index];
                      return TaskItemWidget(
                        task: task,
                        onDelete: () {
                          setState(() {
                            widget.taskList.removeTask(task);
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddTaskDialog();
                  },
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newTaskName = '';

        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            onChanged: (value) {
              newTaskName = value;
            },
            decoration: InputDecoration(hintText: "Task Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTaskName.isNotEmpty) {
                  setState(() {
                    widget.taskList.addTask(Task(label: newTaskName));
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final Function onDelete;

  const TaskItemWidget({Key? key, required this.task, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (newValue) {
                  task.isCompleted = newValue ?? false;
                },
              ),
              Expanded(
                child: Text(
                  task.label,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted ? Colors.green : task.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            onDelete();
          },
        ),
      ],
    );
  }
}
