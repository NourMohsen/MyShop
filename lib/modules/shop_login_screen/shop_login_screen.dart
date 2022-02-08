import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/shop_register_screen/shop_register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constans.dart';
import 'package:shop_app/shared/cubit/shop_login_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_login_cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget
{
  var emailController =TextEditingController();
  var passwordController =TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if (state is ShopLoginSuccessState) {
          if (state.loginModel.status) {
            showToast(text: state.loginModel.message, color: Colors.green)
                .then((value) {
              CacheHelper.setData(
                  key: 'token', value: state.loginModel.data.token)
                  .then((value) {
                    token=state.loginModel.data.token;
                navigateAndFinish(context,HomeLayout());
              });
            });
          } else {
            showToast(text: state.loginModel.message, color: Colors.red);
          }
        } else if (state is ShopLoginErrorState) {
          showToast(text: state.error, color: Colors.red);
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding:const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login",style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black),),
                      Text("Login now to browse our hot offers",style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey),),
                      SizedBox(height: 30,),
                      defaultFormField(
                          controller: emailController,
                          type:TextInputType.emailAddress,
                          validate: (value){
                            if(value.isEmpty){
                              return "Please enter your email address";
                            }
                          },
                          label: "E_mail", prefix: Icons.email_outlined),
                      SizedBox(height: 15,),
                      defaultFormField(
                          controller: passwordController,
                          type:TextInputType.visiblePassword,
                          validate: (value){
                            if(value.isEmpty){
                              return "Password is too short";
                            }
                          },
                          label: "Password",
                          prefix: Icons.lock_outline,
                          suffix: AppCubit.get(context).suffix,
                          isPassword: AppCubit.get(context).isPassword,
                          onSubmit: (value){
                          if (formKey.currentState.validate()){
                            AppCubit.get(context).userLogin(email: emailController.text, password: passwordController.text,);
                          }
                        },
                        suffixPressed:(){
                            AppCubit.get(context).changeVisibility();
                        },
                      ),
                      SizedBox(height: 30,),

                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
                        builder: (context)=> defaultButton(
                          function: (){
                            if (formKey.currentState.validate()){
                              AppCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);
                            }
                          },
                          text: "login",
                          isUpperCase: true,
                        ),
                        fallback: (context)=>Center(child:CircularProgressIndicator(),),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don\'t have an account?"),
                          defaultTextButton(function: (){
                            navigateTo(context, ShopRegisterScreen());
                          }, text: "Register Now")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}