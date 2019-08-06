import 'package:crypto_tracker/model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model.dart';
import './homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyModel model = MyModel();
    return ScopedModel(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crypto Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(model),
      ),
    );
  }
}
