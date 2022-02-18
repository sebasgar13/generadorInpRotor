import 'dart:async';
import 'dart:convert';
import 'dart:io';
void main(List<String> args){
  print(args);
  void prueba() async {
    final file = File(args[0]);
    Stream<String> lines = file.openRead()
      .transform(utf8.decoder)      
      .transform(LineSplitter());    
    try {
      var file2 = File('template.inp');
      var sink = file2.openWrite();
      int primeto = 1;
      await for (var line in lines) {
        if(line.length > 3 && ((line[0]+line[1]+line[2]+line[3]) == args[1] || (line[0]+line[1]+line[2]+line[3]) == args[2] || (line[0]+line[1]+line[2]+line[3]+line[4]) == args[3])){
          print("Encontrado");
        } else if(primeto == 1) {
          sink.write(line);
          primeto += 1;
        } else {
          sink.write("\n$line");
        }
      }
      //Cuando se cierra el archivo esperamos que se escriba y lo utilizamos como template para escribir los otrso archivos
      sink.close().then((value) => {
        File('template.inp').readAsString().then((String contents) {
          print(contents);
          for(int i = 0; i < 13 ; i++){
            var file2 = File('file-${i*30}.inp');
            var sink = file2.openWrite();
            sink.write('%chk=singleDAScanp-${i*30}.chk \n');
            sink.write(contents);
            sink.write('\n${args[2]}\t\t ${-240.0 + (i * 30)} \n');
            sink.write('${args[3]}\t\t ${-120.0 + (i * 30)} \n \n');
            sink.write('${args[1]}\t\t ${0.0 + (i * 30)} \n \n');
            sink.close();
          }
        })
      });
      print('File is now closed.');
    } catch (e) {
      print('Error: $e');
    }
  }

  prueba();
}
