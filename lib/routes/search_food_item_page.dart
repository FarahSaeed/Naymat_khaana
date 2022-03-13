import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:naymat_khaana/custom_widgets/food_item_list_widget.dart';
import 'package:naymat_khaana/main.dart';
import 'package:naymat_khaana/routes/userhome_page.dart';
import '../src/authentication.dart';                  // new
//import 'package:provider/provider.dart';           // new



class SearchFoodItemPage extends StatefulWidget {
  SearchFoodItemPage({Key? key, required this.title}) : super(key: key);

  final String title;



  @override
  _SearchFoodItemPageState createState() => _SearchFoodItemPageState();
}

class _SearchFoodItemPageState extends State<SearchFoodItemPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

  }

  @override
  Widget build(BuildContext context) {

    var items =  List<String>.generate(10000, (i) => 'Item $i');
    List<String> _adsList = [];
/////////////////////////////////////////////////////////////// code for building data source
//       print("****************************************************************************");
//       await FirebaseFirestore.instance
//           .collection('ads')
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           print(doc["_iname"]);
//           _adsList.add( doc["_iname"] as String );
//         });
//       });
//       print('${_adsList.length}');
//       for (final foodname in _adsList) {
//         print('${foodname.toString()}');
//       }
///////////////////////////////////////////////////////////////





    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // AdvertisementForm(),
            Container(
              decoration: const BoxDecoration(color: Colors.blue),
            ),
            Expanded(
              child: SizedBox(
                height:200.0,
                child:  FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('ads').get(),
                        builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if (snapshot.hasError) {
                        return Text("Something went wrong");
                        }

                        // if (snapshot.hasData && !snapshot.data!.exists) {
                        // return Text("Document does not exist");
                        // }

                        if (snapshot.connectionState == ConnectionState.done) {
                        return new ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        // return new ListTile(
                        // title: new Text(data['_iname']),
                        // );
                          return new CustomListItem(
                            user: 'Flutter',
                            oprice : double.parse(data['_oprice'] ),
                            dprice : double.parse(data['_dprice'] ),
                            qty : double.parse(data['_qty'] ),
                            // adate : data['adate'] ,
                            edate : data['_edate'] ,
                            thumbnail: Container(
                              decoration: const BoxDecoration(color: Colors.blue),
                            ),
                            title: data['_iname'] , //'The Flutter YouTube Channel',
                          );
                        }).toList(),
                        );
                        }

                        return Text("loading");
                        },
                        )
                ),
            ),

            // Expanded(
            //   child: SizedBox(
            //     height: 200.0,
            //     child:  ListView.builder( shrinkWrap: true,
            //       itemCount: items.length,
            //       itemBuilder: (context, index) {
            //         return ListTile(
            //           title: Text('${items[index]}'),
            //         );
            //       },
            //     ),
            //   ),
            // ),

            // ListView.builder(shrinkWrap: true,
            //   itemCount: items.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text('${items[index]}'),
            //     );
            //   },
            // ),
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

