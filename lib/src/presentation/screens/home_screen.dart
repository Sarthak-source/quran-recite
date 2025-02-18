import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_recite/src/data/services/speach_service.dart';

import '../../business_logic/bloc/speach_state.dart';
import '../../business_logic/bloc/speech_bloc.dart';
import '../widgets/speak_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> targetWords = [
    "بسم الله الرحمن الرحيم",
    "الحمد لله رب العالمين",
    "الرحمن الرحيم",
    "مالك يوم الدين",
    "إياك نعبد وإياك نستعين",
    "اهدنا الصراط المستقيم",
    "صراط الذين أنعمت عليهم غير المغضوب عليهم ولا الضالين",
];

final speechService = SpeechService();

  //List<String> targetWords = [];

  @override
  void initState()  {
    super.initState();
    //await speechService.initialize();
    //fetchSurahFatiha();
  }

//   final List<String> targetWords = [
  // Future<void> fetchSurahFatiha() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/1'));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         targetWords = (data['data']['ayahs'] as List)
  //             .map((ayah) => ayah['text'].toString())
  //             .toList();

  //         log("targetWords $targetWords");
  //       });
  //     }
  //   } catch (error) {
  //     print('Error fetching Surah Al-Fatiha: $error');
  //   }
  // }

  //   @override
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

            log('targetWords $targetWords');

            List<String> words =
                targetWords.expand((sentence) => sentence.split(' ')).toList();
            // List<String> recognizedList = recognizedWords.split(' ');

            // words = words.reversed.toList();
            // log(words.toString());

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Wrap(
                    
                    spacing: 8, // Space between words
                    children: List.generate(words.length, (index) {
                      Color textColor = Colors.black; // Default color
                      if (state is SpeechSuccess) {
                        textColor =
                            wordMatches[index] ? Colors.green : Colors.red;
                      }
                  
                      return SelectableText(
                        words[index],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textDirection: TextDirection.rtl,
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                SpeakButton(targetWords: words), // **Button stays here**
                SizedBox(height: 20),

                // Recognized Words
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
