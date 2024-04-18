import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LanguagePage(),
    );
  }
}

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<String> _languages = [];

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
  }

  _fetchLanguages() async {
    var url = Uri.parse('http://localhost:3000/languages');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _languages = List<String>.from(json.decode(response.body));
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Language'),
      ),
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_languages[index]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WordPage(language: _languages[index])));
            },
          );
        },
      ),
    );
  }
}

class WordPage extends StatefulWidget {
  final String language;

  const WordPage({Key? key, required this.language}) : super(key: key);

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  _fetchWords() async {
    var url = Uri.parse('http://localhost:3000/words/${widget.language}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _words = List<String>.from(json.decode(response.body));
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words in ${widget.language}'),
      ),
      body: ListView.builder(
        itemCount: _words.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_words[index]),
          );
        },
      ),
    );
  }
}
