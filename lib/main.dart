import 'package:app_veterinary/providers/providers.dart';
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
        routes: {
          'home': (_) => const HomeScreen(),
          'login': (_) =>  LoginScreen(),
          'register': (_) =>  RegisterScreen(),
        },
        scaffoldMessengerKey: NotificationsService.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)),
      ),
    );
  }
}