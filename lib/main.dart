import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/cubit/cubit.dart';
import 'package:flutter_application_2/cubit/states.dart';
import 'package:flutter_application_2/myApp/profile.dart';


import 'package:flutter_application_2/social_login/social_login_screen.dart';
import 'package:flutter_application_2/social_register/social_register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'myApp/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    /*options: FirebaseOptions(
      apiKey: "XXX",
      appId: "XXX",
      messagingSenderId: "XXX",
      projectId: "XXX",
    ),*/
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {}, 
          builder: (context, state) {
            return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home:SocialLoginScreen(),
        theme: ThemeData(
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.white,
      // ignore: prefer_const_constructors
      appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      
      // ignore: prefer_const_constructors
      
      backgroundColor: Colors.teal,//Color.fromRGBO(255, 255, 255, 1)
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      ),
      
    ),
     darkTheme: ThemeData(
        drawerTheme:DrawerThemeData(
          backgroundColor: Colors.black12, ),//HexColor('333739')
                primarySwatch: Colors.teal,
                scaffoldBackgroundColor: HexColor('333739'),//HexColor('333739')
                appBarTheme: AppBarTheme(
                  titleSpacing: 20.0,
                  
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.black12,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  backgroundColor:  Color.fromARGB(255, 34, 31, 31),
                  elevation: 0.0,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.teal,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.teal,
                  unselectedItemColor: Colors.grey,
                  elevation: 20.0,
                  backgroundColor: Colors.black12,
                ),
                textTheme: TextTheme(
                  bodyText1: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
               themeMode:
                  AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
      
    );
            
          }
          ),
    );
  }
}
