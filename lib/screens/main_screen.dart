import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          color: Colors.blueAccent,
          child: Text('Search!'),
          onPressed: () {},
        ),
      ),
    );
  }
}
