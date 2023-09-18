// https://stackoverflow.com/questions/65472270/how-to-create-and-export-csv-file-in-flutter
// https://duckduckgo.com/?t=ffab&q=creatinv+csv+file+for+storage+in+dart&atb=v345-1&ia=web

// https://docs.flutter.dev/cookbook/persistence/reading-writing-files

import 'dart:convert';
//import 'dart:io';
import 'package:my_recipes/model_recipe.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:localstorage/localstorage.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

// https://pub.dev/packages/localstorage/example

late LocalStorage storage;
late List<Recipe> recipes;
/*
db_logic() {
  getStorage();
  Future<Iterable<Recipe>> recipeList = getRecipes();
  recipes = recipes.toList(growable: true);
}

LocalStorage getStorage() {
  storage = LocalStorage('recipe_data.json');
  await storage.ready;
  return storage;
}
*/
Future<List<Recipe>> getRecipes() async {
  storage = LocalStorage('recipe_data.json');
  await storage.ready;
  List<Recipe> recipes = [];
  String? recipeJson = storage.getItem('recipes');
  if (recipeJson != null) {
    List<dynamic> decodedRecipes = jsonDecode(recipeJson);
    for (var recipe in decodedRecipes) {
      recipes.add(Recipe.fromJson(recipe));
      //Recipe recipeObj = Recipe.fromJson(recipe);
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
    print('adding ${recipe.title} to storage');

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
  print("recipeData: $recipeData");
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
