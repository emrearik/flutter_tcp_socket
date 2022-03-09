import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../models/message_item.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({Key? key}) : super(key: key);

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  String localIP = "";
  int port = 9000;
  List<MessageItem> items = [];
  final networkInfo = NetworkInfo();
  TextEditingController ipCon = TextEditingController();
  TextEditingController msgCon = TextEditingController();
  Socket? clientSocket;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    ipCon.dispose();
    msgCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getIPAdress();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Client Page"),
      ),
      body: Column(
        children: [
          connectArea(),
          messageListArea(),
          submitArea(),
        ],
      ),
    );
  }

  Widget connectArea() {
    return Card(
      child: ListTile(
        dense: true,
        leading: Text("Server IP"),
        title: TextField(
          controller: ipCon,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              isDense: true,
              filled: true,
              fillColor: Colors.grey[50]),
        ),
        trailing: MaterialButton(
          child: Text((clientSocket != null) ? "Disconnect" : "Connect"),
          onPressed:
              (clientSocket != null) ? disconnectFromServer : connectToServer,
        ),
      ),
    );
  }

  Widget submitArea() {
    return Card(
      child: ListTile(
        title: TextField(
          controller: msgCon,
        ),
        trailing: IconButton(
          icon: Icon(Icons.send),
          color: Colors.blue,
          disabledColor: Colors.grey,
          onPressed: (clientSocket != null) ? submitMessage : null,
        ),
      ),
    );
  }

  void connectToServer() async {
    print("Destination Address: ${ipCon.text}");

    Socket.connect(ipCon.text, port, timeout: Duration(seconds: 5))
        .then((socket) {
      setState(() {
        clientSocket = socket;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Connected to ${socket.remoteAddress.address}:${socket.remotePort}"),
        ),
      );

      socket.listen(
        (onData) {
          print(String.fromCharCodes(onData).trim());
          setState(() {
            items.insert(
                0,
                MessageItem(clientSocket!.remoteAddress.address,
                    String.fromCharCodes(onData).trim()));
          });
        },
      );
    }).catchError((e) {
      print("error");
    });
  }

  void disconnectFromServer() {
    print("disconnectFromServer");

    clientSocket?.close();
    setState(() {
      clientSocket = null;
    });
  }

  void getIPAdress() async {
    var ipAdress = await networkInfo.getWifiIP();
    setState(() {
      localIP = ipAdress!;
    });
  }

  Widget messageListArea() {
    return Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            MessageItem item = items[index];
            return Container(
              alignment: (item.owner == localIP)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (item.owner == localIP)
                        ? Colors.blue[100]
                        : Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.owner,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.content,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void submitMessage() {
    if (msgCon.text.isEmpty) return;
    setState(() {
      items.insert(0, MessageItem(localIP, msgCon.text));
    });
    clientSocket!.write("$msgCon.text");
    msgCon.clear();
  }
}
