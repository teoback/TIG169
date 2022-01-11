import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'homepage.dart';
import 'player.dart';

class AddPlayerView extends StatefulWidget {
  final Player item;
  const AddPlayerView(this.item);

  @override
  State<AddPlayerView> createState() {
    return _AddPlayerViewState(item);
  }
}

class _AddPlayerViewState extends State<AddPlayerView> {
  late String title;
  TextEditingController textEditingController = TextEditingController();

  _AddPlayerViewState(Player item) {
    title = Player.playerName;
    textEditingController = TextEditingController(text: Player.playerName);

    textEditingController.addListener(() {
      setState(() {
        title = textEditingController.text;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Ny spelare'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Ny spelare?',
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Lägg till'),
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                  } else {
                    Navigator.pop(context, Player());
                  }
                },
              )
            ],
          ),
        ));
  }
}
