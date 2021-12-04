# bluetooth_connector

A Flutter plugin to expose the features of Bluetooth Adapter for **Android only**.

## Objective

The primary purpose of this project was to communicate between flutter and paired Wear OS devices using Bluetooth. It is developed based on the code of [bluetoothadapter package](https://pub.dev/packages/bluetoothadapter) and the only ideal was to make it in compliance with null-safety.

## Main Features
- Setting up a UUID from user end.
- Checking Bluetooth connection status and giving alerts if its off or not right.
- Getting list of paired devices.
- Get a particular paired device info.
- Start Bluetooth server.
- Start Bluetooth client.
- Start Bluetooth client.
- Send message to a connected device.
- Stream for listening to received messages.
- Stream for listening to connection status (CONNECTED, CONNECTING, CONNECTION FAILED, LISTENING, DISCONNECTED).

### Getting Started

For a full example please check /example folder. Here are only the most important parts of the code to illustrate how to use the library.

    //Initiatinng the bluetooth adapter
    BluetoothConnector flutterbluetoothconnector = BluetoothConnector();

	//Listening to the connection status listener
	String _connectionStatus = "NONE";
    StreamSubscription _btConnectionStatusListener =flutterbluetoothconnector.connectionStatus().listen((dynamic status) {
      setState(() {
        _connectionStatus = status.toString();
      });
    });

	//Listening to the recieved messages
	String _recievedMessage;
    StreamSubscription _btReceivedMessageListener = flutterbluetoothconnector.receiveMessages().listen((dynamic newMessage) {
      setState(() {
        _recievedMessage = newMessage.toString();
      });
    });

#### Getting paired devices

    List<BtDevice> devices = await flutterbluetoothconnector.getDevices();

#### Getting paired device

    await flutterbluetoothconnector.getDevice(deviceAddress);

#### Starting BT server

    await flutterbluetoothconnector.startServer();

#### Starting BT client

    flutterbluetoothconnector.startClient(devices.indexOf(element), true);

#### Sending message

    flutterbluetoothconnector.sendMessage(messageString);

#### Check BT connection
	await flutterbluetoothconnector.checkBluetooth(); //returns bool

#### Set UUID
	flutterbluetoothconnector.initBlutoothConnection(uuid);

### Flutter Help

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

