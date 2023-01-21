import 'package:flutter/material.dart';
// ToDo
import 'package:my_recipes/vm_create_recipe.dart';
import 'package:my_recipes/model_recipe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Recipes Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Recipes Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Get recipes from db
    List<String> ingredients = ['Ingredient1', 'Ingredient2'];
    Recipe myRecipeOne = Recipe(1, "title", "notes", ingredients);
    Recipe myRecipeTwo = Recipe(2, "title", "notes", ingredients);

    var recipes = <Recipe>[];
    recipes.add(myRecipeOne);
    recipes.add(myRecipeTwo);

    // Todo: list recipes
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text('Entry')),
          );
        });
  }
}