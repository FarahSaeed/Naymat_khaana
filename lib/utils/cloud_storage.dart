import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  static final CloudStorage _singletonStorage = CloudStorage._internal();

  factory CloudStorage() {
    return _singletonStorage;
  }
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> UploadFile({required String filePath,required String fileName}) async{
  File file = File(filePath);
  try{
    await storage.ref('test/$fileName').putFile(file);
  } on FirebaseException catch (e) {print(e);}
}

Future<String> downloadURL({required String imagename}) async{
String durl = "";
    try{
      durl = await storage.ref('test/$imagename').getDownloadURL();
      return durl;
    } on FirebaseException catch (e) {
      print(e);
    }
    return durl;
  }


  Future<List<String>> downloadallURL({required List<String> imagename}) async{
    List<String> durl = [];
    try{
      for(int i=0; i< imagename.length; i++) {
        String curr_imagename = imagename[i];
        durl.add(await storage.ref('test/$curr_imagename').getDownloadURL());
      }
      return durl;
    } on FirebaseException catch (e) {
      print(e);
    }
    return durl;
  }

Future<ListResult> listFiles() async{
  ListResult results = await storage.ref('test').listAll();

  results.items.forEach((Reference ref) {
    print('found file $ref');
  });
  return results;
  }



  CloudStorage._internal();
}