import 'package:flutter/material.dart';
import 'package:my_recipes/vm_create_recipe.dart';
import 'package:my_recipes/model_recipe.dart';
import 'package:my_recipes/vm_display_recipe.dart';
import 'package:my_recipes/vm_edit_recipe.dart';
import 'db_logic.dart';

Future<void> initializeApp() async {}

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
    //db_logic db = db_logic();
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

  @override
  void initState() {
    super.initState();
  }

  String filterText = '';
  bool isKeto = false;
  void updateRecipes() {
    setState(() {});
  }

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
                  // I never set the recipes [] to what the filterRecipes
                  // function returns so why does it work?
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
              icon: const Icon(Icons.save),
              onPressed: () {
                exportRecipes();
              },
              tooltip:
                  'Export Recipes - Download your recipes to import them on a new device'),
          IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () async {
                await importRecipes();
                setState(() {});
              },
              tooltip:
                  'Import Recipes - Upload your recipes.json that you exported earlier.'),
        ],
      )),
      body: FutureBuilder<Iterable<Recipe>>(
        // READ: https://api.flutter.dev/flutter/dart-async/Future-class.html
        future: getRecipes(),
        builder: ((context, snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return const Text("Null Data!");
          }
          if (snapshot.hasData) {
            recipes = snapshot.data as List<Recipe>;

            if (isKeto == true) {
              recipes = filterRecipesByKeto(isKeto);
            }

            if (filterText != '') {
              recipes = filterRecipes(filterText);
            }

            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return RecipeListItem(recipes[index], updateRecipes);
              },
            );
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
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecipeFormPage()));

            // If a new recipe was added, update the list of recipes

            setState(() {});
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add)),
    );
  }

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
}

class RecipeListItem extends StatefulWidget {
  const RecipeListItem(this.recipe, this.onUpdate, {super.key});
  final Recipe recipe;

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
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              tooltip: 'Edit Recipe',
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditRecipePage(widget.recipe)));
                Future.delayed(const Duration(milliseconds: 10))
                    .then((value) => {widget.onUpdate()});
              },
            ),
            IconButton(
              tooltip: 'Delete Recipe',
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await deleteRecipe(widget.recipe);
                widget.onUpdate();
                // Dirty fix to remove the need to use refresh button
                // When the UI doesn't update properly.
                // Might not be needed anymore
                //Future.delayed(const Duration(milliseconds: 10)).then((value) => {widget.onUpdate()});
              },
            ),
          ],
        ));
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
