import 'package:binance_api_test/core/api/autentication_api.dart';
import 'package:binance_api_test/core/api/core/api_status.dart';
import 'package:binance_api_test/core/authentication_client.dart';
import 'package:binance_api_test/core/base/base_view_model.dart' as custom_base;
import 'package:binance_api_test/core/database/tables/formulario_table.dart';
import 'package:binance_api_test/core/locator.dart';
import 'package:binance_api_test/core/models/usuarios_response.dart';
import 'package:binance_api_test/core/services/navigator_service.dart';
import 'package:binance_api_test/views/home/home_view.dart';
import 'package:binance_api_test/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends custom_base.BaseViewModel {
  final _navigationService = locator<NavigatorService>();
  final _autenticationClient = locator<AuthenticationClient>();
  final _authenticationAPI = locator<AuthenticationApi>();
  final GlobalKey<FormState> formKey = GlobalKey();

  bool _loading = false;
  TextEditingController tcEmail = TextEditingController();
  TextEditingController tcPassword = TextEditingController();
  bool obscurePassword = true;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      loading = true;
      var resp = await _authenticationAPI.signIn(
        usuario: tcEmail.text,
        clave: tcPassword.text,
      );
      if (resp is Success<UsuariosData>) {
        _autenticationClient.isLogged = true;
        _autenticationClient.saveUsuario(resp.response);
        notifyListeners();
        loading = false;

        _navigationService.navigateToPageAndRemoveUntil(HomeView.routeName);
      } else if (resp is Failure) {
        loading = false;
        notifyListeners();
        Dialogs.error(
          msg: resp.message,
        );
      }
    }
  }

  void changeObscure() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  /*  void goToRecoveryPassword() {
    _navigationService.navigateToPage(RecoveryPasswordView.routeName);
  } */

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
