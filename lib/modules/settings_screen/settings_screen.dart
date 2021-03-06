import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_cubit.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_states.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          nameController.text = cubit.userData.data.name;
          emailController.text = cubit.userData.data.email;
          phoneController.text = cubit.userData.data.phone;
          return ConditionalBuilder(
            condition: cubit.userData != null,
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is ShopUpdateProfileLoadingState)
                        LinearProgressIndicator(),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: nameController,
                        label: "Name",
                        validate: (String value) {
                          if (value.isEmpty) {
                            return "Name Must Not Be Empty";
                          }
                        },
                        prefix: Icons.person,
                        type: TextInputType.name,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: emailController,
                        label: "email",
                        validate: (String value) {
                          if (value.isEmpty) {
                            return "email Must Not Be Empty";
                          }
                        },
                        prefix: Icons.email,
                        type: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        label: "phone",
                        validate: (String value) {
                          if (value.isEmpty) {
                            return "phone Must Not Be Empty";
                          }
                        },
                        prefix: Icons.phone,
                        type: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultButton(
                          text: "update",
                          function: () {
                            if (formKey.currentState.validate()) {
                              HomeCubit.get(context).getUpdateUserData(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text);
                            }
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      defaultButton(
                          text: "LogOut",
                          function: () {
                            HomeCubit.get(context).signOut(context);
                          })
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}