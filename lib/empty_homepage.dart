import 'package:flutter/material.dart';
import 'package:titos/colors_palette.dart';

class EmptyHomepage extends StatelessWidget {
  const EmptyHomepage({super.key, required this.addList});
  final Function(BuildContext context) addList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsPalette.tertiary,
        appBar: AppBar(
            backgroundColor: ColorsPalette.tertiary,
            title: Center(
                child: Text(
              "Titos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "It looks like you haven't made any lists!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ColorsPalette.primary),
                ),
                Text(
                  "Would you like to add one?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ColorsPalette.colorA),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(ColorsPalette.colorA)),
                    onPressed: () {
                      addList(context);
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
        ));
  }
}
