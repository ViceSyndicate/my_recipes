// https://stackoverflow.com/questions/65472270/how-to-create-and-export-csv-file-in-flutter
// https://duckduckgo.com/?t=ffab&q=creatinv+csv+file+for+storage+in+dart&atb=v345-1&ia=web

// https://docs.flutter.dev/cookbook/persistence/reading-writing-files

import 'dart:convert';
import 'dart:io';
import 'package:my_recipes/model_recipe.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:localstorage/localstorage.dart';

// https://pub.dev/packages/localstorage/example
class db_logic {
  late LocalStorage storage;
  late List<Recipe> recipes;
  db_logic() {
    this.storage = getStorage();
    Future<Iterable<Recipe>> recipeList = getRecipes();
    recipes = recipes.toList(growable: true);
  }

  LocalStorage getStorage() {
    final storage = LocalStorage('recipe_data.json');
    storage.ready;
    return storage;
  }

  Future<Iterable<Recipe>> getRecipes() async {
    List<Recipe> recipes = [];
    String? recipeJson = storage.getItem('recipes');
    if (recipeJson != null) {
      List<dynamic> decodedRecipes = jsonDecode(recipeJson);
      for (var recipe in decodedRecipes) {
        recipes.add(Recipe.fromJson(recipe));
        print(recipe.toString());
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
      storage.setItem('recipes', jsonEncode(recipesList));
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    Iterable<Recipe> recipes = await getRecipes();

    List<Recipe> recipesList = recipes.toList(growable: true);

    print('Id to remove: ' + recipe.id.toString());
    recipesList.removeWhere((r) => r.id == recipe.id);
    storage.setItem('recipes', jsonEncode(recipesList));
  }
}
