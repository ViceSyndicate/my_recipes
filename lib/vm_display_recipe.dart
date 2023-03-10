import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipes/model_recipe.dart';

class DisplayRecipePage extends StatelessWidget {
  const DisplayRecipePage(this.recipe, {super.key});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Recipe Page'),
      ),
      body: Center(), // Put recipe variables in me
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Back',
        onPressed: () {
          // Save form data
          Navigator.pop(
            context,
          );
        },
        child: const Icon(Icons.arrow_back_rounded),
      ),
    );
  }
}
