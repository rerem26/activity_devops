import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'randomuser.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Loading(),
));

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 7));
      if (response.statusCode == 200) {
        user = [jsonDecode(response.body)];
        print(user[0]['info']['version']);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Message'),
            content: Text('No Internet Connection'),
            actions: [
              TextButton(
                onPressed: () {
                  getData();
                  Navigator.pop(context);
                },
                child: Text('Retry'),
              )
            ],
          );
        },
      );
    }
  }
