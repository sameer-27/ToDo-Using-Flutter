import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.orange,
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List todos = List.empty();
  String input = "";
  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyApp").doc(input);
    Map<String, String> todos = {"todosTitle": input};
    documentReference
        .set(
      todos,
    )
        .whenComplete(
      () {
        print("$input created");
      },
    );
  }

  deleteTodos() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To - do app'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text("Add new todo"),
                content: TextField(
                  onChanged: (String value) {
                    input = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      createTodos();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Add",
                    ),
                  )
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Mytodos").snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentsnapshot =
                  (snapshot.data as QuerySnapshot).docs[index];
              return Dismissible(
                key: Key(
                  index.toString(),
                ),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      documentsnapshot["Todotitle"],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(
                          () {
                            todos.removeAt(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
