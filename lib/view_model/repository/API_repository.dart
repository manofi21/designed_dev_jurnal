import 'dart:math';
import 'package:DevJurnal_new_world/model/task/task_model.dart';
import 'package:intl/intl.dart';

abstract class TodoRepository {
  Future<List<Task>> retrieveTodos(DateTime datePicked);
  Future<void> addTodo(Task task);
  // Future<void> toggle(String id);
  Future<void> edit(int id, Task task);
  Future<void> remove(int id, Task task);
}

class TodoException implements Exception {
  const TodoException(this.error);

  final String error;

  @override
  String toString() {
    return '''
Todo Error: $error
    ''';
  }
}

const double errorLikelihood = 0.4;

class FakeTodoRepository implements TodoRepository {
  FakeTodoRepository() : random = Random() {
    mockTodoStorage = [...lTask2];
  }

  List<Task> mockTodoStorage;
  final Random random;

  @override
  Future<List<Task>> retrieveTodos(DateTime datePicked) async {
    await _waitRandomTime();
    // retrieving mock storage
    if (random.nextDouble() < 0.3) {
      throw const TodoException('Todos could not be retrieved');
    } else {
      return mockTodoStorage;
    }
  }

  Future<void> _waitRandomTime() async {
    await Future.delayed(
      Duration(seconds: random.nextInt(3)),
      () {},
    ); // simulate loading
  }

  @override
  Future<void> addTodo(Task task) async {
    await _waitRandomTime();
    // updating mock storage
    if (random.nextDouble() < errorLikelihood) {
      throw const TodoException('Todo could not be added');
    } else {
      mockTodoStorage = [...mockTodoStorage]..add(Task());
    }
  }

  @override
  Future<void> edit(int id, Task task) async {
    await _waitRandomTime();
    // updating mock storage
    if (random.nextDouble() < errorLikelihood) {
      throw const TodoException('Could not update todo');
    } else {
      print("API_Repository : " + task.toString());
      mockTodoStorage = [
        for (final todo in mockTodoStorage)
          if (mockTodoStorage.indexOf(todo) == id) task else todo,
      ];
    }
  }

  @override
  Future<void> remove(int id, Task task) async {
    await _waitRandomTime();
    // updating mock storage
    if (random.nextDouble() < errorLikelihood) {
      throw const TodoException('Todo could not be removed');
    } else {
      mockTodoStorage =
          mockTodoStorage.where((element) => element != task).toList();
    }
  }
}

List<Task> lTask = [
  Task(
      idUser: "1",
      idProject: "1",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: "2021-02-15 16:20",
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 7)))),
  Task(
      idUser: "3",
      idProject: "1",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: "2021-02-15 16:20",
      finishTimes: "2021-02-15 17:20"),
  Task(
      idUser: "3",
      idProject: "1",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: "2021-02-15 16:20",
      finishTimes: "2021-02-15 17:20"),
  Task(
      idUser: "2",
      idProject: "1",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: "2021-02-15 16:20",
      finishTimes: "2021-02-15 17:20"),
  Task(
      idUser: "1",
      idProject: "1",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: "2021-02-15 16:20",
      finishTimes: "2021-02-15 17:20")
];

List<Task> lTask2 = [
  Task(
      idUser: "1",
      idProject: "2",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 7)))),
  Task(
      idUser: "1",
      idProject: "2",
      projectNames: "DevJournal",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())),
];

List<Task> lTask3 = [
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 1))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(hours: 4)))),
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 1))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(hours: 4)))),
  Task(
      idUser: "3",
      idProject: "2",
      projectNames: "DevJournal Web",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 1))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(hours: 6)))),
  Task(
      idUser: "3",
      idProject: "2",
      projectNames: "DevJournal Web",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 1))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(hours: 6)))),
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 2))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(hours: 6)))),
];

List<Task> lTask4 = [
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 1))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(hours: 4)))),
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web 2",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy 2",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 1))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(minutes: 45)))),
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web 2",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy 2",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 2))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(minutes: 45)))),
];

List<Task> llTask = [
  Task(
      idUser: "2",
      idProject: "2",
      projectNames: "DevJournal Web 2",
      featureNames: "Dev Schedule",
      description: "App for record dev activitiy 2",
      startTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(days: 2))),
      finishTimes: DateFormat("yyyy-MM-dd HH:mm")
          .format(DateTime.now().add(Duration(minutes: 45)))),
];

List<Task> llTaskP(String str) {
  // startTimes: DateFormat("yyyy-MM-dd HH:mm")
  //   .format(DateTime.now().add(Duration(days: 2))),
  return [
    Task(
        idUser: "2",
        idProject: "2",
        projectNames: "DevJournal Web 2",
        featureNames: "Dev Schedule",
        description: "App for record dev activitiy 2",
        startTimes: str + " " + DateFormat("HH:mm").format(DateTime.now()),
        finishTimes: DateFormat("yyyy-MM-dd HH:mm")
            .format(DateTime.now().add(Duration(minutes: 45)))),
  ];
}
