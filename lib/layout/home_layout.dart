import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search_screen/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_cubit.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_states.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
            appBar: AppBar(
              title: Text("Salla"),
              actions: [
                IconButton(onPressed: (){
                  navigateTo(context, SearchScreen());
                }, icon: Icon(Icons.search))
              ],
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) =>
              HomeCubit.get(context).screens[HomeCubit.get(context).currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (newIndex) {
                HomeCubit.get(context).changeIndex(newIndex);
              },
              currentIndex: HomeCubit.get(context).currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.apps,
                  ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  label: 'Favourites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  label: 'Settings',
                ),
              ],
              type: BottomNavigationBarType.fixed,
            ));
      },
    );
  }
}
