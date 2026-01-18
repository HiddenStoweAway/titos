import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

class SaveManager{
  static SaveManager instance = SaveManager();
  final _box = Hive.box('foods');
  final _key = 'foods_data';

  Future<void> saveJson(String json) async{
    await _box.put(_key, json);
  }

  Future<String> getJson() async{
    return _box.get(_key, defaultValue: "");
  }

  Future<void> clearJson() async{
    
  }

  Future<String> saveFile(XFile saveFile) async {
    // final directory = await getApplicationDocumentsDirectory();
    // final newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    // final file = await File(saveFile.path).copy(newPath);

    return base64Encode(await saveFile.readAsBytes());
  }
}