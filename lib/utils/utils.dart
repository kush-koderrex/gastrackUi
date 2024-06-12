import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_track_ui/utils/widgets.dart';


import 'app_colors.dart';



class Palette {
  static const MaterialColor kTolight = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      10:   Color(0xffffffff), //10%
      50:   Color(0xffce5641), //10%
      100:   Color(0xffb74c3a), //20%
      200:   Color(0xffa04332), //30%
      300:   Color(0xff89392b), //40%
      400:   Color(0xff733024), //50%
      500:   Color(0xff5c261d), //60%
      600:   Color(0xff451c16), //70%
      700:   Color(0xff2e130e), //80%
      800:   Color(0xff170907), //90%
      900:   Color(0xff000000), //100%
    },
  );
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below.


class Utils {
  static BuildContext? _loaderContext;
  static BuildContext? _loadingDialoContext;
  static bool _isLoaderShowing = false;
  static bool _isLoadingDialogShowing = false;
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;
  static String model = '';
  static String osVersion = '';
  static String platform = '';
  static String imei = '';
  static String currentAddress = '';
  static String loaction = '';
  static var latitude;
  static var longitude;
  static var checkLogin;

  static String userpic = '';
  static String userlastlogin = '';
  static String userName = '';
  static String userkey = '';
  static String Devicesid = '';
  static String TOKEN = '';
  static String resetTpin = '';
  static String indexname = '';
  // var indexname;
  static Map Accountdata = {};
  static List<Map<String, dynamic>> submenu = [];
  static List<Map<String, dynamic>> menu = [
    {
      "name": "Saree",
      "Menu": [
        {
          "subname": "Occasion",
          "submenu": [
            {
              "name": "Wedding wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-pure-silk-handloom-saree-in-red-v1-smua137.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-light-purple-v1-ssf16661.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-sbha1722.jpg",
              ],
            },
            {
              "name": "Party wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-wine-and-golden-v1-spta11673.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-navy-blue-v1-syc11268.jpg",
              ],
            },
            {
              "name": "Bridal wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-satin-silk-saree-in-red-v1-scba1755.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-satin-silk-saree-in-red-v1-scba1755.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-art-silk-saree-in-off-white-v1-spta11616.jpg"
              ],
            },
            {
              "name": "Festive wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Casual wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Bollywood wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Embroidered Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-teal-green-v1-spta11611.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Printed Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-crepe-saree-in-light-beige-v1-sew13160.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/i/k/ikat-printed-art-silk-saree-in-teal-blue-v1-sfba623.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "South Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-black-v1-smua151.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Woven Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-multicolor-v1-syc10306.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Regional Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/a/patola-woven-art-silk-saree-in-multicolor-v1-ssf18151.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/a/patola-art-silk-saree-in-purple-v1-spta11647.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Half & Half Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/h/a/half-n-half-art-silk-saree-in-mustard-and-red-v1-swna104.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/e/sequinned-crepe-half-n-half-saree-in-wine-and-black-v1-sfla531.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/e/sequinned-crepe-half-n-half-saree-in-wine-and-black-v1-sfla531.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "All Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-yellow-v1-spta11671.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Fabric",
          "submenu": [
            {
              "name": "Cotton wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Silk Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-cotton-silk-saree-in-peach-v1-sma7587.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Art Silk Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Georgette Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-saree-in-navy-blue-v1-scba4430.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-saree-in-navy-blue-v1-scba4430.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-saree-in-navy-blue-v1-scba4430.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Chiffon Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "All Fabrics",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
          ],
        },
        {
          "subname": "More",
          "submenu": [
            {
              "name": "Blouse",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-back-cut-out-blouse-in-sky-blue-v2-uac161.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embellished-art-silk-blouse-in-black-v1-uxc708.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Petticoats",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/u/uub44.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/u/uub138.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/u/uub138.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/u/uub138.jpg",
              ],
            },
            {
              "name": "HandBags",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/k/dkj2389.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/k/dkj2389.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/k/dkj2389.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/k/dkj2389.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/k/dkj2389.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Salwar Kameez",
      "Menu": [
        {
          "subname": "Occasion",
          "submenu": [
            {
              "name": "Festive wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-navy-blue-v1-kch10655.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-rayon-a-line-suit-in-yellow-v1-kaf353.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-navy-blue-v1-kch10655.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-rayon-a-line-suit-in-yellow-v1-kaf353.jpg",
              ],
            },
            {
              "name": "Party wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-abaya-style-suit-in-royal-blue-v1-kch10673.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/c/kch919.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/c/kch919.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/c/kch919.jpg",
              ],
            },
            {
              "name": "Weding wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-maroon-v3-kch2920.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-dusty-pink-v1-kch2618.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-dusty-pink-v1-kch2618.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-dusty-pink-v1-kch2618.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-dusty-pink-v1-kch2618.jpg",
              ],
            },
            {
              "name": "Casual wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-rayon-anarkali-suit-in-black-v1-kmm97.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-crepe-pakistani-suit-in-grey-v1-kcv1816.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-crepe-pakistani-suit-in-grey-v1-kcv1816.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-crepe-pakistani-suit-in-grey-v1-kcv1816.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-crepe-pakistani-suit-in-grey-v1-kcv1816.jpg",
              ],
            },
            {
              "name": "Bollywood wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-crepe-pakistani-suit-in-grey-v1-kcv1816.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
              ],
            },
            {
              "name": "All Occasions",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-abaya-style-suit-in-old-rose-v2-kch1009.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Anarkali Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embellished-cotton-anarkali-suit-in-off-white-v1-krx102.jpg",
              ],
            },
            {
              "name": "Straight Cut Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-straight-suit-in-dark-teal-green-v1-kch1337_4.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-satin-georgette-straight-suit-in-dark-green-v1-kch3252.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-satin-georgette-straight-suit-in-dark-green-v1-kch3252.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-satin-georgette-straight-suit-in-dark-green-v1-kch3252.jpg",
              ],
            },
            {
              "name": "Abaya Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-beige-v1-kej1127.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-faux-georgette-abaya-style-suit-in-dark-purple-v1-kch2454.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-faux-georgette-abaya-style-suit-in-dark-purple-v1-kch2454.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-faux-georgette-abaya-style-suit-in-dark-purple-v1-kch2454.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-faux-georgette-abaya-style-suit-in-dark-purple-v1-kch2454.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-faux-georgette-abaya-style-suit-in-dark-purple-v1-kch2454.jpg",
              ],
            },
            {
              "name": "Pakistani Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-navy-blue-v1-kch10655.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
              ],
            },
            {
              "name": "Punjabi Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-punjabi-suit-in-mustard-v1-kch10790.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-punjabi-suit-in-mustard-v1-kch10790.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-punjabi-suit-in-mustard-v1-kch10790.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-punjabi-suit-in-mustard-v1-kch10790.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-punjabi-suit-in-mustard-v1-kch10790.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-punjabi-suit-in-mustard-v1-kch10790.jpg",
              ],
            },
            {
              "name": "All Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-navy-blue-v1-kch10655.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-beige-v1-kch10653.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Fabric",
          "submenu": [
            {
              "name": "Chanderi Silk",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/o/gota-work-art-chanderi-cotton-pakistani-suit-in-off-white-v1-kmv83.jpg",
              ],
            },
            {
              "name": "Georgette Suits",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-magenta-v1-kch10645.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-magenta-v1-kch10645.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-magenta-v1-kch10645.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-magenta-v1-kch10645.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-pakistani-suit-in-magenta-v1-kch10645.jpg",
              ],
            },
            {
              "name": "Cotton Suits",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-flex-anarkali-suit-in-white-v1-kmm102.jpg",
              ]
            },
            {
              "name": " Net Salwar Suit",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-abaya-style-suit-in-light-beige-and-white-v1-kch1150.jpg",
              ],
            },
            {
              "name": " Art Silk Salwar Kameez",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
              ]
            },
            {
              "name": "All Fabric",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-abaya-style-suit-in-fuchsia-v1-kch3711.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Alternates",
          "submenu": [
            {
              "name": "Kurtas",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/f/o/foil-printed-rayon-cowl-style-kurta-in-fuchsia-v1-tew102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/f/o/foil-printed-rayon-cowl-style-kurta-in-fuchsia-v1-tew102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/f/o/foil-printed-rayon-cowl-style-kurta-in-fuchsia-v1-tew102.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/f/o/foil-printed-rayon-cowl-style-kurta-in-fuchsia-v1-tew102.jpg",
              ],
            },
            {
              "name": "Tunics",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-satin-silk-a-line-skirt-in-green-v1-bsm74.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-anarkali-kurta-in-sky-blue-v1-tgw2737.jpg",
              ],
            },
            {
              "name": "Dupattasr",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-cotton-jacquard-dupatta-from-banaras-in-sky-blue-v1-btz341.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/a/banarasi-dupatta-in-navy-blue-v1-btz364.jpg",
              ],
            },
            {
              "name": "Gowns",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-gown-in-navy-blue-v1-tve528.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/c/o/color-blocked-rayon-asymmetric-kurta-in-mustard-v1-tve527.jpg",
              ],
            },
            {
              "name": "Bottoms",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-cotton-jacquard-dupatta-from-banaras-in-sky-blue-v1-btz341.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/a/banarasi-dupatta-in-navy-blue-v1-btz364.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-cotton-jacquard-dupatta-from-banaras-in-sky-blue-v1-btz341.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/a/banarasi-dupatta-in-navy-blue-v1-btz364.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Lehenga",
      "Menu": [
        {
          "subname": "Occasion",
          "submenu": [
            {
              "name": "wedding wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-wine-v1-lcs410.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
              ],
            },
            {
              "name": "Party wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-and-satin-lehenga-in-teal-blue-v1-lsw38.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-teal-blue-v1-lcc2167.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-and-satin-lehenga-in-teal-blue-v1-lsw38.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-teal-blue-v1-lcc2167.jpg",
              ],
            },
            {
              "name": "Bridal wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-beige-v1-lyc1369.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-beige-v1-lyc1369.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
              ],
            },
            {
              "name": "Festive wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/r/u/ruffled-georgette-lehenga-in-wine-v1-lcc1267.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/r/u/ruffled-georgette-lehenga-in-wine-v1-lcc1267.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/r/u/ruffled-georgette-lehenga-in-wine-v1-lcc1267.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/r/u/ruffled-georgette-lehenga-in-wine-v1-lcc1267.jpg",
              ],
            },
            {
              "name": "Casual wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Bollywood wear",
              "Bollywood wear": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/r/u/ruffled-georgette-lehenga-in-wine-v1-lcc1267.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-lehenga-in-brown-v1-lcs411.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/r/u/ruffled-georgette-lehenga-in-wine-v1-lcc1267.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Circular Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-lehenga-in-dark-green-v1-lyc1120.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-lehenga-in-dark-blue-v1-lyc1111.jpg",
              ]
            },
            {
              "name": "A-Line Lehenga",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-lehenga-in-yellow-v1-lyc1613.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-beige-v1-lyc1618.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-lehenga-in-yellow-v1-lyc1613.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-beige-v1-lyc1618.jpg",
              ],
            },
            {
              "name": "Mermaid Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/u/luf501.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/j/ljn837.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/j/ljn837.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/j/ljn837.jpg",
              ],
            },
            {
              "name": "Indo Western",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-navy-blue-v1-lcc458.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-lcc955.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-lcc955.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-lcc955.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-lcc955.jpg",
              ],
            },
            {
              "name": "All Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/u/luf501.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/j/ljn837.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/l/j/ljn837.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-navy-blue-v1-lcc458.jpg",
              ]
            },
          ],
        },
        {
          "subname": "Fabric",
          "submenu": [
            {
              "name": "Art Silk Lehenga",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-taffeta-silk-lehenga-in-navy-blue-v1-lyc927.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-lehenga-in-dark-green-v2-lyc933.jpg",
              ],
            },
            {
              "name": "Net Lehenga",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-blue-v1-lxw865.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-grey-v1-lcc1212.jpg",
              ],
            },
            {
              "name": "Georgette Lehen",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-blue-v1-lxw865.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-net-lehenga-in-grey-v1-lcc1212.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Alternates",
          "submenu": [
            {
              "name": "Grown ",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Abaya Style Suit",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Lehenga Style Saree",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Men",
      "Menu": [
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Kurta",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-jacquard-kurta-in-blue-v1-mht350.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-sherwani-in-navy-blue-v1-muy424.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-sherwani-in-navy-blue-v1-muy424.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-sherwani-in-navy-blue-v1-muy424.jpg",
              ],
            },
            {
              "name": "Sherwani",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-collar-velvet-sherwani-in-black-v1-mte1450.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-jacquard-layered-sherwani-in-black-v1-muy472.jpg",
              ],
            },
            {
              "name": "Bandhgala",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-terry-rayon-jodhpuri-suit-in-black-v1-mhg968.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-terry-rayon-jodhpuri-suit-in-black-v1-mhg968.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-terry-rayon-jodhpuri-suit-in-black-v1-mhg968.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-terry-rayon-jodhpuri-suit-in-navy-blue-v1-mhg972.jpg",
              ],
            },
            {
              "name": "Kurta Pajama",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-cotton-kurta-set-in-pink-v1-mly219.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-sherwani-in-pink-v1-muy512.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-sherwani-in-pink-v1-muy512.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-sherwani-in-pink-v1-muy512.jpg",
              ],
            },
            {
              "name": "Nehru jackets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-nehru-jacket-in-green-v1-mte1455.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-nehru-jacket-in-green-v1-mte1455.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-nehru-jacket-in-green-v1-mte1455.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-matka-silk-nehru-jacket-in-maroon-v4-mzj21.jpg",
              ],
            },
          ],
        },
        {
          "subname": "More Styles",
          "submenu": [
            {
              "name": "Pathani Suit",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-cotton-pathani-suit-in-yellow-v3-mtr2319.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-cotton-kurta-set-in-light-yellow-v1-mjy162.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-cotton-kurta-set-in-light-yellow-v1-mjy162.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-cotton-kurta-set-in-light-yellow-v1-mjy162.jpg",
              ],
            },
            {
              "name": "Dhoti Kurta",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-dhoti-kurta-in-pink-v1-mly597.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-dhoti-kurta-in-pink-v1-mly597.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/r/printed-cotton-dhoti-kurta-in-pink-v1-mly597.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-cotton-kurta-set-in-blue-v1-mly611.jpg",
              ],
            },
            {
              "name": "Mens Lower",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-turban-in-maroon-and-beige-v1-mgm44.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
              ],
            },
            {
              "name": "Blazer/ Suits/ Jackets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-blazer-in-black-v1-mte1485.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-dupion-silk-dhoti-in-maroon-v1-mte1497.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-dupion-silk-dhoti-in-maroon-v1-mte1497.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-dupion-silk-dhoti-in-maroon-v1-mte1497.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/o/solid-color-dupion-silk-dhoti-in-light-beige-v1-mte1504.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Occasions",
          "submenu": [
            {
              "name": "Party Wear For Mens",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-jacquard-asymmetric-sherwani-in-light-green-v1-mgv1373.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-jacquard-asymmetric-sherwani-in-light-green-v1-mgv1373.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-jacquard-asymmetric-sherwani-in-light-green-v1-mgv1373.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/a/patola-printed-art-silk-nehru-jacket-in-sea-green-v1-mte1015.jpg",
              ],
            },
            {
              "name": "Mens Wedding Wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-nehru-jacket-in-black-v1-mxx131.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-nehru-jacket-in-black-v1-mxx131.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-nehru-jacket-in-black-v1-mxx131.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-nehru-jacket-in-black-v1-mxx131.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-nehru-jacket-in-black-v1-mxx131.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-velvet-nehru-jacket-in-black-v1-mxx131.jpg",
              ],
            },
            {
              "name": "Casual Wear For Mens",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/l/block-printed-pure-cotton-kurta-set-in-light-beige-v1-mee1225.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/l/block-printed-pure-cotton-kurta-set-in-light-beige-v1-mee1231.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/l/block-printed-pure-cotton-kurta-set-in-light-beige-v1-mee1231.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/l/block-printed-pure-cotton-kurta-set-in-light-beige-v1-mee1231.jpg",
              ],
            },
            {
              "name": " Mens Festival Wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/m/g/mgv138.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-sherwani-in-black-v1-muy431.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-sherwani-in-black-v1-muy431.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-sherwani-in-black-v1-muy431.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Accessories",
          "submenu": [
            {
              "name": "Turban / Pagri",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-dupion-silk-turban-in-off-white-v1-mgm216.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-dupion-silk-turban-in-off-white-v1-mgm216.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-dupion-silk-turban-in-off-white-v1-mgm216.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-dupion-silk-turban-in-off-white-v1-mgm216.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-dupion-silk-turban-in-off-white-v1-mgm216.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/f/o/foil-printed-art-silk-turban-in-red-v1-mgm236.jpg",
              ],
            },
            {
              "name": "Kantha",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/p/e/pearl-layered-kanthimala-v1-mte1200.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "IndoWestern",
      "Menu": [
        {
          "subname": "Occasion",
          "submenu": [
            {
              "name": "wedding wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Party wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Bridal wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Festive wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Casual wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Bollywood wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Kurtis",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": " Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Long Kurtas",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Top & Bottom Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Growns",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "All Styles",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Bottoms",
          "submenu": [
            {
              "name": "Skirts",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Palazzo pants",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Patialas",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Laggings",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Pants & Trousers",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
          ],
        },
        {
          "subname": "More",
          "submenu": [
            {
              "name": "Stoles & Scarves",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Dupattas",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Jackets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Tops",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": " Indowestern Lehenga",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Plus",
      "Menu": [
        {
          "subname": "Occasion",
          "submenu": [
            {
              "name": "wedding wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Party wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Bridal wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Festive wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Casual wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Bollywood wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "All wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Salwar kameez",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Indowestern",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Sarees",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "More Styles",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Casual wear",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Fabric",
          "submenu": [
            {
              "name": "Georgette  ",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Net",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Art Silk",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Velvet",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "All Fabrics",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Favorites",
          "submenu": [
            {
              "name": "Abaya Style Suits",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Kurtas",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Bottoms",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Straight Cut Suits",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Jewelry",
      "Menu": [
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Earrings",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/e/beaded-enamel-filled-jhumka-style-earrings-v1-jkc4408.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/e/beaded-enamel-filled-jhumka-style-earrings-v1-jkc4408.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/e/beaded-enamel-filled-jhumka-style-earrings-v1-jkc4408.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/b/e/beaded-enamel-filled-jhumka-style-earrings-v1-jkc4408.jpg",
              ],
            },
            {
              "name": "Neckleaces",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/t/stone-studded-peacock-style-brahmi-nath-v1-jpm5901.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/t/stone-studded-peacock-style-brahmi-nath-v1-jpm5901.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/s/t/stone-studded-peacock-style-brahmi-nath-v1-jpm5901.jpg",
              ],
            },
            {
              "name": "Bangle & Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Rings",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Anklets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "More Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Work",
          "submenu": [
            {
              "name": "American Diamonds",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Stone Studded",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Pearls",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Kundan",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Meenakari",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "All Works",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Wedding Box",
          "submenu": [
            {
              "name": "Maang Tikka",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Nose Rings",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Bridal Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Hand Jewelry",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Mangalsutra",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Style",
          "submenu": [
            {
              "name": "Chokers",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Chandbalis",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Jhumkas",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Ear Cuffs",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
            {
              "name": "Bracelets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/u/kundan-bridal-set-v1-jmy1697.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Concepts",
      "Menu": [
        {
          "subname": "New Curations",
          "submenu": [
            {
              "name": "Royal Heritage",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Embroidered Blouses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Geometric Designs",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Ultra Violet",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Flared Silhouettes",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Beautiful Bottoms",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Our Best Ever",
          "submenu": [
            {
              "name": "Bollywood Special",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Metallic Shades",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Slits",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Layered Attires",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Unusual Designs",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Patel Hues",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Wedding Stories",
          "submenu": [
            {
              "name": "Ring Ceremony",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Cocktail Party",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Haldi Ceremony",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Mehendi",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Sangeet Bash",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Bridal Shower",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Worth a Glance",
          "submenu": [
            {
              "name": "Classic Weaves",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Garden Party",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Earthy Tones",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Monotones",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Rich Embroideries",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Sheer Looks",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "Fashion Pefect",
          "submenu": [
            {
              "name": "Asymmetricals",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Collared Necklines",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Flower Show",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Jewel Tones",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Bright Hues",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Monochrome Style",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
      ],
    },
    {
      "name": "Kids",
      "Menu": [
        {
          "subname": "For Girls",
          "submenu": [
            {
              "name": "Lehenga Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
              ],
            },
            {
              "name": "Salwar Kameez",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
              ],
            },
            {
              "name": "Saree Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
              ],
            },
            {
              "name": "Ethnic Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-georgette-lehenga-in-mustard-v1-ukr482.jpg",
              ],
            },
          ],
        },
        {
          "subname": "For Boys",
          "submenu": [
            {
              "name": "Kurta Pyjama Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
              ],
            },
            {
              "name": "Kids Sherwani",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
              ],
            },
            {
              "name": "Kurta Dhoti Sets",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/u/n/und297.jpg",
              ],
            },
          ],
        },
        {
          "subname": "By Colors",
          "submenu": [
            {
              "name": "Purple Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Orange Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "White Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "Green Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
            {
              "name": "Yellow Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/d/i/digital-printed-georgette-saree-in-off-white-and-pink-v1-sbha1427.jpg",
              ],
            },
            {
              "name": "Red Dress",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-teal-blue-v1-ssf20340.jpg",
              ],
            },
            {
              "name": "Blue Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-dark-green-v1-scba719.jpg",
              ],
            },
          ],
        },
        {
          "subname": "By Occasion",
          "submenu": [
            {
              "name": "Wedding Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/g/a/gadwal-handloom-saree-in-coral-pink-v1-smua150.jpg",
              ],
            },
            {
              "name": "Party Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/w/o/woven-art-silk-saree-in-pink-v1-syc11272.jpg",
              ],
            },
            {
              "name": "Festival Dresses",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/e/m/embroidered-art-silk-saree-in-red-v1-spf2506.jpg",
              ],
            },
            {
              "name": "View All",
              "imglist": [
                "https://medias.utsavfashion.com/media/catalog/product/cache/1/image/1000x/040ec09b1e35df139433887a97daa66f/k/a/kanchipuram-saree-in-off-white-v1-she4217.jpg",
              ],
            },
          ],
        },
      ],
    },
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late BuildContext scaffoldContext;

  // static Future<String?> networkImageToBase64(dynamic imageUrl) async {
  //   http.Response response = await http.get(imageUrl);
  //   final bytes = response?.bodyBytes;
  //   return (bytes != null ? base64Encode(bytes) : null);
  // }

//  Checks
  static bool isNotEmpty(String s) {
    return s != null && s.trim().isNotEmpty;
  }

  static bool isEmpty(String s) {
    return !isNotEmpty(s);
  }

  static bool isListNotEmpty(List<dynamic> list) {
    return list != null && list.isNotEmpty;
  }

  static Future<List<int>> readImageData(String name) async {
    final ByteData data = await rootBundle.load('$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  static Future<List<int>> readImageDataFromServer(ByteData data) async {
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
  // static void showCustomToast(BuildContext context, String message,int duration){
  //   showToast(
  //     message,
  //     context: context,
  //     textPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
  //     textStyle: const TextStyle(fontSize: 13,color: Colors.white),
  //     backgroundColor: Colors.grey.shade900.withOpacity(0.75),
  //     animation: StyledToastAnimation.scale,
  //     reverseAnimation: StyledToastAnimation.fade,
  //     position: StyledToastPosition.top,
  //     animDuration: const Duration(milliseconds: 1500),
  //     duration:  Duration(seconds: duration),
  //     curve: Curves.elasticOut,
  //     reverseCurve: Curves.linear,
  //   );
  // }
  // static void showCustomToastCenter(BuildContext context, String message,int duration){
  //   showToast(
  //     message,
  //     context: context,
  //     textPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
  //     textStyle: const TextStyle(fontSize: 13,color: Colors.white),
  //     backgroundColor: Colors.grey.shade900.withOpacity(0.9),
  //     animation: StyledToastAnimation.scale,
  //     reverseAnimation: StyledToastAnimation.fade,
  //     position: StyledToastPosition.center,
  //     animDuration: const Duration(milliseconds: 1500),
  //     duration:  Duration(seconds: duration),
  //     curve: Curves.elasticOut,
  //     reverseCurve: Curves.linear,
  //   );
  // }

  static void showPicker(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (BuildContext bc) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                height: 300,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 50,
                          child: Divider(
                            thickness: 5,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      const Text('Blouse Size',
                          textScaleFactor: 1.0,
                          // style: FTextStyle.loginuserblack16,
                          textAlign: TextAlign.start),
                      Expanded(
                        child: SizedBox(
                          height: 250,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Divider(
                                    thickness: 1,
                                  ),
                                  InkWell(
                                    child: Text('28” blouse size',
                                        textScaleFactor: 1.0,
                                        style: FTextStyle.shareItStyle,
                                        textAlign: TextAlign.start),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }

  static void showPickerShipin(context,) {
    const dataItems = [
      'Ready to Ship',
      'Within 2 days',
      'Within 7 days',
      'Within 10 days',
      'Within 15 days',
      'More than 15 days',
    ];
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      context: context,
      builder: (BuildContext bc) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: 40,
                      child: Divider(
                        thickness: 3,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text("SHIPS IN",
                      textScaleFactor: 1.0,
                      style: FTextStyle.H1Headings15,
                      textAlign: TextAlign.start),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            const Divider(
                              height: 1,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Container(
                                  child: Text(
                                      // 'Within 2 days',
                                      dataItems[index],
                                      textScaleFactor: 1.0,
                                      style: FTextStyle.decStyle,
                                      textAlign: TextAlign.start),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showPickershort(context,) {
    const dataItemssort = [
      'Price Low to High',
      'Price High to Low',
      'New Arrivals',
      'Biggest Saving',
      'Best Sellers',
      'Most Viewed',
      'Now in Wishlists',
    ];
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (BuildContext bc) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                height: 300,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                          width: 40,
                          child: Divider(
                            thickness: 3,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text("SORT",
                          textScaleFactor: 1.0,
                          style: FTextStyle.H1Headings15,
                          textAlign: TextAlign.start),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.pink,
                          // height: 10,
                          child: ListView.builder(
                            itemCount: dataItemssort.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  const Divider(
                                    height: 1,
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: Container(
                                        child: Text(
                                            // 'Within 2 days',
                                            dataItemssort[index],
                                            textScaleFactor: 1.0,
                                            style: FTextStyle.decStyle,
                                            textAlign: TextAlign.start),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        });
  }

  static void ShowDialog(BuildContext context, String message) {
    Timer? timer = Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                // Bottom rectangular box
                margin: EdgeInsets.only(
                    top: 40), // to push the box half way below circle
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.only(
                    top: 60, left: 20, right: 20), // spacing inside the box
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                child: CircleAvatar(
                  // Top Circle with icon
                  maxRadius: 40.0,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('images/japanlogo.png'),
                ),
              ),
            ],
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      context: context,
    );
    /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(  // Bottom rectangular box
                    margin: EdgeInsets.only(top: 40), // to push the box half way below circle
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 16,
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    child: CircleAvatar( // Top Circle with icon
                      maxRadius: 40.0,
                      backgroundColor: Colors.white,
                      child: Image.asset('images/japanlogo.png'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
           ).then((value){
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });*/
  }

  static void ShowDialoglogin(BuildContext context, String message) {
    // Timer? timer = Timer(const Duration(milliseconds: 3000), (){
    //   Navigator.of(context, rootNavigator: true).pop();
    // });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Dialog(
            child: Container(
              height: 300,
              width: 250,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "images/welcome_icon.png",
                        height: 55,
                        width: 60,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Utsav Fashion",
                    style: FTextStyle.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    message,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 12,
// color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
// (Route<dynamic> route) => false);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const loginScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorpink, // background
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 12,
// color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
// (Route<dynamic> route) => false);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorpink, // background
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(  // Bottom rectangular box
                    margin: EdgeInsets.only(top: 40), // to push the box half way below circle
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 16,
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    child: CircleAvatar( // Top Circle with icon
                      maxRadius: 40.0,
                      backgroundColor: Colors.white,
                      child: Image.asset('images/japanlogo.png'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
           ).then((value){
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });*/
  }

  static void ShowDialogAssitens(BuildContext context, String message) {
    // Timer? timer = Timer(const Duration(milliseconds: 3000), (){
    //   Navigator.of(context, rootNavigator: true).pop();
    // });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Dialog(
            child: Container(
              height: 300,
              width: 250,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "I am Yet",
                    style: FTextStyle.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    message,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 12,
// color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
// (Route<dynamic> route) => false);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const loginScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorpink, // background
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 12,
// color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
// (Route<dynamic> route) => false);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorpink, // background
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(  // Bottom rectangular box
                    margin: EdgeInsets.only(top: 40), // to push the box half way below circle
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 16,
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    child: CircleAvatar( // Top Circle with icon
                      maxRadius: 40.0,
                      backgroundColor: Colors.white,
                      child: Image.asset('images/japanlogo.png'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
           ).then((value){
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });*/
  }

  static void ShowDialogoption(BuildContext context, String message) {
    // Timer? timer = Timer(const Duration(milliseconds: 3000), (){
    //   Navigator.of(context, rootNavigator: true).pop();
    // });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Dialog(
            child: Container(
              height: 300,
              width: 250,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "images/welcome_icon.png",
                        height: 55,
                        width: 60,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Utsav Fashion",
                    style: FTextStyle.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    message,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 12,
// color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
// (Route<dynamic> route) => false);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const loginScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorpink, // background
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 12,
// color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
// (Route<dynamic> route) => false);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorpink, // background
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(  // Bottom rectangular box
                    margin: EdgeInsets.only(top: 40), // to push the box half way below circle
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 16,
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    child: CircleAvatar( // Top Circle with icon
                      maxRadius: 40.0,
                      backgroundColor: Colors.white,
                      child: Image.asset('images/japanlogo.png'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
           ).then((value){
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });*/
  }

  static void showZoom(context, img) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (BuildContext bc) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                height: height - 200,
                child: Column(
                  children: [
                    Align(
                      child: Container(
                        height: 5,
                        width: 30,
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          // border: Border.all(color: Colors.grey, width: 0.0),
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(100, 50)),
                        ),
                        child: const Text('     '),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              // left: 20.0, right: 20, bottom: 50, top: 20),
                              left: 0,
                              right: 0,
                              bottom: 10,
                              top: 0),
                          child: InteractiveViewer(
                            minScale: 0.1,
                            child: img.contains("https")
                                ? Image.network(
                                    img,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    img,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showPickerBottom(context, img) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (BuildContext bc) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                height: height / 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Align(
                            child: Container(
                              height: 5,
                              width: 30,
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                // border: Border.all(color: Colors.grey, width: 0.0),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(100, 50)),
                              ),
                              child: const Text(''),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const Text('SIMILAR PRODUCT',
                          textScaleFactor: 1.0,
                          style: FTextStyle.decStyle,
                          textAlign: TextAlign.start),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: height * 0.300,
                          child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // if (Utils.checkLogin == true) {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               SoldPrdWithLogin(img: img)));
                                  // } else {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               SoldPrdWtLogin(img: img)));
                                  // }
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         // builder: (context) => ConceptPage( )));
                                  //         builder: (context) =>
                                  //             ProductDetailsScreen(img: img)));
                                },
                                child: Card(
                                  color: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      // borderRadius: BorderRadius.circular(10.0),
                                      ),
                                  elevation: 0,
                                  child: Column(
                                    children: [
                                      img.contains("https")
                                          ? Image.network(
                                              img,
                                              fit: BoxFit.fill,
                                              height: height / 3.1,
                                              width: width / 2,
                                            )
                                          : Image.asset(
                                              img,
                                              fit: BoxFit.fill,
                                              height: height / 3.1,
                                              width: width / 2,
                                            ),
                                      // Image.asset(
                                      //
                                      //   img,
                                      //   fit: BoxFit.cover,
                                      //   height: height / 3.1,
                                      //   width: width / 2,
                                      // ),
                                      Container(
                                        // color: Colors.red,
                                        width: width / 2,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Embroidered Net Scalloped Saree in Red",
                                              textAlign: TextAlign.start,
                                              style: FTextStyle.decStyle,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: '',
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: '₹5000.00',
                                                    style:
                                                        FTextStyle.prizeStyle5,
                                                  ),
                                                  TextSpan(
                                                    text: '  ₹3000.00',
                                                    style:
                                                        FTextStyle.prizeStyle3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // margin: EdgeInsets.all(10),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }

  Future<Object?> _buildDialogContent(BuildContext context) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        title: Text('blured background'),
        content: Text('background should be blured and little bit darker '),
        elevation: 2,
        actions: [],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      context: context,
    );
  }

  // static void showLoader(BuildContext context) {
  //   if (!_isLoaderShowing) {
  //     _isLoaderShowing = true;
  //     _loaderContext = context;
  //     showDialog(
  //         context: _loaderContext!,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return const SpinKitRing(
  //             lineWidth: 2.0,
  //             color: AppColors.navColor,
  //           );
  //         }).then((value) => {_isLoaderShowing = false,/* Log.info('Loader hidden!')*/});
  //   }
  // }
  static Widget image(String thumbnail) {
    try {
      String placeholder =
          "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
      if (thumbnail?.isEmpty ?? true)
        thumbnail = placeholder;
      else {
        if (thumbnail.length % 4 > 0) {
          thumbnail +=
              '=' * (4 - thumbnail.length % 4); // as suggested by Albert221
        }
      }
      final _byteImage = Base64Decoder().convert(thumbnail);
      Widget image = Image.memory(_byteImage);
      return image;
    } catch (e) {
      String placeholder =
          "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
      final _byteImage = Base64Decoder().convert(placeholder);
      Widget image = Image.memory(_byteImage);
      return image;
    }
  }

  static void hideLoader() {
    if (_isLoaderShowing && _loaderContext != null) {
      Navigator.pop(_loaderContext!);
      _loaderContext = null;
    }
  }

  static void hideLoadingDialog() {
    if (_isLoadingDialogShowing && _loadingDialoContext != null) {
      Navigator.pop(_loadingDialoContext!);
      _loadingDialoContext = null;
    }
  }

  static void hideKeyBoard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static ThemeData getAppThemeData() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      canvasColor: Colors.transparent,
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    );
  }

  static DateTime convertDateFromString(String strDate) {
    DateTime date = DateTime.parse(strDate);
    // var formatter = new DateFormat('yyyy-MM-dd');
    return date;
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    final String string =
        '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
    String mvalue = '';
    if (string[0] == '-') {
      mvalue = '';
    } else {
      mvalue = string;
    }
    return '${mvalue}';
  }
}


class Util {
  static double remap(
      double value,
      double originalMinValue,
      double originalMaxValue,
      double translatedMinValue,
      double translatedMaxValue) {
    if (originalMaxValue - originalMinValue == 0) return 0;

    return (value - originalMinValue) /
            (originalMaxValue - originalMinValue) *
            (translatedMaxValue - translatedMinValue) +
        translatedMinValue;
  }
}

class ValidationUtils {
  static final RegExp _alphabetRegex = RegExp(r'^[a-zA-Z]+$');
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  static bool isValidPhoneNumber(String number) {
    if (number.isEmpty || number.length < 10)
      return false;
    else
      return true;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty)
      return 'Phone number is required.';
    else if (value.length < 10 && value.length > 10)
      return 'Enter valid 10 digit phone number';
    else
      return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter email address';
    return null;
  }

  static String? validatePassword(String value) {
    if (value != null && value.isEmpty) return 'Password is required.';
    return null;
  }

  static bool isValidName(String s) {
    return _alphabetRegex.hasMatch(s);
  }

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password != null && password.length >= 6;
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierColor: Colors.black38,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            /* ? CircularPercentIndicator(
          radius: 20.0,
          lineWidth: 5.0,
          percent: 1.0,
          center:   Text("100%"),
          progressColor: Colors.green,
        )*/
            : CupertinoActivityIndicator(
                color: AppColors.primary_color,
                radius: 20,
                animating: true,
              ),
      ),
    );
  }
}
