import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_socketapp/models/message_item.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({Key? key}) : super(key: key);

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  ServerSocket? serverSocket;
  int port = 9898;
  String localIp = "";
  final networkInfo = NetworkInfo();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<MessageItem> items = [];

  @override
  Widget build(BuildContext context) {
    getIPAdress();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Flutter Socket App"),
      ),
      body: Column(children: [
        Card(
          child: ListTile(
            dense: true,
            leading: const Text("IP Adresi:"),
            title: Text(localIp + ":" + port.toString()),
            trailing: ElevatedButton(
              onPressed: () =>
                  serverSocket == null ? startServer() : stopServer(),
              child: Text(
                serverSocket == null ? "Start" : "Stop",
              ),
            ),
          ),
        ),
        messageListArea(),
      ]),
    );
  }

  void getIPAdress() async {
    var ipAdress = await networkInfo.getWifiIP();
    setState(() {
      localIp = ipAdress!;
    });
  }

  void startServer() async {
    runZoned(() async {
      serverSocket = await ServerSocket.bind("0.0.0.0", port, shared: true);
      print("Server başlatıldı. Local IP:" + localIp + ":" + port.toString());
      serverSocket!.listen((client) {
        handleClient(client);
      });
    });
  }

  void handleClient(Socket client) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "New client connected. Client Information: " +
              client.remoteAddress.address +
              ":" +
              client.remotePort.toString(),
        ),
      ),
    );

    client.listen(
      (Uint8List data) async {
        print(
            client.remoteAddress.address + ":" + client.remotePort.toString());
        print(String.fromCharCodes(data).trim());
        setState(() {
          items.insert(
              0,
              MessageItem(
                  client.remoteAddress.address +
                      ":" +
                      client.remotePort.toString(),
                  String.fromCharCodes(data).trim()));
        });
      },
      onError: (e) {
        print(e);
        client.close();
      },
      onDone: () {
        print("Client left");
        client.close();
      },
    );
  }

  void stopServer() {
    serverSocket!.close();
    setState(() {
      serverSocket = null;
    });
    print("Server stopped.");
  }

  Widget messageListArea() {
    return Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            MessageItem item = items[index];
            return Container(
              alignment: (item.owner == localIp)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (item.owner == localIp)
                        ? Colors.blue[100]
                        : Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.owner,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.content,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
