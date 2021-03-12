import 'package:DevJurnal_new_world/constant/key_collection.dart';
import 'package:DevJurnal_new_world/model/task/task_model.dart';
import 'package:DevJurnal_new_world/view/journal_widget/flutter_swiper.dart';
import 'package:DevJurnal_new_world/view_model/repository/API_repository.dart';
import 'package:DevJurnal_new_world/view_model/home_change_notifier.dart';
import 'package:DevJurnal_new_world/view_model/riverpod_notifier/task_API_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// final swipeController = SwiperController();
CalendarController calendarController = CalendarController();
Map<DateTime, List<Task>> localDateMap = Map();
int _currentIndex = 0;

void eventsChanges(List<Task> _events) {
  if (_events.isNotEmpty) {
    for (Task entry in _events) {
      DateTime thisDate = DateTime.parse(entry.startTimes.split(" ")[0]);
      if (localDateMap[thisDate] == null) {
        localDateMap[thisDate] = [];
        localDateMap[thisDate].add(entry);
      } else if (!(localDateMap[thisDate].contains(entry))) {
        localDateMap[thisDate].add(entry);
      }
    }
  }
}

class HomePageHook extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tickerProvider = useSingleTickerProvider();
    final _animationController = useAnimationController(
        vsync: tickerProvider, duration: const Duration(milliseconds: 400));
    return HomePageRiverpod(_animationController);
  }
}

final _homeChangeNotifier =
    ChangeNotifierProvider<HomeChangeNotifier>((ref) => HomeChangeNotifier());

class HomePageRiverpod extends StatefulWidget {
  final AnimationController animationController;

  const HomePageRiverpod(this.animationController);
  @override
  _HomePageRiverpodState createState() => _HomePageRiverpodState();
}

class _HomePageRiverpodState extends State<HomePageRiverpod> {
  @override
  void initState() {
    super.initState();
    widget.animationController
        .forward()
        .whenComplete(() => widget.animationController.stop());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final homeChangeNotifier = watch(_homeChangeNotifier);
        final todosState = watch(todosNotifierProvider.state);
        return Scaffold(
          body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      stops: [
                    0.0,
                    0.9
                  ],
                      colors: [
                    Color.fromRGBO(86, 98, 117, 1),
                    Color.fromRGBO(22, 22, 22, 0.9)
                  ])),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  BuidlTableCalendar(
                    animationController: widget.animationController,
                    calendarController: calendarController,
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                      child: todosState.when(
                          data: (values) {
                            eventsChanges(values);
                            return BuidlEventList();
                          },
                          loading: () => Center(
                                child: CircularProgressIndicator(),
                              ),
                          error: (e, _) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e.toString()),
                                    Container(
                                      color: Colors.blue,
                                      child: FlatButton(
                                          onPressed: () {
                                            context
                                                .read(todosNotifierProvider)
                                                .retryLoadingTodo(
                                                    homeChangeNotifier
                                                        .currentDate);
                                            homeChangeNotifier.swipeController
                                                .previous(animation: true);
                                          },
                                          child: Text("Refresh")),
                                    )
                                  ],
                                ),
                              )))
                ],
              )),
        );
      },
    );
  }
}

class BuidlTableCalendar extends StatelessWidget {
  final CalendarController calendarController;
  final AnimationController animationController;
  const BuidlTableCalendar(
      {Key key, this.calendarController, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeChangeNotifier = context.read(_homeChangeNotifier);
    return TableCalendar(
      locale: 'en_US',
      calendarController: calendarController,
      events: homeChangeNotifier.eventsProvider == null
          ? localDateMap
          : homeChangeNotifier.eventsProvider,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekdayStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        weekendStyle: TextStyle().copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        eventDayStyle: TextStyle().copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        holidayStyle: TextStyle().copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      headerDateChild: (dateString) {
        return GradientText(dateString,
            gradient: Gradients.buildGradient(
                Alignment.topCenter, Alignment.bottomCenter, [
              Color.fromRGBO(0, 209, 255, 1),
              Color.fromRGBO(0, 148, 148, 1)
            ]),
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold));
      },
      headerStyle: HeaderStyle(
          rightChevronIcon:
              Icon(Icons.arrow_right, size: 25, color: Colors.white),
          leftChevronIcon:
              Icon(Icons.arrow_left, size: 25, color: Colors.white),
          titleYearStyle: TextStyle(
              color: Color.fromRGBO(126, 132, 142, 1),
              fontSize: 18,
              fontWeight: FontWeight.bold),
          titleMonthStyle: TextStyle(
              color: Colors.orange, fontSize: 25, fontWeight: FontWeight.bold),
          centerHeaderTitle: true),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
            child: Container(
              // height: 50,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 2,
                    color: Color.fromRGBO(0, 0, 0, 0.3))
              ], shape: BoxShape.circle, color: Color.fromRGBO(0, 191, 218, 1)),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange[400]),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        if (homeChangeNotifier.currentDate !=
            DateTime.parse(date.toString().split(" ")[0])) {
          homeChangeNotifier.currentDate = date;
        }
        if (!(homeChangeNotifier.selectedDay
            .contains(homeChangeNotifier.currentDate))) {
          homeChangeNotifier.selectedDayVoid(date);
          context.read(todosNotifierProvider).retryLoadingTodo(date);
        }

        if (!(homeChangeNotifier.selectedDay[_currentIndex] ==
            homeChangeNotifier.currentDate)) {
          homeChangeNotifier.startAutoSwipe();
        }

        var sortedKeys = [
          localDateMap.keys.last,
          ...localDateMap.keys
              .toList(growable: false)
              .sublist(0, localDateMap.length - 1)
        ];
        Map<DateTime, List<Task>> task = Map();
        sortedKeys.forEach((e) {
          task[e] = localDateMap[e];
        });
        print(sortedKeys);
        homeChangeNotifier.eventsProvider = localDateMap;

        // localDateMap.clear();
        // localDateMap = task;
      },
    );
  }
}

class BuidlEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeNotifier = context.read(_homeChangeNotifier);
    print(homeNotifier.eventsProvider == null);
    final list = homeNotifier.selectedDay;
    Widget _buildItem(BuildContext context, int index) {
      final listTask = list[index];
      String toString = DateFormat("dd MMMM yyyy").format(listTask);
      final dateData = homeNotifier.eventsProvider == null
          ? localDateMap[listTask]
          : homeNotifier.eventsProvider[listTask];
      return Container(
        padding: EdgeInsets.only(bottom: 10), //30
        child: Container(
            padding: EdgeInsets.only(top: 17, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(toString,
                        style: TextStyle(
                            color: Color.fromRGBO(252, 138, 20, 1),
                            fontSize: 22)),
                    Row(children: [
                      Icon(Icons.edit),
                      InkWell(
                        onTap: () {
                          print(context
                              .read(_homeChangeNotifier)
                              .selectedEventProvider);
                        },
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Color.fromRGBO(252, 138, 20, 1),
                        ),
                      )
                    ])
                  ],
                ),
                dateData == null
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                            itemCount: dateData.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              children: [
                                                TextSpan(
                                                  text: dateData[index]
                                                      .projectNames,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " - ${dateData[index].featureNames ?? ""}",
                                                )
                                              ]),
                                        ),
                                        subtitle: Text(
                                          dateData[index].description ?? "",
                                          style: TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: timesWidget(dateData[index]),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            })),
              ],
            )),
      );
    }

    Widget _buildEventList() {
      final contextRead = context.read(_homeChangeNotifier);
      return SizedBox(
          width: 600,
          child: Swiper(
            fade: 1,
            index: _currentIndex,
            onIndexChanged: (int index) {
              _currentIndex = index;
              if (contextRead.currentDate == contextRead.selectedDay[index]) {
                contextRead.endAutoSwipe();
              }

              if (!(contextRead.isAutoPlay)) {
                context.read(_homeChangeNotifier).currentDate = list[index];
                calendarController.setSelectedDay(
                    DateTime(
                        list[index].year, list[index].month, list[index].day),
                    runCallback: true);
                contextRead.endAutoSwipe();
              }
            },
            curve: Curves.ease,
            scale: 0.8,
            itemWidth: MediaQuery.of(context).size.width - 20,
            controller: contextRead.swipeController,
            layout: SwiperLayout.TINDER,
            autoplay: false,
            outer: false,
            itemHeight: MediaQuery.of(context).size.height,
            viewportFraction: 0.8,
            autoplayDelay: 1000,
            loop: true,
            itemBuilder: _buildItem,
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            autoplayDisableOnInteraction: false,
          ));
    }

    return _buildEventList();
  }
}
