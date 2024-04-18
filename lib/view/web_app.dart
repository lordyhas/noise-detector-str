import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_detector_str/view/web_app_ui/dashboard.dart';

import '../controller/network_controller_cubit.dart';
import '../no_network_page.dart';

class WebUIApp extends StatelessWidget {
  const WebUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkControllerCubit(Connectivity()),
      child: MaterialApp(
        title: 'noise detector web',
        theme: ThemeData(
          brightness: Brightness.dark,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<NetworkControllerCubit, NetworkState>(
          builder: (context, state) {
            if (state is NetworkConnected ) {
              return const WebDashboard();
            }
            else {
              return const NoNetWorkPage();
            }
          },
        )

        //const WebDashboard(),
      ),
    );
  }
}

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

