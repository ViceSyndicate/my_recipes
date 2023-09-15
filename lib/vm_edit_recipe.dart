import 'package:flutter/material.dart';
import 'package:my_recipes/model_recipe.dart';
import 'package:my_recipes/vm_create_recipe.dart';

class EditRecipePage extends StatelessWidget {
  final Recipe recipe;

  const EditRecipePage(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: MyCustomForm(),
    );
  }
}
