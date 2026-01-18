import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:titos/save_manager.dart';

class Food {
  Food({required this.rating, required this.restaurantName, required this.details, required this.pic64});

  String restaurantName;
  String pic64;
  String details;
  double rating;

  Map<String, dynamic> toJson() =>
      {'rating': rating, 'restaurantName': restaurantName, 'details': details, 'pic64': pic64};
}

class FoodsManager {
  static FoodsManager instance = FoodsManager();
  Map<String, List<Food>> foodLists = <String, List<Food>>{};

  Map<String, dynamic> toMap() => {
        'foodLists': foodLists.map((key, value) {
          return MapEntry(key, value);
        })
      };

  String toJson() => jsonEncode(toMap());

  void clear(){
    foodLists.clear();
  }

  void setFromJson(String json) {
    if (json.isEmpty) {
      foodLists = <String, List<Food>>{};
      return;
    }

    final Map<String, dynamic> src = jsonDecode(json);
    final Map<String, dynamic> rawFoodLists =
        src['foodLists'] as Map<String, dynamic>;

    foodLists = rawFoodLists.map<String, List<Food>>(
      (key, value) {
        var ret = <Food>[];

        for(var i in value){
          ret.add(Food(rating: i['rating'], restaurantName: i['restaurantName'], details: i['details'], pic64: i['pic64']));
        }

        return MapEntry(
          key,
          ret,
        );
      },
    );
  }

  void addFoodList(String name) {
    foodLists[name] = <Food>[];
  }

  Future<void> addFood(String listName, String restaurantName, double rating, String details, XFile pic) async {
    foodLists[listName]
        ?.add(Food(restaurantName: restaurantName, rating: rating, details: details, pic64: await SaveManager.instance.saveFile(pic)));
  }

  List<Food>? getFoodList(String name) {
    return foodLists[name];
  }

  void removeFoodList(String name) {
    foodLists.remove(name);
  }
}
