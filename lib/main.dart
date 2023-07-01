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
  List<Recipe> recipes = [];

  String filterText = '';
  bool isKeto = false;
  void updateRecipes() {
    setState(() {});
  }

  // Note to self: Study this code.
  List<Recipe> filterRecipes(filterText) {
    List<Recipe> filteredRecipes = recipes.where((recipe) {
      final titleMatches =
          recipe.title.toLowerCase().contains(filterText.toLowerCase());

      final ingredientMatches = recipe.ingredients.any((ingredient) =>
          ingredient.toLowerCase().contains(filterText.toLowerCase()));

      return titleMatches || ingredientMatches;
    }).toList();

    return filteredRecipes;
  }

  List<Recipe> filterRecipesByKeto(bool isKeto) {
    List<Recipe> ketoRecipes =
        recipes.where((recipe) => recipe.isKeto == isKeto).toList();

    return ketoRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          const Text('Recipes'),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filterText = value;
                  filterRecipes(filterText);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('Keto'),
          Switch(
            value: isKeto,
            onChanged: (bool value) {
              setState(() {
                isKeto = value;
                recipes = filterRecipesByKeto(isKeto);
                // Apply filtering and update the recipes list
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: updateRecipes,
          ),
        ],
      )),
      body: FutureBuilder<List<Recipe>>(
        future: getRecipes(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            recipes = snapshot.data!;

            if (isKeto == true) {
              recipes = filterRecipesByKeto(isKeto);
            }

            if (filterText != '') {
              recipes = filterRecipes(filterText);
            }
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return RecipeListItem(
                  recipes[index],
                  updateRecipes,
                );
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

            setState(() {});
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add)),
    );
  }

/*
  List<Recipe> getFilteredRecipes(List<Recipe> recipes) {
    if (filterText.isEmpty && !isKeto) {
      return recipes; // Return all recipes when no filter is applied
    }

    return recipes.where((recipe) {
      final titleMatch = filterText.isEmpty ||
          recipe.title.toLowerCase().contains(filterText.toLowerCase());
      final ingredientsMatch = filterText.isEmpty ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(filterText.toLowerCase()));
      final ketoMatch = !isKeto || recipe.isKeto;
      return titleMatch || ingredientsMatch && ketoMatch;
    }).toList();
  }
  */
}

class RecipeListItem extends StatefulWidget {
  const RecipeListItem(this.recipe, this.onUpdate, {super.key});
  final Recipe recipe;
  // onUpdate calls updateRecipes which calls setState()
  // in our main Widget to update our list of recipes
  final Function() onUpdate;

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
        icon: const Icon(Icons.delete),
        onPressed: () {
          /* I think I need to remake the delete button to be a future because 
          somtimes it deletes a recipe but  */
          deleteRecipe(widget.recipe);
          widget.onUpdate();
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
