import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:noise_detector_str/view/web_app.dart';
import 'package:utils_component/utils_component.dart';


import 'firebase_options.dart';
import 'view/mobile_app.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {

    return BooleanBuilder(
        condition: () => kIsWeb,
        ifTrue: const WebUIApp() ,
        ifFalse: const MobileUIApp()
    );
  }
}






