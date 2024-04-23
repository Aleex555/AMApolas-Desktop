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
      debugShowCheckedModeBanner: false,
    );
  }
}

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<String> _languages = [];
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
  }

  _fetchLanguages() async {
    var url = Uri.parse('https://roscodrom6.ieti.site/api/languages');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _languages = List<String>.from(json.decode(response.body));
        });
      } else {
        print("Error loading languages: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Language'),
      ),
      body: Column(
        children: [
          if (_languages.isNotEmpty)
            DropdownButton<String>(
              value: _selectedLanguage,
              hint: Text("Choose a language"),
              items: _languages.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordPage(language: value!),
                  ),
                );
              },
            ),
        ],
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
  String? _selectedLetter;

  @override
  void initState() {
    super.initState();
  }

  void _fetchWords(String letter) async {
    var url = Uri.parse(
        'https://roscodrom6.ieti.site/api/words/${widget.language}/$letter');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _words = List<String>.from(json.decode(response.body));
        });
      } else {
        print('Failed to load words with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words in ${widget.language}'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedLetter,
            hint: Text("Choose a letter"),
            items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((String letter) {
              return DropdownMenuItem<String>(
                value: letter,
                child: Text(letter),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLetter = value;
              });
              if (value != null) {
                _fetchWords(value);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _words.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_words[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
