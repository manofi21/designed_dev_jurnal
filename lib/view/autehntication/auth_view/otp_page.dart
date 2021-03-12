import 'package:DevJurnal_new_world/constant/named_navigation_collection.dart';
import 'package:DevJurnal_new_world/view/autehntication/parent_background.dart';
import 'package:DevJurnal_new_world/flutter_otp_field_func.dart';
import 'package:DevJurnal_new_world/view_model/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpPage extends StatefulWidget {
  final String tokenAccess;
  const OtpPage({Key key, this.tokenAccess}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  AuthAccess authenctication = AuthAccess();
  // String otpStringVertify;
  Widget otpField() {
    return VerificationCode(
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(73, 79, 88, 1)),
      underlineColor: Color.fromRGBO(120, 33, 232, 1),
      autofocus: true,
      keyboardType: TextInputType.name,
      length: 6,
      clearAll: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'clear all',
          style: TextStyle(
              fontSize: 14.0,
              decoration: TextDecoration.underline,
              color: Colors.blue[700]),
        ),
      ),
      onSubmitted: (value) {
        authenctication.otpVertification(value, widget.tokenAccess);
      },
      onEditing: (bool value) {},
      onCompleted: (String value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.tokenAccess);
    return Scaffold(
      body: ParentBackgroundPage(
        swipeNavigatorFunction: () {},
        title: "Enter OTP",
        // height: ,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              otpField(),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      authenctication.resendOtp(widget.tokenAccess);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restore_outlined),
                        SizedBox(width: 15),
                        Text(
                          "Resend Otp",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// Text("Enter OTP",
//     style: GoogleFonts.roboto(
//         color: Color.fromRGBO(120, 33, 232, 1),
//         fontSize: 20,
//         fontStyle: FontStyle.normal,
//         fontWeight: FontWeight.w300)),
