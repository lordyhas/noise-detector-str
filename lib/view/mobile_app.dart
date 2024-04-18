import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_detector_str/controller/mobile_controller/permission_check.dart';
import 'package:noise_detector_str/controller/network_controller_cubit.dart';
import 'package:noise_detector_str/no_network_page.dart';

import 'mobile_app_ui/mobile_home_page.dart';



class MobileUIApp extends StatelessWidget {
  const MobileUIApp({super.key});

  // This widget is the root of the mobile application.
  @override
  Widget build(BuildContext context) {
    PermissionCheck.requestPermission();
    return BlocProvider(
      create: (context) => NetworkControllerCubit(Connectivity()),
      child: MaterialApp(
        title: 'noise detector mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<NetworkControllerCubit, NetworkState>(
          builder: (context, state) {
            if (state is NetworkConnected ) {
              return const MobileHomePage();
            } else {
              return const NoNetWorkPage();
            }
          },
        )
      ),
    );
  }
}

