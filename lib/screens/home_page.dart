import 'package:flutter/material.dart';
import 'package:flutter_socketapp/screens/client_page.dart';
import 'package:flutter_socketapp/screens/server_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Socket App"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ServerPage(),
                ),
              ),
              child: Text("Server Page"),
            ),
          ),
           Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ClientPage(),
                ),
              ),
              child: Text("Client Page"),
            ),
          ),
        ],
      ),
    );
  }
}
