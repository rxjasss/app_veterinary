import 'package:app_veterinary/Models/models.dart';
import 'package:app_veterinary/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class NewMessageScreen extends StatefulWidget {
  final int idVeterinary;
  const NewMessageScreen({required this.idVeterinary});

  @override
  State<NewMessageScreen> createState() =>
      _NewReportScreen(idVeterinary: idVeterinary);
}

class _NewReportScreen extends State<NewMessageScreen> {
  final int idVeterinary;

  _NewReportScreen({required this.idVeterinary});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(children: [
          Icon(
            Icons.message,
          ),
          Text(
            'Message',
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
                      color: Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.message,
                            color: Color.fromARGB(255, 36, 57, 247)),
                        SizedBox(width: 8),
                        Text('Appointments'),
                      ],
                    ),
                  ),
                  value: 'Opcion 1',
                ),
                PopupMenuItem(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
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
                      color: Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
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
                Navigator.pushReplacementNamed(context, 'veterinaryscreen');
              } else if (value == 'Opcion 2') {
                Navigator.pushReplacementNamed(context, 'updateuserscreen');
              } else if (value == 'Opcion 3') {
                Provider.of<AuthService>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, 'login');
              }
            },
          )
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        centerTitle: true,
      ),
        body: Background(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 150),
          CardContainer(
              child: Column(
            children: [
              SizedBox(height: 10),
              Text('Send message',
                  style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: _MessageForm(idVeterinary: idVeterinary))
            ],
          )),
          SizedBox(height: 50),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'messagesveterinaryscreen'),
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 36, 57, 247).withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                'Back',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}
class _MessageForm extends StatefulWidget {
  final int idVeterinary;
  const _MessageForm({required this.idVeterinary});

  @override
  State<_MessageForm> createState() => __Form(idVeterinary: idVeterinary);
}

class __Form extends State<_MessageForm> {
  final int idVeterinary;
  __Form({required this.idVeterinary});

  final userService = UserService();
  User user = User();
  List<User> users = [];


  Future getUsers() async {
    await userService.getListUsers();
    setState(() {
      users = userService.users;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final reportForm = Provider.of<ReportProvider>(context);
    final reportService = ReportService();
    
    List<User> options = [];
    if (users.isNotEmpty) {
      for (var i = 0; i < users.length; i++) {
        options.add(users[i]);
      }
    }

    return Container(
      child: Form(
        key: reportForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            DropdownButtonFormField<dynamic>(
              decoration: InputDecorations.authInputDecoration(
                  prefixIcon: Icons.person,
                  hintText: '',
                  labelText: 'User'),
              // value: selectedItem,
              items: options
                  .map(
                    (op) => DropdownMenuItem(
                      value: op,
                      child: Text(op.username.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                reportForm.idUser = (value.id);
              },
              validator: (cicle) {
                if (cicle != null) {
                  return null;
                } else {
                  return 'Select an user';
                }
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              maxLength: 25,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Message...',
                  labelText: 'Message',
                  prefixIcon: Icons.message),
              onChanged: (value) => reportForm.description = value,
              maxLines: null,
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blueGrey,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      reportForm.isLoading ? 'Wait' : 'Send',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: reportForm.isLoading
                    ? null
                    : () async {

                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!reportForm.isValidForm()) return;

                        reportForm.isLoading = true;
                        int idUser = reportForm.idUser;
                        // TODO: validar si el login es correcto
                        final String? errorMessage = await reportService.create(
                            reportForm.description,
                            idVeterinary,
                            reportForm.idUser);

                        if (errorMessage == '201') {
                          customToast('Sent', context);
                          Navigator.pushReplacementNamed(
                              context, 'messagesveterinaryscreen');
                        } else if (errorMessage == '500') {
                          // TODO: mostrar error en pantalla
                          customToast('Error sending message', context);

                          reportForm.isLoading = false;
                        } else {
                          customToast('Server error', context);
                        }
                        // }
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
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.blue,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}



