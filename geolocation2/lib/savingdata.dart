import 'dart:io';
import 'package:path_provider/path_provider.dart';

class savingdata{

//--------------- Getting local Path

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

//---------------- Creating File

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/loction.txt');
}

//-----------------Writing to the File

Future<File> writeCounter(counter) async {
  final file = await _localFile;
     print("Data is saved at location $file");
  return file.writeAsString('$counter',mode:FileMode.append);
}


//------------------Reading the File

Future readCounter() async {
  print("Reading file data..");
  try {
    final file = await _localFile;
    // Read the file.
    String contents = await file.readAsString();
      print("Contents are $contents");
    return contents;
  } catch (e) {
      print(e);
    return 0;
  }
}

//--------------------Delete the File

Future deleteFile() async{
  try{
    final file =await _localFile;
    var deletstatus=file.delete();
    print("Delete status $deletstatus");
  }catch(e){
    print("Error Occurs $e");
    return 0;
  }
}

}