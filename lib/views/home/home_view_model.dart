import 'dart:convert';
import 'dart:io';

import 'package:binance_api_test/core/authentication_client.dart';
import 'package:binance_api_test/core/base/base_view_model.dart';
import 'package:binance_api_test/core/database/tables/formulario_table.dart';
import 'package:binance_api_test/core/database/tables/tarea_table.dart';
import 'package:binance_api_test/core/models/formularios_response.dart';
import 'package:binance_api_test/core/models/tareas_response.dart';
import 'package:binance_api_test/core/models/ticker_24h_response.dart';
import 'package:binance_api_test/core/models/crypto_data_response.dart';
import 'package:binance_api_test/core/services/navigator_service.dart';
import 'package:binance_api_test/views/detalles_crypto/detalles_crypto_view.dart';
import 'package:binance_api_test/widgets/app_dialogs.dart';
import 'package:binance_api_test/widgets/app_qr_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/io.dart';

import '../../core/locator.dart';

class HomeViewModel extends BaseViewModel {
  final authenticationClient = locator<AuthenticationClient>();
  final listController = ScrollController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _navigationService = locator<NavigatorService>();
  FormularioDB formularioDB = FormularioDB();
  TareasDB tareasDB = TareasDB();

  bool _loading = false;
  bool isLogged = false;

  NavigatorService get navigator => _navigationService;

  final logger = Logger();

  List<Ticker24hData> tickets = [];
  List<CryptoData> cryptosList = [];
  List<FormularioData> formulariosList = [];
  List<TareaData> tareasList = [];
  HomeViewModel();

  GlobalKey<ScaffoldState> get drawerKey => _drawerKey;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> onInit(BuildContext context) async {
    loading = true;
    bool hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      authenticationClient.clear();
      notifyListeners();
    }
    await loadFormularios();
    await loadTareas();
    notifyListeners();
    loading = false;
  }

  Future<void> loadTareas() async {
    final tareas = await tareasDB.selectAll();
    tareasList = tareas.data;
    notifyListeners();
  }

  Future<void> loadFormularios() async {
    final formularios = await formularioDB.selectAll();
    formulariosList = formularios.data;
    notifyListeners();
  }

  void showCreateFormDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Nuevo Formulario'),
          content: TextField(
            controller: _nameController,
            decoration:
                const InputDecoration(hintText: 'Nombre del Formulario'),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Crear', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) {
                  // Mostrar un mensaje de error si el nombre está vacío
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'El nombre del formulario no puede estar vacío')),
                  );
                } else {
                  // Insertar el formulario si el nombre no está vacío
                  formularioDB.insert(nombre: _nameController.text.trim());
                  await loadFormularios();
                  print(formulariosList);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showCreateTaskDialog(BuildContext context, String formularioId) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _horaInicioController = TextEditingController();
    final TextEditingController _horaFinController = TextEditingController();
    TimeOfDay? _horaInicio;
    TimeOfDay? _horaFin;

    Future<void> _selectHoraInicio(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _horaInicio ?? TimeOfDay.now(),
      );
      if (picked != null && picked != _horaInicio) {
        _horaInicio = picked;
        _horaInicioController.text = _horaInicio!.format(context);
      }
    }

    Future<void> _selectHoraFin(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _horaFin ?? TimeOfDay.now(),
      );
      if (picked != null && picked != _horaFin) {
        _horaFin = picked;
        _horaFinController.text = _horaFin!.format(context);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Nueva Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration:
                    const InputDecoration(hintText: 'Nombre de la Tarea'),
              ),
              TextField(
                controller: _horaInicioController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Seleccionar Hora de Inicio',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectHoraInicio(context),
                  ),
                ),
              ),
              TextField(
                controller: _horaFinController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Seleccionar Hora de Fin',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectHoraFin(context),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Crear', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                if (_nameController.text.trim().isEmpty ||
                    _horaInicioController.text.trim().isEmpty ||
                    _horaFinController.text.trim().isEmpty) {
                  // Mostrar un mensaje de error si algún campo está vacío
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Todos los campos son obligatorios')),
                  );
                } else if (_horaInicio!.hour > _horaFin!.hour ||
                    (_horaInicio!.hour == _horaFin!.hour &&
                        _horaInicio!.minute > _horaFin!.minute)) {
                  // Mostrar un mensaje de error si la hora de inicio es después de la hora de fin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'La hora de inicio no puede ser después de la hora de fin')),
                  );
                } else {
                  // Insertar la tarea si todos los campos están llenos y las horas son válidas
                  await tareasDB.insert(
                    idFormulario: int.parse(formularioId),
                    nombre: _nameController.text.trim(),
                    horaInicio: _horaInicioController.text.trim(),
                    horaFin: _horaFinController.text.trim(),
                  );
                  await loadTareas();
                  await loadFormularios(); // Recargar los formularios para reflejar la nueva tarea
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showShareOptionsDialog(
      BuildContext context, FormularioData formulario, List<TareaData> tareas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compartir como'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('QR Code'),
                onTap: () {
                  Navigator.of(context).pop();
                  showQrDialog(context, formulario, tareas);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Excel'),
                onTap: () {
                  generateExcel(formulario, tareas);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showQrDialog(
      BuildContext context, FormularioData formulario, List<TareaData> tareas) {
    final qrData = {
      'formulario': formulario.toJson(),
      'tareas': tareas.map((tarea) => tarea.toJson()).toList(),
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Código QR'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: QrImageView(
                data: jsonEncode(qrData),
                version: QrVersions.auto,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteTask(int taskId) async {
    await tareasDB.deleteById(taskId);
    await loadTareas(); // Recargar las tareas para reflejar los cambios
    notifyListeners();
  }

  Future<void> generateExcel(
      FormularioData formulario, List<TareaData> tareas) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Añadir encabezados
    sheetObject.appendRow([
      'ID Formulario',
      'Nombre Formulario',
      'ID Tarea',
      'Nombre Tarea',
      'Hora Inicio',
      'Hora Fin'
    ]);

    // Añadir datos del formulario y tareas
    for (var tarea in tareas) {
      sheetObject.appendRow([
        formulario.id,
        formulario.nombre,
        tarea.id,
        tarea.nombre,
        tarea.horaInicio,
        tarea.horaFin,
      ]);
    }
    bool haveConnection = await checkInternetConnection();
    if (haveConnection) {
// Obtener la ruta de la carpeta de descargas pública
      final directory = await getExternalStorageDirectory();
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }

      // Generar un nombre de archivo único
      String baseFileName = '${formulario.nombre}_tareas';
      String fileName = '$baseFileName.xlsx';
      int fileIndex = 1;
      while (File('${downloadsDirectory.path}/$fileName').existsSync()) {
        fileName = '$baseFileName($fileIndex).xlsx';
        fileIndex++;
      }

      // Guardar el archivo Excel en la carpeta de descargas pública
      final file = File('${downloadsDirectory.path}/$fileName');
      file.writeAsBytesSync(excel.encode()!);

      // Mostrar mensaje de éxito
      Dialogs.success(msg: 'Archivo Excel guardado en la carpeta de descargas');
      await tareasDB.deleteByIdFormulario(int.parse(formulario.id));
      await formularioDB.deleteById(int.parse(formulario.id));
      await loadFormularios();
    } else {
      Dialogs.error(msg: 'Necesita conexión a internet para la exportación');
    }
  }

  void scanQrCode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QRViewExample(
        onQrCodeScanned: (String qrData) {
          Navigator.of(context).pop();
          importFormularioFromQr(context, qrData);
        },
      ),
    ));
  }

  void importFormularioFromQr(BuildContext context, String qrData) {
    final Map<String, dynamic> data = jsonDecode(qrData);
    final formulario = FormularioData.fromJson(data['formulario']);
    final tareas = (data['tareas'] as List)
        .map((tarea) => TareaData.fromJson(tarea))
        .toList();

    final TextEditingController _nameController =
        TextEditingController(text: formulario.nombre);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Importar Formulario'),
          content: TextField(
            controller: _nameController,
            decoration:
                const InputDecoration(hintText: 'Nombre del Formulario'),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Importar', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'El nombre del formulario no puede estar vacío')),
                  );
                } else {
                  // Insertar el formulario y las tareas
                  final newFormularioId = await formularioDB.insert(
                      nombre: _nameController.text.trim());
                  for (var tarea in tareas) {
                    await tareasDB.insert(
                      idFormulario: newFormularioId,
                      nombre: tarea.nombre,
                      horaInicio: tarea.horaInicio,
                      horaFin: tarea.horaFin,
                    );
                  }
                  await loadFormularios();
                  await loadTareas();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
