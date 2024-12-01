import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const ExpansionTile(
              title: Text('How do I book an experience?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('To book an experience, select the experience you like and follow the steps to complete your booking.'),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('What should I do if I have issues with my booking?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('If you face any issues with your booking, please contact our support team via the email below.'),
                ),
              ],
            ),
            // Add more FAQs as needed

            const SizedBox(height: 20),

            // Support Email
            const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Launch email client with the support email
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'support@lonewolf.com',
                  queryParameters: {
                    'subject': 'Support Request',
                  },
                );
                launch(emailLaunchUri.toString());
              },
              child: const Text(
                'support@lonewolf.com',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void launch(String url) {
  // You can use url_launcher package to launch the email client
  // Example: launch(url);
}
