import 'package:flutter/material.dart';
import 'package:noise_detector_str/view/web_app_ui/dashboard.dart';

class WebUIApp extends StatelessWidget {
  const WebUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'noise detector web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WebDashboard(),
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

