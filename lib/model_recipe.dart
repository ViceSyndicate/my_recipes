class Recipe {
  String id;
  String title;
  List<String> ingredients;
  String instructions;
  String notes;
  bool isKeto;

  // Constructor
  Recipe(
      {required this.title,
      required this.ingredients,
      required this.instructions,
      required this.notes,
      required this.isKeto,
      required this.id});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        title: json['title'],
        ingredients: json['ingredients'].cast<String>(),
        instructions: json['instructions'],
        notes: json['notes'],
        isKeto: json['isKeto'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'notes': notes,
      'isKeto': isKeto,
    };
  }
}
