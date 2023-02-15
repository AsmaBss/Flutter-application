import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = '192.168.1.200',
      user = 'root',
      password = 'mysql',
      db = 'project';
  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConnection() async {
    return await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: user,
        password: password,
        databaseName: db);
    //return await conn.connect();
  }
}
