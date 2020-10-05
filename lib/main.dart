import 'package:flutter/material.dart';
import 'package:flutter_lista_compras/DatabaseHelper.dart';
import 'package:flutter_lista_compras/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lista Compras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = new TextEditingController();
  List<Todo> taskList = new List();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          taskList.add(Todo(id: element['id'], title: element['title']));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                        decoration:
                            InputDecoration(hintText: "Entre com o item"),
                        controller: textController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Digitar o item';
                          }
                          return null;
                        }),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_formKey.currentState.validate()) _addTodo();
                    },
                  )
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: taskList.isEmpty
                      ? Container()
                      : ListView.builder(itemBuilder: (ctx, index) {
                          if (index == taskList.length) return null;
                          return ListTile(
                            title: Text(taskList[index].title),
                            leading: Text(taskList[index].id.toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTodo(taskList[index].id),
                            ),
                          );
                        }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addTodo() async {
    String task = textController.text;
    var id = await DatabaseHelper.instance.insert(Todo(title: task));
    setState(() {
      taskList.insert(0, Todo(id: id, title: task));
    });
    textController.clear();
  }

  void _deleteTodo(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      taskList.removeWhere((element) => element.id == id);
    });
  }
}
