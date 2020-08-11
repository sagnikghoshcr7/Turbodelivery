import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/delivery_listview_model.dart';
import 'pages/delivery_traker_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (context) => DeliveryStateListViewModel(),
        child:
        DeliveryTrackerPage(),
      )
    );
  }
}



