import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';












class Constants {
  Constants._();

  static const login = "Login";
  static const forgot_password = "Forgot\nPassword";
  static const demo_mail =
      "Dear John Smith\n\nThank you for visiting AVK company during the above trade show in Germany.\n\nYou have shown interest in the following producyts:\n\nCommercial products\nDomestic products\n\nYou can read, download and view all\nproduct information according to the below links:";
  static const sub_heading_forgot_password =
      "Enter your email and we'll send you a one time password by email";
  static const error_login_credentials = "Username or password is incorrect";

  //edittext labels
  static const email = "Email";
  static const password = "Password";
  static const confirm_password = "Confirm Password";
  static const search = "Search";

  //edit text hints
  static const enterEmail = "Enter email";
  static const enterPassword = "Enter password";
  static const enterConfirmPassword = "Enter confirm password";
  static const searchHint = "search";
  static const name = "Name";
  static const title = "Title";
  static const phone = "Phone";
  static const address = "Address";
  static const zipcode = "zipcode";
  static const City = "City";
  static const company = "Company";
  static const country = "Country";
  static const Website = "Website";
  static const Permissiondate = "Permission date";
  static const Pleaseentervalidname = "Please enter a valid name";
  static const PleaseentervalidEmail = "Please enter a valid email address";
  static const Pleaseentervalidoption = "Please select an option";
}

class Dimensions {
  Dimensions._();

  static const dp0_05 = 0.05;
  static const dp0_1 = 0.1;
  static const dp0_2 = 0.2;
  static const dp0_3 = 0.3;
  static const dp0_4 = 0.4;
  static const dp0_6 = 0.6;
  static const dp2_0 = 2.0;
  static const dp5_0 = 5.0;
  static const dp8_0 = 8.0;
  static const dp10_0 = 10.0;
  static const dp15_0 = 15.0;
  static const dp20_0 = 20.0;
  static const dp30_0 = 30.0;
  static const dp40_0 = 40.0;
  static const dp50_0 = 50.0;
  static const dp80_0 = 80.0;
  static const dp100_0 = 100.0;
  static const dp150_0 = 150.0;
  static const dp300_0 = 300.0;
}

class ImageAssets {
  ImageAssets._();

  static const logo = " images/japanlogo.png";
}

class ColorPalette {
  ColorPalette._();

  static const textBlack = Colors.black87;
  static const textgray = Color(0xff8C8989);
  static const textgrayheding = Color(0xff646060);
  static const textred = Color(0xffE41D29);
  static const Choosegray = Color(0xff757575);
  static const textgrayOpacity = Color(0xff757575);
  static const white = Colors.white;

  // static const hintText = Colors.black26;
  static const hintText = Color(0xFF646060);
  static const subtext = Color(0xFF646060);
  static const lightGrey = Colors.black12;
  static const themePrimaryColor = Color(0xFF00BCD4);
  static const DividerColor = Color(0xFFB8B4B4);
  static const themeSecondaryColor = Color(0xFF26C6DA);
  static const themeAccentColor = Color(0xFF4DD0E1);
  static const red = Colors.red;
  static const yellow = Color(0xFFFFCC80);
  static const orange = Colors.orangeAccent;
  static const loaderBackground = Color(0xE0E0E0FF);
  static const textgreen = Color(0xff50E05F);
  static const borderColor = Color(0xff646060);
}

class FFamily {
  FFamily._();
}

class FWeight {
  FWeight._();
}

class FSize {
  FSize._();

  static const sp10 = 10.0;
  static const sp12 = 12.0;
  static const sp14 = 14.0;
  static const sp16 = 16.0;
  static const sp18 = 18.0;
  static const sp20 = 20.0;
  static const sp22 = 22.0;
  static const sp24 = 24.0;
  static const sp26 = 26.0;
  static const sp27 = 27.0;
  static const sp28 = 28.0;
  static const sp30 = 30.0;
  static const sp32 = 32.0;
  static const sp33 = 33.0;
  static const sp35 = 35.0;
  static const sp40 = 40.0;
}

class FTextStyle {


  // ****************testMob***************


  static const formfieldHeadingText = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 14,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w600
  );
  static const formfieldHeadingText16 = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 16,
      color: AppColors.Textcolorheading,
      fontWeight: FontWeight.w600);
  static const formfieldhintStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 16,
      // color: AppColors.Textcolorheadingblack,
      color:Colors.grey,
      fontWeight: FontWeight.w400
    // fontWeight: FontWeight.bold
  );
  static const saugataStyle = TextStyle(
    color: AppColors.bulletcolor,
    fontSize: 15,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w400,
  );

  static const assetstypeStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w500,
  );
  static const drwerStyle500 =  TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 16,
      color: AppColors.Textcolorheading,
      fontWeight: FontWeight.w600);
  static const shareWishStyle = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 18,
      color: AppColors.buttongrey,
      fontWeight: FontWeight.w700);
  static const shareItStyle = TextStyle(
    fontFamily: 'SourceSansPro',
    color: AppColors.Textcolorheadingblack,
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

  static const shipintilesStyle = TextStyle(
    fontFamily: 'SourceSansPro',
    color: AppColors.Textcolorheading,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const shipinheadingStyle = TextStyle(
    fontFamily: 'SourceSansPro',
    color: AppColors.Textcolorheading,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const sortheadingStyle = TextStyle(
    fontFamily: 'SourceSansPro',
    color: AppColors.Textcolorheading,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );


  static const sortdataStyle = TextStyle(
    fontFamily: 'SourceSansPro',
    color: AppColors.Textcolorheading,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const removeStyle = TextStyle(
    // textBaseline: ,
    color: Colors.grey,
    fontSize: 13,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.underline,

  );
  static const BrideStyle =TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 12,
      color: Colors.black,
      fontWeight:
      FontWeight.w600);
  static const addtobigStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 12,

      fontWeight:
      FontWeight.w600);
  static const threeStyle = TextStyle(
    color: AppColors.pricecolor,
    fontSize: 16,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w600,
  );
  static const arrowButtonforward =Icon(
    Icons.arrow_forward_ios,
    color: Colors.cyan,
    size: 18,
  );




  // ****************Prize Heading***************
  static const paragrphStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolorgreay,
      fontWeight: FontWeight.w400);
  static const SidemenuTextStyle = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 16,
      color: AppColors.Textcolorheading,
      fontWeight: FontWeight.w400);



  static const SidemenuinsideTextStyle = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 16,
      color: AppColors.primaryColorpink,
      fontWeight: FontWeight.w400);

  static const decStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w400);

  static const dropdownin = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 16,
      color: Colors.black,
      fontWeight:
      FontWeight.w600);
  static const SkUStyle = TextStyle(
    fontFamily: 'SourceSansPro',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.Textcolorgreay,
    // decoration: TextDecoration.lineThrough,
  );

  static const H1Headings = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 18,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w600);


  static const H1Headings21 = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 18,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w400);
  static const H1Headings15 = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w600);
  static const bulletpoint = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 18,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w600);
  static const H1option15 = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolor,
      fontWeight: FontWeight.w400);

  static const prizeStyle3 = TextStyle(
    color:
    AppColors.pricecolor,
    fontSize: 16,
    fontFamily:
    "SourceSansPro",
    fontWeight:
    FontWeight.w600,
  );
  static const FreeStyle = TextStyle(
    color:
    AppColors.pricecolor,
    fontSize: 15,
    fontFamily:
    "SourceSansPro",
    fontWeight:
    FontWeight.w600,
  );
  static const prizeStyle5 = TextStyle(
    fontFamily:
    'SourceSansPro',
    fontSize: 14,
    fontWeight:
    FontWeight.w400,
    color: AppColors.Textcolorgreay,
    decoration: TextDecoration
        .lineThrough,
  );
  static const offprizeStyle = TextStyle(
    color: AppColors.pricecolor,
    fontSize: 14,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w400,
  );
  static const inculedingStyle = TextStyle(
    color: Colors.grey,
    fontFamily: 'SourceSansPro',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    // decoration: TextDecoration.lineThrough,
  );
  static const shipingStyle =  TextStyle(
    fontSize: 14,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w600,
  );
  static const shipingfreeStyle =  TextStyle(
    color: AppColors.pricecolor,
    fontSize: 14,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w600,
  );
  static const shizStyle =  TextStyle(
    decoration: TextDecoration.underline,
    fontFamily: 'SourceSansPro',
    color: Colors.grey,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static const retedStyle =  TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w600,
    // decoration: TextDecoration.lineThrough,
  );
  static const retedStyle4 =  TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w600,
    // decoration: TextDecoration.lineThrough,
  );
  static const rewieStyle =  TextStyle(
    decoration:
    TextDecoration.underline,
    color: Colors.grey,
    // fontSize: 16,
    fontFamily: "SourceSansPro",
    fontWeight: FontWeight.w600,
  );
  static const KnowourStyle =  TextStyle(
    fontFamily: 'SourceSansPro',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static const KnowourBlueStyle =  TextStyle(
    decoration: TextDecoration.underline,
    fontFamily: 'SourceSansPro',
    color: Colors.blue,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static const poducthedingStyle =  TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w600);
  static const addtobagStyle =  TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 16,
      // color: Colors.black,
      fontWeight: FontWeight.w700);


  static const khomeheadingStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 21,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w600);

  static const khomesubheadingStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w400);
  static const Sizechartunder = TextStyle(
      decoration: TextDecoration.underline,
      fontFamily: 'SourceSansPro',
      fontSize: 15,
      color: AppColors.Textcolorheadingblack,
      fontWeight: FontWeight.w400);
  static const subheadingStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 14,
      color:  AppColors.bulletcolor,
      fontWeight: FontWeight.w400);
  //
  static const ksearchheadingStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600
      // fontWeight: FontWeight.bold
      );

  static const TextStyle requiredFieldTextStyle = TextStyle(
    color: Color(0xFFCB4551),
    fontSize: 12,
  );






  static const headingStyle = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  static const chipstextStyle =  TextStyle(
      fontFamily: 'SourceSansPro',
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w400);


  static const Readmore = TextStyle(
    fontFamily: 'SourceSansPro',
    color: Colors.blue,
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

}

class NWidgets {
  NWidgets._();

  static blueGrad() =>
      const LinearGradient(begin: Alignment.topCenter, colors: [
        ColorPalette.themePrimaryColor,
        ColorPalette.themeAccentColor,
        ColorPalette.themeSecondaryColor
      ]);


  static kheadinghome(context, heading) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          heading,
          style: FTextStyle.khomeheadingStyle,
        ),
      );
  static ksizedBox(context) => SizedBox(
    height:  20,
  );
  static ksizedBox15(context) => SizedBox(
    height:  15,
  );
  static ksizedBox10(context) => SizedBox(
    height:  10,
  );
  static ksizedBox5(context) => SizedBox(
    height:  5,
  );
  static ksizedBox30(context) => SizedBox(
    height:  30,
  );
  //
  static kheadingsearch(context, heading) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      heading,
      style: FTextStyle.ksearchheadingStyle,
    ),
  );
  static divider(context) =>  Divider(
  // height: 10,
  // color: AppColors.Textcolorgreay,
  );
  static dividerlight(context) =>    Divider(
    height: 10,
  );



  static kappbarheading(context, heading) => Text(
    heading.toUpperCase(),
    style: const TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 16,
        color: AppColors.Textcolorheadingblack,
        fontWeight: FontWeight.w400),
  );


}
