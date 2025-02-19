import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../business_logic/bloc/speach_state.dart';
import '../../business_logic/bloc/speech_bloc.dart';
import '../widgets/speak_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> targetWords = [];

  @override
  void initState() {
    super.initState();
    fetchSurahFatiha();
  }

  Future<void> fetchSurahFatiha() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          targetWords = (data['data']['ayahs'] as List)
              .map((ayah) => ayah['text'].toString())
              .toList();
        });
      }
    } catch (error) {
      print('Error fetching Surah Al-Fatiha: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speech Recognition")),
      body: Center(
        child: BlocBuilder<SpeechBloc, SpeechState>(
          builder: (context, state) {
            List<bool> wordMatches = [];
            String recognizedWords = "";
            if (state is SpeechSuccess) {
              wordMatches = state.wordMatches;
              recognizedWords = state.recognizedWords;
            }

            List<String> words =
                targetWords.expand((sentence) => sentence.split(' ')).toList();

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Wrap(
                    spacing: 8,
                    children: List.generate(words.length, (index) {
                      Color textColor = Colors.black;
                      if (state is SpeechSuccess &&
                          index < wordMatches.length) {
                        textColor =
                            wordMatches[index] ? Colors.green : Colors.red;
                      }

                      return Text(
                        words[index], // ✅ Display with Tashkeel
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                SpeakButton(targetWords: words),
                SizedBox(height: 20),
                Text(
                  "You said: ${recognizedWords.isNotEmpty ? recognizedWords : "..."}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
