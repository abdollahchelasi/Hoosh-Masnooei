import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:tflite/tflite.dart';



class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isWorking = false;
  String result="";
  CameraController cameraController;
  CameraImage imgCamera;

  loadModel() async{
    await Tflite.loadModel(
      model: 'assets/mobilenet_v1_1.0_224.tflite',
      labels: 'assets/mobilenet_v1_1.0_224.txt',
    );
}

  initCamera()
  {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value)
    {
      if(!mounted)
        {
          return;
        }
      setState(() {
        cameraController.startImageStream((imageFromStream) =>
        {
            if(!isWorking)
              {
                isWorking = true,
                imgCamera= imageFromStream,
                 runModel(),
              }
        });
      });
    }
    );
  }
  runModel() async{
    if(imgCamera != null){
      var recognit = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((e) {
          return e.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,


      );
      result = "" ;
      recognit.forEach((response)
      {
        result += response['label']+ '    ' + (response['confidence'] as double).toStringAsFixed(2) + '\n\n';
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }
  @override
  void dispose() async{
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.grey[900],
          leading: Container(
              margin: EdgeInsets.symmetric(vertical: 11,horizontal: 11),
            child: Image.asset('assets/icon.png'),
              ),
          actions: [
            GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      actions: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text('طراح و برنامه نویس :',style: TextStyle(color: Colors.grey,fontFamily: ArabicFonts.Lalezar,package: 'google_fonts_arabic')),
                              Text('عبدالله چلاسی',style: TextStyle(color: Colors.grey[900],fontFamily: ArabicFonts.Lalezar,package: 'google_fonts_arabic')),

                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
              },
              child: Container(
                  margin: EdgeInsets.only(right: 11),
                  child: Icon(Icons.account_box_outlined,color: Colors.white,size: 30,)),
            ),
          ],
          centerTitle: true,
          title: Text('هوش قشمی',style: TextStyle(color: Colors.grey,fontFamily: ArabicFonts.Lalezar,package: 'google_fonts_arabic'),),
        ),
        body:  Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/jarvis.jpg'),fit: BoxFit.fill)
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 320,
                        height: 320,
                        child: Image.asset('assets/camera.jpg'),
                      ),
                    ),
                    Center(
                      child: FlatButton(onPressed: (){
                        initCamera();
                      }, child: Container(
                        margin: EdgeInsets.only(top: 30),
                        height: 270,
                        width: 360,
                        child: imgCamera == null
                            ? Container(
                          height: 270,
                          width: 340,

                         child: Icon(Icons.photo_camera_front,color: Colors.white,size: 50,)
                        )
                            : AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        ),
                      )),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 55),
                    child: SingleChildScrollView(
                      child: Text(
                          result,
                        style: TextStyle(backgroundColor: Colors.black87,
                        fontSize: 30,color: Colors.white,
                        ),textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

      )),
    );
  }
}
