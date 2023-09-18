import 'package:flutter/material.dart';
import 'package:my_recipes/model_recipe.dart';
import 'package:my_recipes/db_logic.dart';

class EditRecipePage extends StatelessWidget {
  final Recipe recipe;

  const EditRecipePage(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: MyEditForm(recipe),
    );
  }
}

// A lot of this code is copied from create_recipe but it
// takes a recipe variable instead.
class MyEditForm extends StatefulWidget {
  final Recipe recipe;

  MyEditForm(this.recipe, {super.key});

  @override
  MyEditFormState createState() {
    return MyEditFormState();
  }
}

class MyEditFormState extends State<MyEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  List<TextEditingController> _ingredientControllers = [];
  TextEditingController _instructionsController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  bool _isKeto = false;

  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);

    _ingredientControllers = [];

    _instructionsController =
        TextEditingController(text: widget.recipe.instructions);

    _notesController = TextEditingController(text: widget.recipe.notes);

    _isKeto = widget.recipe.isKeto;
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredientControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientControllers.forEach((controller) => controller.dispose());
    _instructionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    if (_ingredientControllers.isEmpty) {
      _addIngredientField();
    } else {
      final lastController = _ingredientControllers.last;
      final lastText = lastController.text.trim();
      if (lastText.isNotEmpty) {
        _addIngredientField();
      }
    }
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          shrinkWrap: true,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(3)),
            TextFormField(
              onSaved: (String? value) {},
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe name';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              controller: _titleController,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  )),
                  icon: Icon(Icons.format_align_left)),
            ),
            Padding(padding: EdgeInsets.all(3)),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              controller: _instructionsController,
              onFieldSubmitted: (String value) {},
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText: 'Recipe Instructions - List order of execution here',
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                )),
                icon: Icon(Icons.format_align_left),
              ),
            ),
            Padding(padding: EdgeInsets.all(3)),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              onFieldSubmitted: (String value) {},
              controller: _notesController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText:
                    'Recipe Notes - List how much of each ingredient here',
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                )),
                icon: Icon(Icons.format_align_left),
              ),
            ),
            Padding(padding: EdgeInsets.all(3)),
            ..._ingredientControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String value) {},
                      controller: controller,
                      onChanged: (value) {
                        if (value == _ingredientControllers.last.text) {
                          _addIngredientField();
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'Ingredient ${index + 1}',
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          )),
                          icon: Icon(Icons.format_align_left)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () => _removeIngredientField(index),
                  ),
                ],
              );
            }).toList(),
            Row(
              children: [
                Checkbox(
                  value: _isKeto,
                  onChanged: (bool? value) {
                    setState(() {
                      _isKeto = value ?? false;
                    });
                  },
                ),
                Text('Is Keto'),
                /*
                Expanded(
                  child: TextButton(
                    child: Text('Add ingredient'),
                    onPressed: _addIngredientField,
                  ),
                ),
                */
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        onPressed: () async {
          List<String> ingredients = [];
          for (var element in _ingredientControllers) {
            ingredients.add(element.text);
          }

          final recipe = Recipe(
            id: widget.recipe.id,
            title: _titleController.text,
            ingredients: ingredients,
            instructions: _instructionsController.text,
            notes: _notesController.text,
            isKeto: _isKeto,
          );
          await saveEditedRecipe(recipe); // ToDo
          Navigator.pop(
            context,
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

// https://blog.devgenius.io/add-remove-textformfields-dynamically-in-flutter-5bef6948e778
