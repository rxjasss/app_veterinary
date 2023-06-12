import 'package:app_veterinary/providers/providers.dart';
import 'package:app_veterinary/screens/appointments_pet_screen.dart';
import 'package:app_veterinary/screens/messages_veterinary_screen.dart';
import 'package:app_veterinary/screens/new_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_veterinary/screens/screens.dart';
import 'package:app_veterinary/services/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
          lazy: false,
        ),
       
        ChangeNotifierProvider(
          create: (_) => VerifyService(),
          lazy: false,
        ),

        ChangeNotifierProvider(
          create: (_) => ReportService(),
          lazy: false,
        ),

        ChangeNotifierProvider(
          create: (_) => ReportProvider(),
          lazy: false,
        ),

        ChangeNotifierProvider(
          create: (_) => PetService(),
          lazy: false,
        ),

        ChangeNotifierProvider(
          create: (_) => PetProvider(),
          lazy: false,
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: LoadingScreen(),
      // ignore: avoid_print
      whenOffline: () => LoadingScreen,
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'app_veterinary',
        initialRoute: 'login',
        onGenerateRoute: (settings) {
          if (settings.name == 'newmessagescreen') {
            final int id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => NewMessageScreen(idVeterinary: id),
            );
          }else if(settings.name == 'appointmentspetscreen'){
            final int id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => AppointmentsPetScreen(idPet: id),
            );
          }else if(settings.name == 'newappointmentscreen'){
            final int id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => NewAppointmentScreen(idPet: id),
            );
          }
          else if(settings.name == 'updatepetscreen'){
            final int id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => UpdatePetScreen(idPet: id),
            );
          }
          return null;
        },
        routes: {
          'home': (_) => const HomeScreen(),
          'login': (_) =>  LoginScreen(),
          'register': (_) =>  RegisterScreen(),
          'userscreen': (_) =>  UserScreen(),
          'veterinaryscreen': (_) =>  VeterinaryScreen(),
          'updateuserscreen': (_) => UpdateUserScreen(),
          'messagesuserscreen': (_) => MessagesUserScreen(),
          'messagesveterinaryscreen': (_) => MessagesVeterinaryScreen(),
          'petscreen': (_) => PetScreen(),
          'newpetscreen': (_) => NewPetScreen(),
        },
        scaffoldMessengerKey: NotificationsService.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(elevation: 0, color: Color.fromARGB(255, 36, 57, 247)),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blue, elevation: 0)),
      ),
    );
  }
}