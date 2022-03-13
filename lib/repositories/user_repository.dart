
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';

class UserRepository{

FirebaseAuth? firebaseAuth;
CollectionReference? users;


UserRepository() {
   this.firebaseAuth = FirebaseAuth.instance; // initializing in initializer list
   this.users = FirebaseFirestore.instance.collection('users');
}


Future<UserAccount?> createUser(String fname, String lname, String dob, String email, String uname, String password) async{
   try{

      await users!
          .add({
         'first_name': fname, // John Doe
         'last_name': lname, // Stokes and Sons
         'email': email, // 42
         'uname': uname, // 42
         'pass': password, // 42
         'dob': dob, // 42
      })
          .then((value) => print("User Added"))
          .catchError((error) => throw Exception(error.toString()));
      var result = await firebaseAuth!.createUserWithEmailAndPassword(email: email, password: password);

       //await firebaseAuth.
      UserAccount userAccount = UserAccount(user: result.user!, fname: fname, lname: lname, uname: uname, email: email, dob: dob);

      return userAccount; //result.user;
   }
   on PlatformException catch(e) {
      throw Exception(e.toString());
   }
}

Future<UserAccount?> getUser(String email1) async{
   try{
      QuerySnapshot userList = await  users!.where("email", isEqualTo: email1).get(); //users!.where('email', arrayContainsAny: [email1]).get();
      QueryDocumentSnapshot doc=userList.docs[0];
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String fname = data['first_name'];
      String lname = data['last_name'];
      String uname = data['uname'];
      String email = data['email'];
      String dob = data['dob'];

      UserAccount userAccount = UserAccount( fname: fname, lname: lname, uname: uname, email: email, dob: dob);
      return userAccount; //result.user;
   }
   on PlatformException catch(e) {
      throw Exception(e.toString());
   }
}





Future<UserAccount?> signInUser(String email1, String password) async{
   try{
      var result = await firebaseAuth!.signInWithEmailAndPassword(email: email1, password: password);
      QuerySnapshot userList = await  users!.where("email", isEqualTo: email1).get(); //users!.where('email', arrayContainsAny: [email1]).get();
      QueryDocumentSnapshot doc=userList.docs[0];
      //
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String fname = data['first_name'];
      String lname = data['last_name'];
      String uname = data['uname'];
      String email = data['email'];
      String dob = data['dob'];

     UserAccount userAccount = UserAccount(user: result.user!, fname: fname, lname: lname, uname: uname, email: email, dob: dob);

   // Future<QuerySnapshot> userList =  users!.get();
      // users!.where('email', arrayContainsAny: [email])
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //    querySnapshot.docs.forEach((doc) {
      //       print(doc["first_name"]);
      //    });
      // });

      return userAccount; //result.user;
   }
   on PlatformException catch(e) {
      throw Exception(e.toString());
   }
}

Future<void> signOut() async{
   await firebaseAuth!.signOut();
}

Future<bool> isSignedIn() async{
   var currentuser = await firebaseAuth!.currentUser;
   return currentuser != null;
}

Future<UserAccount?> getCurrentUser() async{
   User currentUser =  (await firebaseAuth!.currentUser)!;


   QuerySnapshot userList = await  users!.where("email", isEqualTo: currentUser.email).get(); //users!.where('email', arrayContainsAny: [email1]).get();
   QueryDocumentSnapshot doc=userList.docs[0];
   //
   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
   String fname = data['first_name'];
   String lname = data['last_name'];
   String uname = data['uname'];
   String email = data['email'];
   String dob = data['dob'];

   UserAccount userAccount = UserAccount(user: currentUser, fname: fname, lname: lname, uname: uname, email: email, dob: dob);
 return userAccount;

}

Future<bool> UserExist(String email) async{
  // User currentUser =  (await firebaseAuth!.currentUser)!;

   QuerySnapshot userList = await  users!.where("email", isEqualTo: email).get(); //users!.where('email', arrayContainsAny: [email1]).get();

   if (userList.docs.length == 0) {return false;};
   return true;
}



}