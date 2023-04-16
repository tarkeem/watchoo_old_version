import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  IO.Socket? socket;

  List<String> msg = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket!.connect();

    socket!.onConnect((_) {
      print('connect');
    });
    socket!.on('res', (data) {
      setState(() {
        msg.add(data);
      });
    });

    /*socket.onDisconnect((_) => print('disconnect'));
              socket.on('fromServer', (_) => print(_));*/
  }

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: msg.length,
            itemBuilder: (context, index) {
              return Text(
                msg[index],
                style: TextStyle(color: Colors.black),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: 'message'),
            )),
            FloatingActionButton(
              onPressed: () {
                socket!.emit('msg', _textEditingController.text);
                _textEditingController.clear();
              },
              child: Center(
                child: Icon(Icons.send),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
