import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:naymat_khaana/main.dart';
import 'package:naymat_khaana/routes/userhome_page.dart';
import '../src/authentication.dart';                  // new
//import 'package:provider/provider.dart';           // new



class SignupPage extends StatefulWidget {
  SignupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignupForm(),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// Define a custom Form widget.
class SignupForm extends StatefulWidget {
  @override
  SignupFormState  createState() {
    return SignupFormState();
  }
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  //final _idController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _unameController = TextEditingController();
  final _passController = TextEditingController();
  final _dobController = TextEditingController();
  final _orgController = TextEditingController();


  void _incrementCounter() {
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
        'first_name': _fnameController.text, // John Doe
        'last_name': _lnameController.text, // Stokes and Sons
        'email': _emailController.text, // 42
        'uname': _unameController.text, // 42
        'pass': _passController.text, // 42
        'dob': _dobController.text, // 42
        'org': _orgController.text, // 42
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }




    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          TextFormField(
            controller: _fnameController,
            decoration: InputDecoration(
                hintText: "First Name"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lnameController,
            decoration: InputDecoration(
                hintText: "Last Name"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                hintText: "Email"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _unameController,
            decoration: InputDecoration(
                hintText: "Username"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passController,
            decoration: InputDecoration(
                hintText: "Password"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
                hintText: "Date of Birth"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _orgController,
            decoration: InputDecoration(
                hintText: "Organization"
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          ElevatedButton(
            onPressed: ()  async {
              // Validate returns true if the form is valid, or false otherwise.
              var was_successful = true;
              if (_formKey.currentState!.validate()) {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passController.text
                  );
                  addUser(); // validation of different kinds still needs to be added
                } on FirebaseAuthException catch (e) {
                  was_successful = false;
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  was_successful = false;
                  print(e);
                }
                if (was_successful){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      UserHomePage(title: _emailController.text)), (Route<dynamic> route) => false);
                }
              }
            },
            child: Text('Sign up'),
          ),


        ],
      ),
    );
  }

}


