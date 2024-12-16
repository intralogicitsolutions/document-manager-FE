import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../theme/theme.dart';

class Searchbar extends StatefulWidget {
  final Function(String type) onType;
  final String? hint;

  Searchbar(this.onType, {super.key, this.hint});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  TextEditingController searchController = TextEditingController();
  late stt.SpeechToText _speechToText;
  bool _speechEnabled = false;
  bool _isRecordingCancelled = false;
  int _recordingDuration = 0;
  Timer? _timer;
  Timer? _blinkTimer;
  bool _showMicIcon = true; // For blinking effect
  double _micIconPosition = 0.0; // Position of the mic icon during swipe

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  void _startRecording() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _speechEnabled = true;
        _isRecordingCancelled = false;
        _recordingDuration = 0;
      });

      // Start the blinking effect
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _showMicIcon = !_showMicIcon;
        });
      });

      _speechToText.listen(onResult: (val) {
        setState(() {
          searchController.text = val.recognizedWords;
          widget.onType(val.recognizedWords);
        });
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordingDuration++);
      });
    }
  }

  void _stopRecording() {
    _timer?.cancel();
    _blinkTimer?.cancel();
    setState(() => _speechEnabled = false);
    _speechToText.stop();
  }

  void _cancelRecording() {
    _timer?.cancel();
    _blinkTimer?.cancel();
    setState(() {
      _speechEnabled = false;
      _isRecordingCancelled = true;
      _recordingDuration = 0;
    });
    _speechToText.stop();
    searchController.clear();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blinkTimer?.cancel();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: widget.onType,
              decoration: InputDecoration(
                hintText: !_speechEnabled ? "Search here..." : '',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: _speechEnabled
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: 20, // Width for mic icon space
                            child: _showMicIcon
                                ? const Icon(
                                    Icons.mic_none,
                                    color: Colors.redAccent,
                                  )
                                : const SizedBox
                                    .shrink(), // Invisible placeholder
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 8.0),
                        //   child: Text(
                        //     _formatDuration(_recordingDuration),
                        //     style: const TextStyle(
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                    : const Icon(Icons.search, color: Colors.black54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          GestureDetector(
            onLongPressStart: (_) async {
              bool hasPermission =
                  await Permission.microphone.request().isGranted;
              if (hasPermission) {
                if (Platform.isIOS) {
                  bool speechPermissionGranted =
                      await Permission.speech.request().isGranted;
                  if (speechPermissionGranted) {
                    _startRecording();
                  }
                } else {
                  _startRecording();
                }
              }
            },
            onLongPressEnd: (_) {
              if (!_isRecordingCancelled) {
                _stopRecording();
              }
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                // Move the mic icon to the left when swiped
                _micIconPosition += details.primaryDelta!;
                if (_micIconPosition < -100) {
                  _micIconPosition = -100; // Prevent it from going too far left
                }
              });
            },
            onHorizontalDragEnd: (_) {
              // Reset position after swipe
              setState(() {
                if (_micIconPosition < -50) {
                  _cancelRecording(); // Cancel recording if swiped far enough
                }
                _micIconPosition = 0.0; // Reset position
              });
            },
            child: Row(
              children: [
                if (_speechEnabled)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 15, color: Colors.grey),
                  ),
                if (_speechEnabled)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Slide to cancel",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AvatarGlow(
                      glowRadiusFactor: 0.7,
                      glowCount: 3,
                      animate: _speechEnabled,
                      glowColor:
                          _speechEnabled ? Themer.gradient1 : Themer.white,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      glowShape: BoxShape.circle,
                      curve: Curves.fastOutSlowIn,
                      child: Transform.translate(
                        offset: Offset(_micIconPosition, 0),
                        // Apply the swipe position
                        child: Icon(
                          _speechEnabled ? Icons.mic : Icons.mic_none,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:document_manager/component/widget_style.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';
// import '../dialogs/permission_consent.dart';
// import '../theme/theme.dart';
//
// class Searchbar extends StatefulWidget{
//   Function(String type) onType;
//   String? hint;
//
//   Searchbar(this.onType, {super.key,this.hint});
//
//   @override
//   State<Searchbar> createState() => _SearchbarState();
// }
//
// class _SearchbarState extends State<Searchbar> {
//   TextEditingController searchController = TextEditingController();
//
//   var _speechToText = stt.SpeechToText();
//   bool _speechEnabled = false;
//   String _lastWords = 'please press the button for speeking';
//
//   void initState() {
//     super.initState();
//     _speechToText = stt.SpeechToText();
//   }
//
//   void _listen() async {
//     if(!_speechEnabled){
//       bool available = await _speechToText.initialize(
//         onStatus: (val) => print('onStatus : $val'),
//         onError: (val) => print('onError : $val'),
//       );
//       if(available) {
//         setState(() => _speechEnabled = true);
//         _speechToText.listen(
//           onResult: (val) =>
//               setState(() {
//                 _lastWords = val.recognizedWords;
//                 searchController.text = val.recognizedWords;
//                 widget.onType(val.recognizedWords);
//                 print('searchcontroller---->${searchController.text}');
//               }),
//         );
//       }
//     }else{
//       setState(() => _speechEnabled = false);
//       _speechToText.stop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       padding: const EdgeInsets.only(bottom: 10, top: 10),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Themer.white,
//           width: 2.0,
//         ),
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10), // Rounded corners
//       ),
//       child: TextField(
//         controller: searchController,
//         onChanged: widget.onType,
//         decoration: decorationWithHintandPreIcon(
//             hint: widget.hint??"Search here ...",
//             hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
//             prefixIcon: const Icon(Icons.search, color: Colors.black),
//             suffixIcon: GestureDetector(
//               onLongPressStart: (_) async{
//
//                 PermissionConsent(context,() async {
//                   bool hasPermission = await Permission.microphone.request().isGranted;
//                   if(hasPermission) {
//
//                     if(Platform.isIOS) {   // iOS specific permision since we don't have xcode to test
//
//                       PermissionConsent(context,() async {
//                         bool hasPermission = await Permission.speech.request().isGranted;
//                         if(hasPermission) {
//                           _listen();
//                           _speechEnabled = true;
//                         }
//                       },).askPermissionConsent(PermissionConsent.SPEECH_PERMISSION);
//
//                     }else {
//                       _listen();
//                       _speechEnabled = true;
//                     }
//                   }
//                 },).askPermissionConsent(PermissionConsent.MIC_PERMISSION);
//
//               },
//               onLongPressEnd: (_) {
//                 setState(() {
//                   _speechEnabled = false;
//                 });
//               },
//               child: AvatarGlow(
//                 glowRadiusFactor: 0.7,
//                 glowCount: 3,
//                 animate: _speechEnabled,
//                 glowColor: _speechEnabled ? Themer.gradient1 : Themer.white,
//                 duration: const Duration(milliseconds: 2000),
//                 repeat: true,
//                 glowShape: BoxShape.circle,
//                 curve: Curves.fastOutSlowIn,
//                 child: Icon(_speechEnabled ? Icons.mic : Icons.mic_none,
//                     color: Colors.black),
//               ),
//             )
//         ),
//         style: const TextStyle(color: Colors.black),
//       ),
//     );
//   }
// }
