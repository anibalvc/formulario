library home_view;

import 'package:binance_api_test/theme/theme.dart';
import 'package:binance_api_test/widgets/app_line_chart.dart';
import 'package:binance_api_test/widgets/progress_widget.dart';
import 'package:binance_api_test/widgets/tap_to_hide_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/global_drawer_widget.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

class HomeView extends StatelessWidget {
  static const routeName = 'home';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    /*  var menu = Provider.of<MenuProvider>(context, listen: false).menu; */
    HomeViewModel viewModel = HomeViewModel();
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        onViewModelReady: (viewModel) => viewModel.onInit(context),
        builder: (context, viewModel, child) {
          return _HomeMobile(viewModel);
        });
  }
}
