// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:app_veterinary/services/services.dart';
import 'package:app_veterinary/Models/models.dart';
import 'package:app_veterinary/widgets/widgets.dart';
import 'package:app_veterinary/ui/input_decorations.dart';

import '../providers/providers.dart';

// class getCicles extends ChangeNotifier {
//   String _baseUrl = 'http://salesin.allsites.es/public/api/cicles';

//   CiclesProvider() {
//     print('Inicializando');
//   }

//   getCiclesName() async {
//     var url = Uri.https(_baseUrl);

//     final response = await http.get(url);

//     print(response.body);
//   }
// }

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(height: 10),
              Text('Crear cuenta',
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(), child: _RegisterForm())
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Text(
                '¿Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _RegisterForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final ciclesProvider = Provider.of<GetCompanies>(context);
    List<Companies> ciclos = ciclesProvider.getAllCompanies;
    List<Companies> options = [];
    if (ciclos.isNotEmpty) {
      for (var i = 0; i < ciclos.length; i++) {
        options.add(ciclos[i]);
      }
    }

    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Form(
      key: registerForm.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        // ignore: sort_child_properties_last
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Name', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.name = value,
            validator: (name) {
              if (isTextValid(name)) {
                return null;
              } else {
                return 'Name field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Surname', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.surname = value,
            validator: (surname) {
              if (isTextValid(surname)) {
                return null;
              } else {
                return 'Surname field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded),
            onChanged: (value) => registerForm.email = value,
            validator: (email) {
              if (isEmailValid(email)) {
                return null;
              } else {
                return 'Enter a valid email address';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => registerForm.password = value,
            validator: (password) {
              if (isPasswordValid(password)) {
                return null;
              } else {
                return 'Enter a valid password';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => registerForm.cpassword = value,
            validator: (value) {
              if (value != registerForm.password) {
                return "The passwords don't match";
              } else if (value == '') {
                return "The password cant be null";
              }
              return null;
            },
          ),
          DropdownButtonFormField<Companies>(
            decoration: InputDecorations.authInputDecoration(
                prefixIcon: Icons.view_week_outlined,
                hintText: '',
                labelText: 'Company'),
            // value: selectedItem,
            items: options
                .map(
                  (courseName) => DropdownMenuItem(
                    value: courseName,
                    child: Text(courseName.nameCompanie),
                  ),
                )
                .toList(),
            onChanged: (value) {
              registerForm.cicleid = (value?.idCompanie.toInt())!;
            },
            validator: (cicle) {
              if (isCicleValid(cicle)) {
                return null;
              } else {
                return 'Select a companie';
              }
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!registerForm.isValidForm()) return;

                      registerForm.isLoading = true;

                      //validar si el login es correcto
                      final String? errorMessage = await authService.createUser(
                          registerForm.name,
                          registerForm.surname,
                          registerForm.email,
                          registerForm.password,
                          registerForm.cpassword,
                          registerForm.cicleid);
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        //mostrar error en pantalla
                        // customToast('The email is already registered', context);
                        registerForm.isLoading = false;
                        print(errorMessage);
                      }
                      // }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    registerForm.isLoading ? 'Espere' : 'Registrar',
                    style: const TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}

mixin InputValidationMixin {
  bool isTextValid(texto) => texto.length > 0;

  bool isPasswordValid(password) => password.length > 6;

  bool isCicleValid(cicle) => cicle != null;

  bool isEmailValid(email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
