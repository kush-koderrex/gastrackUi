





class KGlobal {
  // ignore: non_constant_identifier_names
  //Global constants
  static const TIME_OUT_DURATION = Duration(seconds: 10);
  static const CONNECT_TIMEOUT = 6000;
  static const RECEIVE_TIMEOUT = 6000;
  static String firebaseToken = "";
}

class KPrefs {
  //Pref Constants
  static const TOKEN = 'token';
  static const IS_LOGGED_IN = 'is_logged_in';
  static const USER_ID = 'user_id';
  static const USER_EMAIL = 'user_email';
  static const MOBILE = 'mobile';
  static const USER_NAME = 'user_name';
  static const FCM_TOKEN = 'fcm_token';
  static const IMAGE = 'image';
}

class KReqHeaders {
  static const AUTHORIZATION = 'Authorization';
  static const DEVICE_TYPE = 'device_type';
  static const PLATFORM = 'Platform';
}

class KApiResponseCodes {
  static const int STATUS_SERVICE_UNAVAILABLE = 503;
}

class KApiBase {
  // static const BASE_URL = 'https://www.utsavfashion.com/';
  static const BASE_URL = 'https://m2devawsadmin.fashionindia.co.nz/rest/default/V1/';

}

// Category list api endPoints
class KApiEndPoints {
  // static const categories = '${KApiBase.BASE_URL}categories';


}

class KDateFormats {
  static const DATE_FORMAT_1 = 'yyyy-MM-dd';
  static const DATE_FORMAT_2 = 'yyyy/MM/dd';
  static const DATE_FORMAT_3 = 'dd/MM/yyyy';
  static const DATE_FORMAT_4 = 'EEEE, d MMMM';
  static const DATE_FORMAT_5 = "d' 'MMM' '''yy";
  static const DATE_FORMAT_6 = 'dd MMM';
  static const DATE_FORMAT_7 = 'hh:mm a';
  static const DATE_FORMAT_8 = 'EEEE, MMMM d';
  static const DATE_FORMAT_9 = 'MMMM yyyy';
  static const DATE_FORMAT_10 = 'ddMMyy';
}

class SharedPrefsKeys {
  static const companyID = 'CompanyID';
  static const Country = 'Country';
  static const City = 'City';
  static const Zipcode = 'Zipcode';
  static const email = 'email';
  static const address = 'address';
  static const companyName = 'companyName';
  static const userID = 'UserID';
  static const apikey = 'Api_key';
  static const setclientListId = 'setclientListId';
  static const tradeShowID = 'tradeShowID';
  static const tradeShowName = 'tradeShowName';
  static const BUSINESS_USER = 'BUSINESS_USER';
  static const PLAN = 'PLAN';
  static const USER_LOGGED_IN = 'USER_LOGGED_IN';
  static const USER_NAME = 'USER_NAME';
  static const Is_LoggedIn = 'isLoggedIn';
  static const USER_TOKEN = 'USER_TOKEN';
  static const USER_REFERRAL = 'USER_REFERRAL';
  static const USER_PINCODE = 'USER_PINCODE';
  static const USER_ADDRESS = 'Address';
  static const FIRST_TIME_LAUNCH = 'first_time_launch';
  static const BUSINESS_STEP = 'business_step';
  static const CART_ITEM_COUNT = "user_data";
  static const USER_ACCESS_KEY = 'access_key';
  static const PRIVACY_POLICY = 'privacy_policy';
  static const TERMS_CONDITION = 'terms_condition';
  static const CONTACT_US = 'contact_us';
  static const ABOUT_US = 'about_us';
}

class KNotificationTypes {
  static const POST_REACTION = 'Order';
  static const NOTIFICATION = 'Notification';
  static const FOLLOW = 'follow';
  static const apiKey = 'AIzaSyDpn8hg8opBwPqDHynrp04RA7zF9_PM9OU';
}


