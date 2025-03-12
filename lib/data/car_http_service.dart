import '../model/car_model.dart';
import 'package:http/http.dart' as http;

// import 'package:rentcar/model/brand_model.dart';
// import 'package:rentcar/model/car_model.dart';
// import 'package:rentcar/utils/const_app.dart';

class CarHttpService {
  final String _serverUrl = "https://car-data.p.rapidapi.com";
  final String _headerKey =
      "7c00063cc0mshd06eb3f7234b024p167924jsn67c78b190f6a";
  final String _headerHost = "car-data.p.rapidapi.com";

  /*
  Obtenir la llista de cotxes
  */
  Future<List<CarsModel>> getCars() async {
    //URL de l'endpoint: És la URL del servidor, més la URL de l'endpoint
    var uri = Uri.parse(
        "$_serverUrl/cars"); //Aquí hem de canviar el text de l'exmple per /cars

    //Fem la petició GET i esperem la resposta
    var response = await http.get(uri, headers: {
      "x-rapidapi-key": _headerKey, //Aquesta informació està a la "
      "x-rapidapi-host":
          _headerHost //Aquí hem de canviar el text de l'exmple per "x-rapidapi-host"
    });

    //Control d'errors. Si la resposta és 200, tot ha anat bé.  Si nó, llancem un error
    if (response.statusCode == 200) {
      return carsModelFromJson(response.body);
    } else {
      throw ("Error al obtenir la llista de cotxes: ${response.statusCode}");
    }
  }

  // Future<List<String>> getBrand() async {
  //   var uri = Uri.parse(_serverUrl + endPointBrands);
  //   var response = await http.get(uri ,
  //       headers: {
  //         headerKey: _headerKey,
  //         headerHost : _headerHost
  //       });

  //   if(response.statusCode == 200){
  //     return brandModelFromJson(response.body);
  //   }else{
  //     throw(messageErrorBrandApi);
  //   }
  // }
}
