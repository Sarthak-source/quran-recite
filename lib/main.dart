import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_recite/src/business_logic/bloc/speech_bloc.dart';
import 'package:quran_recite/src/data/services/speach_service.dart';
import 'package:quran_recite/src/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final speechService = SpeechService();
  await speechService.initialize(); // Ensure speech is initialized

  runApp(MyApp(speechService: speechService));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    //Navigator.pushReplacement(
    // context, MaterialPageRoute(builder: (context) => HomeScreen()));

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيْمِ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/newbackgrnd.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        // color: Color(0xFF40E0D0), // Light Algae Green
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700), // Gold color
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'القرآن الكريم',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFD700), // Gold color
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final SpeechService speechService;

  const MyApp({super.key, required this.speechService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeechBloc(speechService),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

// class SpeechToTextUltraWidgetImplementation extends StatefulWidget {
//   const SpeechToTextUltraWidgetImplementation({super.key});

//   @override
//   State<SpeechToTextUltraWidgetImplementation> createState() =>
//       _SpeechToTextUltraWidgetImplementationState();
// }

// class _SpeechToTextUltraWidgetImplementationState
//     extends State<SpeechToTextUltraWidgetImplementation> {
//   bool mIsListening = false;
//   String mEntireResponse = '';
//   String mLiveResponse = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//         title: const Text(
//           'Speech To Text Ultra',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               mIsListening
//                   ? Text('$mEntireResponse $mLiveResponse')
//                   : Text(mEntireResponse),
//               const SizedBox(height: 20),
//               SpeechToTextUltra(
//                 ultraCallback:
//                     (String liveText, String finalText, bool isListening) {
//                   setState(() {
//                     mLiveResponse = liveText;
//                     mEntireResponse = finalText;
//                     mIsListening = isListening;
//                   });
//                 },
//                 // toPauseIcon: const Icon(Icons.pause),
//                 // toStartIcon: const Icon(Icons.mic),
//                 // pauseIconColor: Colors.black,
//                 // startIconColor: Colors.black,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   bool _speechAvailable = false;
//   String _lastWords = '';
//   String _currentWords = '';

//   // final String _selectedLocaleId = 'es_MX';

//   printLocales() async {
//     var locales = await _speechToText.locales();
//     for (var local in locales) {
//       debugPrint(local.name);
//       debugPrint(local.localeId);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   void errorListener(SpeechRecognitionError error) async {
//     debugPrint(error.errorMsg.toString());
//     // if (_speechEnabled) {
//     //   await _startListening();
//     // }
//   }

//   void statusListener(String status) async {
//     debugPrint("status $status");
//     if (status == "done" && _speechEnabled) {
//       if (_currentWords.isNotEmpty) {
//         setState(() {
//           _lastWords += " $_currentWords";
//           _currentWords = "";
//           _speechEnabled = false;
//         });
//       } else {
//         // wait 50 mil seconds and try again
//         await Future.delayed(Duration(milliseconds: 50));
//       }
//       await _startListening();
//     }
//   }

//   /// This has to happen only once per app
//   void _initSpeech() async {
//     _speechAvailable = await _speechToText.initialize(
//         onError: errorListener, onStatus: statusListener);
//     setState(() {});
//   }

//   /// Each time to start a speech recognition session
//   Future _startListening() async {
//     debugPrint("=================================================");
//     await _stopListening();
//     await Future.delayed(const Duration(milliseconds: 50));
//     await _speechToText.listen(
//         onResult: _onSpeechResult,
//         // localeId: _selectedLocaleId,
//         cancelOnError: false,
//         partialResults: true,
//         listenFor: const Duration(seconds: 60)
//         // listenMode: ListenMode.dictation
//         );
//     setState(() {
//       _speechEnabled = true;
//     });
//   }

//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   Future _stopListening() async {
//     setState(() {
//       _speechEnabled = false;
//     });
//     await _speechToText.stop();
//   }

//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _currentWords = result.recognizedWords;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Speech Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: const Text(
//                 'Recognized words:',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   _lastWords.isNotEmpty
//                       ? '$_lastWords $_currentWords'
//                       : _speechAvailable
//                           ? 'Tap the microphone to start listening...'
//                           : 'Speech not available',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//             _speechToText.isNotListening ? _startListening : _stopListening,
//         tooltip: 'Listen',
//         child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
//     );
//   }
// }
