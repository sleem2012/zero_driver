import 'package:driver/logic_layer/user_info/user_info_cubit.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoLoading) {
          return SizedBox(
            height: SizeConfig.blockSizeVertical * 20,
            child: const LoadingWidget(),
          );
        }
        if (state is UserInfoLoaded) {
          return DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: <Widget>[
                CachedImageWidget(
                  imageUrl: state.userInfo.data!.image ??
                      'https://i.ibb.co/rF27hkX/user-1.png',
                  height: SizeConfig.blockSizeVertical * 7,
                  width: SizeConfig.blockSizeVertical * 7,
                  boxFit: BoxFit.cover,
                  borderRadius: 10,
                ),
                sizedBoxH5,
                Text(
                  state.userInfo.data!.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                sizedBoxH5,
                Text(
                  state.userInfo.data!.mobile ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                sizedBoxH5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      state.userInfo.data!.rating.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    sizedBoxW5,
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
