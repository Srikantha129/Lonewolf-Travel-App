import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lonewolf/services/lonewolfuser_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../constant/constant.dart';
import '../models/LoneWolfUser.dart';
import '../pages/bottom_bar.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isRegistering = false;

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
    if (_user != null && _user!.emailVerified) {
      //return HomePage(loggedUser: _user!);
      return const BottomBar();

    } else {
      return _authScreen();
    }
  }

  Widget _authScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundImage.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(seconds: 1),
                        child: Image.asset(
                          'assets/images/Logo.png',
                          width: 150.0,
                          height: 150.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _isRegistering ? 'Start a New Journey' : 'Welcome Back!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _isRegistering ? _registrationFields() : _loginFields(),
                      const SizedBox(height: 20),
                      _toggleRegistrationOption(),
                      const SizedBox(height: 20),
                      _googleSignInButton(),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
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

  Widget _toggleRegistrationOption() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isRegistering = !_isRegistering;
        });
      },
      child: Text.rich(
        TextSpan(
          text: _isRegistering ? 'Already have an account? ' : 'Don\'t have an account? ',
          style: const TextStyle(color: Colors.white70),
          children: [
            TextSpan(
              text: _isRegistering ? 'Login' : 'Register',
              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

  }

  Widget _googleSignInButton() {
    return SignInButton(
      Buttons.google,
      onPressed: handleGoogleSignIn,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  Widget _loginFields() {
    return _authFields(
      emailController: _emailController,
      passwordController: _passwordController,
      buttonText: 'Login',
      onPressed: handleEmailSignIn,
    );
  }

  Widget _registrationFields() {
    return _authFields(
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      buttonText: 'Register',
      onPressed: handleRegistration,
    );
  }

  Widget _authFields({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    TextEditingController? confirmPasswordController,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        _textField(
          controller: emailController,
          labelText: 'Email',
          icon: Icons.email,
        ),
        const SizedBox(height: 15),
        _textField(
          controller: passwordController,
          labelText: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        if (confirmPasswordController != null) ...[
          const SizedBox(height: 15),
          _textField(
            controller: confirmPasswordController,
            labelText: 'Confirm Password',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: primaryColor,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // Set text color to black
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true);
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth = await account
            .authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(
            credential);
        final user = userCredential.user;

        if (user != null) {
          // Save user email in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userEmail', user.email!);
          await prefs.setString('userName', user.displayName ?? '');
          await prefs.setString('userPhoto', user.photoURL ?? '');
          await prefs.setString('userId', user.uid ?? '');
          print('Saved userEmail: ${user.email!}');
          print('Saved userName: ${user.displayName ?? ''}');
          print('Saved photoURL: ${user.photoURL ?? ''}');

          if (!await LonewolfuserDbService().findUserExists(user.email)) {
            LonewolfuserDbService().addUsers(
              LoneWolfUser(email: user.email!, userrole: 'client'),
            );
          }
        }
      }
    } catch (error) {

      print('Error signing in with Google: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  //Helper to Show Error Messages.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Email login with error handling
  Future<void> handleEmailSignIn() async {
    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        _showSnackBar('Please verify your email before logging in.');
      }else {
        // Save user email in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', userCredential.user!.email!);
        await prefs.setString('userName', userCredential.user!.displayName ?? '');
        await prefs.setString('userPhotoURL', userCredential.user!.photoURL ?? '');
        await prefs.setString('userId', userCredential.user!.uid ?? '');
      }

    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found for this email. Please check or register.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid. Please check the format.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      _showSnackBar(errorMessage);
    } catch (error) {
      _showSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }



  Future<void> handleRegistration() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      _showSnackBar('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user!.sendEmailVerification();
      LoneWolfUser loneWolfUser = LoneWolfUser(
        email: userCredential.user!.email!,
        userrole: 'client',
      );
      LonewolfuserDbService().addUsers(loneWolfUser);
      _showSnackBar('Verification email sent. Please verify your email.');

      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use. Please use a different email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid. Please enter a valid email.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled. Please contact support.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak. Please choose a stronger password.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }
      _showSnackBar(errorMessage);
    } catch (error) {
      _showSnackBar('Error registering: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }


}