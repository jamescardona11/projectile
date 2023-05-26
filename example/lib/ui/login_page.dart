import 'package:flutter/material.dart';
import 'package:example/api_request/api_request_with_http.dart';

import 'const.dart';
import 'widgets/eleventh_button_widget.dart';
import 'widgets/input_text_widget.dart';

class LoginPage extends StatefulWidget {
  /// default constructor
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ApiRequestWithHttp apiRequest = ApiRequestWithHttp();

  String email = '';
  String password = '';
  String messageError = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 80.0,
                  horizontal: 60,
                ),
                child: Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset(logoImg),
                  ),
                ),
              ),
              InputTextWidget(
                hint: 'Enter your email',
                leadingIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                  messageError = '';
                  setState(() {});
                },
              ),
              const SizedBox(height: 15),
              InputTextWidget.password(
                hint: 'Enter your password',
                leadingIcon: Icons.lock,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  messageError = '';
                  setState(() {});
                },
              ),
              const SizedBox(height: 35),
              if (messageError.isNotEmpty)
                Column(
                  children: [
                    Text(messageError),
                    SizedBox(height: 20),
                  ],
                ),
              EleventhButton(
                width: size.width,
                label: 'Login',
                primaryColor: kPrimaryColor,
                splashColor: kBlueColor,
                accentColor: kWhiteColor,
                onPressed: () async {
                  loading = true;
                  setState(() {});

                  final result = await apiRequest.login(email, password);

                  if (!result) messageError = 'Error with credentials';

                  loading = false;
                  setState(() {});
                },
              ),
              if (loading)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // bool get isValid => email.isNotEmpty && password.isNotEmpty;
}
