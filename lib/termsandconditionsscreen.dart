import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("1. Introduction"),
                sectionText(
                  "Welcome to the Scheme App. By using this application, you agree to be bound by these Terms and Conditions. "
                  "Please read them carefully before using our services.",
                ),
                sectionTitle("2. Use of the App"),
                sectionText(
                  "- The app is intended for informational purposes regarding government and private schemes.\n"
                  "- Users must not misuse any functionality.\n"
                  "- You are responsible for the accuracy of the data you provide during registration.",
                ),
                sectionTitle("3. User Information"),
                sectionText(
                  "- We may collect basic personal details such as name, email, and mobile number.\n"
                  "- All data is securely stored using local cache and is not shared with third parties.",
                ),
                sectionTitle("4. Data Disclaimer"),
                sectionText(
                  "- The scheme data shown is based on public APIs and external sources.\n"
                  "- We do not take responsibility for outdated or incorrect scheme details.\n"
                  "- Always verify scheme info through official sources.",
                ),
                sectionTitle("5. Modifications"),
                sectionText(
                  "- We reserve the right to modify or update these terms at any time.\n"
                  "- Users will be notified through the app upon major changes.",
                ),
                sectionTitle("6. Contact Us"),
                sectionText(
                  "If you have any questions regarding these Terms, please contact us at support@example.com.",
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Last updated: April 2025",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
