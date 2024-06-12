import 'package:flutter/material.dart';
import 'package:gas_track_ui/utils/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: AppColors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.pinkAccent,
        //   title: Text(widget.title),
        // ),
        body: Padding(
          // padding: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.020,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "images/welcome_icon.png",
                      // height: 71,
                      // width: 77,
                      width: 97,
                      height: 90,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.020,
                  ),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 40,
                        color: AppColors.Textcolorheading,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Utsav ',
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 20,
                            )),
                        const TextSpan(
                          text: 'fashion',
                          style: TextStyle(
                            color: AppColors.primaryColorpink,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.030,
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: AppColors.bordercontainergreyinside,
                        border: Border.all(color: AppColors.bordergrey)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Image.asset('images/socialImg/Google.png'),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
                          child: Text(
                            "Continue with Google",
                            style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: AppColors.bordercontainergreyinside,
                        border: Border.all(color: AppColors.bordergrey)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Image.asset('images/socialImg/Facebook.png'),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
                          child: Text(
                            "Continue with Facebook",
                            style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(
                        child: Divider(
                          indent: 20.0,
                          endIndent: 10.0,
                          thickness: 1,
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10.0,
                          endIndent: 20.0,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: AppColors.bordercontainergreyinside,
                            border: Border.all(color: AppColors.bordergrey)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Image.asset('images/Mail.png'),
                                iconSize: 25,
                                onPressed: () {},
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
                              child: Text(
                                "Continue with Email",
                                style: TextStyle(
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // Utils.checkLogin=true;
                        // PrefUtils.setLogin(true);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const loginScreen()));
                        // (Route<dynamic> route) => false);
                      }),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  TextButton(
                    onPressed: () {
                      // Utils.checkLogin=false;
                      // // PrefUtils.setLogin(false);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const NavBarBottom(selectedIndex: 0)),
                      //         (Route<dynamic> route) => false
                      // );
                      // (Route<dynamic> route) => false);
                      //signup screen
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(30, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      "Continue as a Guest",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: AppColors.underlineTextcolorheading,
                              offset: Offset(0, -2))
                        ],
                        decoration: TextDecoration.underline,
                        fontFamily: 'SourceSansPro',
                        color: Colors.transparent,
                        fontWeight: FontWeight.w600,
                        decorationColor: AppColors.underlineTextcolorheading,
                        decorationThickness: 1.5,
                        fontSize: 17,
                        decorationStyle:
                        TextDecorationStyle.solid,
                      ),
                      // style: TextStyle(
                      //   decoration: TextDecoration.underline,
                      //   fontFamily: 'SourceSansPro',
                      //   color: AppColors.underlineTextcolorheading,
                      //   decorationStyle: TextDecorationStyle.solid,
                      //   fontWeight: FontWeight.w600,
                      //   decorationThickness: 1.0,
                      //   fontSize: 17,
                      // ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
