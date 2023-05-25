import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class ImagesQuery {
  Future<List> showImages() async {
    return await SQLiteWrapper().query("SELECT * FROM images");
  }

  void addImage(String image) async {
    await SQLiteWrapper()
        .insert(ImageModel(image: image, prelevement: null).toMap(), "images");
    print("Data inserted in local !");
  }

  void deleteImage(int id) async {
    await SQLiteWrapper()
        .execute("DELETE FROM images WHERE id = ?", params: [id]);
    print("Data deleted in local !");
  }

  void delete(ImageModel img) async {
    await SQLiteWrapper().delete(img.toMap(), "images", keys: ["id"]);
    print("Data deleted in local !");
  }
}
