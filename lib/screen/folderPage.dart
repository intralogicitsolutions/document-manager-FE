import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/theme.dart';

class FolderPage extends StatefulWidget{
  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Themer.gradient1,
       title: Text('Folder',style: TextStyle(color: Themer.white),),
       elevation: 0,
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
     body: Container(
       child: Center(
         child: GestureDetector(
           onTap: () {

           },
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.add,size: 25,color: Colors.grey,),
               SizedBox(width: 10,),
               Text(
                 'Add Folder',
                 style: TextStyle(fontSize: 22,color: Colors.grey),
               )
             ],
           ),
         ),
       ),
     ),
   );
  }
}