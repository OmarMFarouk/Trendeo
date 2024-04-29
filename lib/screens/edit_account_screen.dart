import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/bloc/user_bloc/user_cubit.dart';
import 'package:trendeo/bloc/user_bloc/user_states.dart';
import 'package:trendeo/components/user_image_viow.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/themes/theme_button.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/themes/theme_titel.dart';
import 'package:trendeo/widgets/inpout_edit_data.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        backgroundColor: ColorApp.moodApp
            ? ColorApp.darkBackgroundColor
            : ColorApp.lightBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: ThemeIcon(
                    iconData: Icons.arrow_back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: ThemeTitel(
                    text: "Edit my account",
                    size: 30,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder(
                        stream: UserCubit.get(context).fetchUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            DocumentSnapshot data =
                                snapshot.data as DocumentSnapshot;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Edit user image
                                Padding(
                                  padding: EdgeInsets.all(15.r),
                                  child: Stack(
                                    children: [
                                      UserImageCard(
                                        userImage: data['image'],
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: ThemeIcon(
                                          iconData: Icons.camera_alt_outlined,
                                          onPressed: () {
                                            UserCubit.get(context)
                                                .changeProfilePicture();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Edit user name
                                InputUserEditData(
                                  controller:
                                      UserCubit.get(context).nameController!,
                                  hintText: data['name'] == ""
                                      ? "User Name"
                                      : data['name'],
                                  icon: Icons.person_outline,
                                  onChanged: (p0) {},
                                ),

                                // Edit user feacBook link
                                InputUserEditData(
                                  controller:
                                      UserCubit.get(context).fbController!,
                                  hintText: data['fb_link'] == ""
                                      ? "Facebook link"
                                      : data['fb_link'],
                                  icon: Icons.link_outlined,
                                  onChanged: (p0) {},
                                ),

                                // Edit user instagram link
                                InputUserEditData(
                                  controller:
                                      UserCubit.get(context).igController!,
                                  hintText: data['ig_link'] == ""
                                      ? "Instagram link"
                                      : data['ig_link'],
                                  icon: Icons.link_outlined,
                                  onChanged: (p0) {},
                                ),

                                // Edit user phome nampuer
                                InputUserEditData(
                                  controller:
                                      UserCubit.get(context).phoneController!,
                                  hintText: data['phone'] == ""
                                      ? "Phone Number"
                                      : data['phone'],
                                  icon: Icons.phone,
                                  onChanged: (p0) {},
                                  keyboardType: TextInputType.phone,
                                ),

                                // Edit Description box
                                InputUserEditData(
                                  controller:
                                      UserCubit.get(context).bioController!,
                                  hintText: data['bio'] == ""
                                      ? "describe yourself"
                                      : data['bio'],
                                  icon: Icons.psychology_outlined,
                                  onChanged: (p0) {},
                                  maxLines: null,
                                ),
                                ThemeButton(
                                  onPressed: () {
                                    UserCubit.get(context).saveProfileData();
                                    Navigator.pop(context);
                                  },
                                  icon: Icons.verified_outlined,
                                  text: "Save",
                                ),
                              ],
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
