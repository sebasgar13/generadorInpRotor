import 'dart:async';
import 'dart:convert';
import 'dart:io';
void main(){
  //num ocho = 8;
  void prueba() async {
    final file = File('file.txt');
    Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
    try {
      await for (var line in lines) {
        for(int i = 0; i <10; i++){
          print('$line: ${line.length} characters');
          var file2 = File('file-${i*3}.txt');
          var sink = file2.openWrite();
          sink.write('$line: ${line.length} characters');
          sink.write('FILE ACCESSED 2 ${DateTime.now()}\n');
          // Close the IOSink to free system resources.
          sink.close();
        }
      }
      print('File is now closed.');
    } catch (e) {
      print('Error: $e');
    }
  }

  prueba();
  File('file.txt').readAsString().then((String contents) {
    print(contents.length);
  });
  String encabezado = "Es una linea";
  print(encabezado[3]+encabezado[4]);
  for(int i =0; i < 10; i++){
    print(" pala \t $i");
  }
}