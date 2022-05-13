import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share/share.dart';
import 'package:translator/translator.dart';

class TranslatorDemo extends StatefulWidget {
  @override
  State<TranslatorDemo> createState() => _TranslatorDemoState();
}

class _TranslatorDemoState extends State<TranslatorDemo> {
  final translator = GoogleTranslator();

  TextEditingController _textEditingController = TextEditingController();
  String outputText = "";
  String? _dropDownValue;
  String? translated_text;
  bool isSpecking = false;
  final flutterTts = FlutterTts();
  void initialTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        isSpecking = true;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpecking = false;
      });
    });
    flutterTts.setErrorHandler((message) {
      setState(() {
        isSpecking = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialTts();
  }

  void speck() async {
    await flutterTts.speak(translated_text!);
  }

  void stop() async {
    await flutterTts.stop();
    setState(() {
      isSpecking = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Translator World"),
          centerTitle: true,
        ),
        drawer: Drawer(),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                TextField(
                  maxLines: 10,
                  focusNode: FocusNode(canRequestFocus: false),
                  keyboardType: TextInputType.multiline,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 80),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: _dropDownValue == null
                        ? Text("-- Selected Language --",
                            style: TextStyle(
                              color: Colors.blue,
                            ))
                        : Text(
                            _dropDownValue!,
                            style: TextStyle(color: Colors.blue, fontSize: 22),
                          ),
                    items: <String>[
                      "English",
                      "বাংলা",
                      "Arabic",
                      "Japanese",
                      "Chinese",
                      "Russian",
                      "Spanish",
                      "Ukrainian",
                      "Turkey",
                      "Sweden",
                      "Romanian",
                      "Portuguese",
                      "Malaysia",
                      "Italy",
                      "French"
                    ].map((String value) {
                      return DropdownMenuItem(
                          value: value,
                          child: Container(
                            child: Text(value),
                          ));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _dropDownValue = newValue;
                      });
                      if (_dropDownValue == "English") {
                        translate_text("en");
                      } else if (_dropDownValue == "বাংলা") {
                        translate_text("bn");
                      } else if (_dropDownValue == "Arabic") {
                        translate_text("ar");
                      } else if (_dropDownValue == "Japanese") {
                        translate_text("ja");
                      } else if (_dropDownValue == "Chinese") {
                        translate_text("zh-cn");
                      } else if (_dropDownValue == "Russian") {
                        translate_text("ru");
                      } else if (_dropDownValue == "Spanish") {
                        translate_text("es");
                      } else if (_dropDownValue == "Ukrainian") {
                        translate_text("uk");
                      } else if (_dropDownValue == "Turkey") {
                        translate_text("tr");
                      } else if (_dropDownValue == "Sweden") {
                        translate_text("sv");
                      } else if (_dropDownValue == "Romanian") {
                        translate_text("ro");
                      } else if (_dropDownValue == "Portuguese") {
                        translate_text("pt");
                      } else if (_dropDownValue == "Malaysia") {
                        translate_text("ms");
                      } else if (_dropDownValue == "Italy") {
                        translate_text("it");
                      } else if (_dropDownValue == "French") {
                        translate_text("fr");
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          isSpecking ? stop() : speck();
                        },
                        icon: isSpecking
                            ? Icon(
                                Icons.volume_up,
                                size: 31,
                                color: Color.fromARGB(255, 106, 221, 163),
                              )
                            : Icon(
                                Icons.volume_up,
                                size: 25,
                              )),
                    SizedBox(
                      width: 6,
                    ),
                    IconButton(
                        onPressed: () async {
                          final data = ClipboardData(text: translated_text);
                          await Clipboard.setData(data);
                        },
                        icon: const Icon(Icons.copy)),
                  ],
                ),
                Center(
                  child: Container(
                    child: translated_text != null
                        ? Text(
                            translated_text!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          )
                        : Text(outputText),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void translate_text(String locale) {
    translator.translate(_textEditingController.text, to: locale).then((value) {
      setState(() {
        translated_text = value.text;
      });
    });
  }
}
