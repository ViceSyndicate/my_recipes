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
            _buildSection(
              title: 'Ingredients',
              content: recipe.ingredients.join(', '),
            ),
            SizedBox(height: 16),
            _buildSection(
              title: 'Instructions',
              content: recipe.instructions,
            ),
            SizedBox(height: 16),
            _buildSection(
              title: 'Notes',
              content: recipe.notes,
            ),
            SizedBox(height: 16),
            const Text(
              'Is Keto:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(recipe.isKeto ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(content),
          ),
        ),
      ],
    );
  }
}
