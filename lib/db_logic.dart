// https://stackoverflow.com/questions/65472270/how-to-create-and-export-csv-file-in-flutter
// https://duckduckgo.com/?t=ffab&q=creatinv+csv+file+for+storage+in+dart&atb=v345-1&ia=web

// https://docs.flutter.dev/cookbook/persistence/reading-writing-files

import 'dart:convert';
import 'dart:io';
import 'package:my_recipes/model_recipe.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

Future<List<Recipe>> getRecipes() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDocDir.path}/recipes.json';

  final file = File(filePath);
  final fileExists = await file.exists();
  if (!fileExists) {
    await file.create();
  }

  // get recipes
  final contents = await file.readAsString();
  List<dynamic> recipesJson = contents.isNotEmpty ? jsonDecode(contents) : [];

  List<Recipe> recipes = [];
  for (var recipeJson in recipesJson) {
    recipes.add(Recipe.fromJson(recipeJson));
  }

  return recipes;
}

// Future<void> saveRecipe(Recipe recipe) async {
Future<void> saveRecipe(Recipe recipe) async {
  List<Recipe> recipes = await getRecipes();
  recipes.add(recipe);
  /*
  for (int i = 0; i < recipes.length; i++) {
    print(recipes[i].id.toString());
  }
  */
  String jsonString = jsonEncode(recipes);

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDocDir.path}/recipes.json';

  final file = await File(filePath);
  await file.writeAsString(jsonString);
}

Future<void> saveRecipes(List<Recipe> recipes) async {
  String jsonString = jsonEncode(recipes);

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDocDir.path}/recipes.json';

  final file = await File(filePath);
  await file.writeAsString(jsonString);
}

Future<void> deleteRecipe(Recipe recipe) async {
  List<Recipe> recipes = await getRecipes();
  print('Id to remove: ' + recipe.id.toString());
  recipes.removeWhere((r) => r.id == recipe.id);

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDocDir.path}/recipes.json';
  final file = File(filePath);

  await file.writeAsString(jsonEncode(recipes));
}

// Could write a function that simply saves a list of recipes.
// I think that'd be less code.

/*
//Future<String> get _localPath async {
  //final directory = await getApplicationDocumentsDirectory();

  //return directory.path;
//}

final file = File('/path/to/shared/folder/recipes.json');
final recipes = json.decode(await file.readAsString()) as List<dynamic>;
final recipeObjects = recipes.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();



final file = File('/path/to/shared/folder/recipes.json');
final recipes = json.decode(await file.readAsString()) as List<dynamic>;
recipes.add(recipe.toJson());
await file.writeAsString(json.encode(recipes));
*/