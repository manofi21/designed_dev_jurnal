import 'package:DevJurnal_new_world/model/task/task_model.dart';
import 'package:DevJurnal_new_world/view/journal_widget/swiper_controller.dart';
import 'package:flutter/material.dart';

enum ChangeDateStatus { isSelected, isSwipped }

class HomeChangeNotifier with ChangeNotifier {
  List<DateTime> _selectedDay = [
    DateTime.parse(DateTime.now().toString().split(" ")[0])
  ];
  Map<DateTime, List<Task>> _events;
  List<Task> _selectedEvents = [];

  List<DateTime> get selectedDay => this._selectedDay;

  void selectedDayVoid(DateTime dateTime) {
    final currentDateTime = DateTime.parse(dateTime.toString().split(" ")[0]);
    if (this._selectedDay.indexOf(currentDateTime) < 0) {
      this._selectedDay.add(currentDateTime);
    }
    notifyListeners();
  }

  Map<DateTime, List<Task>> get eventsProvider => this._events;

  set eventsProvider(Map<DateTime, List<Task>> event) {
    this._events = event;
    notifyListeners();
  }

  ChangeDateStatus _changeStatus = ChangeDateStatus.isSelected;

  ChangeDateStatus get changeDateStatus => this._changeStatus;

  set changeDateStatus(ChangeDateStatus thisStatus) {
    this._changeStatus = thisStatus;
    notifyListeners();
  }

  List<Task> get selectedEventProvider => this._selectedEvents;

  set selectedEventProvider(List<Task> selectedEvent) {
    this._selectedEvents = selectedEvent;
    notifyListeners();
  }

  DateTime _currentDate =
      DateTime.parse(DateTime.now().toString().split(" ")[0]);

  DateTime get currentDate => this._currentDate;

  set currentDate(DateTime index) {
    this._currentDate = DateTime.parse(index.toString().split(" ")[0]);
    notifyListeners();
  }

  SwiperController _controller = SwiperController();

  SwiperController get swipeController => this._controller;

  void startAutoSwipe() {
    this._controller.autoplay = true;
    notifyListeners();
  }

  void endAutoSwipe() {
    this._controller.autoplay = false;
    notifyListeners();
  }

  bool get isAutoPlay => this._controller.autoplay;

  bool isSameDate(DateTime date) {
    final checkDate = DateTime.parse(date.toString().split(" ")[0]);
    return checkDate == this._currentDate;
  }
}
