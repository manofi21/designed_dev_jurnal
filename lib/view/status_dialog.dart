import 'package:DevJurnal_new_world/constant/key_collection.dart';
import 'package:DevJurnal_new_world/navigation/navigation.dart';
import 'package:flutter/material.dart';

void showDialogClass(Map<bool, dynamic> resultValue,
    {String navigation = "", bool status = false}) {
  showDialog(
    context: registKey.currentContext == null
        ? loginKey.currentContext
        : registKey.currentContext,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => StatusDialog(resultValue, navigation, status),
  );
}

class StatusDialog extends StatelessWidget {
  final Map<bool, dynamic> resultValue;
  final String navigation;
  final bool status;
  StatusDialog(this.resultValue, this.navigation, this.status);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: resultValue == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Status : ${resultValue.keys.first == true ? 'Success' : 'Fail'}'),
                Text('Message : ${resultValue.values.first}'),
                Center(
                  child: FlatButton(
                      onPressed: () {
                        navigation.isEmpty || !(resultValue.keys.first)
                            ? Navigator.pop(context)
                            : navigateToPage(navigation,
                                status: status, otp: resultValue.values.last);
                      },
                      child: Text("OK")),
                )
              ],
            ),
    );
  }
}
