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
      apiKey:  'AIzaSyCHLxwY3cOr38UTa1KIajqKxBfYClDaMrk',
      projectId:  'tripool-ea5ee',
      storageBucket:  'tripool-ea5ee.appspot.com',
      messagingSenderId:'',
      appId: '1:362397402376:android:68664deac5ea50062498bd',
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