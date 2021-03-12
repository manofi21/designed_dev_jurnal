import 'package:DevJurnal_new_world/constant/key_collection.dart';
import 'package:DevJurnal_new_world/model/task/task_model.dart';
import 'package:DevJurnal_new_world/view/home_page.dart';
import 'package:DevJurnal_new_world/view/status_dialog.dart';
import 'package:DevJurnal_new_world/view_model/repository/API_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currentTodo = ScopedProvider<Task>(null);

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  throw UnimplementedError();
});

final todosNotifierProvider = StateNotifierProvider<TodoNotifier>((ref) {
  return TodoNotifier(ref.read);
});

final todoExceptionProvider = StateProvider<TodoException>((ref) {
  return null;
});

// void awaitStatus(Map<bool, dynamic> map, {String navigation}) async {
//   return Future.delayed(Duration(milliseconds: 500), () {
//     showDialogClass(map, navigation: navigation);
//   });
// }

Widget timesWidget(Task _task) {
  // print(_task);
  String firstTime = _task.startTimes.split(" ")[1];
  String lastTime =
      _task.finishTimes != null ? _task.finishTimes.split(" ")[1] : " ";
  String lastText = _task.finishTimes != null ? lastTime : "...";
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(firstTime),
      Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5)),
      )
    ],
  );
}

class TodoNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  TodoNotifier(
    this.read, [
    AsyncValue<List<Task>> todos,
  ]) : super(todos ?? const AsyncValue.loading()) {
    _retrieveTodos(DateTime.now());
  }

  final Reader read;
  AsyncValue<List<Task>> previousState;
  List<Task> previousListTask;
  void _resetState() {
    if (previousState != null) {
      state = previousState;
      previousState = null;
    }
  }

  void _handleException(TodoException e) {
    _resetState();
    read(todoExceptionProvider).state = e;
  }

  void _cacheState() {
    previousState = state;
  }

  Future<void> _retrieveTodos(DateTime datePick) async {
    try {
      final todos = await read(todoRepositoryProvider).retrieveTodos(datePick);
      previousListTask = todos;
      state = AsyncValue.data(todos);
    } on TodoException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> retryLoadingTodo(DateTime datePick) async {
    state = const AsyncValue.loading();
    try {
      final todos = await read(todoRepositoryProvider).retrieveTodos(datePick);
      if (datePick.toString().split(" ")[0] ==
          DateTime.now().toString().split(" ")[0]) {
        state = AsyncValue.data(todos);
      } else {
        final date = datePick.toString().split(" ")[0];
        state = AsyncValue.data(llTaskP(date));
      }
    } on TodoException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh(DateTime datePick) async {
    try {
      final todos = await read(todoRepositoryProvider).retrieveTodos(datePick);
      state = AsyncValue.data(todos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

//   Future<void> add(Task task) async {
//     _cacheState();
//     state = state.whenData((todos) => [...todos]..add(task));

//     try {
//       // showDialogClass();
//       await read(todoRepositoryProvider).addTodo(task);
//       Navigator.pop(scaffoldKey.currentContext);
//       // awaitStatus({"Success": "Data Has Been Added"});
//     } on TodoException catch (e) {
//       Navigator.pop(scaffoldKey.currentContext);
//       // awaitStatus({"Error": e.toString()});
//       _handleException(e);
//     }
//   }

//   Future<void> edit(int id, Task newTask) async {
//     _cacheState();
// // error
//     try {
//       // showDialogClass();
//       await read(todoRepositoryProvider).edit(id, newTask);
//       Navigator.pop(scaffoldKey.currentContext);
//       // awaitStatus({"Success": "Data Has Been Edited"});
//     } on TodoException catch (e) {
//       Navigator.pop(scaffoldKey.currentContext);
//       // awaitStatus({"Error": e.toString()});
//       _handleException(e);
//     }
//   }

//   Future<void> remove(int id, Task task) async {
//     //error
//     _cacheState();
//     state = state.whenData(
//       (value) => value.where((element) => element != task).toList(),
//     );
//     try {
//       // showDialogClass();
//       await read(todoRepositoryProvider).remove(id, task);
//       Navigator.pop(scaffoldKey.currentContext);
//       // awaitStatus({"Success": "Data Has Been Deleted"});
//     } on TodoException catch (e) {
//       Navigator.pop(scaffoldKey.currentContext);
//       // awaitStatus({"Error": e.toString()});
//       _handleException(e);
//     }
//   }
}
