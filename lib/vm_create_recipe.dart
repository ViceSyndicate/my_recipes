import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipes/model_recipe.dart';

class RecipeFormPage extends StatelessWidget {
  const RecipeFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Back to Recipes'),
          backgroundColor: Colors.blueAccent),
      body: const MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  icon: Icon(Icons.format_align_left)),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onFieldSubmitted: (String value) {},
              decoration: const InputDecoration(
                  labelText: 'Recipe Ingredients',
                  icon: Icon(Icons.format_align_left)),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              decoration: const InputDecoration(
                labelText: 'Recipe Instructions',
                icon: Icon(Icons.format_align_left),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              decoration: const InputDecoration(
                labelText: 'Recipe Notes',
                icon: Icon(Icons.format_align_left),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        onPressed: () {
          // Save form data
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
