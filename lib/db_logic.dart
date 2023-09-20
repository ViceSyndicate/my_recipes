import 'dart:convert';
import 'package:my_recipes/model_recipe.dart';
import 'dart:async';
import 'package:localstorage/localstorage.dart';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

late LocalStorage storage;
late List<Recipe> recipes;

Future<List<Recipe>> getRecipes() async {
  storage = LocalStorage('recipe_data.json');
  await storage.ready;
  List<Recipe> recipes = [];
  String? recipeJson = storage.getItem('recipes');
  if (recipeJson != null) {
    List<dynamic> decodedRecipes = jsonDecode(recipeJson);
    for (var recipe in decodedRecipes) {
      recipes.add(Recipe.fromJson(recipe));
    }
    return recipes;
  } else {
    return recipes;
  }
}

Future<void> saveRecipe(Recipe recipe) async {
  try {
    Iterable<Recipe> recipes = await getRecipes();

    List<Recipe> recipesList = recipes.toList(growable: true);

    recipesList.add(recipe);

    await storage.setItem('recipes', jsonEncode(recipesList));
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> saveRecipeList(List<Recipe> recipes) async {
  try {
    await storage.setItem('recipes', jsonEncode(recipes));
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> deleteRecipe(Recipe recipe) async {
  Iterable<Recipe> recipes = await getRecipes();

  List<Recipe> recipesList = recipes.toList(growable: true);

  recipesList.removeWhere((r) => r.id == recipe.id);
  storage.setItem('recipes', jsonEncode(recipesList));
}

Future<void> exportRecipes() async {
  final LocalStorage storage = LocalStorage('recipe_data.json');
  await storage.ready;
  var recipeData = storage.getItem('recipes');
  if (recipeData != null) {
    String jsonData = json.encode(recipeData);

    try {
      // Create a data URI for the JSON content
      final dataUri =
          'data:application/json;charset=utf-8,${Uri.encodeComponent(jsonData)}';
      // Create an anchor element for the download link
      final anchor = html.AnchorElement(href: dataUri)
        ..target = 'webdownload'
        ..download = 'recipe_data.json'; // Specify the filename

      // Trigger a click event on the anchor element
      anchor.click();
    } catch (e) {
      // Handle any exceptions that occur
      print("Error exporting recipes: $e");
    }
  } else {
    // Handle the case where the data is not found in local storage.
    print("Recipe data not found in local storage.");
  }
}

Future<void> importRecipes() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
  List<Recipe> importedRecipes = [];
  if (result != null) {
    try {
      String utfDecoded = utf8.decode(result.files.single.bytes as List<int>);
      String decodedData = json.decode(utfDecoded);

      List<dynamic> dynamicList = json.decode(decodedData);
      for (var recipe in dynamicList) {
        importedRecipes.add(Recipe.fromJson(recipe));
      }
      saveRecipeList(importedRecipes);
    } catch (e) {
      print("Error importing recipes: $e");
    }
  }
}

Future<void> saveEditedRecipe(Recipe recipe) async {
  // Delete old recipe
  await deleteRecipe(recipe);

  // Generate and set new id for edited recipe
  Uuid uuidGen = const Uuid();
  recipe.id = uuidGen.v4();

  await saveRecipe(recipe);
}
