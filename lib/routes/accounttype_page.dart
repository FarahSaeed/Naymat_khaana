import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'signup_page.dart';                  // new
import '../src/authentication.dart';
//import 'package:provider/provider.dart';           // new



class AccountTypePage extends StatefulWidget {
  AccountTypePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AccountTypePageState createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
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
            //SignupForm(),
            ElevatedButton(
              onPressed: ()  async {
                // Validate returns true if the form is valid, or false otherwise.
                //if (_formKey.currentState!.validate()) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage(title: 'Customer Sign up')));
                //}
              },
              child: Text('CUSTOMER'),
            ),
            ElevatedButton(
              onPressed: ()  async {
                // Validate returns true if the form is valid, or false otherwise.
                //if (_formKey.currentState!.validate()) {

                //}
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage(title: 'Seller sign up')));
              },
              child: Text('SELLER'),
            ),

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

