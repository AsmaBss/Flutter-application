/*
  void _getAllLocations() {
    db.getConnection().then((conn) {
      String sql = 'select mail from company.customer where id = 10;';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            //mail = row[0];
          });
        }
      });
      conn.close();
    });
  }
  */


   /*void _getAllLocations() {
    final Mysql db = Mysql();
    db.getConnection().then((conn) {
      String sql = 'select testcol from project.test;';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            print('row' + row[0]);
            //mail = row[0];
          });
        }
      });
      conn.close();
    });
  }*/
//'insert into position (address, description, latitude, longitude) values (?,?,?,?);';
/*address.toString(),
        description.toString(),
        latitude.toString(),
        longitude.toString()*/
