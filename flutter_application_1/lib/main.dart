import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitter Depression Predictor',
      theme: ThemeData(
        textTheme: Typography.blackMountainView,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TwitterPage(),
    );
  }
}

class TwitterPage extends StatefulWidget {
  @override
  _TwitterPageState createState() => _TwitterPageState();
}

class _TwitterPageState extends State<TwitterPage> {
  final TextEditingController _twitterController = TextEditingController();
  bool isLoading = false;
  String statusMessage = "";
  List<Map<String, dynamic>> predictions = [];

  Future<void> fetchAndPredictTweets() async {
    final username = _twitterController.text.trim();
    if (username.isEmpty) {
      setState(() => statusMessage = "Enter a Twitter username.");
      return;
    }

    setState(() {
      isLoading = true;
      statusMessage = "Fetching tweets...";
      predictions = [];
    });

    try {
      final bearerToken = dotenv.env['TWITTER_BEARER_TOKEN'] ?? '';
      final flaskApiUrl = dotenv.env['API_URL'] ?? '';

      if (bearerToken.isEmpty || flaskApiUrl.isEmpty) {
        setState(() {
          statusMessage = "Environment variables not found!";
        });
        return;
      }

      final userResponse = await http.get(
        Uri.parse('https://api.twitter.com/2/users/by/username/$username'),
        headers: {"Authorization": "Bearer $bearerToken"},
      );

      if (userResponse.statusCode != 200) {
        setState(() {
          statusMessage = "Error fetching user: ${userResponse.body}";
        });
        return;
      }

      final userData = json.decode(userResponse.body);
      final userId = userData['data']['id'];

      final tweetsResponse = await http.get(
        Uri.parse(
          'https://api.twitter.com/2/users/$userId/tweets?max_results=5&tweet.fields=text',
        ),
        headers: {"Authorization": "Bearer $bearerToken"},
      );

      if (tweetsResponse.statusCode != 200) {
        setState(() {
          statusMessage = "Error fetching tweets: ${tweetsResponse.body}";
        });
        return;
      }

      final tweetsData = json.decode(tweetsResponse.body);
      List<String> tweets = [];
      if (tweetsData['data'] != null) {
        tweets = List<String>.from(tweetsData['data'].map((t) => t['text']));
      }

      if (tweets.isEmpty) {
        setState(() {
          statusMessage = "No tweets found for @$username";
        });
        return;
      }

      final body = json.encode({"posts": tweets});

      final response = await http.post(
        Uri.parse(flaskApiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode != 200) {
        setState(() {
          statusMessage = "Error from API: ${response.body}";
        });
        return;
      }

      final result = json.decode(response.body) as List<dynamic>;
      setState(() {
        predictions = result.cast<Map<String, dynamic>>();
        statusMessage = "Predictions fetched successfully! ✅";
      });
    } catch (e) {
      setState(() {
        statusMessage = "Error: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F0FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // HEADER CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.deepPurple.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.monitor_heart, size: 80, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Twitter Depression Predictor",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Analyze emotional patterns from recent tweets",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // INPUT FIELD
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _twitterController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        labelText: "Enter Twitter Username",
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // BUTTON
                    ElevatedButton(
                      onPressed: fetchAndPredictTweets,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        elevation: 5,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Get Predictions",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // STATUS MESSAGE
              if (statusMessage.isNotEmpty)
                Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusMessage.contains("Error")
                        ? Colors.red
                        : Colors.green,
                  ),
                ),

              SizedBox(height: 20),

              // PREDICTION CARDS
              if (predictions.isNotEmpty)
                Column(
                  children: predictions.map((p) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(blurRadius: 8, color: Colors.black12),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['post'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Divider(),
                          Text(
                            "Prediction: ${p['prediction']}",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Probability: ${p['probability'].toStringAsFixed(2)}",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
