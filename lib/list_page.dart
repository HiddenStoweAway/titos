import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:titos/add_food.dart';
import 'package:titos/colors_palette.dart';
import 'package:titos/food_details_page.dart';
import 'package:titos/foods_manager.dart';
import 'package:titos/loading_page.dart';
import 'package:titos/save_manager.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.foodListName});
  final String foodListName;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void addFood() async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddFood(listName: widget.foodListName)));

    setState(() {});
  }

  void openFood(Food food) async {

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
          FoodDetailsPage(food: food, foodListName: widget.foodListName)));

    SaveManager.instance.saveJson(FoodsManager.instance.toJson());
    setState(() {});
  }

  List<Widget> getFoodsTiles() {
    var ret = <Widget>[];
    var foods = FoodsManager.instance.foodLists[widget.foodListName]!;

    foods.sort((a, b) => -a.rating.compareTo(b.rating));

    int count = 1;
    for (int i = 0; i < foods.length; i++) {
      final food = foods[i];
      ret.add(ListTile(
          onTap: () {
            openFood(
                food
            );
          },
          leading: Text(
            count.toString(),
            style: TextStyle(fontSize: 15),
          ),
          title: Text(
            food.restaurantName,
            style: TextStyle(
                color: ColorsPalette.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          subtitle: Text(
            " Rating: ${food.rating}/100",
            style: TextStyle(color: ColorsPalette.colorA, fontSize: 12),
          ),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(
              base64Decode(food.pic64),
              width: 50,
              height: 50,
            ),
          )));

      count++;
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
          FoodsManager.instance.setFromJson(snapshot.data!);

          return Scaffold(
            backgroundColor: ColorsPalette.primary,
            appBar: AppBar(
              foregroundColor: ColorsPalette.colorA,
              backgroundColor: ColorsPalette.primary,
              title: Text(
                widget.foodListName,
                style: TextStyle(
                    color: ColorsPalette.tertiary, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      addFood();
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            body: ListView(
              children: getFoodsTiles(),
            ),
          );
        });
  }
}
