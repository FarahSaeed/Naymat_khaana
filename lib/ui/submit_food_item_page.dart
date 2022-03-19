import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_bloc.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_event.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_state.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/blocs/submitFoodItemBloc/submit_food_item_bloc.dart';
import 'package:naymat_khaana/blocs/submitFoodItemBloc/submit_food_item_event.dart';
import 'package:naymat_khaana/blocs/submitFoodItemBloc/submit_food_item_state.dart';
import 'package:naymat_khaana/custom_widgets/submit_page_widgets.dart';


import 'basket_page.dart';
import 'home_page.dart';
import 'login_page.dart'; // new
// new
//import 'package:provider/provider.dart';           // new


class SubmitFoodItemPageParent extends StatelessWidget {
  String title;
  UserAccount useraccount;
  SubmitFoodItemPageParent({required this.title, required this.useraccount});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SubmitFoodItemBloc>(
          create: (context) => SubmitFoodItemBloc(),
          //child: BasketPage(title: this.title, useraccount: this.useraccount),
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
          //child: BasketPage(title: this.title, useraccount: this.useraccount),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(),
          //child: BasketPage(title: this.title, useraccount: this.useraccount),
        ),
      ], child: SubmitFoodItemPage(title: this.title, useraccount: this.useraccount),
    );
    // return BlocProvider(
    //   create: (context) => SubmitFoodItemBloc(),
    //   child: SubmitFoodItemPage(title: this.title, useraccount: this.useraccount),
    // );
  }
}

// Define a custom Form widget.
class SubmitFoodItemPage extends StatefulWidget {
  //User user;
  String title;
  UserAccount useraccount;
  SubmitFoodItemPage({required this.title, required this.useraccount});
  ValueNotifier<int> basketItemsCountNotifier =ValueNotifier(0);
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
    } on FirebaseException catch (e) {print(e);}
    return durl;
  }

Future<ListResult> listFiles() async{
  ListResult results = await storage.ref('test').listAll();

  results.items.forEach((Reference ref) {
    print('found file $ref');
  });
  return results;
  }

  @override
  SubmitFoodItemPageState createState() {
    return SubmitFoodItemPageState(title: this.title, useraccount: this.useraccount);
  }
}


class SubmitFoodItemPageState extends State<SubmitFoodItemPage>  {
  //User user;
  String title;
  UserAccount useraccount;
  SubmitFoodItemPageState({required this.title, required this.useraccount});
  TextEditingController? inameController = TextEditingController();
  //TextEditingController? unameController = TextEditingController();
  TextEditingController? apriceController = TextEditingController();
  TextEditingController? dpriceController = TextEditingController();
  TextEditingController? sdateController = TextEditingController();
  TextEditingController? edateController = TextEditingController();

  String? valid_iname = null;
  //String? valid_uname = null;
  String? valid_aprice = null;
  String? valid_dprice = null;
  String? valid_sdate = null;
  String? valid_edate = null;
  DateTime selectedDate = DateTime.now();
  SubmitFoodItemBloc? submitFoodItemBloc;
  HomePageBloc? homePageBloc;
  BasketBloc? basketBloc;
 var _image;
  XFile? image;

  FocusNode? _focusNodeDprice; // focus management dob
  FocusNode? _focusNodeAprice; // focus management dob

  // FocusNode? _focusNodeEdate; // focus management dob
  @override
  void dispose() {
    super.dispose();
    _focusNodeDprice!.dispose();
    _focusNodeAprice!.dispose();

    // _focusNodeEdate!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNodeDprice = new FocusNode();
    _focusNodeAprice = new FocusNode();
    // // _focusNodeSdate!.addListener(_onOnFocusNodeSdateEvent);
    // _focusNodeEdate = new FocusNode();
    // _focusNodeEdate!.addListener(_onOnFocusNodeEdateEvent);
  }
  void setFocusDprice() {FocusScope.of(context).requestFocus(_focusNodeDprice);}
  void setFocusAprice() {FocusScope.of(context).requestFocus(_focusNodeAprice);}


  // _onOnFocusNodeSdateEvent() async {
  //   if (_focusNodeSdate!.hasFocus){
  //     FocusScope.of(context).unfocus();
  //   //   final DateTime? picked = (await showDatePicker(
  //   //       context: context,
  //   //       initialDate: selectedDate,
  //   //       firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
  //   //       lastDate: DateTime(2101)))!;
  //   //   sdateController!.text = (picked==null)?"":"${picked.toLocal()}".split(' ')[0];
  //   //   FocusScope.of(context).nextFocus();
  //   }
  // }
  // _onOnFocusNodeEdateEvent() async {
  //   if (_focusNodeEdate!.hasFocus){
  //     FocusScope.of(context).unfocus();
  //   //   final DateTime? picked = (await showDatePicker(
  //   //       context: context,
  //   //       initialDate: sdateController!.text == ""? selectedDate:DateTime.parse(sdateController!.text) ,
  //   //       firstDate: sdateController!.text == ""?selectedDate:DateTime.parse(sdateController!.text), //DateTime(1900, 8),
  //   //       lastDate: DateTime(2101)))!;
  //   //   edateController!.text = (picked==null)?"":"${picked.toLocal()}".split(' ')[0];
  //   //   FocusScope.of(context).nextFocus();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    submitFoodItemBloc = BlocProvider.of<SubmitFoodItemBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    basketBloc = BlocProvider.of<BasketBloc>(context);
    basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_sharp,
                  color: Colors.white,
                ),
                onPressed: (){
                  navigateToBasketPage(context);
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      // onTap: (){
                      // } ,
                      child: Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child:
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: widget.basketItemsCountNotifier,
                            builder: (BuildContext context, int nitems, Widget? child)  {
                              return Text(nitems.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                            //child: Text('Hi')
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocListener<SubmitFoodItemBloc,SubmitFoodItemState>(
                listener: (context,state){
                  if (state is SubmissionSuccessful){
                    final snackBar = SnackBar(
                      content: const Text('Item is submitted.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    navigateToHomePage(context, this.useraccount, );
                  }
                },
                child: BlocBuilder<SubmitFoodItemBloc,SubmitFoodItemState>(
                    builder: (context,state) {
                      if (state is SubmitFoodInitialState){
                        return buildInitialUI();
                      }
                      else if (state is SubmissionLoading) {
                        return buildLoadingUI();
                      }
                      else if (state is SubmissionSuccessful) {
                        return Container();
                      }
                      else if (state is SubmissionFailed) {
                        return buildFailureUI(state.message);
                      }
                      else {return buildInitialUI();}
                    }
                ),
              ),
              BlocListener<HomePageBloc,HomePageState>(
                listener: (context,state){
                  if (state is LogoutSuccessful) {
                    navigateToLoginPage(context);
                  }
                },
                child: BlocBuilder<HomePageBloc,HomePageState>(
                    builder: (context,state) {
                      return Container();
                    }
                ),
              ),
              BlocListener<BasketBloc, BasketState>(
                listener: (context, state) {
                  if (state is BasketCountLoaded) {
                    widget.basketItemsCountNotifier.value = state.count;
                  }
                },
                child: BlocBuilder<BasketBloc, BasketState>(
                  builder: (context, state) {
                    if (state is BasketCountLoaded) {
                      return Container();
                    }
                    else {
                      return Container();
                    }
                  },
                ),
              ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 30.0, bottom: 6.0, left: 20.0, right: 20.0),
                child:
                  SubmitInputTextField(
                    labelText: 'Food item name',
                    errorText: valid_iname,
                    inputTextController: inameController,
                  ),
                // TextField(
                //   textInputAction: TextInputAction.next,
                //   controller: inameController,
                //   decoration: InputDecoration(
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                //     ),
                //     labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                //     alignLabelWithHint: true,
                //     //border: OutlineInputBorder(),
                //     //border: OutlineInputBorder(),
                //     labelText: 'Food item name',
                //     errorText: valid_iname,
                //   ),
                // ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child:
                SubmitInputTextField(
                  labelText: 'Actual price',
                  errorText: valid_aprice,
                  inputTextController: apriceController,
                  focusNode: _focusNodeAprice,
                    onSubmitted: (String str) {

                      if ( apriceController!.text !=null && apriceController!.text !="" && dpriceController!.text !=null && dpriceController!.text !=""){
                        if (double.parse(apriceController!.text) <= double.parse(dpriceController!.text))
                        {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Invalid price'),
                              content: const Text('Actual price should be higher than discounted price.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: ()
                                  { Navigator.pop(context, 'Update Actual price');
                                  },
                                  child: const Text('Update Actual price'),
                                ),
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context, 'Update Discounted price');
                                    _focusNodeAprice!.unfocus();
                                    _focusNodeDprice!.requestFocus();
                                    //setFocusDprice();
                                    //FocusScope.of(context).requestFocus( _focusNodeDprice);
                                  },
                                  child: const Text('Update Discounted price'),
                                ),
                              ],
                            ),
                          );
                          FocusScope.of(context).requestFocus( _focusNodeAprice,);
                          //  FocusScope.of(context).requestFocus( _focusNodeSdate);
                        }
                        else FocusScope.of(context).requestFocus( _focusNodeDprice); // _focusNodeAprice!.nextFocus();

                      }
                      else FocusScope.of(context).requestFocus( _focusNodeDprice); //_focusNodeAprice!.nextFocus();
                      //FocusScope.of(context).requestFocus( _focusNodeSdate,);
                    }
                ),
                // TextField(
                //   focusNode: _focusNodeAprice,
                //   textInputAction: TextInputAction.next,
                //   controller: apriceController,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                //     ),
                //     labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                //     alignLabelWithHint: true,
                //     labelText: 'Actual price',
                //     errorText: valid_aprice,
                //   ),
                //     onSubmitted: (String str) {
                //
                //       if ( apriceController!.text !=null && apriceController!.text !="" && dpriceController!.text !=null && dpriceController!.text !=""){
                //         if (double.parse(apriceController!.text) <= double.parse(dpriceController!.text))
                //         {
                //           showDialog<String>(
                //             context: context,
                //             builder: (BuildContext context) => AlertDialog(
                //               title: const Text('Invalid price'),
                //               content: const Text('Actual price should be higher than discounted price.'),
                //               actions: <Widget>[
                //                 TextButton(
                //                   onPressed: ()
                //               { Navigator.pop(context, 'Update Actual price');
                //
                //               //FocusScope.of(context).requestFocus( _focusNodeAprice);
                //              //_focusNodeAprice!.requestFocus();
                //
                //               },
                //                   child: const Text('Update Actual price'),
                //                 ),
                //                 TextButton(
                //                   onPressed: (){
                //                     Navigator.pop(context, 'Update Discounted price');
                //                   _focusNodeAprice!.unfocus();
                //                   _focusNodeDprice!.requestFocus();
                //                   //setFocusDprice();
                //                   //FocusScope.of(context).requestFocus( _focusNodeDprice);
                //                   },
                //                   child: const Text('Update Discounted price'),
                //                 ),
                //               ],
                //             ),
                //           );
                //           FocusScope.of(context).requestFocus( _focusNodeAprice,);
                //           //  FocusScope.of(context).requestFocus( _focusNodeSdate);
                //         }
                //         else FocusScope.of(context).requestFocus( _focusNodeDprice); // _focusNodeAprice!.nextFocus();
                //
                //       }
                //       else FocusScope.of(context).requestFocus( _focusNodeDprice); //_focusNodeAprice!.nextFocus();
                //       //FocusScope.of(context).requestFocus( _focusNodeSdate,);
                //     }
                // ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),

                // child: FocusScope(
                //   canRequestFocus: true,
                //
                //   child: Focus(
                //     focusNode: _focusNodeSdate,
                //     canRequestFocus: true,
                //     onFocusChange: (focus) {
                //
                //       if (!focus && apriceController!.text !=null && apriceController!.text !="" && dpriceController!.text !=null && dpriceController!.text !=""){
                //         if (double.parse(apriceController!.text) < double.parse(dpriceController!.text))
                //         {
                //           showDialog<String>(
                //             context: context,
                //             builder: (BuildContext context) => AlertDialog(
                //               title: const Text('AlertDialog Title'),
                //               content: const Text('AlertDialog description'),
                //               actions: <Widget>[
                //                 TextButton(
                //                   onPressed: () => Navigator.pop(context, 'Cancel'),
                //                   child: const Text('Cancel'),
                //                 ),
                //                 TextButton(
                //                   onPressed: (){ Navigator.pop(context, 'OK');
                //                   FocusScope.of(context).requestFocus( _focusNodeSdate);
                //
                //                   },
                //                   child: const Text('OK'),
                //                 ),
                //               ],
                //             ),
                //           );
                //        //  FocusScope.of(context).requestFocus( _focusNodeSdate);
                //         }
                //
                //       }
                //       //print("fffffffffffffffffffffffffffocus: $focus");
                //       },
                    child: TextField(
                     focusNode: _focusNodeDprice,
                     // textInputAction: TextInputAction.next,
                      controller: dpriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                        ),
                        labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                        alignLabelWithHint: true,
                      //  border: OutlineInputBorder(),
                        labelText: 'Discount price',
                        errorText: valid_dprice,
                      ),
                        onSubmitted: (String str) {

                                if ( apriceController!.text !=null && apriceController!.text !="" && dpriceController!.text !=null && dpriceController!.text !=""){
                                  if (double.parse(apriceController!.text) <= double.parse(dpriceController!.text))
                                  {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Invalid price'),
                                        content: const Text('Discounted price should be less than actual price.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: ()
                                            { Navigator.pop(context, 'Update Actual price');
                                           // _focusNodeDprice!.unfocus();
                                            //_focusNodeAprice!.unfocus();
                                            _focusNodeDprice!.unfocus();
                                            _focusNodeAprice!.requestFocus();
                                            //FocusScope.of(context).requestFocus( _focusNodeAprice);
                                            },
                                            child: const Text('Update Actual price'),
                                          ),
                                          TextButton(
                                            onPressed: (){ Navigator.pop(context, 'Update Discounted price');
                                            //_focusNodeAprice!.unfocus();
                                            //_focusNodeDprice!.requestFocus();
                                            //FocusScope.of(context).requestFocus( _focusNodeDprice);
                                            },
                                            child: const Text('Update Discounted price'),
                                          ),
                                        ],
                                      ),
                                    );
                                    FocusScope.of(context).requestFocus( _focusNodeDprice,);
                                 //  FocusScope.of(context).requestFocus( _focusNodeSdate);
                                  }
                                  else _focusNodeDprice!.unfocus();

                                }
                                else _focusNodeDprice!.unfocus();
                          //FocusScope.of(context).requestFocus( _focusNodeSdate,);
                        }
                    ),
                //   ),
                // ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                 // focusNode: _focusNodeSdate,
                  textInputAction: TextInputAction.next,
                  controller: sdateController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Submission date',
                    errorText: valid_sdate,
                  ),
                  onTap: () async {
                    DateTime? picked = (await showDatePicker(
                        helpText: "Selection date",
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
                        lastDate: DateTime(2101)));
                    sdateController!.text = (picked == null)?"": "${picked.toLocal()}".split(' ')[0];
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                 // focusNode: _focusNodeEdate,
                  textInputAction: TextInputAction.next,
                  controller: edateController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Expiration date',
                    errorText: valid_edate,
                  ),
                  onTap: () async {
                    DateTime? picked = (await showDatePicker(
                        helpText: "Expiration date",
                        context: context,
                        initialDate: sdateController!.text == ""? selectedDate:DateTime.parse(sdateController!.text) ,
                        firstDate: sdateController!.text == ""?selectedDate:DateTime.parse(sdateController!.text), //DateTime(1900, 8),
                        lastDate: DateTime(2101)));
                    edateController!.text = (picked == null)?"":"${picked.toLocal()}".split(' ')[0];
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();
                    var source = ImageSource.gallery;
                    image = await picker.pickImage(
                        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  //String a = File(image!.path);
                     setState(() {
                     _image = File(image!.path);

                     // if (_image == null)
                     //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no image was selected')));
                     // else {
                     //   widget.UploadFile(filePath: image!.path, fileName: image!.name).then((value) => print('done'));
                     // }
                     });
                  },
                  child: const Text('Upload Image', style: TextStyle(fontSize: 17),),
                ),
              ),

              _image== null?Container():

              Container(
                margin: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),

                child: Image.file(
                  _image,
                  //width: 200.0,
                  //height: 200.0,
                  fit: BoxFit.fitHeight,
                ),
              ),

              Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white60, offset: Offset(0, 1), blurRadius: 0.5)
                  ],
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    stops: [0.1, 0.5, 1.0],
                    colors: [
                      Colors.green,
                      Colors.lightGreen,
                      Colors.green,
                    ],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    setState(() {

                    valid_iname = validate_iname(inameController!.text);
                   // valid_uname = validate_uname(unameController!.text);
                    valid_aprice = validate_aprice(apriceController!.text);
                    valid_dprice = validate_dprice(dpriceController!.text);
                    valid_sdate = validate_sdate(sdateController!.text);
                    valid_edate = validate_edate(edateController!.text);

                    if (_image == null)
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no image was selected')));
                    else {
                      widget.UploadFile(filePath: image!.path, fileName: image!.name).then((value) => print('done'));
                    }

                    if (valid_iname == null && valid_aprice == null && valid_dprice == null && valid_sdate == null && valid_edate == null ){
                      submitFoodItemBloc!.add(SubmitButtonPressedEvent(iname: inameController!.text, uname: useraccount.uname, aprice: apriceController!.text, dprice: dpriceController!.text, sdate: sdateController!.text, edate: edateController!.text, useremail: (this.useraccount.email), imagename: image!.name ));
                      //setState(() {
                        //_image = File(image!.path);

                    }
                    });},
                  child: const Text('Submit'),
                ),
              ),

            Container(
              // height: 45,
              // width: double.infinity,
              // margin: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0, right: 20.0),
              // child: FutureBuilder(
              //     future: widget.listFiles(),
              //     builder: (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
              //       if (snapshot.hasError) {
              //         return Text('Something went wrong');
              //       }
              //
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Text("Loading");
              //       }
              //
              //       return Container(
              //
              //         child: ListView.builder
              //           ( //scrollDirection: Axis.horizontal,
              //         shrinkWrap: true,
              //         itemCount: snapshot.data!.items.length,
              //         itemBuilder: (BuildContext context, int index){
              //
              //           return Text(snapshot.data!.items[index].name);
              //         } )
              //
              //       );
              //     }),
            ),


              Container(
                // height: 45,
                // width: double.infinity,
                // margin: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0, right: 20.0),
                // child: FutureBuilder(
                //     future: widget.downloadURL(imagename: 'scaled_image_picker1176476598179497756.jpg'),
                //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                //       if (snapshot.hasError) {
                //         return Text('Something went wrong');
                //       }
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return Text("Loading");
                //       }
                //       return Container(
                //           width: 300,
                //           height: 250,
                //         child: Image.network(snapshot.data!, fit: BoxFit.cover )
                //
                //       );
                //     }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validate_iname(String value) {
      value = value == null? '':value;
      if (value == '') {return 'Value Can\'t Be Empty'; }
      else {  return null;}
  }

  String? validate_aprice(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    var int_num = int.tryParse(value);
    var double_num = double.tryParse(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (int_num==null && double_num== null) {
      return 'Invalid value';
    }
    else {  return null;}
  }
  String? validate_dprice(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    var int_num = int.tryParse(value);
    var double_num = double.tryParse(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (int_num==null && double_num== null) {
      return 'Invalid value';
    }
    if (apriceController!.text == null || apriceController!.text == ""){
      return null; // it is handeled in aprice validator so returning null here
    }

    else if ( double.tryParse(apriceController!.text)! <= double.tryParse(dpriceController!.text)!  ){
      return "Discounted price should be less than actual price";
    }
    else {  return null;}
  }
  String? validate_sdate(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }
  String? validate_edate(String value) {
    value = value == null || value == ''? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    if (sdateController!.text == '' || sdateController!.text == null) {return ''; }

    DateTime sd = DateTime.parse(sdateController!.text);
    DateTime ed = DateTime.parse(edateController!.text);
    final bool edBeforesd = ed.isBefore(sd);
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (edBeforesd) {return 'Expiry date is before submission date';}
    else {  return null;}
  }

  Widget buildInitialUI(){
    return Container(); //Text('Waiting for Submission');
  }
  Widget buildLoadingUI(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget buildFailureUI(String message){
    return Text(
        message,
        style: TextStyle(
          color: Colors.red,
        )
    );
  }

  void navigateToHomePage(BuildContext context, UserAccount useraccount){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        HomePageParent(title: 'Home', useraccount: useraccount)), (Route<dynamic> route) => false);
  }
  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        homePageBloc!.add(LogoutButtonPressedEvent());
        break;
      case 'Settings':
        break;
    }
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        LoginPageParent(title: 'Login')), (Route<dynamic> route) => false);
  }

  void navigateToBasketPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BasketPageParent(title: "Basket Items", useraccount: this.useraccount);
    })).then(
            (context) {
          basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
        });
  }
}
