import 'package:discomania2/AddPlayerView.dart';
import 'package:discomania2/Discgame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Discomaniac'),
        ),
        body: Consumer<DiscproviderState>(
            builder: (context, state, child) => DiscGame(state.list, state)),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 40),
          onPressed: () async {
            var nyPlayer = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPlayerView(Player())));
            if (nyPlayer != null) {
              Provider.of<DiscproviderState>(context, listen: false)
                  .nyItem(nyPlayer);
            }
          },
        ));
  }

  List<Player> _filterList(list) {
    return list;
  }
}
