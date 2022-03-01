import 'dart:async';
import 'dart:convert';
import 'dart:io';
void main(List<String> args) {
  void prueba() async {
    final file = File(args[0]);
    Stream<String> lines = file.openRead()
      .transform(utf8.decoder)      
      .transform(LineSplitter());    
    try {
      var file2 = File('tabla.dat');
      var sink = file2.openWrite();
      bool primeto = true;
      int contador = 0;
      double minimo = 0.0;
      sink.write("#Archivo \t ángulo \t hartree \t kCal/mol \t Energia Rel \n");
      await for (var line in lines) {
        if(primeto){
          sink.write("$line \t ${contador * 15.0} \t");
          primeto = !primeto;
          contador += 1;
        } else {
          if(contador == 1){
            minimo = double.parse(line);
          } 
          sink.write("\t $line \t ${double.parse(line) * 627.503} \t ${(minimo - double.parse(line)) * 627.503} \n");
          primeto = !primeto;
        }
      }
      //Cuando se cierra el archivo esperamos que se escriba y lo utilizamos como template para escribir los otrso archivos
      sink.close();
      print('File is now closed.');
    } catch (e) {
      print('Error: $e');
    }
  }

  prueba();
}
