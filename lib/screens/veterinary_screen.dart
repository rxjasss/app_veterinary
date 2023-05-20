import 'package:app_veterinary/Models/models.dart';
import 'package:app_veterinary/services/auth_service.dart';
import 'package:app_veterinary/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class VeterinaryScreen extends StatefulWidget {
  const VeterinaryScreen({Key? key}) : super(key: key);

  @override
  State<VeterinaryScreen> createState() => _VeterinaryScreenState();
}

class _VeterinaryScreenState extends State<VeterinaryScreen> {
  final appointmentService = AppointmentService();
  final userService = UserService();

  List<Appointment> appointmentVeterinary = [];
  List<Appointment> appointments = [];
  String user = "";
  bool desactivate = true;

  Future getPets() async {
    await appointmentService
        .getAppointmentsVeterinary(await AuthService().readId());
    setState(() {
      appointments = appointmentService.appointments;
      appointmentVeterinary = appointments;
    });
  }

  Future getUser() async {
    await userService.getUser();
    String id = await userService.getUser() as String;
    setState(() {
      user = id;
    });
  }

  @override
  void initState() {
    super.initState();
    getPets();
  }

  void _runFilter(String enteredKeyword) {
    List<Appointment> results = [];
    if (enteredKeyword.isEmpty) {
      results = appointments;
    } else {
      results = appointments
          .where((x) =>
              x.hour!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'userscreen');
      } else {
        Navigator.pushReplacementNamed(context, 'updatescreen');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(children: [
          Icon(
            Icons.perm_device_information_rounded,
          ),
          Text(
            'Appointments',
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
                      color: Color.fromARGB(255, 36, 57, 247).withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.pets,
                            color: Color.fromARGB(255, 36, 57, 247)),
                        SizedBox(width: 8),
                        Text('Create pets'),
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
                Navigator.pushReplacementNamed(
                    context, 'messagesveterinaryscreen');
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
      body: appointmentService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      child: Container(
                        child: buildListView(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildListView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(30),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: appointmentVeterinary.length,
      itemBuilder: (BuildContext context, index) {
        String fechaCompleta = appointmentVeterinary[index].date!;
        List<String> partes = fechaCompleta.split('T');
        String fecha = partes[0];

        return Stack(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fecha,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.black),
                    Text(
                      '${appointmentVeterinary[index].hour}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 36, 57, 247),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete appointment"),
                          content: Text("Are you sure?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () async {
                                await appointmentService.deleteAppointment(
                                    appointmentVeterinary[index].id!);
                                Navigator.of(context).pop();
                                setState(() {
                                  appointmentVeterinary.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
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
