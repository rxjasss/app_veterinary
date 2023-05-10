import 'package:app_veterinary/Models/models.dart';
import 'package:app_veterinary/services/auth_service.dart';
import 'package:app_veterinary/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final petService = PetService();
  final userService = UserService();

  List<Pet> petUser = [];
  List<Pet> pets = [];
  String user = "";
  int cont = 0;
  bool desactivate = true;

  Future getPets() async {
    await petService.getPetsUser(await AuthService().readId());
    setState(() {
      pets = petService.pets;

      cont = pets.length;
      if (cont >= 5) {
        desactivate = false;
      }

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
    setState(() {
    });
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
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          Text(
            'Pets',
          ),
          Text(
            '$cont',
            style: const TextStyle(fontSize: 30),
          ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: const InputDecoration(
                            labelText: '    Search',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        child: builListView(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Pets'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_circle_outlined), label: 'Data'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }

  Widget builListView(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(30),
      itemCount: petUser.length,
      itemBuilder: (BuildContext context, index) {
        return SizedBox(
          height: 250,
          child: Card(
            elevation: 20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('${petUser[index].animal}',
                            style: const TextStyle(fontSize: 20)),
                        Text('${petUser[index].breed}',
                            style: const TextStyle(fontSize: 20))
                      ]),
                  const Divider(color: Colors.black),
                  Text('${petUser[index].name}',
                      style: const TextStyle(fontSize: 35),
                      textAlign: TextAlign.center),
                      Text('${petUser[index].age}',
                      style: const TextStyle(fontSize: 35),
                      textAlign: TextAlign.center),
                  const Divider(color: Colors.black),
                ]),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
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
