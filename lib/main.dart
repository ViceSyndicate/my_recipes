import 'package:flutter/material.dart';
import 'package:my_recipes/vm_create_recipe.dart';
import 'package:my_recipes/model_recipe.dart';
import 'package:my_recipes/vm_display_recipe.dart';

import 'db_logic.dart';

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
        brightness: Brightness.dark,
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
  Future<List<Recipe>> _futureRecipes = getRecipes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: getRecipes(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return RecipeListItem(recipes[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching recipes: ${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Navigate to RecipeFormPage and wait for result
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecipeFormPage()));

            // If a new recipe was added, update the list of recipes

            setState(() {
              _futureRecipes = getRecipes();
            });
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add)),
    );
  }
}

class RecipeListItem extends StatefulWidget {
  RecipeListItem(this.recipe);
  final Recipe recipe;

  @override
  State<RecipeListItem> createState() => _RecipeListItemState();
}

class _RecipeListItemState extends State<RecipeListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.white,
      title: Text(widget.recipe.title),
      subtitle: Text(widget.recipe.ingredients.join(', ')),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayRecipePage(widget.recipe)))
      },
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Perform delete operation here
          print('START del func');
          deleteRecipe(widget.recipe);
          print('END del func');
          // Trigger UI update by calling setState
          setState(() {});
        },
      ),
    );
  }
}

class MyColor extends MaterialStateColor {
  const MyColor() : super(_defaultColor);

  static const int _defaultColor = 0xcafefeed;
  static const int _pressedColor = 0xdeadbeef;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return const Color(_pressedColor);
    }
    return const Color(_defaultColor);
  }
}
