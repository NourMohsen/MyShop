
import 'package:shop_app/models/change_favourites_model.dart';
import 'package:shop_app/models/shop_login_model.dart';

abstract class HomeStates{}
class ShopHomeInitialState extends HomeStates{}
class AppChangeBottomNavBarState extends HomeStates{}
class ShopHomeLoadingState extends HomeStates {}
class ShopHomeSuccessState extends HomeStates {}
class ShopHomeErrorState extends HomeStates {}
class ShopCategoriesSuccessState extends HomeStates {}
class ShopCategoriesErrorState extends HomeStates {}
class ShopChangeFavouriteSuccessState extends HomeStates {
  final ChangeFavoritesModel model;

  ShopChangeFavouriteSuccessState(this.model);
}
class ShopChangeFavouriteState extends HomeStates {}
class ShopChangeFavouriteErrorState extends HomeStates {}
class ShopUserProfileLoadingState extends HomeStates {}

class ShopUserProfileSuccessState extends HomeStates {
  final ShopLoginModel loginModel;

  ShopUserProfileSuccessState(this.loginModel);
}

class ShopUserProfileErrorState extends HomeStates {}
class ShopGetFavouritesSuccessState extends HomeStates {}
class ShopGetFavouritesLoadingState extends HomeStates {}
class ShopGetFavouritesErrorState extends HomeStates {}
class ShopUpdateProfileLoadingState extends HomeStates {}

class ShopUpdateProfileSuccessState extends HomeStates {
  final ShopLoginModel loginModel;

  ShopUpdateProfileSuccessState(this.loginModel);
}

class ShopUpdateProfileErrorState extends HomeStates {}
