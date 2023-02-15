import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/mysql.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final db = Mysql();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      //onPressed: _saveData,
      onPressed: _saveData,
      child: Text("test db"),
    );
  }

  void _saveData() async {
    await db.getConnection().then((conn) async {
      await conn.connect();
      print("database connected");
      await conn.execute("SELECT * FROM test WHERE id = :id", {"id": 1}).then(
          (results) {
        for (final row in results.rows) {
          print(row.assoc());
        }
      }).whenComplete(() {
        print("database closed");
        conn.close();
      });
    });
  }
}
