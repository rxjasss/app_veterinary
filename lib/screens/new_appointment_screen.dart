import 'package:app_veterinary/widgets/background.dart';
import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class NewAppointmentScreen extends StatefulWidget {
  final int idPet;
  const NewAppointmentScreen({required this.idPet});

  @override
  State<NewAppointmentScreen> createState() =>
      _NewAppointmentScreen(idPet: idPet);
}

class _NewAppointmentScreen extends State<NewAppointmentScreen> {
  final int idPet;

  _NewAppointmentScreen({required this.idPet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(children: [
            Icon(
              Icons.info_rounded,
            ),
            Text(
              'Appointment',
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
                          Icon(Icons.account_box_sharp,
                              color: Color.fromARGB(255, 36, 57, 247)),
                          SizedBox(width: 8),
                          Text('User options'),
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
                          Icon(Icons.pets,
                              color: Color.fromARGB(255, 36, 57, 247)),
                          SizedBox(width: 8),
                          Text('Pets'),
                        ],
                      ),
                    ),
                    value: 'Opcion 3',
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
                    value: 'Opcion 4',
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'Opcion 1') {
                  Navigator.pushReplacementNamed(context, 'messagesuserscreen');
                } else if (value == 'Opcion 2') {
                  Navigator.pushReplacementNamed(context, 'updateuserscreen');
                } else if (value == 'Opcion 3') {
                  Navigator.pushReplacementNamed(context, 'userscreen');
                } else if (value == 'Opcion 4') {
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
                  Text('Take Appointment',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => AppointmentProvider(),
                      child: _Form(idPet: idPet))
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, 'appointmentspetscreen', arguments: idPet),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
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

class _Form extends StatefulWidget {
  final int idPet;
  const _Form({required this.idPet});

  @override
  State<_Form> createState() => __Form(idPet: idPet);
}

class __Form extends State<_Form> {
  final int idPet;
  __Form({required this.idPet});

  final userService = UserService();
  final appointmentService = AppointmentService();

  List<User> veterinarys = [];
  List<Appointment> appointments = [];
  User user = User();
  String selectedButton = '';
  DateTime selectedDate = DateTime(10);
  List<String> hoursOcu = [];
  var appointmentForm = null;

  Future<void> _selectDate(
      BuildContext context, DateTime select, int id) async {
    List<String> hours = ['16:00', '17:00', '18:00', '19:00'];
    List<Appointment> appDep = [];
    List<Appointment> app = [];
    List<String> disps = [];
    List<String> fechaS = select.toString().split(' ');

    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].idUser == id) {
        appDep.add(appointments[i]);
      }
    }

    for (int i = 0; i < appDep.length; i++) {
      List<String> fechaD = appDep[i].date.toString().split('T');

      if (fechaD[0] == fechaS[0]) {
        app.add(appDep[i]);
      }
    }

    for (int f = 0; f < app.length; f++) {
      String h = app[f].hour!.substring(0, 5);

      for (int i = 0; i < hours.length; i++) {
        if (hours.contains(h)) {
          disps.add(h);
          break;
        }
      }
    }
    setState(() {
      hoursOcu = disps;
    });
  }

  Future getVeterinarys() async {
    await userService.getListVeterinarys();
    setState(() {
      veterinarys = userService.veterinarys;
    });
  }

  Future getAppointments() async {
    await appointmentService.getAppointmentsPet(idPet.toString());
    setState(() {
      appointments = appointmentService.appointmentsPets;
    });
  }

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
    getVeterinarys();
    getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentForm = Provider.of<AppointmentProvider>(context);
    final appointmentService = AppointmentService();

    List<User> options = [];
    if (veterinarys.isNotEmpty) {
      for (var i = 0; i < veterinarys.length; i++) {
        options.add(veterinarys[i]);
      }
    }

    return Container(
      child: Form(
        key: appointmentForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            DropdownButtonFormField<User>(
              decoration: InputDecorations.authInputDecoration(
                  prefixIcon: Icons.account_circle_outlined,
                  hintText: '',
                  labelText: 'Veterinary'),
              // value: selectedItem,
              items: options
                  .map(
                    (vet) => DropdownMenuItem(
                      value: vet,
                      child: Text(vet.name.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                appointmentForm.idVeterinary = (value?.id)!;
              },
              validator: (cicle) {
                if (cicle != null) {
                  return null;
                } else {
                  return 'Select a veterinary';
                }
              },
            ),
            SizedBox(height: 30),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(Duration(days: 365)),
                          onChanged: (value) {
                        appointmentForm.date = value;
                        _selectDate(
                            context, value, appointmentForm.idVeterinary);
                      }, currentTime: DateTime.now(), locale: LocaleType.es);
                    },
                    child: Text(
                      'Date:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 36, 57, 247),
                        fontSize: 14,
                      ),
                    )),
                Visibility(
                    visible: appointmentForm.hour != null,
                    child:
                        Text(appointmentForm.date.toString().substring(0, 10))),
              ],
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Hours:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 36, 57, 247),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Visibility(
                  visible: !_isVisible('16:00'),
                  child: buildRoundButton('16:00', appointmentForm)),
              Visibility(
                  visible: !_isVisible('17:00'),
                  child: buildRoundButton('17:00', appointmentForm)),
              Visibility(
                  visible: !_isVisible('18:00'),
                  child: buildRoundButton('18:00', appointmentForm)),
              Visibility(
                  visible: !_isVisible('19:00'),
                  child: buildRoundButton('19:00', appointmentForm)),
            ]),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Color.fromARGB(255, 36, 57, 247),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      appointmentForm.isLoading ? 'Wait' : 'Take appointment',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: appointmentForm.isLoading
                    ? null
                    : () async {
                        if (appointmentForm.date.isUtc ||
                            appointmentForm.hour.isEmpty ||
                            appointmentForm.idVeterinary == 0) {
                          customToast("Fiels can't be empty", context);
                        } else {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!appointmentForm.isValidForm()) return;

                          appointmentForm.isLoading = true;
                          int idUser = user.id!;

                          List<String> da =
                              appointmentForm.date.toString().split(" ");

                          final String? errorMessage =
                              await appointmentService.create(
                                  da[0],
                                  appointmentForm.hour,
                                  idPet,
                                  appointmentForm.idVeterinary);

                          if (errorMessage == '201') {
                            customToast('Appointment created', context);
                            Navigator.pushReplacementNamed(
                                context, 'appointmentspetscreen',
                                arguments: idPet);
                          } else if (errorMessage == '500') {
                            customToast('Error creating appointment', context);

                            appointmentForm.isLoading = false;
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

  Widget buildRoundButton(
      String buttonNumber, AppointmentProvider _appointmentForm) {
    bool isSelected = selectedButton == buttonNumber;
    bool activate = hoursOcu.contains(selectedButton);

    return InkWell(
      enableFeedback: activate,
      onTap: () {
        setState(() {
          selectedButton = buttonNumber;
          _appointmentForm.hour = selectedButton;
          appointmentForm = _appointmentForm;
        });
      },
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Color.fromARGB(255, 36, 57, 247) : Colors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonNumber.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  bool _isVisible(String _hour) {
    bool activate = hoursOcu.contains(_hour);
    return activate;
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
