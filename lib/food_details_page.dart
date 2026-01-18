import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:titos/colors_palette.dart';
import 'package:titos/foods_manager.dart';
import 'package:titos/loading_page.dart';
import 'package:titos/save_manager.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage(
      {super.key, required this.foodListName, required this.foodIndex});

  final String foodListName;
  final int foodIndex;

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  final TextEditingController restaurantNameTEC = TextEditingController();
  final TextEditingController ratingTEC = TextEditingController();
  final TextEditingController detailsTEC = TextEditingController();

  void save() {
    Food food =
        FoodsManager.instance.foodLists[widget.foodListName]![widget.foodIndex];

    if (restaurantNameTEC.text.replaceAll(" ", "") == "" ||
        double.tryParse(ratingTEC.text) == null) {
      var snackBar = SnackBar(
        content: Text("Please Enter a Real Rating and Restaurant"),
        backgroundColor: ColorsPalette.colorA,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    FoodsManager.instance.foodLists[widget.foodListName]![widget.foodIndex] =
        Food(
            rating: double.parse(ratingTEC.text),
            restaurantName: restaurantNameTEC.text,
            details: detailsTEC.text,
            pic64: food.pic64);
    SaveManager.instance.saveJson(FoodsManager.instance.toJson());

    Navigator.of(context).pop();
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
        Food food = FoodsManager
            .instance.foodLists[widget.foodListName]![widget.foodIndex];
        restaurantNameTEC.text = food.restaurantName;
        ratingTEC.text = food.rating.toString();
        detailsTEC.text = food.details;

        return Scaffold(
          backgroundColor: ColorsPalette.primary,
          appBar: AppBar(
            backgroundColor: ColorsPalette.primary,
            foregroundColor: ColorsPalette.colorB,
            title: Row(
              children: [
                Text("Restaurant: "),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: restaurantNameTEC,
                      style: TextStyle(
                        fontSize: 24,
                        color: ColorsPalette.tertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 80,
                child: TextField(
                  onChanged: (value) {
                    if (ratingTEC.text.isNotEmpty &&
                        (ratingTEC.text.length > 2 && value != '100')) {
                      // caps the rating under 10 and makes it the right digits
                      ratingTEC.text =
                          value.substring(0, ratingTEC.text.length - 1);
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: ratingTEC,
                  cursorColor: ColorsPalette.colorB,
                  decoration: InputDecoration(
                      suffixText: "/100",
                      filled: true,
                      fillColor: ColorsPalette.tertiary,
                      focusColor: ColorsPalette.colorA,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  style: TextStyle(color: ColorsPalette.primary),
                ),
              )
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(
                    base64Decode(food.pic64),
                    width: 400,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      controller: detailsTEC,
                      maxLines: 5,
                      cursorColor: ColorsPalette.colorB,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorsPalette.tertiary,
                          focusColor: ColorsPalette.colorA,
                          border: InputBorder.none),
                      style: TextStyle(color: ColorsPalette.primary),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(ColorsPalette.colorB)),
                      onPressed: () {
                        save();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: ColorsPalette.tertiary),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
