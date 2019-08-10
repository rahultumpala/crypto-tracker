import 'package:crypto_tracker/model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model.dart';

class MyHomePage extends StatefulWidget {
  int i = 0;
  final MyModel model;
  MyHomePage(this.model);
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    widget.model.getData();
    super.initState();
  }

  List<Widget> generator(
      int length, Map<String, dynamic> data, MyModel model, bool onFirstrun,
      [List<dynamic> val]) {
    List<dynamic> keys = data.keys.toList();
    List<dynamic> values = data.values.toList();
    print(values);
    List<Widget> k = [];
    IconData icon;
    for (var i = 0; i < length; i++) {
      switch (keys[i]) {
        case 'USD':
          {
            icon = FontAwesomeIcons.dollarSign;
            break;
          }
        case 'INR':
          {
            icon = FontAwesomeIcons.rupeeSign;
            break;
          }
        case 'EUR':
          {
            icon = FontAwesomeIcons.poundSign;
            break;
          }
        default:
      }
      k.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: 20,
              ),
              Text('${keys[i]}'),
              Text(
                ': ${values[i]}',
              ),
            ],
          ),
        ),
      );
    }
    model.oldValues = values;
    return k;
  }

  Widget firstTimeLoading(MyModel model) {
    Map<String, dynamic> m = model.data;
    dynamic keys = m.keys.toList();
    dynamic values = m.values.toList();
    if (model.data == null) {
      return Center(
        child: Text("No data"),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: m.length,
          itemBuilder: (BuildContext context, int index) {
            List<dynamic> oldValues = values[index].values.toList();
            print(oldValues);
            return Card(
              child: Container(
                // width: 250,
                // height: 250,
                child: Column(
                  children: <Widget>[
                        ListTile(
                          title: Text(
                            '     ${keys[index]} :  ',
                            style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ] +
                      generator(
                        values[index].length,
                        values[index],
                        model,
                        true,
                      ), // oldValues),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget update(MyModel model) {
    Map<String, dynamic> m = model.updateData;
    dynamic keys = m.keys.toList();
    dynamic values = m.values.toList();
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: m.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Container(
              // width: 250,
              // height: 250,
              child: Column(
                children: <Widget>[
                      ListTile(
                        title: Text(
                          '     ${keys[index]} :  ',
                          style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ] +
                    generator(
                        values[index].length, values[index], model, false),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget pageContent(MyModel model) {
    widget.i = 1;
    model.updateFunction();
    return firstTimeLoading(model);
  }

  @override
  Widget build(BuildContext context) {
    // double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MyModel model) {
        return SafeArea(
          child: Scaffold(
            body: model.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      model.getData();
                      return null;
                    },
                    child: widget.i == 0 ? pageContent(model) : update(model),
                  ),
          ),
        );
      },
    );
  }
}
