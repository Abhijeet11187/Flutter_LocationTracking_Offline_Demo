import 'dart:convert';
import 'dart:io';
import 'package:geolocation2/savingdata.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

// import 'package:geolocation/channel/location_channel.dart';
import 'dart:async';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Geolocation Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//  @override
//  initState(){
//    super.initState();
//    trackLocation=false;
//    location=[];
//  }
@override
initState() {
  super.initState();

Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    print("Connectivity Result is $result");
  });
}

// Dispose Method to cancel the subscription
@override
dispose() {
  super.dispose();

  // subscription.cancel();
}

List<LocationResult>location=[];
StreamSubscription<LocationResult> streamSubscription;
bool trackLocation=false;
void resumeTracking(){
  // print("while Resuming Location Array ");
  //  print(location);
  setState(() {
    streamSubscription.resume();
  });
}

//Checking Mobile Connectivity

void checkMobileDataStatus()async{
var connectivityResult = await (Connectivity().checkConnectivity());

if (connectivityResult == ConnectivityResult.mobile) {
  print("Mobile Data is On ");
} else if (connectivityResult == ConnectivityResult.wifi) {
 print("Wifi data is on");
 
}else{
  print("Mobile Data is Off ");
}

}
 
void deleteFile(){
  print("In the function");
// savingdata().deleteFile();
    var res=location.toList();
    print(res.map((e) => print(e.location.latitude)).toList());
    
} 

void creatingObject()async{


//--------------------File Writing Logic starts-----------------------------------------

await savingdata().writeCounter(location);

//_________________________File Writing logic Ends _________________________________________


  

  //----------------------Share Prefence Data Storing------------------------------------

  // var locationResult=location;
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  // prefs.setString("locationData",locationResult.toString());
  // print("Data is stored to the shared preference");

//_________________________ Share Preference Ends _____________________________________________

  // print(locationResult);
  // print(location);
  // print("Mapping...");
  // locationResult.map((e) => {
  //   print(e),
  // });
  // location.forEach((element) { 
  //   print(element);
  // });
  // var list=locationResult.values.toList();
  // print(location);
  // print("Mapped values");
  // for (var key in locationResult){
  //   print("Key is $key");
  // }
  // locationResult.forEach((element) {print(element);});
  // var locationData={
  //   "name":"Location Traced",
  //    "locationArray":locationResult,
  // };
  // print("LocationData Array is ");
  // print(locationData);
}
 void desubscribe(){
  //  print("While Pausing Location Array ");
  //  print(location);
   setState(() {
     streamSubscription.pause();
      // trackLocation=false;
        //  streamSubscription.cancel();
        //  streamSubscription=null;
        //  location=[];
   });
 }

 retreiveData()async{

//--------------------File reading Logic starts-----------------------------------------

// await writeCounter(23444);
// readCounter();
savingdata().readCounter();

//_________________________File Reading logic Ends __________________________________________



//---------------------- SharedPreference DataRetreive logic starts ----------------------------

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var data=prefs.getString("locationData");
  
  // print("Data Retreived from shredpreference");
  // print(data);

//____________________________Sharepreference DataRetreive logic ends_______________________________

 }        
void getGPS() async{
  
     if(trackLocation){
       setState(() {
         trackLocation=false;
        //  streamSubscription.cancel();
         streamSubscription=null;
         location=[];
       });
     }else{
       setState(() {
         trackLocation=true;
                  location=[];

       });
     }
     streamSubscription=Geolocation.locationUpdates(
       accuracy:LocationAccuracy.best,
       displacementFilter: 0.0,
       inBackground: true).listen((event) { 
         final result=event;
        //  List<String> res=result.toStr ing();
         print(result.location);
         setState(() {
          //  print(result.locations);
           location.add(result);
         });
       });
        streamSubscription.onDone(() { 
          setState(() {
            trackLocation=false;
          });
        });
}

//   void _incrementCounter() async{

     
//   final GeolocationResult result = await Geolocation.requestLocationPermission(
//     LocationPermission permission= const LocationPermission(
//     android: LocationPermissionAndroid.fine,
//     ios: LocationPermissionIOS.always,
//   ),
//   openSettingsIfDenied: true,
// );
//   print(result.dataToString());
// if(result.isSuccessful) {
// print("Success");} else {
//   print("Fail");
// }
    

//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.stop), onPressed: desubscribe),
              IconButton(icon: Icon(Icons.restore),onPressed: creatingObject),
              IconButton(icon: Icon(Icons.search), onPressed: retreiveData),
              IconButton(icon: Icon(Icons.delete_forever), onPressed: deleteFile)
            ],
          ),
        ],
      ),
      body: Center(
       
        child: Container(
        child: ListView(
          children:location.map((e) => ListTile(
title: Text(
  "You are here : LAT ${e.location.latitude} : LANG ${e.location.longitude}"
),subtitle: Text("Altitude is ${e.location.altitude}"),
          )).toList(),
        ),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: getGPS,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
