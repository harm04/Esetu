import 'package:esetu/screens/home/home.dart';
import 'package:esetu/screens/signup/signup.dart';
import 'package:esetu/services/auth_services.dart';
import 'package:esetu/utils/snackbar.dart';
import 'package:esetu/widgets/custom_button.dart';
import 'package:esetu/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final AuthServices authService = AuthServices();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future login() async {}

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
          backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Login to your account',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'It\'s great to see you again',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextfield(
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        obsecureText: false,
                        hintText: 'email',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextfield(
                        type: TextInputType.text,
                        controller: passwordController,
                        obsecureText: true,
                        hintText: 'password',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Forgot password?',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Reset password',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          String res = await authService.login(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString());

                          if (res == 'success') {
                            setState(() {
                              isLoading = false;
                            });

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return HomePage();
                            }));
                            showSnackbar('login success', context);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            showSnackbar(res, context);
                          }
                        },
                        child: const CustomButton(
                          buttonText: 'Login',
                          buttonColor: Colors.black,
                          textColor: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(children: <Widget>[
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("OR"),
                          ),
                          Expanded(child: Divider()),
                        ]),
                      ),
                      Card(
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic_google.png',
                                  height: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Login with Google',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 19),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignUpScreen();
                              }));
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
          );
  }
}
