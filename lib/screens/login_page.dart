import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lonewolf/services/lonewolfuser_db_service.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../models/LoneWolfUser.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return HomePage(loggedUser: _user as User);
    } else {
      return _googleSignInScreen();
    }
  }

  Widget _googleSignInScreen() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<void> handleGoogleSignIn() async {
      try {

        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        if (account != null) {

          final GoogleSignInAuthentication googleAuth = await account.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final UserCredential userCredential = await _auth.signInWithCredential(credential);
          final user = userCredential.user;
          print(user?.email);

          // Save User
          if (user != null) {
            print(user.email);

            // Save User (if email exists)
            if (!await LonewolfuserDbService().findUserExists(user.email)) {

              LoneWolfUser loneWolfUser = LoneWolfUser(
                email: user.email.toString(),
                userrole: 'client',
              );

              LonewolfuserDbService().addUsers(loneWolfUser);

            }
          } else {
            print("Sign-in failed or user not found");
          }
        } else {
          print('User did not sign in (canceled or error).');
        }
      } on Exception catch (error) {
        print('Error signing in with Google: $error');
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundImage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        width: 300.0,
                        height: 300.0,
                      ),
                      const SizedBox(height: 250),
                      const Text(
                        "Escape the ordinary. \n Pack your bags and chase sunsets in a new land. \n Adventure awaits - are you ready?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0,
                          fontFamily: 'popins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 250),
                      SizedBox(
                        height: 50,
                        child: SignInButton(
                          Buttons.google,
                          onPressed: handleGoogleSignIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _handleGoogleSignIn() {
  //   try {
  //     GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
  //     _auth.signInWithProvider(_googleAuthProvider).then((result) {
  //       // User signed in successfully
  //       final user = result.user;
  //       print(user?.email);
  //     }).catchError((error) {
  //       print(error.message);
  //     });
  //   } catch (error) {
  //     print(error);
  //   }
  // }

}
