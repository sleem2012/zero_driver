import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/logic_layer/update_profile/update_profile_cubit.dart';
import 'package:driver/logic_layer/upload_profile_image/upload_profile_image_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:nations/nations.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:driver/ui_layer/widgets/shared/custom_text_field/custom_TextField_without_icon.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';

class UpdateProfile extends StatefulWidget {
  static const routeName = '/update-profile';
  const UpdateProfile({Key? key, this.imageUrl}) : super(key: key);

  final String? imageUrl;
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController userNameController = TextEditingController();
  String countryCode = '';
  String phoneNumber = '0';
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    phoneNumber = getUserPhone()!;
    phoneController.text = phoneNumber;
    userNameController.text = getUserName()!;
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadProfileImageCubit(),
      child: BlocProvider(
        create: (context) => UpdateProfileCubit()..emit(UpdateProfileInitial()),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'updateProfileInfo'.tr,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, state) {
              if (state is UpdateProfileStateLoading) {
                showOverlayNotification(
                  (context) {
                    return const OverlayLoading();
                  },
                  position: NotificationPosition.bottom,
                  key: const ValueKey('message'),
                );
              }
              if (state is UpdateProfileStateSuccess) {
                Fluttertoast.showToast(msg: 'Addedd Success');
                Navigator.pop(context);
              }
              if (state is UpdateProfileStateError) {
                Fluttertoast.showToast(msg: state.error);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Container(
                  color: const Color(
                    0xffE5E5E5,
                  ),
                  child: Padding(
                    padding: padding8,
                    child: Column(
                      children: <Widget>[
                        BlocBuilder<UploadProfileImageCubit,
                            UploadProfileImageState>(
                          builder: (context, state) {
                            if (state is UploadImageSuccess) {
                              return Center(
                                child: SizedBox(
                                  height: SizeConfig.blockSizeVertical * 10,
                                  width: SizeConfig.blockSizeVertical * 10,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: FileImage(
                                          state.image,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: -15,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: circular20,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () async {
                                context
                                    .read<UploadProfileImageCubit>()
                                    .pickImage(context);
                              },
                              child: Center(
                                child: SizedBox(
                                  height: SizeConfig.blockSizeVertical * 10,
                                  width: SizeConfig.blockSizeVertical * 10,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: circular24,
                                        child: CachedImageWidget(
                                          borderRadius: 24,
                                          boxFit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                          imageUrl: widget.imageUrl ??
                                              'https://i.ibb.co/rF27hkX/user-1.png',
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: -15,
                                        child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<UploadProfileImageCubit>()
                                                .pickImage(context);
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: circular20,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.black,
                                                size: 20,
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
                          },
                        ),
                        sizedBoxH10,
                        CustomTextFieldWithoutIcon(
                          hintLabel: 'Name',
                          validator: (String? val) {},
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          controller: userNameController,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: CustomTextFieldWithoutIcon(
                                        textInputAction: TextInputAction.next,
                                        validator: (String? value) =>
                                            value!.isEmpty
                                                ? 'emptyField'
                                                : null,
                                        controller: phoneController,
                                        hintLabel: '0123456789',
                                        textInputType: TextInputType.phone,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      phoneController.clear();
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                          //    color: Colors.blue,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/clear_icon.png'),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        DefaultButton(
                          width: 100,
                          function: () {
                            final FormState? form = _formKey.currentState;

                            if (form!.validate()) {
                              context.read<UpdateProfileCubit>().updateProfile(
                                    name: userNameController.text,
                                    email: emailController.text,
                                    phone: countryCode + phoneController.text,
                                    image: context.read<UploadProfileImageCubit>().image,
                                  );
                            }
                          },
                          background: kDefaultColor,
                          fontSize: 16,
                          height: SizeConfig.blockSizeVertical * 7,
                          radius: 10,
                          text: 'save'.tr,
                          titleColor: Colors.white,
                          toUpper: false,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
