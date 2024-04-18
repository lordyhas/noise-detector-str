
import 'package:flutter/material.dart';

class NoNetWorkPage extends StatelessWidget {

  const NoNetWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Column(
              children: [
                Icon(Icons.wifi_off, size: 75,),
                Text("Pas de connection internet"),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}