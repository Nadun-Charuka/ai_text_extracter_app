import 'package:ai_text_extracter_app/constants/colors.dart';
import 'package:ai_text_extracter_app/firebase_options.dart';
import 'package:ai_text_extracter_app/main_screen.dart';
import 'package:ai_text_extracter_app/provider/premium_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //load the env
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISHABLE_KEY"] ?? "";
  //debugPrint("Stripe key: ${Stripe.publishableKey}");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PremiumProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Text Extract app",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: mainColor,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: mainColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsetsDirectional.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: mainColor),
            ),
            backgroundColor: mainColor,
          ),
        ),
      ),
      home: MainScreen(),
    );
  }
}
