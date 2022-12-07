import 'dart:convert';

import 'package:flutter/material.dart';
import 'helper.dart';
import 'page_welcome.dart';
import 'package:http/http.dart' as http;

class PageRegister extends StatelessWidget {
  const PageRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page Register")),
      body: const Registerbody(),
    );
  }
}

class Registerbody extends StatefulWidget {
  const Registerbody({super.key});

  @override
  State<Registerbody> createState() => _RegisterbodyState();
}

class _RegisterbodyState extends State<Registerbody> {
  String username = "";
  String email = "";
  String password = "";
  String repassword = "";
  String mess_error = "";
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Form(
            key: _formkey,
            child: Column(
              children: [
                createTextFormField("Username", "login name",
                    "Username must not be empty", "username"),
                createTextFormField(
                    "Email", "", "Email must not be empty", "email"),
                createTextFormField(
                    "Password", "", "Password must not be empty", "password"),
                createTextFormField("Re-Password", "",
                    "Re-password must not be empty", "repassword"),
                Text(mess_error),
                TextButton.icon(
                    onPressed: () {
                      if (_formkey.currentState?.validate() == true) {
                        _formkey.currentState?.save();
                        // setState(() {
                        //   mess_error = username;
                        // });
                        // Helper.nextPage(context, PageWelcome());
                        post_register(context);
                      }
                    },
                    icon: Icon(Icons.app_registration_rounded),
                    label: Text("Save")),
              ],
            )),
      ),
    );
  }

  void post_register(BuildContext context) {
    debugPrint('trong phuong thuc debug');
    postSignup(context, username, email, password);
  }

  Future<void> postSignup(
      BuildContext context, String username, String mail, String pass) async {
    final http.Response response = await http.post(
      Helper.linkRegister,
      headers: <String, String>{
        'Content-Type': 'aplication/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "email": mail,
        "password": pass,
        "password_confirmation": pass,
        "tos": 'true',
      }),
    );
    debugPrint('trong phuong thuc dang nhap');
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 201) {
      Helper.nextPage(context, PageWelcome());
    } else {
      // throw Exception('Khong xac dinh loi trong dang ky');
    }
  }

  TextFormField createTextFormField(
      String label, String hint, String error, String save_value) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          if (save_value == "username") username = value;
          if (save_value == "email") email = value;
          if (save_value == "password") password = value;
          if (save_value == "repassword") repassword = value;
        });
      },
      obscureText:
          (save_value == "password" || save_value == "repassword") == true
              ? true
              : false,
      validator: (value) {
        String temp = value!;
        if (save_value == "username") username = value;
        if (save_value == "email") email = value;
        if (save_value == "password") password = value;
        if (save_value == "repassword") {
          repassword = value;
          if (repassword != password) {
            mess_error = "password does not match!";
            return '';
          }
        }
        if (temp.isEmpty == true) {
          setState(() {
            mess_error = error;
          });

          return '';
        } else {
          setState(() {
            mess_error = "";
          });
        }
        return null;
      },
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
