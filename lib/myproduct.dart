import 'package:flutter/material.dart';

import 'helper.dart';
import 'mainpage.dart';
import 'myaccount.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("my product page")),
      body: Container(),
      bottomNavigationBar: Container(
        height: 65,
        width: double.infinity,
        color: Colors.orange,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Helper.createBottomNaviItem("Home", Icons.home, () {
            Helper.newPage(context, Mainpage());
          }),
          Helper.createBottomNaviItem("Products", Icons.library_books, () {}),
          Helper.createBottomNaviItem("My account", Icons.account_box, () {
            Helper.newPage(context, MyaccountPage());
          }),
        ]),
      ),
    );
  }
}
