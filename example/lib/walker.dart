import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bluetooth_connector/bluetooth_connector.dart';

class Walker extends StatefulWidget {
  const Walker({Key? key}) : super(key: key);

  @override
  _WalkerState createState() => _WalkerState();
}

class _WalkerState extends State<Walker> {
  BluetoothConnector bluetoothAdapter = BluetoothConnector();
  String _connectionStatus = "NONE";
  BtDevice? currentDevice;
  List<BtDevice> devices = [];
  final List _receivedMessage = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  _startListening() async {
    // await bluetoothAdapter.initBlutoothConnection('00001101-5555-1000-8000-00805F9B34FB');
    await bluetoothAdapter.initBlutoothConnection('00001101-1296-1000-8000-00805F9B34FB');
    bluetoothAdapter.connectionStatus().listen((dynamic status) {
      setState(() => _connectionStatus = status.toString());
    });

    bluetoothAdapter.receiveMessages().listen((dynamic newMessage) {
      if (newMessage != 'READY TO RECEIVE MESSAGES') {
        print('aaa: ${newMessage}');
        setState(() => _receivedMessage
          ..clear()
          ..addAll(json.decode(newMessage).toList()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text('Любитель природы'),
        ),
        body: FutureBuilder(
            future: bluetoothAdapter.getDevices(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                devices = snapshot.data as List<BtDevice>;
              }
              return Column(
                children: <Widget>[

                  Text('Убедитесь, что в настройках приложения разрешен доступ к Bluetooth'),
                  SizedBox(height: 12),
                  Text("STATUS - $_connectionStatus"),

                  SizedBox(height: 12),
                  Text('Список сопряженных устройств для подключения'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 20,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: _createDevices(),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(hintText: "Write message"),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              bluetoothAdapter.sendMessage(_controller.text, sendByteByByte: false);
                              _controller.clear();
                            },
                            child: const Icon(Icons.send),
                          ),
                        ),
                      )
                    ],
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _receivedMessage.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: const Text('Sender'),
                          subtitle: Text(
                            _receivedMessage[index],
                          ),
                        );
                      },
                    ),
                  ),

                  // ListView(
                  //   shrinkWrap: true,
                  //   children: _receivedMessage.isNotEmpty
                  //       ? [..._receivedMessage.map((e) => Text(e)).toList()]
                  //       : [],
                  // )
                  // Text(
                  //   _receivedMessage ?? "NO MESSAGE",
                  //   style: const TextStyle(fontSize: 24),
                  // ),
                ],
              );
            }),
      ),
    );
  }

  _createDevices() {
    if (devices.isEmpty) {
      return [
        const Center(
          child: Text("No Paired Devices listed..."),
        )
      ];
    }

    return [
      for (var element in devices)
        InkWell(
          key: UniqueKey(),
          onTap: () async {
            bluetoothAdapter.startClient(devices.indexOf(element));
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              element.name.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        )
    ];
  }
}
