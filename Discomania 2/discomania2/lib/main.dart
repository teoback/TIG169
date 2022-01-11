import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'player.dart';
import 'AddPlayerView.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DiscproviderState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DiscoManiac',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}

class DiscproviderState extends ChangeNotifier {
  List<Player> _list = [];
  List<Player> get list => _list;

  void nyItem(Player item) async {
    _list.add(item);
    notifyListeners();
  }
}
