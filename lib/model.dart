import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyModel extends Model {
  Map<String, dynamic> m;
  Map<String, dynamic> l;
  List<dynamic> oldValues;
  bool _isloading;
  List<dynamic> keys;
  List<dynamic> values;
  Map<String, String> myHeaders = {
    'Apikey':
        '391d9fc879e01ce75b1e99fe21e6cce7a802081c23d6c7e037b6032c7728f084',
  };

  String myUrl =
      'https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,LTC,ETH,EOS&tsyms=USD,EUR';

  getData() async {
    _isloading = true;
    notifyListeners();
    http.Response response = await http.get(
      myUrl,
      headers: myHeaders,
    );
    _isloading = false;
    m = json.decode(response.body);
    notifyListeners();
  }

  listen() async {
    http.Response response = await http.get(
      myUrl,
      headers: myHeaders,
    );
    l = json.decode(response.body);
    print(l);
  }

  updateFunction() async {
    while (true) {
      await listen();
      keys = l.keys.toList();
      values = l.values.toList();
      notifyListeners();
    }
  }

  bool get isLoading {
    return _isloading;
  }

  Map<String, dynamic> get updateData {
    return l;
  }

  Map<String, dynamic> get data {
    return m;
  }
}
