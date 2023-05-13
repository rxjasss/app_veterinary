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
  final petService = PetService();
  final userService = UserService();

  List<Pet> petUser = [];
  List<Pet> pets = [];
  String user = "";
  bool desactivate = true;

  Future getPets() async {
    await petService.getPetsUser(await AuthService().readId());
    setState(() {
      pets = petService.pets;
      petUser = pets;
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
    List<Pet> results = [];
    if (enteredKeyword.isEmpty) {
      results = pets;
    } else {
      results = pets
          .where((x) =>
              x.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
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
      body: petService.isLoading
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(30),
      itemCount: petUser.length,
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
                        '${petUser[index].name != null ? petUser[index].name![0].toUpperCase() + petUser[index].name!.substring(1) : ''}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Text(
                    '${petUser[index].animal != null ? petUser[index].animal![0].toUpperCase() + petUser[index].animal!.substring(1) : ''}',
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
