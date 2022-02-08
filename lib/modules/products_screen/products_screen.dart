import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_categories_model.dart';
import 'package:shop_app/models/shop_home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_cubit.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if(state is ShopChangeFavouriteSuccessState){
            if(!state.model.status){
              showToast(text: "${state.model.message}",color: Colors.red);
            }
          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: HomeCubit.get(context).homeModel != null && HomeCubit.get(context).categoriesModel != null,
            builder: (context) =>
                productBuilder(HomeCubit.get(context).homeModel,HomeCubit.get(context).categoriesModel,context),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget productBuilder(ShopHomeModel model,CategoriesModel categoriesModel,context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CarouselSlider(
            items: model.data.banners
                .map((e) => Image(
                      image: NetworkImage("${e.image}"),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ))
                .toList(),
            options: CarouselOptions(
                height: 200,
                viewportFraction: 1.0,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlay: true,
                initialPage: 0,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        buildCategories(categoriesModel.data.data[index]),
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                    itemCount: categoriesModel.data.data.length,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "New Products",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              mainAxisSpacing: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.5,
              crossAxisCount: 2,
              children: List.generate(model.data.products.length,
                  (index) => buildGridProduct(model.data.products[index],context)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGridProduct(Product product,context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Stack(
      alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              height: 200,
              image: NetworkImage("${product.image}"),
              width: double.infinity,
            ),
        if (product.discount != 0)
    Container(
      padding: EdgeInsets.all(2),
      color: Colors.red,
      child: Text(
        "Discount",
        style: TextStyle(color: Colors.white,fontSize: 14),
      ),)
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${product.price.round()}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: defaultColor),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                    if(product.discount != 0)
                    Text(
                      "${product.oldPrice.round()}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough),
                    ),
                  Spacer(),
                  IconButton(
                      icon: CircleAvatar(
                        radius: 15,
                        backgroundColor: HomeCubit.get(context).favourites[product.id] ? defaultColor : Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        HomeCubit.get(context).changeFavourite(product.id);
                      })
                ],
              )
            ]))
      ]),
    );
  }
  Widget buildCategories(Datum model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage("${model.image}"),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.8),
        width: 100,
        child: Text(
          "${model.name}",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      )
    ],
  );
}
