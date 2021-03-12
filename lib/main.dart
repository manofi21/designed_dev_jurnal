import 'package:DevJurnal_new_world/view_model/repository/API_repository.dart';
import 'package:DevJurnal_new_world/view_model/riverpod_notifier/task_API_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'navigation/navigation.dart';
import 'view/autehntication/auth_view/sing_up.dart';

void main() {
  Routes.createRoutes();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // ApiAccess access = ApiAccess();
    // // access.singIn("piu90019@cuoly.com", "witwot77");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        overrides: [
          todoRepositoryProvider.overrideWithValue(FakeTodoRepository())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SingUp(),
          onGenerateRoute: Routes.sailor.generator(),
          navigatorKey: Routes.sailor.navigatorKey,
        ));
  }
}
