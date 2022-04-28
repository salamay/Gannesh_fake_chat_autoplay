import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ganeshchatap/MyProvider.dart';
import 'package:ganeshchatap/home.dart';
import 'package:provider/provider.dart';

import 'ChatScreen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>MyProvider(),
      child: MaterialApp(
          home: Home()
      ),
    );
  }
}


