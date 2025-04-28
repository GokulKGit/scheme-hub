import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schemes/aboutcontactscreen.dart';
import 'package:schemes/loginscreen.dart';
import 'package:schemes/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(SchemesApp());
}

class SchemesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schemes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

class SchemesScreen extends StatefulWidget {
  @override
  _SchemesScreenState createState() => _SchemesScreenState();

  String? category;

  SchemesScreen({required this.category});
}

class _SchemesScreenState extends State<SchemesScreen> {
  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? "User";
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  List<dynamic> schemes = [];
  String selectedCategory = "students_schemes"; // Default category
  final List<String> categories = [
    "students_schemes",
    "farmers_schemes",
    "unemployment_schemes",
    "girls_schemes",
    "boys_schemes",
    "sports_schemes"
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category ?? "students_schemes";
    fetchSchemes();
  }

  Future<void> fetchSchemes() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://scheme-api.onrender.com/api/schemes/$selectedCategory"),
      );

      if (response.statusCode == 200) {
        setState(() {
          schemes = json.decode(response.body);
        });
      } else {
        throw Exception("Failed to load schemes");
      }
    } catch (error) {
      print("Error fetching schemes: $error");
      setState(() {
        schemes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getName(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? "User";
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutContactScreen(),
                ),
              );
            },
            child: Icon(Icons.settings),
          ),
          appBar: AppBar(
            title: Text("Government & Private Schemes"),
            actions: [
              IconButton(
                  onPressed: () => logout(context),
                  icon: Icon(Icons.exit_to_app))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome $name, Nice to meet you!",
                  style: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
                // Dropdown for category selection
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.replaceAll("_schemes", "").toUpperCase(),
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                          fetchSchemes();
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // ListView to display schemes
                Expanded(
                  child: schemes.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: schemes.length,
                          itemBuilder: (context, index) {
                            final scheme = schemes[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: ListTile(
                                title: Text(scheme["name"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(scheme["description"],
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                    SizedBox(height: 5),
                                    Text("Type: ${scheme["type"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Criteria: ${scheme["criteria"]}"),
                                    Text(
                                        "Launch Date: ${scheme["launch_date"]}"),
                                  ],
                                ),
                                trailing:
                                    Icon(Icons.open_in_new, color: Colors.blue),
                                onTap: () async {
                                  final url = scheme["link"];
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
