import 'package:card_flow/views/login/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:card_flow/views/home/home_page.dart';

// Your web app's Firebase configuration
const firebaseConfig = {
  "apiKey": "AIzaSyB0MlSe6lc6HhzGR3jAzwpweCCQVigF_c0",
  "authDomain": "cardflow-a6664.firebaseapp.com",
  "projectId": "cardflow-a6664",
  "storageBucket": "cardflow-a6664.appspot.com",
  "messagingSenderId": "525797488115",
  "appId": "1:525797488115:web:a4d3edb5fbf757732ace86"
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: firebaseConfig['apiKey']!,
        authDomain: firebaseConfig['authDomain']!,
        projectId: firebaseConfig['projectId']!,
        storageBucket: firebaseConfig['storageBucket']!,
        messagingSenderId: firebaseConfig['messagingSenderId']!,
        appId: firebaseConfig['appId']!,
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LandingPage();
        },
      ),
    );
  }
}
