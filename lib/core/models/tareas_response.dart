import 'dart:convert';

TareasResponse tareasResponseFromJson(String str) =>
    TareasResponse.fromList(json.decode(str));

String tareasResponseToJson(TareasResponse data) => json.encode(data.toJson());

class TareasResponse {
  TareasResponse({
    required this.data,
  });

  List<TareaData> data;

  factory TareasResponse.fromList(List<dynamic> list) => TareasResponse(
        data: list.map<TareaData>((e) => TareaData.fromJson(e)).toList(),
      );

  factory TareasResponse.fromJson(Map<String, dynamic> json) => TareasResponse(
        data: List<Map<String, dynamic>>.from(json["data"])
            .map<TareaData>((e) => TareaData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()).toList(),
      };
}

class TareaData {
  TareaData({
    required this.id,
    required this.idFormulario,
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
  });

  String id;
  String idFormulario;
  String nombre;
  String horaInicio;
  String horaFin;

  factory TareaData.fromJson(Map<String, dynamic> json) => TareaData(
        id: json["id"].toString(),
        idFormulario: json["idFormulario"].toString(),
        nombre: json["nombre"],
        horaInicio: json["horaInicio"],
        horaFin: json["horaFin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idFormulario": idFormulario,
        "nombre": nombre,
        "horaInicio": horaInicio,
        "horaFin": horaFin,
      };
}
