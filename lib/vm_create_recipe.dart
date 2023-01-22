import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipes/model_recipe.dart';

class RecipeFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Back to Recipes'),
          backgroundColor: Colors.blueAccent),
      body: const MyCustomForm(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // create_recipe page
            Navigator.pop(
              context,
            );
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.save)),
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              'Register',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ), // title: login
          Container(
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              decoration: InputDecoration(
                  labelText: 'Recipe Name',
                  //prefixIcon: Icon(Icons.email),
                  icon: Icon(Icons.format_align_left)),
            ),
          ),
          Container(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onFieldSubmitted: (String value) {},
              decoration: InputDecoration(
                  labelText: 'Recipe Notes',
                  icon: Icon(Icons.format_align_left)),
            ),
          ),
          Container(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              decoration: InputDecoration(
                labelText: 'Recipe Ingredients',
                icon: Icon(Icons.format_align_left),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// https://blog.devgenius.io/add-remove-textformfields-dynamically-in-flutter-5bef6948e778