import 'package:flutter/material.dart';

class NoInternetErrorPage extends StatelessWidget {
  const NoInternetErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No Internet!'),
      ),
    );
  }
}
