import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bluetooth_connector/bluetooth_connector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothConnector flutterbluetoothadapter = BluetoothConnector();
  StreamSubscription? _btConnectionStatusListener, _btReceivedMessageListener;
  String _connectionStatus = "NONE";
  List<BtDevice> devices = [];
  String? _recievedMessage;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    flutterbluetoothadapter
        .initBlutoothConnection("20585adb-d260-445e-934b-032a2c8b2e14");
    flutterbluetoothadapter
        .checkBluetooth()
        .then((value) => print(value.toString()));
    _startListening();
  }

  _startListening() {
    _btConnectionStatusListener =
        flutterbluetoothadapter.connectionStatus().listen((dynamic status) {
      setState(() {
        _connectionStatus = status.toString();
      });
    });
    _btReceivedMessageListener =
        flutterbluetoothadapter.receiveMessages().listen((dynamic newMessage) {
      setState(() {
        _recievedMessage = newMessage.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        await flutterbluetoothadapter.startServer();
                      },
                      child: const Text('LISTEN'),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        devices = await flutterbluetoothadapter.getDevices();
                        setState(() {});
                      },
                      child: const Text('LIST DEVICES'),
                    ),
                  ),
                )
              ],
            ),
            Text("STATUS - $_connectionStatus"),
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
            Text(
              _recievedMessage ?? "NO MESSAGE",
              style: const TextStyle(fontSize: 24),
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
                      decoration:
                          const InputDecoration(hintText: "Write message"),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        flutterbluetoothadapter.sendMessage(
                            _controller.text ?? "no msg",
                            sendByteByByte: false);
//                        flutterbluetoothadapter.sendMessage(".",
//                            sendByteByByte: true);
                        _controller.text = "";
                      },
                      child: const Text('SEND'),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
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
    List<Widget> deviceList = [];
    devices.forEach((element) {
      deviceList.add(
        InkWell(
          key: UniqueKey(),
          onTap: () {
            flutterbluetoothadapter.startClient(devices.indexOf(element), true);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              element.name.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    });
    return deviceList;
  }
}
