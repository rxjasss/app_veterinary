import 'package:app_veterinary/Models/models.dart';
import 'package:app_veterinary/services/auth_service.dart';
import 'package:app_veterinary/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class MessagesUserScreen extends StatefulWidget {
  const MessagesUserScreen({Key? key}) : super(key: key);

  @override
  State<MessagesUserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<MessagesUserScreen> {
  final reportService = ReportService();
  final userService = UserService();

  List<Report> reportUser = [];
  List<Report> reports = [];
  String user = "";
  bool desactivate = true;

  Future getPets() async {
    await reportService.getReportsUser(await AuthService().readId());
    setState(() {
      reports = reportService.reports;
      reportUser = reports;
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
    List<Report> results = [];
    if (enteredKeyword.isEmpty) {
      results = reports;
    } else {
      results = reports
          .where((x) => x.description!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
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
            Icons.message,
          ),
          Text(
            'Messages',
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
                        Icon(Icons.pets,
                            color: Color.fromARGB(255, 36, 57, 247)),
                        SizedBox(width: 8),
                        Text('Pets'),
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
                Navigator.pushReplacementNamed(context, 'userscreen');
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
      body: reportService.isLoading
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
    List<Report> reversedList = List.from(reportUser.reversed);
    if (reversedList.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: 250),
          child: Text(
            'Here is nothing to see yet...',
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
      // Invertir el orden de la lista

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(30),
        itemCount: reversedList.length,
        itemBuilder: (BuildContext context, index) {
          return SizedBox(
            height: 250,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${reversedList[index].idVeterinary}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Text(
                      '${reversedList[index].description != null ? reversedList[index].description![0].toUpperCase() + reversedList[index].description!.substring(1) : ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Divider(color: Colors.black),
                  ],
                ),
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
