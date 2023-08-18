import 'package:flutter/material.dart';
import 'package:my_recipes/vm_create_recipe.dart';
import 'package:my_recipes/model_recipe.dart';
import 'package:my_recipes/vm_display_recipe.dart';
import 'db_logic.dart';

Future<void> initializeApp() async {
  db_logic db = db_logic();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    db_logic db = db_logic();
    return MaterialApp(
      title: 'My Recipes Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'My Recipes Home Page', db),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.db, {super.key, required this.title});
  final String title;
  final db_logic db;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Iterable<Recipe>>? recipes;

  @override
  void initState() {
    recipes = widget.db.getRecipes();
    super.initState();
    //print(recipes);
    //_initializeRecipes(); // Call an async function to initialize recipes
  }

  String filterText = '';
  bool isKeto = false;
  void updateRecipes() {
    setState(() {});
    //widget.db.getRecipes();
  }

  // Note to self: Study this code.
  List<Recipe> filterRecipes(filterText) {
    List<Recipe> filteredRecipes = widget.db.recipes.where((recipe) {
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
        widget.db.recipes.where((recipe) => recipe.isKeto == isKeto).toList();

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
                  //filterRecipes(filterText);
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
                //widget.db.recipes = filterRecipesByKeto(isKeto);
                // Apply filtering and update the recipes list
              });
            },
          ),
          IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {},
              tooltip: 'Export Recipes'),
          IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () {},
              tooltip: 'Import Recipes'),
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: updateRecipes,
              tooltip: 'Refresh Recipes'),
        ],
      )),
      body: FutureBuilder<Iterable<Recipe>>(
        future: recipes,
        builder: ((context, snapshot) {
          var data = snapshot.data;
          print("Snapshot data: ${snapshot.data}");
          print("recipes: ${recipes}");
          //print(snapshot.connectionState);
          if (data == null) {
            return const Text("Loading...");
          }
          if (snapshot.hasData) {
            print(snapshot.data);
            //widget.db.recipes = snapshot.data!;
            /*
            return ListView.builder(
              itemCount: widget.db.recipes.length,
              itemBuilder: (context, index) {
                return RecipeListItem(
                    widget.db.recipes[index], updateRecipes, widget.db);
              },
            );
            */
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching recipes: ${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Navigate to RecipeFormPage and wait for result
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipeFormPage(widget.db)));

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
  const RecipeListItem(this.recipe, this.onUpdate, this.db, {super.key});
  final Recipe recipe;
  final db_logic db;
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
        tooltip: 'Delete Recipe',
        icon: const Icon(Icons.delete),
        onPressed: () async {
          /* I think I need to remake the delete button to be a future because 
          somtimes it deletes a recipe but  */
          await widget.db.deleteRecipe(widget.recipe);
          widget.onUpdate();
          // Dirty fix to remove the need to use refresh button
          // When the UI doesn't update properly.
          Future.delayed(const Duration(milliseconds: 10))
              .then((value) => {widget.onUpdate()});
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
