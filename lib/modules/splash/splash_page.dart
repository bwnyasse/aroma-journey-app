import 'package:aroma_journey/modules/onboarding/pages/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Modular.to.navigate('/onboarding/');
      } else {
        Modular.to.navigate('/home/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF14181B),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.network(
              OnboardingPageConstants.coverImageUrl,
            ).image,
          ),
        ),
      ),
    );
  }
}
