import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<Map<String, dynamic>> userData;

  Future<Map<String, dynamic>> getData() async {
    final url = 'https://randomuser.me/api/'; // Add your API endpoint here
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return decodedData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  @override
  void initState() {
    userData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press here
        // Return false to prevent the default back button behavior
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent[200],
          title: Text('Random Its Boy or Girl'),
          centerTitle: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final userData = snapshot.data!;
              return UserDataDisplay(userData: userData);
            }
          },
        ),
      ),
    );
  }
}
class UserDataDisplay extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserDataDisplay({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final results = userData['results'][0];
    final String name =
        '${results['name']['title']}. ${results['name']['first']} ${results['name']['last']}';
    final String gender = results['gender'];
    final String country = results['location']['country'];
    final String email = results['email'];
    final String username = results['login']['username'];
    final String age = results['dob']['age'].toString();
    final String phoneNumber = results['phone'];

    return RefreshIndicator(
      onRefresh: () async {
        // Implement your refresh logic here
      },
      child: ListView(
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(results['picture']['large']),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '$name',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Gender'),
              subtitle: Text(gender),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Country'),
              subtitle: Text(country),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Username'),
              subtitle: Text(username),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Age'),
              subtitle: Text(age),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone Number'),
              subtitle: Text(phoneNumber),
            ),
          ),
        ],
      ),
    );
  }
}
