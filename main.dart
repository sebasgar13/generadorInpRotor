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
      String anguloFijo="", segundo="", tercero="", incremento="30";
      int primeto = 1;
      int longitud = args.length;
      //Encontramos los parametros de los ámgulos diedros en las entradas
      for(int i = 0; i < longitud; i++){
        String opcion = args[i];
        int finalQ = opcion.length; 
        if((opcion[0] + opcion[1]) == "ap" ){
          anguloFijo = opcion[3];
          for(int j = 4; j < finalQ; j++ ){
            anguloFijo = anguloFijo + opcion[j];
          }
        } else if((opcion[0] + opcion[1]) == "as"){
          segundo = opcion[3];
          for(int j = 4; j < finalQ; j++ ){
            segundo = segundo + opcion[j];
          }
        } else if((opcion[0] + opcion[1]) == "at"){
          tercero = opcion[3];
          for(int j = 4; j < finalQ; j++ ){
            tercero = tercero + opcion[j];
          }
        } else if((opcion[0] + opcion[1]) == "in"){
          incremento="";
          for(int j = 3; j < finalQ; j++ ){
            incremento = incremento + opcion[j];
          }
        }
      }
      //Leemos el template
      await for (var line in lines) {
        if(line.length > 9){
          if((line[0]+line[1]) == 'di'){
            String obtenerCaracter = "p", etiquetaAngulo= "";
            int contadorCadena = 0;
            while(obtenerCaracter != " "){
              etiquetaAngulo = etiquetaAngulo + line[contadorCadena];
              obtenerCaracter = line[contadorCadena+1];
              contadorCadena++;
            }
            if(etiquetaAngulo == anguloFijo || etiquetaAngulo == segundo || etiquetaAngulo == tercero){
              contadorCadena=0;
            } else {
              sink.write("\n$line");
            }
          } else {
            sink.write("\n$line");
          }
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
          //print(contents);
          for(int i = 0; i <= 360 ; i+=int.parse(incremento)){
            var file2;
            if(i<10){
              file2 = File('file-00${i}.inp');
            } else if(10 <= i && i < 100){
              file2 = File('file-0${i}.inp');
            } else {
              file2 = File('file-${i}.inp');
            }
            var sink = file2.openWrite();
            sink.write('%chk=singleDAScanp-${i}.chk \n');
            sink.write(contents);
            sink.write('\n${segundo}\t\t ${-120.0 + i} \n');
            sink.write('${tercero}\t\t ${-240.0 + i} \n\n');
            sink.write('${anguloFijo}\t\t ${0.0 + i} \n \n \n');
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
