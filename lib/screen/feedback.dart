import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/theme.dart';

class RatingReviewPage extends StatefulWidget {
  @override
  _RatingReviewPageState createState() => _RatingReviewPageState();
}

class _RatingReviewPageState extends State<RatingReviewPage> {
  double _rating = 0.0;  // Variable to store the rating value
  TextEditingController _reviewController = TextEditingController();

  void _submitReview() {
    // Get review text
    String reviewText = _reviewController.text;

    // Handle submit action, like saving to database, or sending to server
    print("Rating: $_rating, Review: $reviewText");

    // Clear the fields after submission
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
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Themer.buttonColor.withOpacity(0.2),
              ),
              child: Text("Submit",style: TextStyle(color: Themer.white, fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}
