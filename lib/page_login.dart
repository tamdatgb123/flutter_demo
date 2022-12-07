import 'dart:convert';
import 'dart:io';

import 'package:bai1/helper.dart';
import 'package:bai1/mainpage.dart';
import 'package:bai1/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page Login")),
      body: const Login_body(),
    );
  }
}

class Login_body extends StatefulWidget {
  const Login_body({super.key});

  @override
  State<Login_body> createState() => _Login_bodyState();
}

class _Login_bodyState extends State<Login_body> {
  String mess_error = "";
  String username = "";
  String password = "";
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.all(8.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            createTextFormField('username', "username for login",
                "username must not be empty!", "username"),
            createTextFormField('password', "password for login",
                "password must not be empty!", "password"),
            Text(
              mess_error,
              style: TextStyle(color: Colors.red),
            ),
            TextButton.icon(
              onPressed: () {
                postLogin(context, username, password);
              },
              icon: Icon(Icons.login_rounded),
              label: Text("login"),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> postLogin(
      BuildContext context, String username, String pass) async {
    final http.Response response = await http.post(
      Helper.linkLogin,
      headers: <String, String>{
        'Content-Type': 'aplication/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": pass,
        "device_name": "app",
      }),
    );
    debugPrint('trong phuong thuc dang nhap');
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      Token.fromJson(jsonDecode(response.body));
      Helper.token = Token.value;
      debugPrint(Helper.token);
      Helper.newPage(context, Mainpage());
    } else {
      throw Exception('Khong xac dinh loi trong dang nhap');
    }
  }

  TextFormField createTextFormField(
      String label, String hint, String error, String save_value) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          if (save_value == "username") username = value;
          if (save_value == "password") password = value;
        });
      },
      obscureText:
          (save_value == "password" || save_value == "repassword") == true
              ? true
              : false,
      validator: (value) {
        String temp = value!;
        if (save_value == "username") username = value;
        if (save_value == "password") password = value;
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
