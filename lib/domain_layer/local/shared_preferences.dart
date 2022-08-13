import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

Future<void> sharedPreferences() async {
  preferences = await SharedPreferences.getInstance();
}

//save user token
Future<bool> saveUserToken(String userToken) =>
    preferences.setString('userToken', userToken);
Future<bool> removeUserToken() => preferences.remove('userToken');
String? getUserToken() => preferences.getString('userToken');

//id!
/// save user id
Future<bool> saveUserId(String userId) => preferences.setString('id', userId);

/// get user id
String? getUserId() => preferences.getString('id');

//name!
/// save user id
Future<bool> saveUserName(String name) => preferences.setString('name', name);

/// get user id
String? getUserName() => preferences.getString('name');

//name!
/// save user id
Future<bool> saveUserPhone(String phone) =>
    preferences.setString('phone', phone);

/// get user id
String? getUserPhone() => preferences.getString('phone');


/// save user id
Future<bool> saveUserImage(String image) =>
    preferences.setString('image', image);

/// get user id
String? getUserImage() => preferences.getString('image');

//carColor!
/// save car color
Future<bool> saveCarColor(String carColor) =>
    preferences.setString('color', carColor);

/// get car color
String? getCarColor() => preferences.getString('color');

//car model!
/// save car model
Future<bool> saveCarModel(String carModel) =>
    preferences.setString('model', carModel);

/// get user id
String? getCarModel() => preferences.getString('model');

//car number!
/// save user id
Future<bool> saveCarNumber(String carNumber) =>
    preferences.setString('carnumber', carNumber);

/// get user id
String? getCarNumber() => preferences.getString('carnumber');

/// save user id
Future<bool> saveUserStatus(bool userStatus) =>
    preferences.setBool('userStatus', userStatus);

/// get user id
bool? getUserStatus() => preferences.getBool('userStatus');

/// save user id
Future<bool> saveCarType(int userStatus) =>
    preferences.setInt('cartype', userStatus);

/// get user id
int? getCarType() => preferences.getInt('cartype');

Future<bool> saveUserRate(String userRate) =>
    preferences.setString('rate', userRate);

/// get car color
String? getUserRate() => preferences.getString('rate');

Future<bool> saveStartDate(String startDate) =>
    preferences.setString('startDate', startDate);

/// get car color
String? getStartDate() => preferences.getString('startDate');

Future<bool> saveEndTime(String endTime) =>
    preferences.setString('endTime', endTime);

/// get car color
String? getEndDate() => preferences.getString('endTime');

///
Future<bool> removeStartDate() => preferences.remove('startDate');

Future<bool> removeEndDate() => preferences.remove('endTime');
