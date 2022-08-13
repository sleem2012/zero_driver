// import 'package:driver/logic_layer/phone_verfication/phone_verfication_cubit.dart';
// import 'package:driver/ui_layer/helpers/constants/constants.dart';
// import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
// import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
// import 'package:driver/ui_layer/widgets/shared/default_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pinput/pin_put/pin_put.dart';
// import 'package:nations/nations.dart';

// /// Otp Screen
// class OtpScreen extends StatefulWidget {
//   /// Constructor
//   const OtpScreen({Key? key}) : super(key: key);

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController _pinPutController = TextEditingController();
//   final FocusNode _pinPutFocusNode = FocusNode();
//   BoxDecoration get _pinPutDecoration {
//     return BoxDecoration(
//       color: Colors.white,
//       border: Border.all(color: Colors.deepPurpleAccent),
//       borderRadius: circular24,
//     );
//   }

//   @override
//   void initState() {
//     context.read<PhoneVerficationCubit>().verifyPhoneNumber('011018270000');

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         // color: kMainBackgroundColor,
//         child: Directionality(
//           textDirection: TextDirection.ltr,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 width: double.infinity,
//               ),
//               Image.asset(
//                 'assets/icons/otp.png',
//                 height: SizeConfig.blockSizeVertical * 30,
//                 width: SizeConfig.blockSizeHorizontal * 60,
//               ),
//               const Text(
//                 "Verification Code sent to : ",
//                 style: TextStyle(
//                   color: Color(0xff3f3f3f),
//                 ),
//               ),
//               const Text(
//                 "MM-K@gmail.com",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontFamily: "Poppins",
//                   fontStyle: FontStyle.normal,
//                   fontSize: 16.0,
//                 ),
//               ),
//               sizedBoxH10,
//               const Text(
//                 "Enter the 4 digit code sent to your Phone",
//                 style: TextStyle(
//                   color: Color(0xff3f3f3f),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Container(
//                 margin: padding16,
//                 padding: padding16,
//                 child: PinPut(
//                   fieldsCount: 4,
//                   onSubmit: (String pin) => _showSnackBar(pin, context),
//                   focusNode: _pinPutFocusNode,
//                   controller: _pinPutController,
//                   eachFieldWidth: 50,
//                   eachFieldHeight: 50,
//                   disabledDecoration: _pinPutDecoration.copyWith(
//                     border: Border.all(
//                       color: Colors.red.withOpacity(.5),
//                     ),
//                   ),
//                   submittedFieldDecoration: _pinPutDecoration.copyWith(),
//                   selectedFieldDecoration: _pinPutDecoration.copyWith(),
//                   followingFieldDecoration: _pinPutDecoration.copyWith(
//                     border: Border.all(
//                       color: Colors.deepPurpleAccent.withOpacity(.5),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: paddingH8,
//                 child: TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Didn’t get the code?',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                       fontSize: 14.0,
//                       color: Color(0xff1374ba),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: DefaultButton(
//         width: 100,
//         function: () {
//           context
//               .read<PhoneVerficationCubit>()
//               .verifyPhoneNumber('011018270000');
//         },
//         background: kDefaultColor,
//         fontSize: 18,
//         height: SizeConfig.blockSizeVertical * 7,
//         radius: 10,
//         text: 'send'.tr,
//         titleColor: Colors.white,
//         toUpper: false,
//       ),
//     );
//   }

//   void _showSnackBar(String pin, BuildContext context) {
//     final snackBar = SnackBar(
//       duration: const Duration(seconds: 3),
//       content: Container(
//         height: 80.0,
//         child: Center(
//           child: Text(
//             'Pin Submitted. Value: $pin',
//             style: const TextStyle(fontSize: 25.0),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.deepPurpleAccent,
//     );
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }
// }
