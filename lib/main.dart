import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Data APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movie Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectTitle = "Star";
  List<String> titleList = [
    "Star",
    "Maze",
    "Flash",
    "Superman",
    "Batman",
  ];
  String desc = "No Data";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Simple Movie",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            DropdownButton(
              itemHeight: 60,
              value: selectTitle,
              onChanged: (newValue) {
                setState(() {
                  selectTitle = newValue.toString();
                });
              },
              items: titleList.map((selectTitle) {
                return DropdownMenuItem(
                  value: selectTitle,
                  child: Text(
                    selectTitle,
                  ),
                );
              }).toList(),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title search',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: _getGenre, child: const Text("Load Genre")),
            ElevatedButton(
                onPressed: _getImage, child: const Text("Load Image")),
            Text(desc,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _getGenre() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 3));
    progressDialog.dismiss();
    var apiid = "276a9b3f";
    var url = Uri.parse('http://www.omdbapi.com/?t=$selectTitle&apikey=$apiid');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var genre = parsedJson['Genre'];
        desc = "The genre of $selectTitle is $genre.";
      });
    } else {
      setState(() {
        desc = "No record";
      });
    }
    Fluttertoast.showToast(
        msg: "Found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  Future<void> _getImage() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 3));
    progressDialog.dismiss();
    var apiid = "276a9b3f";
    var url = Uri.parse('http://www.omdbapi.com/?t=$selectTitle&apikey=$apiid');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var img = parsedJson['Poster'];
        desc = "The current weather in $selectTitle is   $img.  ";
      });
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }
}
