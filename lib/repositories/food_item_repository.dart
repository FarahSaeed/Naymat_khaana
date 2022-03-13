
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';

class FoodItemRepository {
  CollectionReference fooditems = FirebaseFirestore.instance.collection('fooditems');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  List<FoodItem> foodItemsList = [];
  String? uname;

  // FoodItemRepository() {
  //   this.fooditems = FirebaseFirestore.instance.collection('fooditems');
  //   this.orders = FirebaseFirestore.instance.collection('orders');
  // }
  FoodItemRepository( {this.uname}){
     // this.fooditems = FirebaseFirestore.instance.collection('fooditems');
      // this.orders = FirebaseFirestore.instance.collection('orders');
      // if (this.uname != null)
      //   {
      //
      //   }
      // else{
      //
      // }
  }

  bool isFoodItemsListEmpty() {
  return this.foodItemsList.isEmpty;
  }

  Future<List<FoodItem>> searchfoodItems(String searchStr) async {
    List<FoodItem> searchItems = [];
    if (searchStr == null){searchStr = '';}
    else{searchStr = searchStr.trim().toLowerCase();}
    for( var i = 0 ; i < this.foodItemsList.length; i++ ) {
      if (this.foodItemsList[i].iname.toLowerCase().contains(searchStr)){
        searchItems.add(this.foodItemsList[i]);
      }
    }
    return searchItems;
  }

  Future<QuerySnapshot> basketfoodItemsListReference(String uname)  {
    Future<QuerySnapshot> result = this.fooditems.where("receiever", isEqualTo: uname).where("taken", isNull: true).get();
    return result;
  }

  Future<QuerySnapshot> foodItemsListReference()  {
    Future<QuerySnapshot> res =   this.fooditems.where("receiever", isNull: true).get();
    return res;
  }

  //Convert map to goal list
  List<FoodItem> mapToList({required List<DocumentSnapshot> docList}) {
    this.foodItemsList.clear();
     // List<FoodItem> fooditemList = [];
      docList.forEach((document) {

        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String iname = data['item_name'];
        String uname = data['username'];
        String aprice = data['actual_price'];
        String dprice = data['discount_price'];
        String sdate = data['submit_date'];
        String edate = data['exp_date'];
        String useremail = data['user_email']==null?'na':data['user_email'];
        String imagename = data['imagename']==null? "":data['imagename'];

        this.foodItemsList.add(FoodItem(iname: iname, uname: uname, aprice: aprice, dprice: dprice, sdate: sdate, edate: edate, useremail: useremail, id: document.id, imagename: imagename));
      });

      this.foodItemsList.sort((a, b) => DateTime.parse(b.edate).compareTo(DateTime.parse(a.edate)) );

      //this.foodItemsList.sort((a, b) => a.iname.toLowerCase().compareTo(b.iname.toLowerCase()) ); //compare(a.state, b.state));
      //print(list);
      return this.foodItemsList;
  }

  Future<void> submitItem(FoodItem foodItem) async{
    try{

      var result = await fooditems
          .add({
        'item_name': foodItem.iname, // John Doe
        'username': foodItem.uname, // Stokes and Sons
        'actual_price': foodItem.aprice, // 42
        'discount_price': foodItem.dprice, // 42
        'submit_date': foodItem.sdate, // 42
        'exp_date': foodItem.edate, // 42
        'user_email': foodItem.useremail, // 42
        'receiever': foodItem.receiver,
        'taken': foodItem.taken,
        'imagename':foodItem.imagename
      })
          .then((value) => print("Food item submitted"))
          .catchError((error) => throw Exception(error.toString()));

      return result;
    }
    on Exception catch(e) {
      throw Exception(e.toString());
    }
  }



  /////////////////////////////////////////////////////////////////////////
  Future<void> addReciever(String id, String recieveruname) async{
    try{

      var result = await fooditems.doc(id)
          .update({

        'receiever': recieveruname
      })
          .then((value) => print("Food item updated"))
          .catchError((error) => throw Exception(error.toString()));

      return result;
    }
    on Exception catch(e) {
      throw Exception(e.toString());
    }
  }

  /////////////////////////////////////////////////////////////////////////
  Future<void> removeFromBasket(String id, int index) async{
    try{
      //this.foodItemsList.removeAt(index);
      var result = await this.fooditems.doc(id)
          .update({

        'receiever': null
      })
          .then((value) => print("Food item updated"))
          .catchError((error) => throw Exception(error.toString()));

      return result;
    }
    on Exception catch(e) {
      throw Exception(e.toString());
    }
  }

  /////////////////////////////////////////////////////////////////////////
  Future<void> checkout(String adress, String uname) async{
    try{
      QuerySnapshot querySnapshots = await this.fooditems.where("receiever", isEqualTo: uname).where("taken", isNull: true).get();

      String todaysDate = new DateTime.now().toString().substring(0,10);

      // get selected bakset items of user and set taken=true or current data
      List<String> basketItemIds = [];
      for (var doc in querySnapshots.docs) {

        // / if expiry date is not passed otherwise dont check out this item
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        FoodItem fooditem = FoodItem(iname: data['item_name'], uname: data['username'], aprice: data['actual_price'], dprice: data['discount_price'], sdate: data['submit_date'], edate: data['exp_date'], useremail: data['user_email']);

        DateTime expirationDate = DateTime.parse(fooditem.edate);
        final now = DateTime.now();
        final bool isExpired = expirationDate.isBefore(now);
        if (isExpired) continue;

         basketItemIds.add(doc.id);
        await doc.reference.update({
          'taken': todaysDate,
        }).then((value) => print("Food item updated"))
            .catchError((error) => throw Exception(error.toString()));

        // add selected basket items to order collection

        //var formatter = new DateFormat('yyyy-MM-dd');
        //String todaysDate = formatter.format(now);
        //print(formattedDate); // 2016-01-25
      }
      var result = await orders
          .add({
        'uname': uname, // John Doe
        'address': adress, // Stokes and Sons
        'basket_items': basketItemIds, // 42
        'order_date': todaysDate, // 42
      })
          .then((value) => print("order submitted"))
          .catchError((error) => throw Exception(error.toString()));

     // return result;
    }
    on Exception catch(e) {
      throw Exception(e.toString());
    }
  }

  Future<int> getBasketCount(String uname) async {
    QuerySnapshot querySnapshots = await this.fooditems
        .where("receiever", isEqualTo: uname)
        .where("taken", isNull: true).get();

    // get selected bakset items of user and set taken=true or current data
    int count = 0;
    for (var doc in querySnapshots.docs) {

      // / if expiry date is not passed otherwise dont check out this item
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      FoodItem fooditem = FoodItem(iname: data['item_name'], uname: data['username'], aprice: data['actual_price'], dprice: data['discount_price'], sdate: data['submit_date'], edate: data['exp_date'], useremail: data['user_email']);

      DateTime expirationDate = DateTime.parse(fooditem.edate);
      final now = DateTime.now();
      final bool isExpired = expirationDate.isBefore(now);
      if (isExpired) continue;
      else count = count +1;
    }
    return count;
  }

}