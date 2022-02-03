import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'apistuff.dart';

void main() {
  var state = ListanproviderState();
  state.visaLista;
  runApp(ChangeNotifierProvider(
      create: (context) => ListanproviderState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Listan',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Listan'),
          actions: [
            PopupMenuButton(
                onSelected: (value) {
                  Provider.of<ListanproviderState>(context, listen: false)
                      .setFilter(value!);
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text('Alla'),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text('Färdiga'),
                        value: 2,
                      ),
                      const PopupMenuItem(
                        child: Text('Ej färdig'),
                        value: 3,
                      )
                    ])
          ],
        ),
        body: Consumer<ListanproviderState>(
            builder: (context, state, child) => Listan(
                  _filterList(state.list, state._filterBy),
                )),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 40.0),
          onPressed: () async {
            var nyAkt = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SecondView(ListSpec(title: '', id: '', done: false))));

            if (nyAkt != null) {
              Provider.of<ListanproviderState>(context, listen: false)
                  .nyItem(nyAkt);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  List<ListSpec> _filterList(list, filterBy) {
    if (filterBy == 2) {
      return list.where((item) => item.done == true).toList();
    } else if (filterBy == 3) {
      return list.where((item) => item.done == false).toList();
    }
    return list;
  }
}

class SecondView extends StatefulWidget {
  final ListSpec item;

  const SecondView(this.item, {Key? key}) : super(key: key);

  @override
  State<SecondView> createState() {
    // ignore: no_logic_in_create_state
    return _SecondViewState(item);
  }
}

class _SecondViewState extends State<SecondView> {
  late String title;
  TextEditingController textEditingController = TextEditingController();

  _SecondViewState(ListSpec item) {
    title = item.title;
    textEditingController = TextEditingController(text: item.title);

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
          title: const Text('Ny aktivitet'),
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
                    labelText: 'Ny aktivitet?',
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Lägg till'),
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                  } else {
                    Navigator.pop(
                        context,
                        ListSpec(
                          title: title,
                          id: '',
                        ));
                  }
                },
              )
            ],
          ),
        ));
  }
}

class Listan extends StatefulWidget {
  final List<ListSpec> list;

  const Listan(this.list, {Key? key}) : super(key: key);

  @override
  State<Listan> createState() => _ListanState();
}

class _ListanState extends State<Listan> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: widget.list.map((item) => _toDoItem(item, context)).toList());
  }

  Widget _toDoItem(item, context) {
    return ListTile(
      leading: Checkbox(
        value: item.done,
        onChanged: (bool? value) {
          setState(() {
            item.done = value!;
            Provider.of<ListanproviderState>(context, listen: false)
                .klar(item, value);
          });
        },
      ),
      title: Text(item.title,
          style: TextStyle(
              decoration: item.done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none)),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Provider.of<ListanproviderState>(context, listen: false)
              .removeItem(item);
        },
      ),
    );
  }
}

class ListSpec {
  String title;
  bool done;
  String id;

  ListSpec({required this.title, required this.id, this.done = false});

  static Map<String, dynamic> toJson(ListSpec item) {
    return {'title': item.title, 'done': item.done, 'id': item.id};
  }

  static ListSpec fromJson(Map<String, dynamic> json) {
    return ListSpec(
      title: json['title'],
      done: json['done'],
      id: json['id'],
    );
  }
}

class ListanproviderState extends ChangeNotifier {
  late List<ListSpec> _list = [];
  Object _filterBy = 'Alla';
  List<ListSpec> get list => _list;
  Object get filterBy => _filterBy;

  Future visaLista() async {
    List<ListSpec> list = await apiGrejer.getItem();
    _list = list;
    notifyListeners();
  }

  void nyItem(ListSpec item) async {
    _list = await apiGrejer.nyItem(item);
    //_list.add(item);          Gammal
    notifyListeners();
  }

  void removeItem(ListSpec item) async {
    _list = await apiGrejer.removeItem(item.id);
    //_list.remove(item);         Gammal
    notifyListeners();
  }

  void setFilter(Object filterBy) {
    _filterBy = filterBy;
    notifyListeners();
  }

  void klar(ListSpec item, value) async {
    item.done = !item.done;
    await apiGrejer.updateItem(item, value);
    notifyListeners();
  }
}
