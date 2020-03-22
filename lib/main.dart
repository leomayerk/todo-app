import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    //inicializa items
    items = [];
    // adiciona um item à lista no início da aplicação
    // items.add(Item(title: "Banana", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controlador para buscar informações
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    //setState pra atualizar a tela (se não, iria criar e n att a tela)
    setState(() {
      widget.items.add(
        Item(title: newTaskCtrl.text, done: false),
      );
      newTaskCtrl.text = "";
      //ou
      // newTaskCtrl.clear();
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      //converte string dos dados em json
      Iterable decoded = jsonDecode(data);
      // percorre itens do decoded (json) e add itens na lista
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //leading: Text(">>"),
          title: TextFormField(
              controller: newTaskCtrl,
              keyboardType: TextInputType.text, //tipo do teclado texto
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                  labelText: "New task",
                  labelStyle: TextStyle(color: Colors.white))),
          actions: <Widget>[
            Icon(Icons.add),
          ],
        ),
        body: ListView.builder(
          //widget.alguma coisa pra acessar a classe pai (items) criada fora
          itemCount: widget.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            //facilitar pra n chamar toda hora widget.items[index]
            final item = widget.items[index];

            //Dismissible é o efeito de arrastar cada item da lista
            return Dismissible(
              //checkboxListTile são os itens da lista em com check
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              //Não recomendável (apenas pq n tem um id passo o item.title)
              //fora do CheckboxListTile  pq o Dismissible precisa de key
              key: Key(item.title),
              background: Container(
                color: Colors.red.withOpacity(0.6),
                child: IconTheme(
                    data: IconThemeData(
                      color: Colors.white,
                    ),
                    child: Icon(Icons.delete,)),
              ),
              onDismissed: (direction) {
                //se a direção for da direita p esquerda
                if (direction == DismissDirection.endToStart) {
                  remove(index);
                }
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          //chamar método add() em parênteses
          onPressed: add,
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ));
  }
}
