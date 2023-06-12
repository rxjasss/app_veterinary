import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              SizedBox(height: 10),
              Text('Create account',
                  style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: _LoginForm())
            ],
          )),
          SizedBox(height: 50),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 36, 57, 247).withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                'Dou you have an account?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Name...',
                  labelText: 'Name',
                  prefixIcon: Icons.abc),
              onChanged: (value) => loginForm.name = value,
            ),
            
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Surname...',
                  labelText: 'Surname',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => loginForm.surname = value,
            ),
            
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Username...',
                  labelText: 'Username',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => loginForm.username = value,
            ),
            
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '******',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
            ),
            SizedBox(height: 10),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Color.fromARGB(255, 36, 57, 247),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Wait' : 'Register',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (loginForm.username.isEmpty ||
                            loginForm.password.isEmpty ||
                            loginForm.name.isEmpty ||
                            loginForm.surname.isEmpty) {
                          customToast("Fields can't be empty", context);
                        } else {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          // TODO: validar si el login es correcto
                          final String? errorMessage =
                              await authService.register(
                                  loginForm.name,
                                  loginForm.surname,
                                  loginForm.username,
                                  loginForm.password);

                          if (errorMessage == '200') {
                            customToast('Registered', context);
                            Navigator.pushReplacementNamed(context, 'login');
                          } else if (errorMessage == '500') {
                            // TODO: mostrar error en pantalla
                            customToast('Username is already in use', context);

                            loginForm.isLoading = false;
                          } else {
                            customToast('Server error', context);
                          }
                        }
                      })
          ],
        ),
      ),
    );
  }

  void customToast(String message, BuildContext context) {
  showToast(
    message,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Color.fromARGB(255, 36, 57, 247),
      fontWeight: FontWeight.bold,
    ),
    textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    fullWidth: true,
    toastHorizontalMargin: 40,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(30),
    ),
    backgroundColor: Colors.white,
    alignment: Alignment.bottomCenter,
    position: StyledToastPosition.bottom,
    duration: const Duration(seconds: 3),
    animation: StyledToastAnimation.slideToTop,
    reverseAnimation: StyledToastAnimation.slideToBottom,
    curve: Curves.easeInOut,
    reverseCurve: Curves.easeInOut,
    context: context,
  );
}
}
