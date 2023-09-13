import 'package:firebase_core/firebase_core.dart';
import 'package:myplatform/pages/home.dart';
import 'package:myplatform/pages/login.dart';
import 'package:myplatform/pages/sign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myplatform/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
Future BgMessage(RemoteMessage message) async{
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //every time if async in main
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // androidProvider: AndroidProvider.debug,
  );
  FirebaseMessaging.onBackgroundMessage(BgMessage);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthP(),
    ),
  ],
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'home': (context){
          var prov = Provider.of<AuthP>(context);
          return HomePage(prov.user);
        },
        'login': (context) => LoginPage(),
        'sign': (context) => SignUpPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'طريق النجاح',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xff01953D),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Color(0xffffffff),
              fontSize: 18
          ),
          bodyMedium: TextStyle(
              color: Colors.black87,
              fontSize: 18
          ),
        ),
        colorScheme: const ColorScheme(
          background: Color(0xfff6f9ff),
          brightness: Brightness.light,
          primary: Color(0xff01953D),
          onPrimary: Color(0xff0f9b48),
          secondary: Color(0xff2E2777),
          onSecondary: Color(0xff3b3391),
          error: Color(0xffff0000),
          onError: Color(0xfff80909),
          onBackground: Color(0xff01953D),
          surface: Color(0xffffffff),
          onSurface: Color(0xff000111),),
      ),
      home:_ShowHome(context),
    );
  }
  Widget _ShowHome(context){
    var Prov = Provider.of<AuthP>(context);
    switch(Prov.authStatus){
      case AuthStatus.authenticating:
      case AuthStatus.unAuthenticated:
        return LoginPage();
      case AuthStatus.authenticated:
        return HomePage(Prov.user);
    }
  }
}


