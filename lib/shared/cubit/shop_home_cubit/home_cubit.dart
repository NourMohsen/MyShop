import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/change_favourites_model.dart';
import 'package:shop_app/models/shop_categories_model.dart';
import 'package:shop_app/models/shop_favourites_model.dart';
import 'package:shop_app/models/shop_home_model.dart';
import 'package:shop_app/models/shop_login_model.dart';
import 'package:shop_app/modules/categories_screen/categories_screen.dart';
import 'package:shop_app/modules/favourite_screen/favourite_screen.dart';
import 'package:shop_app/modules/products_screen/products_screen.dart';
import 'package:shop_app/modules/settings_screen/settings_screen.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constans.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_states.dart';
import 'package:shop_app/shared/network/end_point.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';


class HomeCubit extends Cubit<HomeStates>{
  HomeCubit() : super(ShopHomeInitialState());
  static HomeCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  List<Widget> screens =
  [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen()
  ];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }
  ShopHomeModel homeModel;
  Map<int,bool>favourites={};
  void getHomeData(){
    emit(ShopHomeLoadingState());
    DioHelper.getData(url: Home,token: token).then((value){
      homeModel=ShopHomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favourites.addAll({element.id:element.inFavorites});
      });
      print(favourites.toString());
      printFullText(homeModel.data.banners[0].image);
      print(token);
      emit(ShopHomeSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShopHomeErrorState());
    });
  }
  CategoriesModel categoriesModel;
  void getCategoriesData(){
    DioHelper.getData(url: Get_Categories).then((value){
      categoriesModel=CategoriesModel.fromJson(value.data);
      printFullText(categoriesModel.data.data[0].image);
      emit(ShopCategoriesSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShopCategoriesErrorState());
    });
  }
  ChangeFavoritesModel changeFavoritesModel;
  void changeFavourite(int productId){
    favourites[productId]= !favourites[productId];
    emit(ShopChangeFavouriteState());
    DioHelper.postData(
        url: FAVOURITES,
        data: {
          "product_id":productId
        },token: token
    ).then((value){
      changeFavoritesModel=ChangeFavoritesModel.fromJson(value.data);
      if(!changeFavoritesModel.status){
        favourites[productId]= !favourites[productId];
      }else{
        getFav();
      }
      print(value.data);
      emit(ShopChangeFavouriteSuccessState(changeFavoritesModel));
    }).catchError((error){
      favourites[productId]= !favourites[productId];
      emit(ShopChangeFavouriteErrorState());
    });
  }
  FavoritesModel favoritesModel;
  void getFav(){
    emit(ShopGetFavouritesLoadingState());
    DioHelper.getData(url: FAVOURITES,token: token).then((value){
      favoritesModel=FavoritesModel.fromJson(value.data);
      emit(ShopGetFavouritesSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShopGetFavouritesErrorState());
    });
  }
  ShopLoginModel userData;
  void getUserData() {
    emit(ShopUserProfileLoadingState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userData = ShopLoginModel.fromJson(value.data);
      emit(ShopUserProfileSuccessState(userData));
    }).catchError((error) {
      print(error.toString());
      emit(ShopUserProfileErrorState());
    });
  }
  void getUpdateUserData({String name, String email, String phone}) {
    emit(ShopUpdateProfileLoadingState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      "name": name,
      "email": email,
      "phone": phone,
    }).then((value) {
      userData = ShopLoginModel.fromJson(value.data);
      emit(ShopUpdateProfileSuccessState(userData));
    }).catchError((error) {
      print(error.toString());
      emit(ShopUpdateProfileErrorState());
    });
  }
  void signOut(context) {
    CacheHelper.removeData('token').then((value) {
      if (value) navigateAndFinish(context,ShopLoginScreen());
    });
  }
}