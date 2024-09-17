import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_track_ui/screen/Login_Screen.dart';
import 'package:gas_track_ui/screen/onBoardScreen.dart';
import 'package:gas_track_ui/screen/splash_screen.dart';
import 'package:gas_track_ui/screen/welcome_screen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const String splashScr = 'splashScreen';
  static const String welcomeScr = 'welcomeScreen';
  static const String loginScr = 'loginScreen';
  static const String onboardScr = 'onBoardScreen';
  // static const String onBoardScr = 'onBoardScreen';
  // static const String recoverPassScr = 'recoverPassword';


  @override
  void initState() {
    // init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: MyColors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: MyColors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Gas Track',
      routes: <String, WidgetBuilder>{
        splashScr: (BuildContext context) => const SplashScreen(),
        welcomeScr: (BuildContext context) => const SplashScreen(),
        loginScr: (BuildContext context) => const LoginScreen(),
        onboardScr: (BuildContext context) => const OnBoardScreen(),
      },
      initialRoute: loginScr,
      navigatorKey: navigatorKey,
      home: const MyHomePage(title: 'Gas Track'),
    );
  }
}

class MyColors {
  static const MaterialColor pink = MaterialColor(
    0xFFFF4CBB,
    <int, Color>{
      50: Color(0xFFFF4CBB),
      100: Color(0xFFFF4CBB),
      200: Color(0xFFFF4CBB),
      300: Color(0xFFFF4CBB),
      400: Color(0xFFFF4CBB),
      500: Color(0xFFFF4CBB),
      600: Color(0xFFFF4CBB),
      700: Color(0xFFFF4CBB),
      800: Color(0xFFFF4CBB),
      900: Color(0xFFFF4CBB),
    },
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    // padding: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "images/welcome_icon.png",
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Forgot Your Password",
                    style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Please enter your email address below. You will receive a link to reset your password.",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      // fontSize: 20,
                      color: Colors.black,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Email Address",
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                // fontSize: 20,
                                color: Colors.black,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Example@gmail.com'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                // fontSize: 20,
                                color: Colors.black,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid password';
                              }
                              return null;
                            },
                            // onSaved: (val) => _password = val,
                            obscureText: passwordVisible,
                            decoration: InputDecoration(
                              hintText: 'XXXXXXXXXXXXXXX',
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        // fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      // const SizedBox(width: 5.0),
                      const Text(
                        "Remember me",
                        style: TextStyle(
                            color: Color(0xff646464),
                            fontSize: 12,
                            fontFamily: 'SourceSansPro'),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            //forgot password screen
                          },
                          child: const Text(
                            'Create an Account',
                            style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              // fontSize: 20,
                              // color: Colors.black,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                    width: 500,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primaryColorpink, // background
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        label: const Align(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                              // color: Colors.black,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
