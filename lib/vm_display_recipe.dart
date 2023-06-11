import 'package:flutter/material.dart';
import 'package:my_recipes/model_recipe.dart';

class DisplayRecipePage extends StatelessWidget {
  final Recipe recipe;

  const DisplayRecipePage(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(recipe.ingredients.join(', ')),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(recipe.instructions),
            SizedBox(height: 16),
            Text(
              'Notes:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(recipe.notes),
            SizedBox(height: 16),
            Text(
              'Is Keto:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(recipe.isKeto ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }
}
