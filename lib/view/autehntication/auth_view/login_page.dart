import 'package:DevJurnal_new_world/view/autehntication/parent_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:motion_widget/motion_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AnimationController _controller;
  Animation _animation;
  ScrollPhysics physics = NeverScrollableScrollPhysics();
  final scrollController = ScrollController();
  int currentIndex = 0;
  bool isIgnore = false;

  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePass = FocusNode();

  void isFocusTrue(FocusNode node) {
    if (node.hasFocus) {
      _controller.forward().whenComplete(() => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          ));
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: 180.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNodeEmail.addListener(() {
      isFocusTrue(_focusNodeEmail);
    });

    _focusNodePass.addListener(() {
      isFocusTrue(_focusNodePass);
    });

    KeyboardVisibilityNotification().addNewListener(
      onHide: () {
        _focusNodeEmail.unfocus();
        _focusNodePass.unfocus();
      },
    );
  }

  Widget formField(TextEditingController controller) => SizedBox(
        height: 55,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(244, 243, 243, 1),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: TextFormField(
                controller: controller,
                focusNode: controller == emailController
                    ? _focusNodeEmail
                    : _focusNodePass,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                    border: InputBorder.none,
                    hintText: controller == emailController
                        ? "Email Address"
                        : "Password",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            )),
      );

  @override
  Widget build(BuildContext context) {
    return ParentBackgroundPage(
      controller: scrollController,
      height: _animation.value,
      title: "Login to \nExisting Account",
      swipeTitle: "Swipe up to create a new account",
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            formField(emailController),
            formField(passwordController),
            nextButton(context),
            SizedBox(
              height: 13,
            ),
            Center(
                child: Text("I forgot my password",
                    style: GoogleFonts.roboto(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(120, 33, 232, 1)))),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}

Widget nextButton(BuildContext context) {
  return Center(
    child: Container(
        height: 40,
        width: (MediaQuery.of(context).size.width / 2) + 50,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 5),
                  // spreadRadius: 2,
                  color: Color.fromRGBO(0, 0, 0, 0.3))
            ],
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Color.fromRGBO(120, 33, 232, 1)),
        child: FlatButton(
          onPressed: () {},
          child: Text("Login",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        )),
  );
}
