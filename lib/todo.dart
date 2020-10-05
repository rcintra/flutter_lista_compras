class Todo {
  int id;
  String title;

  Todo({this.id, this.title});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  factory Todo.fromJson(Map<String, dynamic> parsedJson) {
    return Todo(id: parsedJson['id'], title: parsedJson['title']);
  }
}
