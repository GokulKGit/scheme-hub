import 'package:flutter/material.dart';
import 'package:schemes/profile.dart';
import 'package:schemes/termsandconditionsscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutContactScreen extends StatefulWidget {
  @override
  State<AboutContactScreen> createState() => _AboutContactScreenState();
}

class _AboutContactScreenState extends State<AboutContactScreen> {
  final String emailID = "support@scheme.com";

  final String phone = "+91 23459 25291";

  final String location = "Salem, Tamil Nadu";

  void launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailID,
    );
    await launchUrl(emailLaunchUri);
  }

  void launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(phoneLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About & Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    title: Text("Profile"),
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.north_east_sharp),
                  )),
            ),
            SizedBox(height: 10),

            /// About Us Section
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Us",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "We are committed to simplifying access to government and private schemes for the people. Our platform ensures that citizens can explore, understand, and apply for schemes easily.",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "We aim to bridge the gap between digital governance and common users through modern technology and user-friendly solutions.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndConditionsScreen()));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    title: Text("Terms and Condition"),
                    trailing: Icon(Icons.north_east_sharp),
                  )),
            ),
            SizedBox(height: 10),

            /// Contact Us Section
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue),
                    title: Text("Email"),
                    subtitle: Text(emailID),
                    onTap: launchEmail,
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.green),
                    title: Text("Phone"),
                    subtitle: Text(phone),
                    onTap: launchPhone,
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text("Location"),
                    subtitle: Text(location),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
