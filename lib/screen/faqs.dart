// import 'package:document_manager/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class FaqPage extends StatefulWidget {
//   const FaqPage({super.key});
//
//   @override
//   _FaqPageState createState() => _FaqPageState();
// }
//
// class _FaqPageState extends State<FaqPage> {
//   List<Map<String, String>> faqList = [
//     {
//       'question': 'How do I upload a document?',
//       'answer': 'To upload a document, click the "+" icon at the bottom-center corner of the screen and select the document you wish to upload.',
//     },
//     {
//       'question': 'How do I organize my documents?',
//       'answer': 'You can organize your documents by creating folders. Tap on the "Folders" tab to create and manage your folders.',
//     },
//     {
//       'question': 'How do I search for a document?',
//       'answer': 'Use the search bar at the top of the screen. Type in keywords related to the document name, and it will show matching results.',
//     },
//     {
//       'question': 'How do I share a document?',
//       'answer': 'To share a document, tap on the document, then click the "Share" icon. Select your preferred method to share.',
//     },
//     {
//       'question': 'How do I delete a document?',
//       'answer': 'Swipe left on the document, and you will see an option to delete it. Confirm the action to permanently delete the document.',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("FAQs", style: TextStyle(color: Colors.white)),
//         backgroundColor: Themer.gradient1,
//         leading: IconButton(
//           icon: SvgPicture.asset(
//             "assets/images/ios-back-arrow.svg",
//             colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: faqList.length,
//           itemBuilder: (context, index) {
//             return FaqTile(
//               question: faqList[index]['question']!,
//               answer: faqList[index]['answer']!,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class FaqTile extends StatefulWidget {
//   final String question;
//   final String answer;
//
//   const FaqTile({required this.question, required this.answer});
//
//   @override
//   _FaqTileState createState() => _FaqTileState();
// }
//
// class _FaqTileState extends State<FaqTile> {
//   bool _isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       elevation: 2,
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           dividerColor: Colors.transparent, // Removes the underline effect
//         ),
//         child: ExpansionTile(
//           leading: Icon(Icons.help_outline),
//           title: Text(
//             widget.question,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           trailing: Icon(
//             _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//             color: Themer.gradient1,
//           ),
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 widget.answer,
//                 style: TextStyle(fontSize: 16, color: Colors.black54),
//               ),
//             ),
//           ],
//           onExpansionChanged: (bool expanded) {
//             setState(() {
//               _isExpanded = expanded;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:document_manager/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  _FaqPageState createState() => _FaqPageState();
}



class _FaqPageState extends State<FaqPage> {
  final List<Map<String, String>> faqList = [
    {
      'question': 'How do I upload a document?',
      'answer':
      'To upload a document, click the "+" icon at the bottom-center corner of the screen and select the document you wish to upload.',
    },
    {
      'question': 'How do I organize my documents?',
      'answer':
      'You can organize your documents by creating folders. Tap on the "Folders" tab to create and manage your folders.',
    },
    {
      'question': 'How do I search for a document?',
      'answer':
      'Use the search bar at the top of the screen. Type in keywords related to the document name, and it will show matching results.',
    },
    {
      'question': 'How do I share a document?',
      'answer':
      'To share a document, tap on the document, then click the "Share" icon. Select your preferred method to share.',
    },
    {
      'question': 'How do I delete a document?',
      'answer':
      'Swipe left on the document, and you will see an option to delete it. Confirm the action to permanently delete the document.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs", style: TextStyle(color: Colors.white)),
        backgroundColor: Themer.gradient1,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTileGroup(
          toggleType: ToggleType.expandOnlyCurrent, // Ensures only one is expanded
          spaceBetweenItem: 8.0, // Adds spacing between tiles
          children: faqList.map((faq) {
            return ExpansionTileCard(
              elevation: 0, // Disable default elevation shadow
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(
                //   color: Colors.black45, // Set transparent or any color for border
                //   width: 1.0, // Set border width
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    offset: Offset(0, 2), // Horizontal and vertical displacement of the shadow
                    // blurRadius: 6.0, // How blurry the shadow is
                    // spreadRadius: 1.0, // Spread of the shadow
                  ),
                ],
              ),
              expendedBorderColor: Themer.gradient1,
              title: Text(
                faq['question']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              leading: Icon(Icons.help_outline, color: Themer.gradient1),
              expandedAlignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

