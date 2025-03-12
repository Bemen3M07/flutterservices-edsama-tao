import 'dart:convert';

// Funció per obtenir una llista d'objectes de tipus CarsModel a partir d'un string json
List<CarsModel> carsModelFromJson(String str) => List<CarsModel>.from(
    json.decode(str).map((x) => CarsModel.fromMapToCarObject(x)));

//Funció per obtenir un string json a partir d'una llista d'objectes de tipus CarsModel
String carsModelToJson(List<CarsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.fromObjectToMap())));

class CarsModel {
  CarsModel({
    required this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.type,
  });

  final int id;
  final int year;
  final String make;
  final String model;
  final String type;

  /* 
    Constructor d'objectes a partir de mapes d'objectes
    Rep com a paràmetre un Map<String, dynamic> 
    Aquest mapa són els objectes qeu genera el json decoder
    dynamic vol dir que pot ser de qualsevol tipus
    El mètode fromMapToCarObject retorna un objecte de tipus CarsModel

  */
  factory CarsModel.fromMapToCarObject(Map<String, dynamic> json) => CarsModel(
        id: json["id"],
        year: json["year"],
        make: json["make"],
        model: json["model"],
        type: json["type"],
      );

  // Mètode per convertir un objecte de tipus CarsModel a un mapa d'objectes
  Map<String, dynamic> fromObjectToMap() => {
        "id": id,
        "year": year,
        "make": make,
        "model": model,
        "type": type,
      };
}
