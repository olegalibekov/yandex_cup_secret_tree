import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_connector/bluetooth_connector.dart';

class PineTree extends StatefulWidget {
  const PineTree({Key? key}) : super(key: key);

  @override
  _PineTreeState createState() => _PineTreeState();
}

class _PineTreeState extends State<PineTree> {
  BluetoothConnector bluetoothAdapter = BluetoothConnector();
  String _connectionStatus = "NONE";

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  _startListening() async {
    await bluetoothAdapter.initBlutoothConnection('00001101-1296-1000-8000-00805F9B34FB');
    await bluetoothAdapter.startServer();

    bluetoothAdapter.connectionStatus().listen((dynamic status) async {
      setState(() => _connectionStatus = status.toString());
      if (status == 'Connected') {
        bluetoothAdapter.sendMessage(jsonEncode(Hive.box('testBox').values.toList()));
      } else if (status == 'Disconnected') {
        await bluetoothAdapter.startServer();
      }
    });

    bluetoothAdapter.receiveMessages().listen((dynamic newMessage) {
      if (newMessage != 'READY TO RECEIVE MESSAGES') {
        Hive.box('testBox').add(newMessage.toString());
        bluetoothAdapter.sendMessage(jsonEncode(Hive.box('testBox').values.toList()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Сосна'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Убедитесь, что в настройках приложения разрешен доступ к Bluetooth'),
          const SizedBox(height: 12),
          Text("STATUS - $_connectionStatus"),
          ValueListenableBuilder(
              valueListenable: Hive.box('testBox').listenable(),
              builder: (context, Box box, widget) {
                print('aaa: ${box.values}');
                return Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text('Sender'),
                        subtitle: Text(
                          box.values.toList()[index],
                        ),
                      );
                    },
                  ),
                );
              }
              // return const Text(
              //   "Нет сообщений",
              //   style: TextStyle(fontSize: 24),
              // );
              // },
              ),
        ],
      ),
    );
  }
}
