import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddPlayerView.dart';
import 'main.dart';
import 'homepage.dart';
import 'player.dart';

class DiscGame extends StatefulWidget {
  final List<Player> list;

  const DiscGame(this.list, DiscproviderState state, {Key? key})
      : super(key: key);

  @override
  State<DiscGame> createState() => _DiscGameState();
}

class _DiscGameState extends State<DiscGame> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children:
            widget.list.map((item) => gamePlayer(item, context)).toList());
  }

  Widget gamePlayer(item, context) {
    return ListTile(
      title: Text(Player.playerName),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Provider.of<DiscproviderState>(context, listen: false);
          // .removeItem(item);
        },
      ),
    );
  }
}
