import 'package:flutter/material.dart';
// import 'package:tripool_app/screens/login.dart';
import 'package:tripool_app/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tripool_app/screens/main_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY']??'',
      projectId: dotenv.env['PROJECT_ID']??'',
      storageBucket: dotenv.env['STORAGE_BUCKET']??'',
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']??'',
      appId: dotenv.env['APP_ID']??'',
      
    ),
  );
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
        theme: ThemeData(
            primarySwatch: Colors.purple,
            // accentColor: Colors.amber,
            fontFamily: 'Raleway',
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            )),
        home: const MainPage(),
      );
  }
}