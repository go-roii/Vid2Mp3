import 'package:flutter/material.dart';
import 'package:vid2mp3/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const primarySwatchColor = Colors.blueGrey;

  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primarySwatchColor,
        primaryColor: primarySwatchColor,
        fontFamily: 'Rubik',
        // visualDensity: VisualDensity.standard, // same size for all platform
        // materialTapTargetSize:
        //     MaterialTapTargetSize.shrinkWrap, // remove additional margin
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.transparent,
          shape: Border(
            bottom: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          // floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black38,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: primarySwatchColor,
              width: 2,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black, width: 2),
            elevation: 0,
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
