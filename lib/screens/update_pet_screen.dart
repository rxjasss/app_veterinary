import 'package:app_veterinary/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class UpdatePetScreen extends StatelessWidget {
  final int idPet;
  const UpdatePetScreen({required this.idPet});

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
              'Pet info',
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
                  Navigator.pushReplacementNamed(context, 'veterinaryscreen');
                } else if (value == 'Opcion 2') {
                  Navigator.pushReplacementNamed(
                      context, 'messagesveterinaryscreen');
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
                  Text('Update pet info',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(), child: _PetForm(idPet: idPet))
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'petscreen'),
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

class _PetForm extends StatefulWidget {
  final int idPet;
  const _PetForm({required this.idPet});

  @override
  State<_PetForm> createState() => __Form(idPet: idPet);
}

class __Form extends State<_PetForm> {
  final int idPet;
  __Form({required this.idPet});
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
    final petForm = Provider.of<PetProvider>(context);
    final petService = PetService();

    List<User> options = [];
    if (users.isNotEmpty) {
      for (var i = 0; i < users.length; i++) {
        options.add(users[i]);
      }
    }

    return Container(
      child: Form(
        key: petForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Animal...',
                  labelText: 'Animal',
                  prefixIcon: Icons.pets),
              onChanged: (value) => petForm.animal = value,
              maxLines: null,
            ),
            SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Breed...',
                  labelText: 'Breed',
                  prefixIcon: Icons.pets),
              onChanged: (value) => petForm.breed = value,
              maxLines: null,
            ),
            SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              maxLength: 12,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Name...',
                  labelText: 'Name',
                  prefixIcon: Icons.abc),
              onChanged: (value) => petForm.name = value,
              maxLines: null,
            ),
            SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              maxLength: 2,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Age...',
                labelText: 'Age',
                prefixIcon: Icons.numbers,
              ),
              onChanged: (value) {
                try {
                  petForm.age = int.parse(value);
                } catch (e) {
                  customToast(
                      'Invalid age. Please enter a valid number.', context);
                }
              },
              maxLines: null,
            ),
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
                      petForm.isLoading ? 'Wait' : 'Update',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: petForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (petForm.age == 0 ||
                            petForm.animal.isEmpty ||
                            petForm.breed.isEmpty ||
                            petForm.name.isEmpty ||
                            petForm.idUser == null) {
                          customToast("Fields can't be empty", context);
                        } else {
                          final petService =
                              Provider.of<PetService>(context, listen: false);

                          if (!petForm.isValidForm()) return;

                          petForm.isLoading = true;

                          final String? errorMessage = await petService.update(
                              idPet,
                              petForm.age,
                              petForm.name,
                              petForm.animal,
                              petForm.breed);

                          if (errorMessage == '200') {
                            customToast('Updated', context);
                            Navigator.pushReplacementNamed(
                                context, 'petscreen');
                          } else if (errorMessage == '500') {
                            customToast('Error updating pet', context);
                            petForm.isLoading = false;
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
