import 'dart:convert';

FormulariosResponse formulariosResponseFromJson(String str) =>
    FormulariosResponse.fromList(json.decode(str));

String formulariosResponseToJson(FormulariosResponse data) =>
    json.encode(data.toJson());

class FormulariosResponse {
  FormulariosResponse({
    required this.data,
  });

  List<FormularioData> data;

  factory FormulariosResponse.fromList(List<dynamic> list) =>
      FormulariosResponse(
        data: list
            .map<FormularioData>((e) => FormularioData.fromJson(e))
            .toList(),
      );

  factory FormulariosResponse.fromJson(Map<String, dynamic> json) =>
      FormulariosResponse(
        data: json["data"]
            .map<FormularioData>((e) => FormularioData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()).toList(),
      };
}

class FormularioData {
  FormularioData({
    required this.id,
    required this.nombre,
  });

  String id;
  String nombre;

  factory FormularioData.fromJson(Map<String, dynamic> json) => FormularioData(
      id: json.values.first.toString(), nombre: json.values.last);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
