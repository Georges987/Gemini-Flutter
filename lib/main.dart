import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geminix/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geminix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  late GenerativeModel _model;

  List<String> _generated_text = [];

  void initState() {
    // TODO: implement initState
    super.initState();

    const apiKey = APIKEY;

    if (apiKey == null) {
      print('No \$API_KEY environment variable');

      // exit(1);
    }
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    _generateText('Salut Gemini');
  }

  void _generateText(text) async {
    setState(() {
      debugPrint("loading");
      _generated_text.add("Génération en cours...");
    });

    final content = [Content.text(text)];
    final response = await _model.generateContent(content);
    setState(() {
      _generated_text
          .add(response.text ?? 'Aucune réponse obtenue de la part de Gemini');
    });
  }

  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Geminix'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                height: 535,
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(_generated_text.last),
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre texte',
                ),
                controller: _textEditingController,
              ),
              ElevatedButton(
                onPressed: () => _generateText(_textEditingController.text),
                child: const Text('Generate du contenu'),
              ),
            ],
          ),
        ));
  }
}
