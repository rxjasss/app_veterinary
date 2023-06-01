import 'package:app_veterinary/Models/models.dart';
import 'package:app_veterinary/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AppointmentsPetScreen extends StatefulWidget {
  final int idPet;
  const AppointmentsPetScreen({required this.idPet});

  @override
  State<AppointmentsPetScreen> createState() => _UserScreenState(idPet: idPet);
}

class _UserScreenState extends State<AppointmentsPetScreen> {
  final appointmentService = AppointmentService();
  final petService = PetService();
  final idPet;

  _UserScreenState({required this.idPet});

  List<Appointment> appointmentsPet = [];
  List<Appointment> appointments = [];
  bool desactivate = true;

  Future getAppointments() async {
    await appointmentService.getAppointmentsPet(idPet.toString());
    setState(() {
      appointments = appointmentService.appointmentsPets;
      appointmentsPet = appointments;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  void _runFilter(String enteredKeyword) {
    List<Appointment> results = [];
    if (enteredKeyword.isEmpty) {
      results = appointments;
    } else {
      results = appointments
          .where((x) =>
              x.date!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'veterinaryscreen');
      } else {
        Navigator.pushReplacementNamed(context, 'updatescreen');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(children: [
          Icon(
            Icons.info_rounded,
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
                  value: 'Opcion 3',
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
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'newappointmentscreen',
              arguments: idPet);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: Color.fromARGB(255, 36, 57, 247),
        child: Icon(Icons.add_box, color: Colors.white),
        constraints: BoxConstraints.tightFor(
          width: 40.0,
          height: 40.0,
        ),
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    if (appointmentsPet.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: 250),
          child: Text(
            'There is nothing to see yet...',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 151, 144, 144),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      appointmentsPet.sort((a, b) {
        int dateComparison = a.date!.compareTo(b.date!);
        if (dateComparison != 0) {
          return dateComparison;
        } else {
          return a.hour!.compareTo(b.hour!);
        }
      });

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        itemCount: appointmentsPet.length,
        itemBuilder: (BuildContext context, index) {
          String fechaCompleta = appointmentsPet[index].date!;
          List<String> partes = fechaCompleta.split('T');
          DateTime fecha = DateTime.parse(partes[0]);
          String fechaFormateada = DateFormat('dd-MM-yyyy').format(fecha);
          return SizedBox(
            height: 120,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: ' + fechaFormateada,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(color: Colors.black),
                        SizedBox(height: 5),
                        Text(
                          'Hour: ${appointmentsPet[index].hour}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Divider(color: Colors.black),
                        SizedBox(height: 5),
                      ],
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
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Cancel appointment"),
                                content: Text("Are you sure?"),
                                actions: [
                                  TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () async {
                                      await appointmentService
                                          .deleteAppointment(
                                              appointmentsPet[index].id!);
                                      Navigator.of(context).pop();
                                      setState(() {
                                        appointmentsPet.removeAt(index);
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
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      );
    }
  }
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
