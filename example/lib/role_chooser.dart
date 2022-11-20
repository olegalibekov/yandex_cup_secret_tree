import 'package:bluetooth_connector_example/pine_tree.dart';
import 'package:bluetooth_connector_example/walker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class RoleChooser extends StatefulWidget {
  const RoleChooser({Key? key}) : super(key: key);

  @override
  State<RoleChooser> createState() => _RoleChooserState();
}

class _RoleChooserState extends State<RoleChooser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () async {
                final applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
                Hive.init(applicationDocumentsDirectory.path);
                final box = await Hive.openBox('testBox');
                // box.clear();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PineTree(),
                ));
              },
              child: const Center(
                child: Text(
                  'Сосна',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Walker(),
                ));
              },
              child: const Center(
                child: Text(
                  'Любитель природы',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
