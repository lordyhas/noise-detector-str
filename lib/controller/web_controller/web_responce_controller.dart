

import 'package:firebase_database/firebase_database.dart';

class ResponseController {
  static const String refName = "detect_data";

  late final DatabaseReference _responseRef;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  ResponseController(): _responseRef = FirebaseDatabase.instance.ref("").child("response") ;
}