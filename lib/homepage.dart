import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:titos/add_food_list.dart';
import 'package:titos/colors_palette.dart';
import 'package:titos/empty_homepage.dart';
import 'package:titos/foods_manager.dart';
import 'package:titos/list_page.dart';
import 'package:titos/loading_page.dart';
import 'save_manager.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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

  void removeFoodList(name) {
    FoodsManager.instance.removeFoodList(name);

    SaveManager.instance.saveJson(FoodsManager.instance.toJson());
    setState(() {});
  }

  void openFoodList(String name) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ListPage(foodListName: name)));

    setState(() {});
  }

  List<Widget> getListTiles() {
    var ret = <Widget>[];
    var lists = FoodsManager.instance.foodLists;

    for (var i in lists.keys) {
      // Filter by searchText (case-insensitive)
      if (searchText.isNotEmpty &&
          !i.toLowerCase().startsWith(searchText.toLowerCase())) {
        continue;
      }

      // GETS THE HIGHEST RATED RESTAURANT
      double highestRating = 0;
      String? highestRatedImg;
      String? highestRated;
      for (var j in lists[i]!) {
        if (j.rating > highestRating) {
          highestRated = j.restaurantName;
          highestRating = j.rating;
          highestRatedImg = j.pic64;
        }
      }

      ret.add(ListTile(
        title: Text(
          i,
          style: TextStyle(
              color: ColorsPalette.tertiary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        subtitle: highestRated != null
            ? Text(
                "#1: $highestRated",
                style: TextStyle(color: ColorsPalette.colorA, fontSize: 12),
              )
            : null,
        leading: highestRatedImg != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  base64Decode(highestRatedImg),
                  width: 50,
                  height: 50,
                ),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: ColorsPalette.tertiary,
                    borderRadius: BorderRadius.circular(15)),
              ),
        onTap: () {
          openFoodList(i);
        },
        trailing: IconButton(
            onPressed: () {
              removeFoodList(i);
            },
            icon: Icon(
              Icons.close,
              color: ColorsPalette.colorA,
            )),
      ));
    }

    return ret;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SaveManager.instance.saveJson(FoodsManager.instance.toJson());

    super.dispose();
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
                  body: Column(children: [
                    Expanded(child: ListView(children: getListTiles())),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: SizedBox(
                                  width: 250,
                                  child: SearchBar(
                                    hintText: searchText.isEmpty
                                        ? "Search..."
                                        : searchText,
                                    onSubmitted: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                    },
                                    trailing: searchText.isNotEmpty
                                        ? [
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
                                  ))),
                          IconButton(
                            onPressed: () {
                              addFoodList(context);
                            },
                            icon: Icon(Icons.add),
                            color: ColorsPalette.colorA,
                            iconSize: 35,
                          ),
                          IconButton(
                            onPressed: () {
                              FoodsManager.instance.clear();
                              SaveManager.instance.saveJson(FoodsManager.instance.toJson());
                            },
                            icon: Icon(Icons.clear),
                            color: ColorsPalette.colorA,
                            iconSize: 35,
                          )
                        ],
                      ),
                    ),
                  ]),
                  drawer: Drawer(
                    backgroundColor: ColorsPalette.primary,
                    child: ListView(
                      children: getListTiles(),
                    ),
                  ),
                );
        });
  }
}
