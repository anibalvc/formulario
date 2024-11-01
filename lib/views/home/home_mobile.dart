part of 'home_view.dart';

class _HomeMobile extends StatelessWidget {
  final HomeViewModel vm;

  const _HomeMobile(this.vm);

  @override
  Widget build(BuildContext context) {
    return MyTapToHideKeyboard(
      child: ProgressWidget(
        inAsyncCall: vm.loading,
        opacity: false,
        child: Scaffold(
          key: vm.drawerKey,
          drawer: GlobalDrawerDartDesktop(
            notify: () {
              vm.notifyListeners();
            },
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                vm.drawerKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu, color: AppColors.blue),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: AppColors.blue),
                onPressed: () {
                  vm.scanQrCode(context);
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              vm.showCreateFormDialog(context);
            },
            child: const Icon(Icons.add),
            backgroundColor: AppColors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vm.authenticationClient.isLogged
                    ? Text(
                        "Bienvenido al registro de tareas ${vm.authenticationClient.loadUsuario.nombrePerfil}",
                        maxLines: 2,
                        style: AppTextStyle.h1White,
                      )
                    : const Text(
                        "Bienvenido al registro de tareas",
                        style: AppTextStyle.h1White,
                      ),
                if (!vm.authenticationClient.isLogged)
                  ElevatedButton(
                    onPressed: () {
                      vm.navigator.navigateToPage("login");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.formulariosList.length,
                    itemBuilder: (context, index) {
                      final formulario = vm.formulariosList[index];
                      return ExpansionTile(
                        collapsedIconColor: AppColors.blue,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              formulario.nombre,
                              style: const TextStyle(
                                color: AppColors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: const Icon(Icons.share,
                                  color: AppColors.blue),
                              onPressed: () => vm.showShareOptionsDialog(
                                  context,
                                  formulario,
                                  vm.tareasList
                                      .where((tarea) =>
                                          tarea.idFormulario == formulario.id)
                                      .toList()),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.add, color: AppColors.blue),
                              onPressed: () {
                                vm.showCreateTaskDialog(context, formulario.id);
                              },
                            ),
                          ],
                        ),
                        iconColor: AppColors.blue,
                        children: <Widget>[
                          ...vm.tareasList
                              .where((tarea) =>
                                  tarea.idFormulario == formulario.id)
                              .map((tarea) => ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          tarea.nombre,
                                          style: const TextStyle(
                                            color: AppColors.blue,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => vm
                                              .deleteTask(int.parse(tarea.id)),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'Inicio: ${tarea.horaInicio} - Fin: ${tarea.horaFin}',
                                      style: const TextStyle(
                                        color: AppColors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
