import 'package:DevJurnal_new_world/constant/key_collection.dart';
import 'package:DevJurnal_new_world/constant/named_navigation_collection.dart';
import 'package:DevJurnal_new_world/navigation/navigation.dart';
import 'package:DevJurnal_new_world/view/autehntication/parent_background.dart';
import 'package:DevJurnal_new_world/view_model/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class SingUp extends StatefulWidget {
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AuthAccess access = AuthAccess();
  int _currentIndex = 0;

  AnimationController _controller;
  Animation<double> _animation;
  ScrollController scrollController;

  static FocusNode _focusNodeName = FocusNode();
  static FocusNode _focusNodeEmail = FocusNode();
  static FocusNode _focusNodePass = FocusNode();

  List<FocusNode> listFocus = [_focusNodeName, _focusNodeEmail, _focusNodePass];

  void isFocusTrue(FocusNode node) {
    if (node.hasFocus) {
      _controller.forward().whenComplete(() => scrollController.animateTo(
            scrollController.position.maxScrollExtent - 250,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          ));
    } else {
      _controller.reverse();
      // _controller.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    nameController.text = "hoiiiiii";
    emailController.text = "jqb04623@cuoly.com";
    passwordController.text = "hoiiiiii23231232132";

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 200.0).animate(_controller)
      ..addListener(() {
        // setState(() {});
      });

    listFocus[0].addListener(() {
      isFocusTrue(listFocus[0]);
    });

    listFocus[1].addListener(() {
      // print(1);
      isFocusTrue(listFocus[1]);
    });

    listFocus[2].addListener(() {
      // print(2);
      isFocusTrue(listFocus[2]);
    });

    KeyboardVisibilityNotification().addNewListener(
      onHide: () {
        listFocus.forEach((e) {
          e.unfocus();
        });
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
                focusNode: controller == nameController
                    ? listFocus[0]
                    : controller == emailController
                        ? listFocus[1]
                        : listFocus[2],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                    border: InputBorder.none,
                    hintText: controller == emailController
                        ? "Email Address"
                        : controller == passwordController
                            ? "Password"
                            : "Name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            )),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: registKey,
      body: ParentBackgroundPage(
        controller: scrollController,
        height: _animation.value,
        title: "Create an \nAccount",
        swipeTitle: "Swipe up to sign in",
        swipeNavigatorFunction: () {
          navigateToPage(SignInNavigation);
        },
        child: Focus(
          onFocusChange: (bool check) {
            if (check) {
              print(check);
              // listFocus.forEach((e) => e.unfocus());
              // listFocus[_currentIndex].requestFocus();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                formField(nameController),
                formField(emailController),
                formField(passwordController),
                SizedBox(height: 10),
                nextButton(context),
                SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
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
            onPressed: () {
              access.signUp(nameController.text, emailController.text,
                  passwordController.text);
              // navigateToPage(OtpPageNavigation);
            },
            child: Text("Next",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          )),
    );
  }
}
