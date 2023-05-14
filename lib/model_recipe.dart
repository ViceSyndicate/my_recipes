import 'package:uuid/uuid.dart';

class Recipe {
  String id;
  String title;
  List<String> ingredients;
  String instructions;
  String notes;

  // Constructor
  Recipe(
      {required this.title,
      required this.ingredients,
      required this.instructions,
      required this.notes})
      : this.id = Uuid().v4();

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      ingredients: json['ingredients'].cast<String>(),
      instructions: json['instructions'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'notes': notes,
    };
  }
}
