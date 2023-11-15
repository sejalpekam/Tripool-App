import 'package:flutter/material.dart';
import 'package:tripool_app/styleguide.dart';
import 'package:tripool_app/screens/faq.dart'; // Import your FAQ page

class FaqWidget extends StatelessWidget {
  const FaqWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 60,  // Reduced width
        height: 60,  // Reduced height
        decoration: BoxDecoration(
          border: Border.all(color: Color(0x99FFFFFF), width: 2), // Adjusted border width
          borderRadius: BorderRadius.all(Radius.circular(12)), // Adjusted border radius
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.question_answer, // FAQ Icon
              color: Colors.white,
              size: 30,  // Reduced icon size
            ),
            SizedBox(height: 5), // Adjusted spacing
            Text(
              '?',
              style: categoryTextStyle, // Use appropriate text style
            )
          ],
        ),
      ),
    );
  }
}
