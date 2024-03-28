import 'dart:math';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:noise_detector_str/model/NoiseModel.dart';
import 'package:utils_component/utils_component.dart';

import '../../controller/mobile_controller/realtime_db_controller.dart';
import '../background_font.dart';
import 'datatable_view.dart';




const double kMinDimens = 520.0;
const double kTabDimens = 720.0;
const double kDeskDimens = 1028.0;
const kPhoneDimens = 620.0;
const kPhoneXDimens = 720.0;
const double kMediumDimens = 720.0;
const double kMedium2Dimens = 1028.0;


class WebDashboard extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const WebDashboard(),
      );

  const WebDashboard({Key? key}) : super(key: key);

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  TextStyle get numStyle =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  TextStyle get textStyle => const TextStyle(color: Colors.white70);

  bool underline = false;

  RealtimeDataController realtimeData = RealtimeDataController();

  @override
  Widget build(BuildContext context) {
    double boxWidth = 100.0;
    double boxHeight = 60.0;
    final ScrollController scrollController = ScrollController();

    return BackgroundUI(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //backgroundColor: AppColor.homePageBackground,
        appBar: AppBar(title: const Text('Admin Dashboard'),),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(maxWidth: 1280),
            child: FirebaseAnimatedList(
              key: const ValueKey<bool>(false),
              query: realtimeData.messagesRef,
              reverse: false,
              controller: null,
              itemBuilder: (context, snapshot, animation, index) {
                /*final map = Map<String, String>.from(snapshot.value.map((key, value) {
                  return MapEntry(key, value.toString());
                }));*/
                if(snapshot.value is Map){
                  Map<String, dynamic> linkedMap = Map<String, dynamic>.from(snapshot.value as Map);

                  Map<String, dynamic> map = <String, dynamic>{};

                  print("########### Type : ${map.runtimeType}");
                  print(map);

                  linkedMap.forEach((key, value) {
                    map[key] = value;
                  });
                  //var noise = NoiseModel.fromMap(map);
                  return SizeTransition(
                    sizeFactor: animation,
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {}, //=> _deleteMessage(snapshot),
                        icon: const Icon(Icons.delete),
                      ),
                      title: Text('$index: ${snapshot.value}'),
                      subtitle: const Text(""),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());

              },
            ),
          ),
        ),


        /*Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                constraints: const BoxConstraints(maxWidth: 1280),
                //const BoxConstraints(maxWidth: kMediumDimens),
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  children: [
                    //const SizedBox(height: 32.0,),
                    //const H1("MySpace"),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      constraints: const BoxConstraints(
                        maxWidth: kPhoneDimens,
                      ),
                      height: Responsive.of(context).isPhone ? null : 320,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                        //boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight)],
                      ),
                      child: Column(
                        children: [
                          BooleanBuilder(
                            condition: () => false,
                            //state.status == AuthenticationStatus.authenticated,
                            ifTrue: const SizedBox.shrink(),
                            /*ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  "${state.user.photoMail}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text("${state.user.name}"),
                              subtitle: Text("${state.user.email}"),
                            ),*/
                            ifFalse: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  "assets/avatar/avatar_3.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: const Text("Unknown Name"),
                              subtitle: const Text("guest-user@mail.com"),
                            ),
                          ),
                          const SizedBox(
                            height: 32.0,
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  height: 75,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                    /*image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/img/bg_image_web.jpeg"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.grey, BlendMode.color)),*/
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "À verifier",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white70),
                                      ),
                                      Text("18",
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  height: 75,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child:  const Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Déjà ajouté",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white70),
                                      ),
                                      Text(
                                        "4",
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                hoverColor: Colors.cyan,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  height: 75,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child:  const Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Femmmes",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                hoverColor: Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  //Navigator.of(context).push(DataTableDemo.route());
                                  Navigator.of(context).push(DatatableView.route());
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  height: 75,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child:  const Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Docteurs",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //const SizedBox(height: 16.0,),
                    Container(
                      //constraints: const BoxConstraints(maxHeight: 200),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      constraints: const BoxConstraints(maxWidth: kPhoneDimens),
                      height: Responsive.of(context).isPhone ? 400 : 320,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        /*image: const DecorationImage(
                            image: AssetImage("assets/img/bg_material_2.jpg"),
                            fit: BoxFit.cover),*/
                        borderRadius: BorderRadius.circular(20),
                        //boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight)],
                      ),

                      child: SizedBox(
                        child: Column(
                          children: [
                             Row(),
                            const Spacer(),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  constraints: const BoxConstraints(
                                    maxWidth: 150,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: boxWidth,
                                    height: boxHeight,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Vue",
                                          style: textStyle,
                                        ),
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "4",
                                              style: numStyle,
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  constraints: const BoxConstraints(
                                    maxWidth: 150,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: boxWidth,
                                    height: boxHeight,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Check",
                                          style: textStyle,
                                        ),
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "496",
                                              style: numStyle,
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  constraints: const BoxConstraints(
                                    maxWidth: 150,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: boxWidth,
                                    height: boxHeight,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Deprtmnt",
                                          style: textStyle,
                                        ),
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Lab", style: numStyle),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  constraints:
                                      const BoxConstraints(maxWidth: 150),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: boxWidth,
                                    height: boxHeight,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Niveau",
                                          style: textStyle,
                                        ),
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(text: "3", style: numStyle),
                                            const TextSpan(
                                              text: "LVL",
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  constraints:
                                      const BoxConstraints(maxWidth: 150),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: boxWidth,
                                    height: boxHeight,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Frais",
                                          style: textStyle,
                                        ),
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(text: "4", style: numStyle),
                                            const TextSpan(
                                              text: "\$",
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  constraints:
                                      const BoxConstraints(maxWidth: 150),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: boxWidth,
                                    height: boxHeight,
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Gain",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text.rich(TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "1250",
                                              style: numStyle,
                                            ),
                                            const TextSpan(
                                              text: "\$",
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            //const Spacer(),
                            //const ListTile(),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      //constraints: const BoxConstraints(maxHeight: 200),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      constraints: Responsive.of(context).size.width > 1363
                          ? null
                          : const BoxConstraints(maxWidth: kPhoneDimens),
                      //height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                        //boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight)],
                      ),

                      child: SizedBox(

                        child: Column(
                          children: [
                            //const SizedBox(height: 1, child: Expanded(child: SizedBox(width: 10,),),),
                            const ListTile(
                              title: Text(
                                "Tab",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            /*Flexible(
                              child: FirebaseAnimatedList(
                                key: const ValueKey<bool>(false),
                                query: realtimeData.messagesRef,
                                reverse: false,
                                itemBuilder: (context, snapshot, animation, index) {
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    child: ListTile(
                                      trailing: IconButton(
                                        onPressed: () {}, //=> _deleteMessage(snapshot),
                                        icon: const Icon(Icons.delete),
                                      ),
                                      title: Text('$index: ${snapshot.value}'),
                                    ),
                                  );
                                },
                              ),
                            ),*/
                            /*Wrap(
                              runAlignment: WrapAlignment.start,
                              alignment: WrapAlignment.start,
                              runSpacing: 8.0,
                              children: placeholderList,
                            ),*/
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),*/
      ),
    );
  }

  var placeholderList = List<Widget>.generate(
      15,
      (index) => SizedBox(
            width: 400,
            height: 150,
            child: ListTile(
              //leading: Icon(Icons.ac_unit),
              title: const Placeholder(),
              onTap: () {},
            ),
          ));
}
