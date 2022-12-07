import 'dart:convert';

import 'package:bai1/myaccount.dart';
import 'package:bai1/page_welcome.dart';
import 'package:bai1/profile.dart';
import 'package:bai1/token.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Helper {
  static Uri linkRegister =
      Uri.parse("https://chocaycanh.club/public/api/register");
  static Uri linkLogin = Uri.parse("https://chocaycanh.club/public/api/login");
  static Uri linkProfile = Uri.parse("https://chocaycanh.club/public/api/me");
  static Uri linkUpdateProfile =
      Uri.parse("https://chocaycanh.club/public/api/me/details");
  static Uri linkuploadavatar =
      Uri.parse("https://chocaycanh.club/public/api/me/avatar");
  static String baseurl = "https://chocaycanh.club/public/api/me/base/";
  static String token = "";
  static Widget createBottomNaviItem(
      String title, IconData icon, Function() press) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: press,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  static void nextPage(BuildContext context, Widget page) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  static void newPage(BuildContext context, Widget page) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  static void newUniquePage(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }

  static Future<void> postSignup(
      BuildContext context, String username, String mail, String pass) async {
    final http.Response response = await http.post(
      linkRegister,
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
      throw Exception('Khong xac dinh loi trong dang ky');
    }
  }

  static Future<void> getProfile(BuildContext context) async {
    final http.Response response = await http.get(
      linkProfile,
      headers: <String, String>{
        'Content-Type': 'aplication/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Token.value,
        'Accept': 'application/json',
      },
    );
    debugPrint('.. get Profile ..');
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      Profile.fromJson((body['data']));
      Helper.newUniquePage(context, MyaccountPage());
    } else {
      // throw Exception('Khong xac dinh loi trong dang ky');
    }
  }
}
