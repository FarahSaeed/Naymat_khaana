import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:naymat_khaana/routes/accounttype_page.dart';
import 'package:naymat_khaana/routes/userhome_page.dart';
// import 'src/authentication.dart';                  // new
// import 'routes/signup_page.dart';
//import 'package:provider/provider.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.user,
    required this.oprice,
    required this.dprice,
    required this.qty,
    // required this.adate,
    required this.edate,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String user;
  final double oprice;
  final double dprice;
  final double qty;
  // final String adate;
  final String edate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _VideoDescription(
              title: title,
              user: user,
              oprice: oprice,
              dprice: dprice,
              qty: qty,
              // adate: adate,
              edate: edate,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
    Key? key,
    required this.title,
    required this.user,
    required this.oprice,
    required this.dprice,
    required this.qty,
    // required this.adate,
    required this.edate,
  }) : super(key: key);

  final String title;
  final String user;
  final double oprice;
  final double dprice;
  final double qty;
  // final String adate;
  final String edate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            user,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Original price ' + '$oprice ',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Discounted price ' + '$dprice ',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Quantity ' + '$qty ',
            style: const TextStyle(fontSize: 10.0),
          ),
          // const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          // Text(
          //   'Added date: ' + '$adate ',
          //   style: const TextStyle(fontSize: 10.0),
          // ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Expiry date ' + '$edate ',
            style: const TextStyle(fontSize: 10.0),
          ),

        ],
      ),
    );
  }
}

// ...

Widget build(BuildContext context) {
  return ListView(
    padding: const EdgeInsets.all(8.0),
    itemExtent: 106.0,
    children: <CustomListItem>[
      CustomListItem(
        user: 'Flutter',
        oprice: 999000,
        dprice: 999000,
        qty: 999000,
        // adate: '06-23-2021',
        edate: '12122022',
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        title: 'The Flutter YouTube Channel',
      ),
      CustomListItem(
        user: 'Dash',
        oprice: 884000,
        dprice: 999000,
        qty: 999000,
        // adate: '06-23-2021',
        edate: '12122022',
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.yellow),
        ),
        title: 'Announcing Flutter 1.0',
      ),
    ],
  );
}