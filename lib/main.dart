import 'package:card_flow/pages/home_page.dart';
import 'package:card_flow/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      appId: firebaseConfig['appId']!,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color palette for the Soft Dark Theme
    const primaryColor = Color(0xFF6C63FF); // Electric Violet
    const backgroundColor = Color(0xFF1A1B26); // Gunmetal
    const surfaceColor = Color(0xFF252634); // Lighter dark gray for cards
    const primaryTextColor = Colors.white;
    const secondaryTextColor = Color(0xFFA0A0B0); // Silver-gray

    // Create the base text theme
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

    // Customize the text theme to match the design system
    final customTextTheme = textTheme.copyWith(
      headlineMedium: textTheme.headlineMedium?.copyWith(color: primaryTextColor, fontWeight: FontWeight.w600),
      titleLarge: textTheme.titleLarge?.copyWith(color: primaryTextColor),
      titleMedium: textTheme.titleMedium?.copyWith(color: secondaryTextColor),
      bodyLarge: textTheme.bodyLarge?.copyWith(color: primaryTextColor),
      bodyMedium: textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
    );

    return MaterialApp(
      title: 'CardFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: primaryColor,
          surface: surfaceColor, // For cards, dialogs, etc.
          background: backgroundColor, 
          onPrimary: Colors.white, 
          onSurface: primaryTextColor, 
          onBackground: primaryTextColor,
        ),

        textTheme: customTextTheme,

        cardTheme: CardThemeData(
          elevation: 2,
          color: surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)
          ),
        ),
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor,));
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
