import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.1.200',
      user = 'root',
      password = 'mysql',
      db = 'project';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db,
        maxPacketSize: 20971520);
    return await MySqlConnection.connect(settings);
  }
}
