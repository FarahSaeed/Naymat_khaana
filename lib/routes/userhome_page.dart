import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:naymat_khaana/main.dart';
import 'package:naymat_khaana/routes/advertise_food_item_page.dart';
import '../src/authentication.dart';
import 'search_food_item_page.dart';                  // new
//import 'package:provider/provider.dart';           // new


class UserHomePage extends StatefulWidget {
  UserHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
           // SignupForm(),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchFoodItemPage(title: "Search from Ads") )
                );
              },
              child:  Text('Search'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdvertiseFoodItemPage(title: "Advertise") )
                );
              },
              child:  Text('Sell'),
            ),
            ElevatedButton(
              onPressed: () async {
                //Provider.of<Auth>(context, listen: false).logout();
                await FirebaseAuth.instance.signOut();
                //setState();
                //  setState(() { });
                //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    MyHomePage(title: "Homepage")), (Route<dynamic> route) => false);

                // setState(() {
                //
                // });
              },
              child:  Text('Log out'),
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

