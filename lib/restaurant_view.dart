import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:titos/add_food_list.dart';
import 'package:titos/colors_palette.dart';
import 'package:titos/empty_homepage.dart';
import 'package:titos/foods_manager.dart';
import 'package:titos/homepage.dart';
import 'package:titos/list_page.dart';
import 'package:titos/loading_page.dart';
import 'package:titos/restaurant_view.dart';
import 'save_manager.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  String searchText = "";

  void addFoodList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddFoodList(),
      ),
    );

    setState(() {});
  }

  void openFoodList(String name) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ListPage(foodListName: name)));

    setState(() {});
  }

  void deleteFood(String foodName, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ColorsPalette.primary,
            title: Text(
              "Are You Sure You Want To Delete?",
              style: TextStyle(color: ColorsPalette.colorB),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: ColorsPalette.colorA),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    FoodsManager.instance.deleteFood(foodName, index);
                    await SaveManager.instance
                        .saveJson(FoodsManager.instance.toJson());
                    setState(() {});
                    Navigator.pop(context, 'OK');
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: ColorsPalette.colorA),
                  ))
            ],
          );
        });
  }

  List<Widget> getListTiles() {
    if (searchText.isEmpty) {
      return [];
    }

    var ret = <Widget>[];
    var lists = FoodsManager.instance.foodLists;

    // the Food, the Restaurant and the Index in its own foodlist
    var foods = <(Food, String, int)>[];
    for (var i in lists.entries) {
      int index = 0;
      for (var j in i.value) {
        if (j.restaurantName
            .toLowerCase()
            .startsWith(searchText.toLowerCase())) {
          foods.add((j, i.key, index));
        }

        index += 1;
      }
    }

    for (var i in foods) {
      ret.add(ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.memory(
            base64Decode(i.$1.pic64),
            width: 50,
            height: 50,
          ),
        ),
        title: Text(
          i.$2,
          style: TextStyle(
              color: ColorsPalette.tertiary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        subtitle: Text(
          " Rating: ${i.$1.rating}/100",
          style: TextStyle(color: ColorsPalette.colorB, fontSize: 12),
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: ColorsPalette.colorB,
            ),
            onPressed: () {
              deleteFood(i.$2, i.$3);
            }),
      ));
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SaveManager.instance.getJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          }
          if (snapshot.hasData == false) {
            return EmptyHomepage(addList: addFoodList);
          }

          FoodsManager.instance.setFromJson(snapshot.data!);

          return FoodsManager.instance.foodLists.isEmpty
              ? EmptyHomepage(addList: addFoodList)
              : Scaffold(
                  backgroundColor: ColorsPalette.primary,
                  appBar: AppBar(
                    title: searchText.isEmpty
                        ? Text("Search For A Restaurant: ")
                        : Text("Foods At $searchText:"),
                    backgroundColor: ColorsPalette.primary,
                    foregroundColor: ColorsPalette.colorB,
                  ),
                  body: Column(children: [
                    Expanded(child: ListView(children: getListTiles())),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Homepage(),
                                ),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.restaurant_menu),
                            color: ColorsPalette.colorB,
                            iconSize: 35,
                          ),
                          Expanded(
                            child: SearchBar(
                              hintText:
                                  searchText.isEmpty ? "Search..." : searchText,
                              onSubmitted: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                              trailing: searchText.isNotEmpty
                                  ? <Widget>[
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              searchText = "";
                                            });
                                          },
                                          icon: Icon(Icons.close))
                                    ]
                                  : null,
                              shadowColor: WidgetStateColor.transparent,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              addFoodList(context);
                            },
                            icon: Icon(Icons.add),
                            color: ColorsPalette.colorB,
                            iconSize: 35,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                searchText = "";
                              });
                            },
                            icon: Icon(Icons.clear),
                            color: ColorsPalette.colorB,
                            iconSize: 35,
                          )
                        ],
                      ),
                    ),
                  ]),
                );
        });
  }
}
