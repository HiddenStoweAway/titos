import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titos/colors_palette.dart';
import 'package:titos/foods_manager.dart';
import 'package:titos/save_manager.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key, required this.listName});
  final String listName;

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final TextEditingController nameTEC = TextEditingController();

  final TextEditingController ratingTEC = TextEditingController();

  final TextEditingController detailsTEC = TextEditingController();

  XFile? foodImage;

  void addFood(var context) async {
    if (foodImage == null) {
      var snackBar = SnackBar(
        content: Text("Please Upload a Picture"),
        backgroundColor: ColorsPalette.colorA,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    } else if (nameTEC.text.replaceAll(" ", "") == "" ||
        int.tryParse(ratingTEC.text) == null) {
      var snackBar = SnackBar(
        content: Text("Please Enter a Real Rating and Restaurant"),
        backgroundColor: ColorsPalette.colorA,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await FoodsManager.instance.addFood(widget.listName, nameTEC.text,
        double.parse(ratingTEC.text), detailsTEC.text, foodImage!);
    await SaveManager.instance.saveJson(FoodsManager.instance.toJson());
    Navigator.pop(context);
  }

  void selectImage() async {
    final picker = ImagePicker();
    foodImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      
    });
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
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Restaurant: ",
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
                    border: InputBorder.none),
                style: TextStyle(color: ColorsPalette.primary),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Rating: ",
                style: TextStyle(
                    color: ColorsPalette.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
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
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorsPalette.colorB,
                      borderRadius: BorderRadius.circular(15)),
                  width: 250,
                  height: 200,
                  child: Icon(
                    foodImage == null ? Icons.upload : Icons.check,
                    color: ColorsPalette.tertiary,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Other Details",
                style: TextStyle(
                    color: ColorsPalette.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              TextField(
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
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(ColorsPalette.colorB)),
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
      ),
    );
  }
}
