import 'package:DevJurnal_new_world/view/home_page.dart';
import 'package:flutter/material.dart';

void showDialogClass(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => AddDialog(),
  );
}

class AddDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        backgroundColor: Color.fromRGBO(24, 123, 159, 1),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Create a New Task',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              // Text('Message : ${status.values.first}'),
              Text('16th February 2021',
                  style: TextStyle(color: Colors.orange, fontSize: 15)),
              SizedBox(height: 10),
              // InnerShadow(
              //   blur: 5,
              //   color: const Color.fromRGBO(86, 98, 117, 1),
              //   offset: const Offset(5, 5),
              //   child:
              SizedBox(
                height: 48,
                child: Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              AssetImage("assets/text_field_background.png")),
                      color: Color.fromRGBO(244, 243, 243, 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //
                    child: Center(
                      child: TextFormField(
                        // controller: controller,
                        // focusNode: _focusNodeName,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 17),
                            border: InputBorder.none,
                            // hintText: controller == nameController
                            //     ? "Your Name"
                            //     : "Password",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    )),
              ),
              SizedBox(
                height: 48,
                child: Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              AssetImage("assets/text_field_background.png")),
                      color: Color.fromRGBO(244, 243, 243, 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //
                    child: Center(
                      child: TextFormField(
                        // controller: controller,
                        // focusNode: _focusNodeName,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 17),
                            border: InputBorder.none,
                            // hintText: controller == nameController
                            //     ? "Your Name"
                            //     : "Password",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    )),
              ),
              SizedBox(
                height: 48,
                child: Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              AssetImage("assets/text_field_background.png")),
                      color: Color.fromRGBO(244, 243, 243, 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //
                    child: Center(
                      child: TextFormField(
                        // controller: controller,
                        // focusNode: _focusNodeName,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 17),
                            border: InputBorder.none,
                            // hintText: controller == nameController
                            //     ? "Your Name"
                            //     : "Password",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    )),
              ),
              SizedBox(height: 10),
              Container(
                // height: 25,
                // margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/text_field_background.png")),
                  color: Color.fromRGBO(244, 243, 243, 1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: TextFormField(
                    // controller: descriptionController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 10, bottom: 17, top: 10),
                    ),
                    maxLines: 4,
                  ),
                ),
              ),
              // ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 5),
                          // spreadRadius: 2,
                          color: Color.fromRGBO(0, 0, 0, 0.3))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: Colors.orange),
                // color: Colors.orange,
                child: FlatButton(
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
