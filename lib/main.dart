import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constans.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_cubit.dart';
import 'package:shop_app/shared/cubit/shop_login_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_register_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_search_cubit/cubit.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'layout/home_layout.dart';
import 'modules/on_boarding_screen/on_boarding_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool onBoarding = CacheHelper.getData("onBoarding");
  token = CacheHelper.getData("token");
  Widget widget;

  if (onBoarding != null) {
    if (token != null)
      widget = HomeLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }
  runApp(MyApp(startWidget: widget,));
}
 class MyApp extends StatelessWidget {
   final Widget startWidget;
   MyApp({Key key, this.startWidget}) : super(key: key);
   @override
   Widget build(BuildContext context) {
     return MultiBlocProvider(
       providers: [
         BlocProvider(create: (context)=>AppCubit(),),
         BlocProvider(create: (context)=>HomeCubit()..getHomeData()..getCategoriesData()..getFav()..getUserData(),),
         BlocProvider(create: (context) => ShopRegisterCubit(),),
         BlocProvider(create: (context) => SearchCubit(),
         ),
       ],
       child: MaterialApp(
         debugShowCheckedModeBanner: false,
         theme: lightTheme,
         darkTheme: darkTheme,
         themeMode: ThemeMode.light,
         home: startWidget,
       ),
     );
   }
 }
