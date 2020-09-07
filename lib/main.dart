import 'package:bands_app/src/pages/home_page.dart';
import 'package:bands_app/src/pages/status_pages.dart';
import 'package:bands_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SocketService(),)
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/status': (context) => StatusPage()
      },
    ),
  ));
}
