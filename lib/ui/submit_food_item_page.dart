import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:naymat_khaana/ui/camera_page.dart';
import 'package:naymat_khaana/ui/result_screen.dart';
import 'package:naymat_khaana/utils/cloud_storage.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';
import 'package:naymat_khaana/utils/validation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
//import 'package:google_ml_kit/google_ml_kit.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';

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
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(),
        ),
      ], child: SubmitFoodItemPage(title: this.title, useraccount: this.useraccount),
    );

  }
}

class SubmitFoodItemPage extends StatefulWidget {
  String title;
  UserAccount useraccount;
  SubmitFoodItemPage({required this.title, required this.useraccount});
  ValueNotifier<int> basketItemsCountNotifier =ValueNotifier(0);
  CloudStorage cloudStorage = CloudStorage();
  @override
  SubmitFoodItemPageState createState() {
    return SubmitFoodItemPageState(title: this.title, useraccount: this.useraccount);
  }
}


class SubmitFoodItemPageState extends State<SubmitFoodItemPage> with WidgetsBindingObserver {

  CameraController? _cameraController; //Its purpose is to visualise the camera controller
  final _textRecognizer = TextRecognizer();

  String title;
  UserAccount useraccount;
  SubmitFoodItemPageState({required this.title, required this.useraccount});
  TextEditingController? inameController = TextEditingController();
  TextEditingController? apriceController = TextEditingController();
  TextEditingController? dpriceController = TextEditingController();
  TextEditingController? sdateController = TextEditingController();
  TextEditingController? edateController = TextEditingController();
  String scannedText = "";
  String? textresult = null;
  String? valid_iname = null;
  String? valid_aprice = null;
  String? valid_dprice = null;
  String? valid_sdate = null;
  String? valid_edate = null;
  DateTime selectedDate = DateTime.now();
  SubmitFoodItemBloc? submitFoodItemBloc;
  HomePageBloc? homePageBloc;
  BasketBloc? basketBloc;
 var _image= null;
  XFile? image;
  List<XFile>? imageFileList = [];
  late PageController _pageController;
  late final Future<void> _future;
  int activePage = 1;
  //the path of the image stored in the device
// String? _imagePath;
//TextDetector? _textDetector;
  bool _isPermissionGranted = false;
  FocusNode? _focusNodeDprice; // focus management dob
  FocusNode? _focusNodeAprice; // focus management dob

  Future<String> recongnizeDate(String inputStr) async
  {
    String scannedString = "";
    bool dateFound = false;
    DateTime? originalFormat;
    List<String> dateFormatsList =["MMddyy",'MM/dd/yyyy', 'MM-dd-yyyy',"MMM-yy","MMMM-yy","MMM-yyyy"] ;
    final lines = inputStr.split('\n');

    for(String line in lines){
      List<String> lineStr = [line];
      if (line.toLowerCase().contains('exp')){
        lineStr = line.split(" ");
      }
      for (String strcandidate in lineStr) {
        for (String format in dateFormatsList ) {
          try {
            originalFormat = DateFormat(format).parse(strcandidate);
            dateFound = true;
          } catch (e) {}
          try{
          if (!dateFound){
            var re = RegExp(
              r'^'
              r'(?<month>[0-9]{1,2})'
              // r'/'
              r'(?<day>[0-9]{1,2})'
              // r'/'
              r'(?<year>[0-9]{1,2})'
              r'$',
            );
            var match = re.firstMatch(strcandidate);
            if (match == null) {
              throw FormatException('Unrecognized date format');
            }
            dateFound = true;
            originalFormat = DateTime(2000+
              int.parse(match.namedGroup('year')!),
              int.parse(match.namedGroup('month')!),
              int.parse(match.namedGroup('day')!),
            );
          }
          } catch (e) {}
          if (dateFound) {
            var outputFormat = DateFormat('yyyy-MM-dd');
            var date2 = outputFormat.format(originalFormat!);
            date2.toString();
            scannedString = date2.toString();
            break;
          }
        }
        if (dateFound) break;
      }
      if (dateFound) break;
    }

    return scannedString;
  }

  Future<String> recongnizeText(XFile imageXFile) async
  {
    //final inputImage = InputImage.fromFilePath(imageXFile.path);
//    final textDetector = GoogleMlKit.vision.textDetector();
    //RecognisedText recognisedText = await textDetector.processImage(inputImage);
    //await textDetector.close();
    String scannedString = "";
    bool dateFound = false;
    DateTime? originalFormat;
    List<String> dateFormatsList =["MMddyy",'MM/dd/yyyy', 'MM-dd-yyyy',"MMM-yyyy","MMM-yy","MMMM-yy"] ;

  //   for (TextBlock block in recognisedText.blocks){
  //     for (TextLine line in block.lines){
  //       // scannedString = scannedString+line.text+"\n";
  //       List<String> lineStr = [line.text];
  //
  //       if (line.text.toLowerCase().contains('exp')){
  //         lineStr = line.text.split(" ");
  //
  //       }
  //       for (String strcandidate in lineStr) {
  //       for (String format in dateFormatsList ) {
  //         try {
  //           // print(DateFormat('MM/dd/yyyy').parse(line.text));
  //           originalFormat = DateFormat(format).parse(strcandidate);
  //           dateFound = true;
  //         } catch (e) {}
  //         try{
  //         if (!dateFound){
  //           var re = RegExp(
  //             r'^'
  //             r'(?<month>[0-9]{1,2})'
  //             // r'/'
  //             r'(?<day>[0-9]{1,2})'
  //             // r'/'
  //             r'(?<year>[0-9]{1,2})'
  //             r'$',
  //           );
  //           var match = re.firstMatch(strcandidate);
  //           if (match == null) {
  //             throw FormatException('Unrecognized date format');
  //           }
  //           dateFound = true;
  //           originalFormat = DateTime(2000+
  //             int.parse(match.namedGroup('year')!),
  //             int.parse(match.namedGroup('month')!),
  //             int.parse(match.namedGroup('day')!),
  //           );
  //         }
  //         } catch (e) {}
  //         if (dateFound) {
  //           var outputFormat = DateFormat('yyyy-MM-dd');
  //           var date2 = outputFormat.format(originalFormat!);
  //           date2.toString();
  //           scannedString = date2.toString();
  //           break;
  //         }
  //       }
  //       if (dateFound) break;
  //       }
  //       if (dateFound) break;
  //
  //       // if(DateTime.tryParse(line.text) != null){
  // //   scannedString = line.text;
  // // }
  //
  // // DateFormat('MM-dd-yyyy').parse('06-09-2019');
  //     }
  //   }
   // setState(() {});
    return scannedString;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    _focusNodeDprice!.dispose();
    _focusNodeAprice!.dispose();

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    //TODO: Control camera flow
    if ((_cameraController == null) || (!_cameraController!.value.isInitialized)){
      return;
    }
    if (state == AppLifecycleState.inactive){
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
                _cameraController!= null &&
                _cameraController!.value.isInitialized){
      _startCamera();
    }
  }

  void _recognizTexts(String _imagePath) async {
    // Creating an InputImage object using the image path
    //final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final text = "abc" ;//await _textDetector!.processImage(inputImage);
    // Finding text String(s)
    // for (TextBlock block in text.blocks) {
    //   for (TextLine line in block.lines) {
    //     print('text: ${line.text}');
    //   }
    // }
  }

  @override
  void initState() {
    // Initializing the text detector
    //_textDetector = GoogleMlKit.vision.textDetector();

    super.initState();
    _focusNodeDprice = new FocusNode();
    _focusNodeAprice = new FocusNode();
    _pageController = PageController(viewportFraction: 0.8);

    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();


  }

  Future<void> _requestCameraPermission() async{
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera(){
    if (_cameraController != null){
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera(){
    if (_cameraController != null){
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras){
    if (_cameraController != null)
      return;

    //select the first rear camera
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++){
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back){
        camera = current;
        break;
      }
    }

    if (camera != null){
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async{
    _cameraController = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false
    );
    await _cameraController?.initialize();
    if (!mounted){
      return;
    }
    setState(() {});
  }

  Future<void>  _scanImage() async{

    if (_cameraController == null) return;

    final navigator = Navigator.of(context);
    try{
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      await navigator.push(
        MaterialPageRoute(builder: (context) => ResultScreen(text: recognizedText.text), )
      );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred when scanning text.')));
    }
  }

  void setFocusDprice() {FocusScope.of(context).requestFocus(_focusNodeDprice);}
  void setFocusAprice() {FocusScope.of(context).requestFocus(_focusNodeAprice);}

  List<Widget> indicators(imagesLength,currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 5,
        height: 5,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.green : Color(0xFF97E269),
            shape: BoxShape.circle),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    submitFoodItemBloc = BlocProvider.of<SubmitFoodItemBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    basketBloc = BlocProvider.of<BasketBloc>(context);
    basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));

    // return FutureBuilder(
    //     future: _future,
    //     builder: (context, snapshot){
    //       return Stack(
    //         children: [
    //           if (_isPermissionGranted)
    //
    //             FutureBuilder<List<CameraDescription>>(
    //                 future: availableCameras(),
    //                 builder: (context, snapshot){
    //                   if (snapshot.hasData){
    //                     _initCameraController(snapshot.data!);
    //                     return Center(child: CameraPreview(_cameraController!));
    //
    //                   }else {
    //                     return const LinearProgressIndicator();
    //                   }
    //
    //                 },
    //             ),
    //           // }
    //         ],
    //       );
    //     }
    // );
    return FutureBuilder(

      future: _future,
      builder: (context, snapshot){
        return Scaffold(
          appBar: AppBar(
              title: Text(this.title),
              actions: [
                CartItemsIcon(
                    basketItemsCountNotifier: widget.basketItemsCountNotifier,
                    handleClick: (){
                      navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                    }),
                UserSideMenu(handleClick: handleClick),
              ]
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



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
                  ///////////////////////////////////////////////////////////////////////////////////
                  // if (_isPermissionGranted)
                  //   FutureBuilder<List<CameraDescription>>(
                  //       future: availableCameras(),
                  //       builder: (context, snapshot){
                  //         if (snapshot.hasData){
                  //           _initCameraController(snapshot.data!);
                  //           return
                  //             Container(
                  //                 margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                  //               child: Center(child: CameraPreview(_cameraController!))
                  //             );
                  //             // Center(child: CameraPreview(_cameraController!));
                  //         }else {
                  //           return const LinearProgressIndicator();
                  //         }
                  //       }
                  //   ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   _isPermissionGranted?
//                   // Column(
//                   //     children: [
//                   //       Expanded(
//                   //         child: Container(),
//                   //       ),
//                         Container(
//                             padding: const EdgeInsets.only(bottom: 30.0),
//                             child:  Center(
//                                 child: ElevatedButton(
//                                     onPressed:  _scanImage,
//                                     child: const Text("Scan text")
//                                 )
//                             )
//                         )
//                   //     ]
//                   // )
//                       :Center(
//                     child: Container(
//                       padding: const EdgeInsets.only(left: 24.0, right: 24.0,),
//                       child: const Text('Permission denied',
//                         textAlign: TextAlign.center,),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     padding: EdgeInsets.only(left: 30.0),
//                     child: TextButton(
//                       onPressed: () async {
//                         textresult = await Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) =>  CameraScreen()),
//                         );
//                         inameController!.text='$textresult';
//                        ScaffoldMessenger.of(context)
//                              ..removeCurrentSnackBar()
//                              ..showSnackBar(SnackBar(content: Text('$textresult')));
//                       },
//                       child: const Text('Add product photo', style: TextStyle(fontSize: 17),),
//                     ),
//                   ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  Container(
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsets.only(top: 30.0, bottom: 6.0, left: 20.0, right: 20.0),
                    child:
                    SubmitInputTextField(
                      labelText: 'Food item name',
                      errorText: valid_iname,
                      hintText: 'Scan using camera icon',
                      inputTextController: inameController,
        suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Container(
        margin: const EdgeInsets.only( left: 5.0, right: 5.0),
        child: GestureDetector(
        child:Icon(Icons.camera_alt),

        onTap: () async {

          textresult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CameraScreen()),
          );
          String inputStr = '$textresult';
          final title_lines = inputStr.split('\n');
          inameController!.text= title_lines[0]; //'$textresult';
          inameController!.text.replaceAll("\n", " ");
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('$textresult'))); //replace all newline chars with a space
        }
        ))])
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                    child:
                    SubmitInputTextField(
                        labelText: 'Actual price',
                        errorText: valid_aprice,

                        hintText: 'Enter actual price',
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
                        }
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),

                    child:

                    SubmitInputTextField(
                        labelText: 'Discount price',
                        errorText: valid_dprice,
                        hintText: 'Enter discount price',
                        inputTextController: dpriceController,

                        focusNode: _focusNodeDprice,
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

                                      _focusNodeDprice!.unfocus();
                                      _focusNodeAprice!.requestFocus();

                                      },
                                      child: const Text('Update Actual price'),
                                    ),
                                    TextButton(
                                      onPressed: (){ Navigator.pop(context, 'Update Discounted price');

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


                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                    child:

                    SubmitInputTextField(
                      labelText: 'Submission date',
                      errorText: valid_sdate,
                      hintText: 'Enter the submission date',
                      inputTextController: sdateController,

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
        child:

        SubmitInputTextField(
        labelText: 'Expiraiton date',
        errorText: valid_edate,
        hintText: 'Scan using camera icon',
        inputTextController: edateController,
            suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only( left: 5.0, right: 5.0),
                  child: GestureDetector(
                      child:Icon(Icons.camera_alt),
                      onTap: () async {
                        textresult = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CameraScreen()),
                        );
                        edateController!.text='$textresult';
                        edateController!.text.replaceAll("\n", " ");
                        edateController!.text = await recongnizeDate(edateController!.text!);
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(edateController!.text))); //replace all newline chars with a space

                        // ..showSnackBar(SnackBar(content: Text('$textresult'))); //replace all newline chars with a space
                      }
                  ))]),
            onTap: () async {
        DateTime? picked = (await showDatePicker(
        helpText: "Expiration date",
        context: context,
        initialDate: sdateController!.text == ""? selectedDate:DateTime.parse(sdateController!.text) ,
        firstDate: sdateController!.text == ""?selectedDate:DateTime.parse(sdateController!.text), //DateTime(1900, 8),
        lastDate: DateTime(2101)));
        edateController!.text = (picked == null)?"":"${picked.toLocal()}".split(' ')[0];
        },
        )),

                  // Container(
                  //   margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                  //   child:
                  //
                  //   SubmitInputTextField(
                  //     labelText: 'Expiraiton date',
                  //     errorText: valid_edate,
                  //     inputTextController: edateController,
                  //     suffixIcon: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: <Widget>[
                  //           Container(
                  //             margin: const EdgeInsets.only( left: 5.0, right: 5.0),
                  //             child: GestureDetector(
                  //                 child:Icon(Icons.camera_alt),
                  //                 onTap: () async {
                  //                   ImagePicker picker = ImagePicker();
                  //                   var source = ImageSource.camera;
                  //                   XFile? sdateImage = await picker.pickImage(
                  //                       source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  //                   setState(() async {
                  //                     // Fi_image = File(sdateImage!.path);
                  //                     // scannedText= recongnizeText(sdateImage!) as String;
                  //                     edateController!.text = await recongnizeText(sdateImage!);
                  //                     //edateController!.text = sdateController!.text;
                  //                   });
                  //                   setState(() {});
                  //                 }
                  //               // (){
                  //               // showDialog<String>(
                  //               //   context: context,
                  //               //   builder: (BuildContext context) => AlertDialog(
                  //               //     title: const Text('Invalid price'),
                  //               //     content: const Text('Actual price should be higher than discounted price.'),
                  //               //     actions: <Widget>[
                  //               //       TextButton(
                  //               //         onPressed: ()
                  //               //         {
                  //               //           Navigator.pop(context, 'Update Actual price');
                  //               //         },
                  //               //         child: const Text('Update Actual price'),
                  //               //       ),
                  //               //       TextButton(
                  //               //         onPressed: (){
                  //               //           Navigator.pop(context, 'Update Discounted price');
                  //               //         },
                  //               //         child: const Text('Update Discounted price'),
                  //               //       ),
                  //               //     ],
                  //               //   ),
                  //               // );
                  //               // },
                  //             ),
                  //           ),
                  //           Container(
                  //             margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                  //             child: GestureDetector(
                  //                 child:Icon(Icons.image),
                  //                 onTap: () async {
                  //                   ImagePicker picker = ImagePicker();
                  //                   var source = ImageSource.gallery;
                  //                   XFile? sdateImage = await picker.pickImage(
                  //                       source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  //                   setState(() async {
                  //                     // Fi_image = File(sdateImage!.path);
                  //                     // scannedText= recongnizeText(sdateImage!) as String;
                  //                     edateController!.text = await recongnizeText(sdateImage!);
                  //                     //edateController!.text = sdateController!.text;
                  //                   });
                  //                   setState(() {});
                  //                 }
                  //               // (){
                  //               // showDialog<String>(
                  //               //   context: context,
                  //               //   builder: (BuildContext context) => AlertDialog(
                  //               //     title: const Text('Invalid price'),
                  //               //     content: const Text('Actual price should be higher than discounted price.'),
                  //               //     actions: <Widget>[
                  //               //       TextButton(
                  //               //         onPressed: ()
                  //               //         {
                  //               //           Navigator.pop(context, 'Update Actual price');
                  //               //         },
                  //               //         child: const Text('Update Actual price'),
                  //               //       ),
                  //               //       TextButton(
                  //               //         onPressed: (){
                  //               //           Navigator.pop(context, 'Update Discounted price');
                  //               //         },
                  //               //         child: const Text('Update Discounted price'),
                  //               //       ),
                  //               //     ],
                  //               //   ),
                  //               // );
                  //               // },
                  //             ),
                  //           ),
                  //
                  //         ]
                  //     ),
                  //     onTap: () async {
                  //       DateTime? picked = (await showDatePicker(
                  //           helpText: "Expiration date",
                  //           context: context,
                  //           initialDate: sdateController!.text == ""? selectedDate:DateTime.parse(sdateController!.text) ,
                  //           firstDate: sdateController!.text == ""?selectedDate:DateTime.parse(sdateController!.text), //DateTime(1900, 8),
                  //           lastDate: DateTime(2101)));
                  //       edateController!.text = (picked == null)?"":"${picked.toLocal()}".split(' ')[0];
                  //     },
                  //   ),
                  //
                  // ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30.0),
                    child: TextButton(
                      onPressed: () async {},
                      child: const Text('Add product photo', style: TextStyle(fontSize: 17),),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        tooltip: 'Select from gallery',
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          imageFileList!.clear();
                          final List<XFile>? selectedImages = await
                          imagePicker.pickMultiImage();
                          if (selectedImages!.isNotEmpty) {
                            imageFileList!.addAll(selectedImages);
                          }
                          print("Image List Length:" + imageFileList!.length.toString());
                          setState((){});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        tooltip: 'Select from gallery',
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();
                          var source = ImageSource.camera;
                          image = await picker.pickImage(
                              source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                          setState(() {
                            _image = File(image!.path);
                            recongnizeText(image!);
                          });
                        },
                      ),
                      //for single image upload
                      // IconButton(
                      //   icon: const Icon(Icons.image),
                      //   tooltip: 'Select from gallery',
                      //   onPressed: () async {
                      //     ImagePicker picker = ImagePicker();
                      //     var source = ImageSource.gallery;
                      //     image = await picker.pickImage(
                      //         source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                      //     setState(() {
                      //       _image = File(image!.path);
                      //       recongnizeText(image!);
                      //     });
                      //   },
                      // ),
                    ],
                  ),




                  // Container(
                  //   alignment: Alignment.center,
                  //   child: TextButton(
                  //     onPressed: () async {
                  //       ImagePicker picker = ImagePicker();
                  //       var source = ImageSource.gallery;
                  //       image = await picker.pickImage(
                  //           source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  //        setState(() {
                  //        _image = File(image!.path);
                  //        recongnizeText(image!);
                  //        });
                  //     },
                  //     child: const Text('Upload Image from gallery', style: TextStyle(fontSize: 17),),
                  //   ),
                  // ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: TextButton(
                  //     onPressed: () async {
                  //       ImagePicker picker = ImagePicker();
                  //       var source = ImageSource.camera;
                  //       image = await picker.pickImage(
                  //           source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  //       setState(() async {
                  //         _image = File(image!.path);
                  //         scannedText = await recongnizeText(image!);
                  //       });
                  //     },
                  //     child: const Text('Upload Image from camera', style: TextStyle(fontSize: 17),),
                  //   ),
                  // ),

                  imageFileList==null?Container():
                  Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
                    width: double.infinity,
                    height: 300.0,
                    child: PageView.builder(
                        itemCount: imageFileList!.length,
                        pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            activePage = page;
                          });},
                        itemBuilder: (context,pagePosition){
                          return Container(
                              margin: EdgeInsets.all(10),
                              child: Image.file(File(imageFileList![pagePosition].path),fit: BoxFit.cover,)); //Image.network(images[pagePosition]));
                        }),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicators(imageFileList!.length,activePage)),
                  // imageFileList== null?Container():
                  // Container(
                  //   margin: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
                  //   child: GridView.builder(
                  //       shrinkWrap: true,
                  //       itemCount: imageFileList!.length,
                  //       gridDelegate:
                  //       SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 3),
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return Image.file(File(imageFileList![index].path),
                  //           fit: BoxFit.cover,);
                  //       }),
                  // ),
                  (_image== null || (imageFileList != null && imageFileList!.length>=1) )?Container():
                  Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),

                    child: Image.file(
                      _image,

                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  // _image== null?Container():
                  //     Text(scannedText),

                  SubmitButtonField(
                    buttonText: 'Submit',
                    onPressed: () async {
                      setState(() {

                        valid_iname = validate_iname(inameController!.text);

                        valid_aprice = validate_aprice(apriceController!.text);
                        valid_dprice = validate_dprice(dpriceController!.text,apriceController!.text, dpriceController!.text );
                        valid_sdate = validate_sdate(sdateController!.text);
                        valid_edate = validate_edate(edateController!.text,sdateController!.text,edateController!.text);

                        if (imageFileList!.length == 0) //(_image == null)
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no image was selected')));
                        else {
                          List<String> imageSetList = [];
                          for( var i = 0 ; i < imageFileList!.length; i++ ) {
                            widget.cloudStorage.UploadFile(filePath: imageFileList![i].path, fileName: imageFileList![i].name).then((value) => print('done'));
                            imageSetList.add(imageFileList![i].name);
                          }

                          if (valid_iname == null && valid_aprice == null && valid_dprice == null && valid_sdate == null && valid_edate == null ){
                            submitFoodItemBloc!.add(SubmitButtonPressedEvent(iname: inameController!.text, uname: useraccount.uname, aprice: apriceController!.text, dprice: dpriceController!.text, sdate: sdateController!.text, edate: edateController!.text, useremail: (this.useraccount.email), imagename: imageSetList ));
                          }
                        }
                      });},
                  ),

                  Container(

                  ),

                ],
              ),
            ),
          ),
        );

      }
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

}
