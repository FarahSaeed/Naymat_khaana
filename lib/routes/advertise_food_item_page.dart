import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:naymat_khaana/main.dart';
import 'package:naymat_khaana/routes/userhome_page.dart';
import '../src/authentication.dart';                  // new
//import 'package:provider/provider.dart';           // new



class AdvertiseFoodItemPage extends StatefulWidget {
  AdvertiseFoodItemPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AdvertiseFoodItemPageState createState() => _AdvertiseFoodItemPageState();
}

class _AdvertiseFoodItemPageState extends State<AdvertiseFoodItemPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // List<String> _adsList = [];
    // print("****************************************************************************");
    // await FirebaseFirestore.instance
    //     .collection('ads')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc["_iname"]);
    //     _adsList.add( doc["_iname"] as String );
    //   });
    // });
    // print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // print('${_adsList.length}');
    // for (final foodname in _adsList) {
    //   // print(foodname);
    //   print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    //   print('${foodname.toString()}');
    // }
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
            AdvertisementForm(),
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
class AdvertisementForm extends StatefulWidget {
  @override
  AdvertisementFormState  createState() {
    return AdvertisementFormState();
  }
}

class AdvertisementFormState extends State<AdvertisementForm> {
  final _formKey = GlobalKey<FormState>();
  //final _idController = TextEditingController();
  final _inameController = TextEditingController();
  final _opriceController = TextEditingController();
  final _dpriceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _edateController = TextEditingController();

  void _incrementCounter() {
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference ads = FirebaseFirestore.instance.collection('ads');

    Future<void> addAdvertisement(_iname, _oprice, _dprice, _qty, _edate) async {
      // Call the user's CollectionReference to add a new user
      DateTime now = new DateTime.now();
      DateTime _addingdate = new DateTime(now.year, now.month, now.day);
      return ads
          .add({
        '_iname': _iname, // John Doe
        '_oprice': _oprice, // Stokes and Sons
        '_dprice': _dprice, // 42
        '_qty': _qty, // 42
        '_edate': _edate, // 42
        'adate': _addingdate, // 42
        'seller': await FirebaseAuth.instance.currentUser!.uid // 42
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
            controller: _inameController,
            decoration: InputDecoration(
                hintText: "Food item Name"
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
            controller: _opriceController,
            decoration: InputDecoration(
                hintText: "Original price"
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
            controller: _dpriceController,
            decoration: InputDecoration(
                hintText: "Discounted price"
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
            controller: _qtyController,
            decoration: InputDecoration(
                hintText: "Quantity"
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
            controller: _edateController,
            decoration: InputDecoration(
                hintText: "Expiry date"
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
                try{
                  addAdvertisement(_inameController.text, _opriceController.text, _dpriceController.text, _qtyController.text, _edateController.text); // validation of different kinds still needs to be added
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
                  var curr_email = FirebaseAuth.instance.currentUser!.email;
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserHomePage(title:  (curr_email == null)
                      ? "no-user-logged-in"
                      : curr_email))
              );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Advertisement posted.')));
                 }
              };
            },
            child: Text('Post'),
          ),


        ],
      ),
    );
  }

}


