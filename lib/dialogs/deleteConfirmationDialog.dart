
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../component/snackBar.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';

Future<void> _deleteAccount(BuildContext context, String firstname) async {
  String? token = await TokenStorage.getToken();
  print('name ==> ${firstname}');
  try{
    print('name2 ==> ${firstname}');
    final response = await http.delete(
      Uri.parse(Global.BASE_URL + "api/delete-account"),
      headers: {
        'Content-Type': 'application/json',
        'token': '$token',
      },
      body: jsonEncode({'first_name': firstname}),
    );
    print('response  ==> ${response.body}');
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseData["success"] == 1) {
        String msg = responseData['msg'] ?? "Account deleted successfully."; // Fallback message
        print("Message to show: $msg");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(msg),
          ));
        }
        // CustomSnackbar.show(context, responseData['msg']);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['msg'] ?? "Failed to delete account"),
          ));
        }
        // CustomSnackbar.show(context, responseData['msg']);
        throw Exception(responseData["msg"] ?? "Failed to delete account");
      }
    } else {
      throw Exception("Failed to delete account. Server returned status code: ${response.statusCode}");
    }
  }catch(e){
    //Navigator.of(context).pop();
    // CustomSnackbar.show(context,  Text(e.toString()) as String);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(e.toString()),
    //   ),
    // );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
void showDeleteConfirmationDialog(BuildContext context) {
  final TextEditingController _confirmNameController = TextEditingController();
  ValueNotifier<bool> isDeleteButtonEnabled = ValueNotifier(false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Are you sure you want to delete your account?",style: TextStyle(fontSize: 18),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("To confirm, please type your first name \"${Global.userFirstName}\" below."),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: [
                  TextSpan(text: "To confirm, please type your first name "),
                  TextSpan(
                    text: "${Global.userFirstName}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " below."),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmNameController,
              decoration: InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                isDeleteButtonEnabled.value = value == Global.userFirstName;
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ValueListenableBuilder<bool>(
              valueListenable: isDeleteButtonEnabled,
            builder: (context, isEnabled, child) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled ? Themer.gradient1 : Colors.grey,
                ),
                child: Text("Delete",style: TextStyle(color: Themer.white),),
                onPressed:
                    // () {
                  isEnabled
                      ? () {
                  print('first name is ==> ${ _confirmNameController.text}');
                  String firstName = _confirmNameController.text;
                    Navigator.of(context).pop();
                    _deleteAccount(context, firstName); // Call the delete API
                  }
                      : null,
              );
            }
          ),
        ],
      );
    },
  );
}
