import 'package:binance_api_test/core/base/base_view_model.dart';
import 'package:binance_api_test/core/database/tables/formulario_table.dart';
import 'package:binance_api_test/core/locator.dart';
import 'package:binance_api_test/core/models/usuarios_response.dart';
import 'package:binance_api_test/core/services/navigator_service.dart';
import 'package:binance_api_test/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';

class CreateAccountViewModel extends BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final GlobalKey<FormState> formKey = GlobalKey();
  /* final usuarioDB = UsuarioDB(); */

  bool _loading = false;
  TextEditingController tcNombreUsuario = TextEditingController();
  TextEditingController tcNombrePerfil = TextEditingController();
  TextEditingController tcCorreo = TextEditingController();
  TextEditingController tcPassword = TextEditingController();
  TextEditingController tcPassword2 = TextEditingController();
  bool obscurePassword = true;
  bool obscurePassword2 = true;
  bool checked = false;
  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void checkTerminos() {
    checked = !checked;
    notifyListeners();
  }

  void changeObscure() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void changeObscure2() {
    obscurePassword2 = !obscurePassword2;
    notifyListeners();
  }

  /*  void goToRecoveryPassword() {
    _navigationService.navigateToPage(RecoveryPasswordView.routeName);
  } */

  @override
  void dispose() {
    tcCorreo.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
