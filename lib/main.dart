import 'package:flutter/material.dart';
import 'package:needtalk/landing_page.dart';
import 'package:needtalk/locator.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // bu olmaazsa bütün sistem çöker
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.teal,
            primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white))),
        home: LandingPage(),
      ),
      create: (BuildContext context) => UserModel(),
      // Uyguluma açıldığında ilk bu sayfa açılacaktır.
    );
  }
}
