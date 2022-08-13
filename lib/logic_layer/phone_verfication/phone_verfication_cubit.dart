import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'phone_verfication_state.dart';

class PhoneVerficationCubit extends Cubit<PhoneVerficationState> {
  PhoneVerficationCubit() : super(PhoneVerficationInitial());
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = '';
  verifyPhoneNumber(String phoneNumber) async {
    // FirebaseAuth.instance.setSettings(
    //   // appVerificationDisabledForTesting: true,

    // );
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+201281275782',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message.toString());
        emit(PhoneVerficationFailed(errorMessage: e.message.toString()));
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationId = verificationId;
        emit(PhoneVerficationSent());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
    );
  }
}
