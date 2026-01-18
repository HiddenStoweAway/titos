import 'package:flutter/material.dart';
import 'package:titos/save_manager.dart';
import 'package:titos/colors_palette.dart';
import 'package:titos/foods_manager.dart';

class AddFoodList extends StatelessWidget {
  AddFoodList({super.key});
  final TextEditingController nameTEC = TextEditingController();

  void addFood(var context) async {
    if(nameTEC.text.replaceAll(" ", "") != ""){
      FoodsManager.instance.addFoodList(nameTEC.text);
      await SaveManager.instance.saveJson(FoodsManager.instance.toJson());
      Navigator.pop(context);
    }
    else{
      const snackBar = SnackBar(content: Text("Please Enter an Actual Name"), backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsPalette.primary,
      appBar: AppBar(
        foregroundColor: ColorsPalette.colorB,
        backgroundColor: ColorsPalette.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the name of the food: ",
              style: TextStyle(
                  color: ColorsPalette.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            TextField(
              controller: nameTEC,
              cursorColor: ColorsPalette.colorB,
              
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorsPalette.tertiary,
                focusColor: ColorsPalette.colorA,
                border: InputBorder.none
              ),
              style: TextStyle(color: ColorsPalette.primary),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(ColorsPalette.colorB)),
                onPressed: () {
                  addFood(context);
                },
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
