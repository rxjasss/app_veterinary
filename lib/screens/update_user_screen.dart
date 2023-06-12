import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class UpdateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(children: [
            Icon(
              Icons.info,
            ),
            Text(
              'Info',
            ),
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              offset: Offset(0, 50),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.message,
                              color: Color.fromARGB(255, 36, 57, 247)),
                          SizedBox(width: 8),
                          Text('Messages'),
                        ],
                      ),
                    ),
                    value: 'Opcion 1',
                  ),
                  PopupMenuItem(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.pets,
                              color: Color.fromARGB(255, 36, 57, 247)),
                          SizedBox(width: 8),
                          Text('Pets'),
                        ],
                      ),
                    ),
                    value: 'Opcion 2',
                  ),
                  PopupMenuItem(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Color.fromARGB(255, 36, 57, 247)),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                    value: 'Opcion 3',
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'Opcion 1') {
                  Navigator.pushReplacementNamed(context, 'messagesuserscreen');
                } else if (value == 'Opcion 2') {
                  Navigator.pushReplacementNamed(context, 'userscreen');
                } else if (value == 'Opcion 3') {
                  Provider.of<AuthService>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, 'login');
                }
              },
            )
          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          centerTitle: true,
        ),
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Update your info',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(), child: _LoginForm())
                ],
              )),
              SizedBox(height: 50),
            ],
          ),
        )));
  }
}
class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => __LoginForm();
}

class __LoginForm extends State<_LoginForm> {
  final userService = UserService();
  User user = User();

  Future getUser() async {
    await userService.getUser();
    User us = await userService.getUser();
    setState(() {
      user = us;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final userService = UserService();

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              initialValue: user.name,
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
              initialValue: user.surname,
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
              initialValue: user.username,
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
                      loginForm.isLoading ? 'Wait' : 'Update',
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

                          final String? errorMessage = await userService.update(
                              loginForm.name,
                              loginForm.surname,
                              loginForm.username,
                              loginForm.password);

                          if (errorMessage == '201') {
                            customToast('Info updated', context);
                            Navigator.pushReplacementNamed(
                                context, 'userscreen');
                          } else if (errorMessage == '500') {
                            customToast('Username is already in use', context);
                            loginForm.isLoading = false;
                          } else {
                            customToast('Server error', context);
                          }
                        }
                      }),
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
