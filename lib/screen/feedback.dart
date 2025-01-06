import 'dart:convert';

import 'package:document_manager/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../global/tokenStorage.dart';
import '../theme/theme.dart';

class RatingReviewPage extends StatefulWidget {
  @override
  _RatingReviewPageState createState() => _RatingReviewPageState();
}

class _RatingReviewPageState extends State<RatingReviewPage> {
  double _rating = 0.0;  // Variable to store the rating value
  TextEditingController _reviewController = TextEditingController();
  bool _isFeedbackSubmitted = false;

  final String apiUrl = Global.BASE_URL + "feedback";
  final String? userId = Global.userId;

  Future<void> _checkFeedbackStatus() async {
    setState(() {
      _isFeedbackSubmitted = false; // Mock check
    });
  }

  Future<void> _submitFeedback() async {
    String? token = await TokenStorage.getToken();
    // Only submit feedback if not already submitted
    if (_isFeedbackSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have already submitted feedback.")),
      );
      return;
    }

    String reviewText = _reviewController.text;

    // Construct the payload
    var feedbackData = {
      "rating": _rating,
      "review": reviewText,
      "user_id": userId
    };

    try {
      // Make the POST request to submit feedback
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(feedbackData),
      );

      print('feedback response : ${response.body}');

      if (response.statusCode == 201) {
        // setState(() {
        //   _isFeedbackSubmitted = true;
        // });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thank you for your feedback!")),
        );
        Navigator.pop(context);
      } else if(response.statusCode == 400){
        var responseBody = json.decode(response.body);
        if (responseBody['message'] == 'You have already submitted feedback.') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You have already submitted feedback.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to submit feedback. Please try again later.")),
          );
        }
      }
      else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit feedback. Please try again later.")),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _submitReview() {
    String reviewText = _reviewController.text;

    print("Rating: $_rating, Review: $reviewText");

    setState(() {
      _rating = 0.0;
      _reviewController.clear();
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Thank you for your feedback!")),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkFeedbackStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate and Review'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Themer.gradient1,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "How was your experience?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Tap a star to rate",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Rating bar
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),

            SizedBox(height: 30),

            // Review input field
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Write your review",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Submit button
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Themer.buttonColor.withOpacity(0.2),
              ),
              child: Text(_isFeedbackSubmitted ? "Feedback Submitted" : "Submit",
                style: TextStyle(color: Themer.white, fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}
