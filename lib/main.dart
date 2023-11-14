import 'package:flutter/material.dart';
import 'package:tripool_app/screens/bottom_bar_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tripool',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //     primarySwatch: Colors.purple,
        //     // accentColor: Colors.amber,
        //     fontFamily: 'Raleway',
        //     iconTheme: IconTheme.of(context).copyWith(
        //       color: Colors.white,
        //     )),
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          primaryColor:  Colors.blue,
          // textTheme: GoogleFonts.muliTextTheme(),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(
                    secondary: Colors.blueAccent, ),
        ),
        home: const BottomBarScreen(),
      );
  }
}


 