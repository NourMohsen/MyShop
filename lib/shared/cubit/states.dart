import 'package:shop_app/models/shop_login_model.dart';

abstract class AppStates{}
class ShopLoginInitialState extends AppStates{}
class ShopLoginLoadingState extends AppStates{}
class ShopLoginSuccessState extends AppStates{
  final ShopLoginModel loginModel;
  ShopLoginSuccessState(this.loginModel);
}
class ShopLoginErrorState extends AppStates{
  final String error;
  ShopLoginErrorState(this.error);
}
class ShopChangePasswordVisibilityState extends AppStates{}
